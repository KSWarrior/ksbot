#!/bin/bash

read -p "Enter File Name: " filename
read -p "Enter MC Version: " mc_version
read -p "Enter IP Address: " ip
read -p "Enter Port: " port
read -p "Enter Bot Name: " botname

cat <<EOF > $filename.js
const mineflayer = require('mineflayer');

let retryCount = 0;
const MAX_RETRIES = 3600;
const RETRY_DELAY = 5000;

function createBot() {
  if (retryCount >= MAX_RETRIES) {
    console.log('❌ Max retries reached. Bot will not reconnect.');
    return;
  }

  const bot = mineflayer.createBot({
    host: '$ip',
    port: $port,
    username: '$botname',
    version: '$mc_version',
    auth: 'mojang' // or 'offline' for cracked servers
  });

  bot.on('login', () => {
    console.log('✅ Bot joined the server!');
    retryCount = 0;
  });

  bot.on('spawn', () => {
    console.log('🚀 Bot has spawned into the world!');
  });

  bot.on('kicked', (reason, loggedIn) => {
    console.log('❌ Bot was kicked:', reason);
  });

  bot.on('error', (err) => {
    console.log('❌ Error:', err.message);
  });

  bot.on('end', () => {
    retryCount++;
    console.log(\`🔄 Disconnected. Retry \${retryCount}/\${MAX_RETRIES} in 5s...\`);
    setTimeout(createBot, RETRY_DELAY);
  });
}

createBot();
EOF

echo "✅ $filename.js created successfully!"
