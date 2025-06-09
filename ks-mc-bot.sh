#!/bin/bash

read -p "Enter File Name: " filename
read -p "Enter IP Address: " ip
read -p "Enter Port: " port
read -p "Enter Bot Name: " botname

cat <<EOF > $filename.js
const { ping, StatusBEDROCK } = require('minecraft-server-util')
const mineflayer = require('mineflayer')
const bedrock = require('bedrock-protocol')

// User-defined:
const host = '$ip'
const port = $port
const username = '$botname'

async function detectAndConnect(host, port, username) {
  try {
    // Try Java ping first
    const javaStatus = await ping(host, port, { timeout: 5000 })
    console.log(\`✅ Detected Java Edition! Version: \${javaStatus.version.name}\`)

    const bot = mineflayer.createBot({
      host,
      port,
      username,
      version: javaStatus.version.name // Use detected version
    })

    bot.on('login', () => {
      console.log(\`✅ \${username} joined Java server!\`)
    })

    bot.on('end', () => {
      console.log('❌ Disconnected from Java! Reconnecting in 5s...')
      setTimeout(() => detectAndConnect(host, port, username), 5000)
    })

    bot.on('error', err => {
      console.log('⚠️ Java Bot Error:', err.message)
    })

  } catch (e) {
    // Try Bedrock if Java ping fails
    try {
      const bedrockStatus = await StatusBEDROCK(host, port, { timeout: 5000 })
      console.log(\`✅ Detected Bedrock Edition! Version: \${bedrockStatus.version}\`)

      const client = bedrock.createClient({
        host,
        port,
        username,
        version: bedrockStatus.version
      })

      client.on('join', () => {
        console.log(\`✅ \${username} joined Bedrock server!\`)
      })

      client.on('disconnect', () => {
        console.log('❌ Disconnected from Bedrock! Reconnecting in 5s...')
        setTimeout(() => detectAndConnect(host, port, username), 5000)
      })

      client.on('error', err => {
        console.log('⚠️ Bedrock Bot Error:', err.message)
      })

    } catch (err2) {
      console.error('❌ Failed to detect server edition or connect:', err2.message)
    }
  }
}

detectAndConnect(host, port, username)
EOF

echo "✅ $filename.js created successfully!"
