// Deno Edge Function: OTP prüfen
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type Body = { dealId: string; code: string };

const JSONH = { "Content-Type": "application/json" };

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SERVICE_ROLE_KEY")!;
const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function sha256Hex(input: string): Promise<string> {
  const data = new TextEncoder().encode(input);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2,"0")).join("");
}

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ ok:false, error:"method_not_allowed" }), { status:405, headers: JSONH });
    }

    const { dealId, code } = (await req.json()) as Body;
    if (!dealId || !code) {
      return new Response(JSON.stringify({ ok:false, error:"missing_params" }), { status:400, headers: JSONH });
    }

    // neueste OTP-Row nehmen
    const { data: rows, error } = await admin
      .from("customer_ok_otp")
      .select("deal_id, code_hash, expires_at, attempts, locked_until, last_sent_at")
      .eq("deal_id", dealId)
      .order("last_sent_at", { ascending: false })
      .limit(1);

    if (error) {
      return new Response(JSON.stringify({ ok:false, error:"db_select_failed", detail:error.message }), { status:500, headers: JSONH });
    }
    if (!rows || rows.length === 0) {
      return new Response(JSON.stringify({ ok:false, error:"no_otp" }), { status:404, headers: JSONH });
    }

    const row = rows[0];
    const now = new Date();

    if (row.locked_until && new Date(row.locked_until) > now) {
      return new Response(JSON.stringify({ ok:false, error:"locked" }), { status:423, headers: JSONH });
    }
    if (new Date(row.expires_at) < now) {
      return new Response(JSON.stringify({ ok:false, error:"expired" }), { status:410, headers: JSONH });
    }

    const match = (await sha256Hex(code.trim())) === row.code_hash;
    if (!match) {
      const attempts = (row.attempts ?? 0) + 1;
      const lock = attempts >= 5 ? new Date(now.getTime() + 15 * 60_000).toISOString() : null;
      const { error: updErr } = await admin.from("customer_ok_otp")
        .update({ attempts, locked_until: lock })
        .eq("deal_id", dealId);
      if (updErr) console.error("attempts update failed", updErr);
      return new Response(JSON.stringify({ ok:false, error:"invalid" }), { status:401, headers: JSONH });
    }

    // verified
    const { error: rpcErr } = await admin.rpc("mark_customer_ok_verified", { p_deal_id: dealId });
    if (rpcErr) {
      console.error("rpc failed", rpcErr);
      return new Response(JSON.stringify({ ok:false, error:"rpc_failed", detail: rpcErr.message }), { status:500, headers: JSONH });
    }

    // OTP wegputzen (Fehler loggen, aber nicht mehr 500’n)
    const { error: delErr, count } = await admin
      .from("customer_ok_otp")
      .delete({ count: "exact" })
      .eq("deal_id", dealId);
    if (delErr) console.error("delete otp failed", delErr);

    return new Response(JSON.stringify({ ok:true, deleted: count ?? 0 }), { status:200, headers: JSONH });
  } catch (e) {
    console.error("otp-verify failed", e);
    return new Response(JSON.stringify({ ok:false, error:"server_error", detail:String(e?.message ?? e) }), { status:500, headers: JSONH });
  }
});
