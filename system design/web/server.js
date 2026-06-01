const http = require("http");
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const webRoot = __dirname;
const port = Number(process.env.PORT || 4173);

const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".md": "text/markdown; charset=utf-8"
};

function send(res, status, body, type = "text/plain; charset=utf-8") {
  res.writeHead(status, {
    "Content-Type": type,
    "Cache-Control": "no-store"
  });
  res.end(body);
}

function safeJoin(base, target) {
  const resolved = path.resolve(base, target);
  if (!resolved.startsWith(base)) return null;
  return resolved;
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const pathname = decodeURIComponent(url.pathname);

  if (pathname.startsWith("/content/")) {
    const requested = pathname.replace("/content/", "");
    const file = safeJoin(root, requested);
    if (!file || path.extname(file) !== ".md") {
      send(res, 403, "Forbidden");
      return;
    }
    fs.readFile(file, (error, data) => {
      if (error) {
        send(res, 404, "Not found");
        return;
      }
      send(res, 200, data, types[".md"]);
    });
    return;
  }

  const target = pathname === "/" ? "index.html" : pathname.slice(1);
  const file = safeJoin(webRoot, target);
  if (!file) {
    send(res, 403, "Forbidden");
    return;
  }

  fs.readFile(file, (error, data) => {
    if (error) {
      send(res, 404, "Not found");
      return;
    }
    send(res, 200, data, types[path.extname(file)] || "application/octet-stream");
  });
});

server.listen(port, () => {
  console.log(`System Design Learning Hub running at http://localhost:${port}`);
});
