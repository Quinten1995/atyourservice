// supabase/functions/send_push/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type SendPushPayload = {
  user_ids?: string[];
  tokens?: string[];
  title?: string;
  body?: string;
  notification?: { title?: string; body?: string };
  data?: Record<string, string>;
  android?: {
    priority?: "HIGH" | "NORMAL" | "high" | "normal";
    notification?: {
      channel_id?: string;
      sound?: string;
      icon?: string;
      [k: string]: unknown;
    };
    [k: string]: unknown;
  };
};

const SA_RAW = Deno.env.get("FCM_SERVICE_ACCOUNT_JSON");
if (!SA_RAW) console.error("Missing FCM_SERVICE_ACCOUNT_JSON");
const SA = SA_RAW ? JSON.parse(SA_RAW) : null;

const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

const sb = SUPABASE_URL && SERVICE_ROLE_KEY
  ? createClient(SUPABASE_URL, SERVICE_ROLE_KEY)
  : null;

function b64url(bytes: Uint8Array | ArrayBuffer) {
  const bin = String.fromCharCode(
    ...new Uint8Array(bytes instanceof ArrayBuffer ? bytes : bytes.buffer),
  );
  return btoa(bin).replaceAll("+", "-").replaceAll("/", "_").replaceAll("=", "");
}

async function getAccessToken(): Promise<string> {
  if (!SA) throw new Error("No service account JSON");
  const now = Math.floor(Date.now() / 1000);

  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: SA.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const enc = (o: unknown) => b64url(new TextEncoder().encode(JSON.stringify(o)));
  const unsigned = `${enc(header)}.${enc(claim)}`;

  const pem = (SA.private_key as string).replace(/-----[^-]+-----/g, "").replace(/\s+/g, "");
  const keyData = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const privateKey = await crypto.subtle.importKey(
    "pkcs8",
    keyData,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", privateKey, new TextEncoder().encode(unsigned));
  const jwt = `${unsigned}.${b64url(sig as ArrayBuffer)}`;

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  if (!res.ok) throw new Error(`oauth token error ${res.status}: ${await res.text()}`);
  const json = await res.json();
  return json.access_token as string;
}

async function sendToToken(
  accessToken: string,
  projectId: string,
  token: string,
  notification?: { title?: string; body?: string },
  data?: Record<string, string>,
  androidPayload?: Record<string, unknown>,
) {
  const url = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

  const body = {
    message: {
      token,
      notification: {
        title: notification?.title ?? "Benachrichtigung",
        body: notification?.body ?? "",
      },
      data: data ?? {},
      android: androidPayload ?? {},
    },
  };

  const res = await fetch(url, {
    method: "POST",
    headers: {
      authorization: `Bearer ${accessToken}`,
      "content-type": "application/json",
    },
    body: JSON.stringify(body),
  });

  const json = await res.json().catch(() => ({}));
  return { status: res.status, response: json };
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}

async function resolveTokensFromUserIds(userIds: string[]): Promise<string[]> {
  if (!sb) return [];
  if (!Array.isArray(userIds) || userIds.length === 0) return [];
  const { data, error } = await sb
    .from("users")
    .select("push_token")
    .in("id", userIds);
  if (error) {
    console.error("token lookup failed:", error);
    return [];
  }
  return (data ?? [])
    .map((r: any) => r.push_token)
    .filter((t: string | null) => !!t) as string[];
}

serve(async (req) => {
  if (req.method !== "POST") return json({ error: "Only POST allowed" }, 405);
  if (!SA?.project_id) return json({ error: "No project_id/SA" }, 500);

  try {
    const payload = (await req.json()) as SendPushPayload;

    // 1) Titel/Body aus oberer Ebene oder aus notification nehmen
    const title = payload.title ?? payload.notification?.title;
    const body = payload.body ?? payload.notification?.body;

    // 2) Tokens sammeln: direkt + (optional) via user_ids aus DB
    const directTokens = Array.isArray(payload.tokens) ? payload.tokens : [];
    const fromUsers = Array.isArray(payload.user_ids) && payload.user_ids.length > 0
      ? await resolveTokensFromUserIds(payload.user_ids)
      : [];
    let allTokens = [...new Set([...directTokens, ...fromUsers])].filter(Boolean);

    if (allTokens.length === 0) {
      return json({ error: "tokens[] required" }, 400);
    }

    // 3) Android-Defaults für Heads-Up (kann via payload.android überschrieben/ergänzt werden)
    const androidDefaults = {
      priority: "HIGH",
      notification: {
        channel_id: "high_importance_channel",
        sound: "default",
        icon: "ic_stat_notification",
      },
    };
    const android: Record<string, unknown> = {
      ...(androidDefaults as Record<string, unknown>),
      ...(payload.android ?? {}),
      notification: {
        ...(androidDefaults.notification as Record<string, unknown>),
        ...((payload.android?.notification ?? {}) as Record<string, unknown>),
      },
    };

    // 4) Access-Token holen & senden (parallel)
    const accessToken = await getAccessToken();

    const results: Array<{ status: number; response: any }> = await Promise.all(
      allTokens.map((t) =>
        sendToToken(
          accessToken,
          SA.project_id,
          t,
          { title, body },
          payload.data,
          android,
        )
      )
    );

    return json({ ok: true, count: allTokens.length, results });
  } catch (e) {
    console.error(e);
    return json({ error: String(e) }, 500);
  }
});
