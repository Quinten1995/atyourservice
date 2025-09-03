// supabase/functions/push_worker/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const SEND_PUSH_URL = Deno.env.get("SEND_PUSH_URL")!; // z.B. https://<ref>.functions.supabase.co/send_push
const SEND_PUSH_AUTH = Deno.env.get("SEND_PUSH_AUTH")!; // unser Shared Secret für send_push
const ANON = Deno.env.get("SUPABASE_ANON_KEY")!;        // für Gateway-Auth (Bearer + apikey)

const sb = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

// -------------------- I18N --------------------
const T = {
  new_job: {
    de: (ctx: any) => ({ title: "Neuer Auftrag", body: `Es gibt ${ctx?.count ?? 1} neue Aufträge` }),
    en: (ctx: any) => ({ title: "New job", body: `${ctx?.count ?? 1} new jobs available` }),
    nl: (ctx: any) => ({ title: "Nieuwe opdracht", body: `${ctx?.count ?? 1} nieuwe opdrachten` }),
    fr: (ctx: any) => ({ title: "Nouvelle mission", body: `${ctx?.count ?? 1} nouvelles missions disponibles` }),
    tr: (ctx: any) => ({ title: "Yeni iş", body: `${ctx?.count ?? 1} yeni iş mevcut` }),
    es: (ctx: any) => ({ title: "Nuevo trabajo", body: `${ctx?.count ?? 1} nuevos trabajos disponibles` }),
    it: (ctx: any) => ({ title: "Nuovo lavoro", body: `${ctx?.count ?? 1} nuovi lavori disponibili` }),
  },
  job_update: {
    de: (ctx: any) => ({ title: "Update zum Auftrag", body: `${ctx?.title ?? "Auftrag"} wurde aktualisiert` }),
    en: (ctx: any) => ({ title: "Job update", body: `${ctx?.title ?? "Job"} has been updated` }),
    nl: (ctx: any) => ({ title: "Update opdracht", body: `${ctx?.title ?? "Opdracht"} is bijgewerkt` }),
    fr: (ctx: any) => ({ title: "Mise à jour de la mission", body: `${ctx?.title ?? "Mission"} a été mise à jour` }),
    tr: (ctx: any) => ({ title: "İş güncellemesi", body: `${ctx?.title ?? "İş"} güncellendi` }),
    es: (ctx: any) => ({ title: "Actualización del trabajo", body: `${ctx?.title ?? "Trabajo"} se ha actualizado` }),
    it: (ctx: any) => ({ title: "Aggiornamento lavoro", body: `${ctx?.title ?? "Lavoro"} è stato aggiornato` }),
  },
  auftrag_angenommen: {
    de: (ctx: any) => ({ title: "Auftrag angenommen", body: `${ctx?.title ?? "Auftrag"} wurde angenommen` }),
    en: (ctx: any) => ({ title: "Job accepted", body: `${ctx?.title ?? "Job"} has been accepted` }),
    nl: (ctx: any) => ({ title: "Opdracht geaccepteerd", body: `${ctx?.title ?? "Opdracht"} is geaccepteerd` }),
    fr: (ctx: any) => ({ title: "Mission acceptée", body: `${ctx?.title ?? "Mission"} a été acceptée` }),
    tr: (ctx: any) => ({ title: "İş kabul edildi", body: `${ctx?.title ?? "İş"} kabul edildi` }),
    es: (ctx: any) => ({ title: "Trabajo aceptado", body: `${ctx?.title ?? "Trabajo"} ha sido aceptado` }),
    it: (ctx: any) => ({ title: "Lavoro accettato", body: `${ctx?.title ?? "Lavoro"} è stato accettato` }),
  },
} as const;

function normalizeLang(input: string | null | undefined): keyof typeof T["new_job"] | "en" {
  const v = String(input ?? "").toLowerCase().trim();
  if (v.startsWith("de")) return "de";
  if (v.startsWith("en")) return "en";
  if (v.startsWith("nl")) return "nl";
  if (v.startsWith("fr") || v === "frz") return "fr";
  if (v.startsWith("tr") || v === "tu" || v === "tur") return "tr";
  if (v.startsWith("es")) return "es";
  if (v.startsWith("it")) return "it";
  return "en";
}

function tr(key: keyof typeof T | string, langCode: ReturnType<typeof normalizeLang>, ctx: any) {
  const dict = (T as any)[key];
  if (dict && typeof dict === "object") {
    const f = dict[langCode] ?? dict["en"] ?? dict["de"];
    if (typeof f === "function") return f(ctx ?? {});
  }
  return { title: ctx?.title ?? "Notification", body: ctx?.body ?? "" };
}
// ---------------------------------------------

serve(async (req) => {
  const { tier } = await req.json().catch(() => ({})) as { tier?: string };
  const wantedTierRaw = (tier ?? "").trim().toLowerCase();
  const wantedTier = ["gold", "silver", "free"].includes(wantedTierRaw) ? wantedTierRaw : null;

  const { data: jobs, error } = await sb.rpc("claim_due_push_jobs", { p_limit: 100 });
  if (error) return new Response(`claim error: ${error.message}`, { status: 500 });

  let ok = 0, fail = 0, skippedTier = 0, skippedNoToken = 0;

  for (const job of jobs ?? []) {
    try {
      const { data: userRow, error: userErr } = await sb
        .from("users")
        .select("push_token, abo_typ, lang")
        .eq("id", job.user_id)
        .single();
      if (userErr) throw new Error(`fetch user failed: ${userErr.message}`);

      const token: string | null = userRow?.push_token ?? null;
      const userTier = String(userRow?.abo_typ ?? "").trim().toLowerCase();
      const lang = normalizeLang(userRow?.lang ?? "de");

      const templateKey = (job as any)?.template_key as string | undefined;

      const ignoreTierForTemplates = new Set<string>([
        "auftrag_angenommen",
      ]);
      const shouldIgnoreTier = templateKey ? ignoreTierForTemplates.has(templateKey) : false;

      if (!shouldIgnoreTier && wantedTier && userTier && userTier !== wantedTier) {
        skippedTier++;
        await sb.from("push_queue").update({ claimed_at: null }).eq("id", job.id);
        continue;
      }

      if (!token) {
        skippedNoToken++;
        await sb.from("push_queue")
          .update({ processed_at: new Date().toISOString(), last_error: "no push_token for user" })
          .eq("id", job.id);
        continue;
      }

      let finalTitle: string | undefined = job.title as string | undefined;
      let finalBody:  string | undefined = job.body  as string | undefined;

      if (templateKey) {
        const ctx = (job as any)?.template_ctx ?? { title: job.title, body: job.body, count: (job as any)?.count };
        const translated = tr(templateKey as any, lang, ctx);
        finalTitle = translated.title ?? finalTitle;
        finalBody  = translated.body  ?? finalBody;
      }

      // -------- send_push korrekt aufrufen (Gateway + Secret) --------
      const res = await fetch(SEND_PUSH_URL, {
        method: "POST",
        headers: {
          "content-type": "application/json",
          "authorization": `Bearer ${ANON}`, // Gateway: Bearer = ANON
          "apikey": ANON,                    // Gateway: apikey = ANON
          "x-send-push-auth": SEND_PUSH_AUTH // Secret fürs send_push
        },
        body: JSON.stringify({
          tokens: [token],
          title: finalTitle ?? job.title ?? "Benachrichtigung",
          body:  finalBody  ?? job.body  ?? "",
          data:  { type: templateKey ?? "new_job", job_id: job.job_id?.toString?.() ?? String(job.job_id ?? "") },
          meta:  { queue_id: job.id },
        }),
      });

      if (!res.ok) {
        const txt = await res.text().catch(() => "");
        throw new Error(`send_push ${res.status}: ${txt}`);
      }
      // ---------------------------------------------------------------

      await sb.from("push_queue")
        .update({ processed_at: new Date().toISOString(), last_error: null })
        .eq("id", job.id);

      ok++;
    } catch (e) {
      fail++;
      await sb.from("push_queue").update({ last_error: String(e) }).eq("id", job.id);
    }
  }

  return Response.json({
    claimed: jobs?.length ?? 0,
    ok,
    fail,
    skippedTier,
    skippedNoToken,
    tier: wantedTier ?? null,
  });
});
