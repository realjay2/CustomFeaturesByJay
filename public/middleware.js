export default function middleware(req) {
    const executorAgents = [
        "Volt",
        "Volcano",
        "Potassium",
        "ScriptWare",
        "SW",
        "Krnl",
        "Solara",
        "Synapse",
        "SynapseZ",
        "Fluxus",
        "Codex",
        "Wave",
        "Vortex",

        "Delta",
        "Hydrogen",
        "Arceus",
        "Arceus X",
        "CodexAndroid",
        "Panda"
    ];

    const ua = req.headers.get("user-agent") || "";

    const isExecutor = executorAgents.some(exec =>
        ua.toLowerCase().includes(exec.toLowerCase())
    );

    if (!isExecutor) {
        return new Response("Access Denied: Executor Required", {
            status: 403,
            headers: { "Content-Type": "text/plain" }
        });
    }

    return;
}
