const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const outputPath = path.join(root, "assets", "js", "offline-data.js");

function readJson(relativePath) {
  return JSON.parse(fs.readFileSync(path.join(root, relativePath), "utf8"));
}

const data = {
  "data/lessons.json": readJson("data/lessons.json"),
  "data/roadmap.json": readJson("data/roadmap.json"),
  "data/diagrams.json": readJson("data/diagrams.json")
};

const markdown = {};
for (const lesson of data["data/lessons.json"]) {
  const source = path.join(root, lesson.path);
  if (fs.existsSync(source)) {
    markdown[lesson.path] = fs.readFileSync(source, "utf8");
  }
}

const output = `window.LEARNING_LIBRARY_DATA = ${JSON.stringify(data)};\nwindow.LEARNING_LIBRARY_MARKDOWN = ${JSON.stringify(markdown)};\n`;

fs.writeFileSync(outputPath, output);
console.log(`Wrote ${outputPath}`);
