import { readFile } from "fs/promises";
import path from "path";

export default async function handler(req, res) {
  const userAgent = req.headers["user-agent"] || "";

  // Only allow these executors
  const allowed = /(Volcano|Delta|Xeno|Solara|Potassium|Volt)/i;
  if (!allowed.test(userAgent)) {
    res.status(404).sendFile(path.join(process.cwd(), "public/404.html"));
    return;
  }

  // Extract the requested Lua file from the URL
  const fileName = req.url.split("/").pop();
  if (!fileName || !fileName.endsWith(".lua")) {
    res.status(404).sendFile(path.join(process.cwd(), "public/404.html"));
    return;
  }

  try {
    const filePath = path.join(process.cwd(), "api", "scripts", fileName);
    const luaContent = await readFile(filePath, "utf-8");
    res.setHeader("Content-Type", "text/plain");
    res.status(200).send(luaContent);
  } catch (err) {
    res.status(404).sendFile(path.join(process.cwd(), "public/404.html"));
  }
}
