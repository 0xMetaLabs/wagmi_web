const fs = require('fs');
const path = require('path');

// Files that contain reownBrandingTemplate methods
const filesToModify = [
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/partials/w3m-legal-footer/index.js',
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/views/w3m-connecting-wc-view/index.js'
];

// Function to remove UX branding by making reownBrandingTemplate return null
function removeUXBranding(filePath) {
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;
    
    // Pattern 1: Full method with HTML template
    const pattern1 = /reownBrandingTemplate\s*\([^)]*\)\s*{[\s\S]*?return\s+html\s*`[\s\S]*?<wui-ux-by-reown>[\s\S]*?<\/wui-ux-by-reown>[\s\S]*?`;[\s\S]*?}/g;
    
    // Pattern 2: Method that checks remoteFeatures
    const pattern2 = /reownBrandingTemplate\s*\([^)]*\)\s*{[^}]*if\s*\([^}]*\)[^}]*return\s+null;[^}]*return\s+html[^}]*<wui-ux-by-reown>[^}]*<\/wui-ux-by-reown>[^}]*}/g;
    
    // Pattern 3: Any reownBrandingTemplate method
    const pattern3 = /reownBrandingTemplate\s*\([^)]*\)\s*{[^}]*}/g;
    
    // Try each pattern
    if (pattern1.test(content)) {
      content = content.replace(pattern1, 'reownBrandingTemplate(showOnlyBranding = false) {\n        return null;\n    }');
      modified = true;
    } else if (pattern2.test(content)) {
      content = content.replace(pattern2, 'reownBrandingTemplate(showOnlyBranding = false) {\n        return null;\n    }');
      modified = true;
    } else {
      // Check if method exists and doesn't already return null
      const matches = content.match(pattern3);
      if (matches && matches.some(match => !match.includes('return null'))) {
        content = content.replace(pattern3, (match) => {
          if (!match.includes('return null')) {
            return 'reownBrandingTemplate(showOnlyBranding = false) {\n        return null;\n    }';
          }
          return match;
        });
        modified = true;
      }
    }
    
    if (modified) {
      fs.writeFileSync(filePath, content, 'utf8');
      console.log(`✅ Successfully removed UX branding from: ${filePath}`);
      return true;
    } else {
      // Check if already modified
      if (content.includes('reownBrandingTemplate') && content.includes('return null')) {
        console.log(`✓ Already modified: ${filePath}`);
        return true;
      }
      console.log(`⚠️  No changes needed for: ${filePath}`);
      return false;
    }
  } catch (error) {
    console.error(`❌ Error processing ${filePath}:`, error.message);
    if (error.code === 'EACCES') {
      console.error('   Permission denied. Try running with sudo:');
      console.error('   sudo node wagmi_remove_footer_completely.js');
    }
    return false;
  }
}

// Main execution
console.log('🔧 Removing UX branding from all Reown AppKit views...\n');

let successCount = 0;
let totalFiles = filesToModify.length;

for (const file of filesToModify) {
  if (removeUXBranding(file)) {
    successCount++;
  }
}

console.log(`\n✨ Processed ${successCount}/${totalFiles} files.`);

if (successCount === totalFiles) {
  console.log('🎉 All UX branding has been successfully removed!');
} else {
  console.log('⚠️  Some files could not be modified. You may need to run with sudo.');
}