const fs = require('fs');
const path = require('path');

const docsDir = path.join(__dirname, '..', 'src', 'content', 'docs');

function formatTitle(name) {
  return name
    .split(/[-_ ]/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

function processDirectory(dir, folderName = '') {
  const items = fs.readdirSync(dir);
  
  // Check if this folder needs an index.mdx
  const hasIndex = items.some(item => item.toLowerCase() === 'index.md' || item.toLowerCase() === 'index.mdx');
  const isRoot = dir === docsDir;

  if (!isRoot && !hasIndex) {
    const title = formatTitle(folderName);
    // Calculate how many levels up we need to go to reach src/
    // src/content/docs/folder/index.mdx -> needs ../../../ to get to src/
    const levels = folderName.split('/').length + 2;
    const upPrefix = '../'.repeat(levels);
    const content = `---
title: ${title}
description: Category overview for ${title}
---

import FolderScanner from '${upPrefix}components/FolderScanner.astro';

Browse the notes in this category:

<FolderScanner folder="${folderName}" />
`;
    fs.writeFileSync(path.join(dir, 'index.mdx'), content);
    console.log(`[Auto-Gen] Created index.mdx for folder: ${folderName}`);
  }

  // Process files and subdirectories
  items.forEach(item => {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      processDirectory(fullPath, folderName ? `${folderName}/${item}` : item);
    } else if (item.endsWith('.md') || item.endsWith('.mdx')) {
      // Fix missing frontmatter
      let content = fs.readFileSync(fullPath, 'utf8');
      if (!content.trim().startsWith('---')) {
        const title = formatTitle(path.parse(item).name);
        const frontmatter = `---\ntitle: "${title}"\n---\n\n`;
        fs.writeFileSync(fullPath, frontmatter + content);
        console.log(`[Auto-Fix] Added frontmatter to: ${fullPath}`);
      }
    }
  });
}

console.log('Running pre-build maintenance...');
processDirectory(docsDir);
console.log('Maintenance complete.');
