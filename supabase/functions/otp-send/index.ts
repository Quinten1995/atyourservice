// Deno Edge Function: OTP senden (mit Service-Role + sauberem Upsert)
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import twilio from "https://esm.sh/twilio@4?target=deno";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type Body = { dealId: string; phone: string };

const JSONH = { "Content-Type": "application/json" };

function mask(s: string, keep = 4) {
  if (!s) return "";
  const clean = s.replace(/\s+/g, "");
  return clean.slice(0, keep) + "…" + clean.slice(-keep);
}
function normalizeE164(s: string) {
  return s.replace(/\s+/g, "");
}
async function sha256Hex(input: string): Promise<string> {
  const data = new TextEncoder().encode(input);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2,"0")).join("");
}

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SERVICE_ROLE_KEY")!;
const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ ok:false, error:"method_not_allowed" }), { status:405, headers: JSONH });
    }

    const { dealId, phone } = (await req.json()) as Body;
    if (!dealId || !phone) {
      return new Response(JSON.stringify({ ok:false, error:"missing_params" }), { status:400, headers: JSONH });
    }

    const SID   = Deno.env.get("TWILIO_ACCOUNT_SID");
    const TOKEN = Deno.env.get("TWILIO_AUTH_TOKEN");
    const FROM  = Deno.env.get("TWILIO_FROM");
    if (!SID || !TOKEN || !FROM) {
      console.error("Twilio ENV missing", { SID: !!SID, TOKEN: !!TOKEN, FROM: !!FROM });
      return new Response(JSON.stringify({ ok:false, error:"twilio_env_missing" }), { status:500, headers: JSONH });
    }

    // 6-stelliger Code
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = await sha256Hex(code);
    const now = new Date();
    const expiresAt = new Date(now.getTime() + 10 * 60_000).toISOString();
    const e164 = normalizeE164(phone);

    // Upsert (konflikt auf deal_id)
    const { error: upsertErr } = await admin
      .from("customer_ok_otp")
      .upsert(
        {
          deal_id: dealId,
          phone: e164,
          code_hash: codeHash,
          expires_at: expiresAt,
          attempts: 0,
          last_sent_at: now.toISOString(),
        },
        { onConflict: "deal_id" }
      );

    if (upsertErr) {
      console.error("OTP upsert failed:", upsertErr);
      return new Response(JSON.stringify({ ok:false, error:"db_upsert_failed", detail: upsertErr.message }), { status:500, headers: JSONH });
    }

    // SMS
    const client = twilio(SID, TOKEN);
    const msg = await client.messages.create({
      from: FROM,
      to: e164,
      body: `Dein Bestätigungscode: ${code} (gültig 10 Min).`,
    });

    console.log("otp-send ok", { sid: msg.sid, to: mask(e164) });
    return new Response(JSON.stringify({ ok:true, sid: msg.sid }), { status:200, headers: JSONH });
  } catch (e) {
    console.error("otp-send failed", e);
    return new Response(JSON.stringify({ ok:false, error:"twilio_send_failed", detail: String(e?.message ?? e) }), { status:500, headers: JSONH });
  }
});
