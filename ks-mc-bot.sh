#!/bin/bash

# === Config ===
read -p "Enter Discord Member Name: " DC_USER
read -p "Enter IP Address: " MC_SERVER
read -p "Enter Port: " MC_PORT
read -p "Enter Bot File Name (without .js): " BOT_FILE

MC_VERSION=false

# === Create bot file ===
cat > "${BOT_FILE}.js" <<EOF
const mineflayer = require('mineflayer');

function start() {
  const bot = mineflayer.createBot({
    host: '${MC_SERVER}',
    port: ${MC_PORT},
    username: 'KS_Bot',
    version: ${MC_VERSION}
  });

  bot.on('spawn', () => {
    console.log('[+] KS_Bot joined the server!');
  });

  bot.on('end', () => {
    console.log('[!] Disconnected. Reconnecting in 5 seconds...');
    setTimeout(start, 5000);
  });

  bot.on('error', (err) => {
    console.log('[!] Error:', err.message);
    bot.end();
    setTimeout(start, 5000);
  });
}

start();
EOF

# === Start bot with PM2 ===
echo "[+] Starting KS_Bot for ${DC_USER} using PM2..."
pm2 start "${BOT_FILE}.js" --name "${DC_USER}"

# Optional: Save PM2 config to auto-start on reboot
# pm2 save
# pm2 startup
