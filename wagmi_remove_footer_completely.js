const fs = require('fs');
const path = require('path');

// Files that contain reownBrandingTemplate methods - updated for new structure
const filesToModify = [
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/partials/w3m-legal-footer/index.js',
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/views/w3m-connecting-wc-view/index.js',
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/views/w3m-connect-view/index.js',
  'node_modules/@reown/appkit-scaffold-ui/dist/esm/src/views/w3m-connecting-wc-basic-view/index.js'
];

// Function to remove UX branding by making reownBrandingTemplate return null
function removeUXBranding(filePath) {
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;
    
    // Pattern 1: Method with if checks and HTML return (like in connect-view)
    const pattern1 = /reownBrandingTemplate\s*\([^)]*\)\s*{\s*if\s*\([^{]*\)\s*{\s*return\s+null;\s*}\s*if\s*\([^{]*\)\s*{\s*return\s+null;\s*}\s*return\s+html\s*`[^`]*<wui-ux-by-reown>[^`]*`;\s*}/g;
    
    // Pattern 2: Method with single if check and HTML return (like in connecting-wc-basic-view) 
    const pattern2 = /reownBrandingTemplate\s*\([^)]*\)\s*{\s*if\s*\([^{]*\)\s*{\s*return\s+null;\s*}\s*return\s+html\s*`[^`]*<wui-ux-by-reown>[^`]*`;\s*}/g;
    
    // Pattern 3: Any method that contains wui-ux-by-reown HTML
    const pattern3 = /reownBrandingTemplate\s*\([^)]*\)\s*{[^}]*<wui-ux-by-reown>[^}]*}/g;
    
    // Pattern 4: Any reownBrandingTemplate method that doesn't already return null
    const pattern4 = /reownBrandingTemplate\s*\([^)]*\)\s*{(?![^}]*return\s+null)[^}]*}/g;
    
    // Check if already returns null in all methods
    const nullReturns = content.match(/reownBrandingTemplate\s*\([^)]*\)\s*{\s*return\s+null;\s*}/g);
    const allMethods = content.match(/reownBrandingTemplate\s*\([^)]*\)\s*{[^}]*}/g);
    
    if (allMethods && nullReturns && nullReturns.length === allMethods.length) {
      console.log(`✓ Already modified: ${filePath}`);
      return true;
    }
    
    // Apply patterns in order of specificity
    if (pattern1.test(content)) {
      content = content.replace(pattern1, 'reownBrandingTemplate() {\n        return null;\n    }');
      modified = true;
    }
    
    if (pattern2.test(content)) {
      content = content.replace(pattern2, 'reownBrandingTemplate() {\n        return null;\n    }');
      modified = true;
    }
    
    if (pattern3.test(content)) {
      content = content.replace(pattern3, 'reownBrandingTemplate() {\n        return null;\n    }');
      modified = true;
    }
    
    if (pattern4.test(content)) {
      content = content.replace(pattern4, 'reownBrandingTemplate() {\n        return null;\n    }');
      modified = true;
    }
    
    if (modified) {
      fs.writeFileSync(filePath, content, 'utf8');
      console.log(`✅ Successfully removed UX branding from: ${filePath}`);
      return true;
    } else {
      console.log(`⚠️  No reownBrandingTemplate methods found or no changes needed: ${filePath}`);
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