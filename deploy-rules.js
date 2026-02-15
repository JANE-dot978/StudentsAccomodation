#!/usr/bin/env node
const { execSync } = require('child_process');
const path = require('path');

try {
  console.log('🚀 Deploying Firestore rules...');
  const result = execSync('firebase deploy --only firestore:rules', {
    cwd: path.dirname(__filename),
    stdio: 'inherit',
  });
  console.log('✅ Rules deployed successfully!');
} catch (error) {
  console.error('❌ Deployment failed. Please manually deploy:');
  console.error('   1. Go to Firebase Console');
  console.error('   2. Firestore → Rules tab');
  console.error('   3. Copy/paste rules from firestore.rules file');
  console.error('   4. Click Publish');
  process.exit(1);
}
