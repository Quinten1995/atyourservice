import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

// Diese Funktion löscht alle Daten zu einem User, inkl. Auth-User
serve(async (req) => {
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const { user } = await req.json();

  if (!user || !user.id) {
    return new Response(JSON.stringify({ error: "User ID fehlt" }), { status: 400 });
  }

  // Authorization prüfen (JWT)
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  // 1. Lösche Userdaten aus allen relevanten Tabellen (REST API-Calls)
  // Helper zum REST-Call
  async function deleteRows(table: string, match: Record<string, string | null>) {
    const params = new URLSearchParams();
    for (const key in match) {
      if (match[key] !== null) params.append(key, `eq.${match[key]}`);
    }
    const url = `${supabaseUrl}/rest/v1/${table}?${params.toString()}`;
    return await fetch(url, {
      method: "DELETE",
      headers: {
        "apikey": serviceRoleKey,
        "Authorization": `Bearer ${serviceRoleKey}`,
        "Content-Type": "application/json",
        "Prefer": "return=representation", // optional
      },
    });
  }

  // (1) User-Tabelle
  await deleteRows("users", { id: user.id });

  // (2) Dienstleister-Details
  await deleteRows("dienstleister_details", { user_id: user.id });

  // (3) Bewertungen (als Kunde und als Dienstleister)
  await deleteRows("bewertungen", { kunde_id: user.id });
  await deleteRows("bewertungen", { dienstleister_id: user.id });

  // (4) Aufträge (als Kunde und als Dienstleister)
  await deleteRows("auftraege", { kunde_id: user.id });
  await deleteRows("auftraege", { dienstleister_id: user.id });

  // (5) Rechnungen (als Dienstleister)
  await deleteRows("rechnungen", { dienstleister_id: user.id });

  // 2. Auth-User löschen
  const authDelete = await fetch(`${supabaseUrl}/auth/v1/admin/users/${user.id}`, {
    method: "DELETE",
    headers: {
      "apiKey": serviceRoleKey,
      "Authorization": `Bearer ${serviceRoleKey}`,
    },
  });

  if (authDelete.ok) {
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  } else {
    const err = await authDelete.text();
    return new Response(JSON.stringify({ error: err }), { status: 400 });
  }
});
