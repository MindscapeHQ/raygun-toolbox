const fs = require('fs').promises;
const path = require('path');

async function cleanDir(dirPath) {
  try {
    await fs.rm(dirPath, { recursive: true, force: true });
    console.log(`Successfully removed ${dirPath}.`);
  } catch (err) {
    console.error(`Error removing ${dirPath}: ${err}`);
  }
}

cleanDir(path.join(__dirname, '../dist'));
