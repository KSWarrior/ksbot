#!/bin/bash

echo "🔍 Checking system compatibility..."
if ! command -v apt &> /dev/null; then
  echo "❌ This script only supports APT-based systems (Debian/Ubuntu)."
  exit 1
fi

echo "📦 Updating package list..."
apt update -y

echo "🧰 Installing curl and build tools (if missing)..."
apt install -y curl build-essential

echo "⬇️ Installing Node.js 18.x and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

echo "✅ Node.js version: $(node -v)"
echo "✅ npm version: $(npm -v)"

echo "🚀 Installing PM2 globally..."
npm install -g pm2

echo "✅ pm2 version: $(pm2 -v)"

echo "🚀 Installing mineflayer..."
npm init -y
npm install mineflayer
echo "🎉 All done! Node.js, npm, mineflayer and pm2 are installed."
