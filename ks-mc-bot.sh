#!/bin/bash

read -p "Enter File Name: " filename
read -p "Enter IP Address: " ip
read -p "Enter Port: " port
read -p "Enter Bot Name: " botname

cat <<EOF > $filename.js
const { ping } = require('minecraft-server-util')
const mineflayer = require('mineflayer')

// Server info
const host = '$ip'
const port = $port
const username = '$botname'

async function connectBot() {
  try {
    const status = await ping(host, port, { timeout: 5000 })
    const version = status.version.name
    console.log(\`✅ Java Edition detected! Version: \${version}\`)

    const bot = mineflayer.createBot({
      host,
      port,
      username,
      version
    })

    bot.on('login', () => {
      console.log(\`🤖 \${username} joined the server!\`)
    })

    bot.on('end', () => {
      console.log('❌ Disconnected! Reconnecting in 5s...')
      setTimeout(connectBot, 5000)
    })

    bot.on('error', (err) => {
      console.log('⚠️ Error:', err.message)
    })

  } catch (err) {
    console.error('❌ Could not connect:', err.message)
  }
}

connectBot()
EOF

echo "✅ $filename.js created successfully!"
