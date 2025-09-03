// supabase/functions/send_push/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { importPKCS8, SignJWT } from "https://deno.land/x/jose@v4.14.4/index.ts";

// ---- ENV / Setup ------------------------------------------------------------
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

// ---- Auth: Access Token via JOSE (stabil) -----------------------------------
async function getAccessToken(): Promise<string> {
  if (!SA?.client_email || !SA?.private_key) {
    throw new Error("Service Account JSON missing client_email or private_key");
  }
  const now = Math.floor(Date.now() / 1000);

  const jwt = await new SignJWT({
    iss: SA.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .sign(await importPKCS8(SA.private_key, "RS256"));

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!res.ok) {
    const txt = await res.text().catch(() => "");
    throw new Error(`oauth token error ${res.status}: ${txt}`);
  }
  const json = await res.json();
  return json.access_token as string;
}

// ---- FCM v1 Call -------------------------------------------------------------
async function sendToToken(
  accessToken: string,
  projectId: string,
  token: string,
  notification: { title?: string; body?: string } | null,
  data: Record<string, string> | undefined,
  androidPayload: Record<string, unknown> | undefined,
) {
  const url = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;
  const hasAlert = !!(notification?.title || notification?.body);

  const apns: Record<string, unknown> = {
    headers: {
      "apns-priority": hasAlert ? "10" : "5",
      "apns-push-type": hasAlert ? "alert" : "background",
    },
    payload: {
      aps: hasAlert
        ? {
            alert: {
              title: notification?.title ?? "Benachrichtigung",
              body: notification?.body ?? "",
            },
            sound: "default",
            badge: 1,
          }
        : { "content-available": 1 },
    },
  };

  const body = {
    message: {
      token,
      notification: hasAlert
        ? {
            title: notification?.title ?? "Benachrichtigung",
            body: notification?.body ?? "",
          }
        : undefined,
      data: data ?? {},
      android: androidPayload ?? {},
      apns,
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
    .from("users").select("push_token").in("id", userIds);
  if (error) {
    console.error("token lookup failed:", error);
    return [];
  }
  return (data ?? []).map((r) => r.push_token).filter((t) => !!t);
}

// ---- HTTP Handler -----------------------------------------------------------
serve(async (req) => {
  if (req.method !== "POST") return json({ error: "Only POST allowed" }, 405);
  if (!SA?.project_id) return json({ error: "No project_id/SA" }, 500);

  // --- Shared-secret check (Gateway auth ist separat via Bearer/anon) ---
  const expected = Deno.env.get("SEND_PUSH_AUTH");
  const provided = req.headers.get("x-send-push-auth");
  if (expected && expected !== provided) {
    return json({ error: "unauthorized" }, 401);
  }
  // ---------------------------------------------------------------------

  try {
    const payload = await req.json();
    const title = payload.title ?? payload.notification?.title;
    const bodyText = payload.body ?? payload.notification?.body;

    const directTokens: string[] = Array.isArray(payload.tokens) ? payload.tokens : [];
    const fromUsers: string[] =
      Array.isArray(payload.user_ids) && payload.user_ids.length > 0
        ? await resolveTokensFromUserIds(payload.user_ids)
        : [];
    const allTokens = [...new Set([...directTokens, ...fromUsers])].filter(Boolean);
    if (allTokens.length === 0) return json({ error: "tokens[] required" }, 400);

    const androidDefaults = {
      priority: "HIGH",
      notification: {
        channel_id: "high_importance_channel",
        sound: "default",
        icon: "ic_stat_notification",
      },
    };
    const android = {
      ...androidDefaults,
      ...(payload.android ?? {}),
      notification: {
        ...androidDefaults.notification,
        ...(payload.android?.notification ?? {}),
      },
    };

    const accessToken = await getAccessToken();
    const results = await Promise.all(
      allTokens.map((t) =>
        sendToToken(
          accessToken,
          SA.project_id,
          t,
          { title, body: bodyText },
          payload.data,
          android,
        )
      ),
    );

    return json({ ok: true, count: allTokens.length, results });
  } catch (e) {
    console.error(e);
    return json({ error: String(e) }, 500);
  }
});
