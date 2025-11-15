import fs from "fs";
import path from "path";

const allowedExecutors = [
    "Volcano",
    "Wave",
    "KRNL",
    "Volt",
    "Solara",
    "Electron",
    "Script-Ware",
    "Hydrogen",
    "Arceus",
    "Vega",
    "Fluxus",
    "Delta",
    "Xeno"
];

export default function handler(req, res) {
    const userAgent = req.headers["user-agent"] || "";
    const scriptName = req.query.name;

    // Check if request is from an executor
    const isExecutor = allowedExecutors.some(exec =>
        userAgent.toLowerCase().includes(exec.toLowerCase())
    );

    if (!isExecutor) {
        return res.status(403).send("Access denied: executor only.");
    }

    // Validate script name
    if (!scriptName || !scriptName.endsWith(".lua")) {
        return res.status(400).send("Invalid script name.");
    }

    // Path to the script file
    const scriptPath = path.join(process.cwd(), "scripts", scriptName);

    if (!fs.existsSync(scriptPath)) {
        return res.status(404).send("Script not found.");
    }

    // Send the Lua file
    const scriptContent = fs.readFileSync(scriptPath, "utf8");

    res.setHeader("Content-Type", "text/plain");
    res.status(200).send(scriptContent);
}
