#!/bin/bash

# Exit if any command fails
set -e

echo "🚀 Bootstrapping Llamafile + Open WebUI setup..."

# Step 1: Install dependencies
echo "🔧 Installing dependencies..."
sudo dnf update -y
sudo dnf install -y curl wget unzip python3 python3-venv docker

# Step 2: Download Llamafile
echo "📥 Downloading Llamafile..."
wget -O llamafile https://huggingface.co/jartine/llamafile/releases/latest/download/llamafile-linux-x86_64
chmod +x llamafile

# Step 3: Download a Llama model (e.g., Mistral 7B or Llama 2)
echo "🤖 Downloading Llama model..."
mkdir -p models
cd models
wget -O model.gguf https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q4_K_M.gguf
cd ..

# Step 4: Run Llamafile in API mode
echo "🚀 Running Llamafile..."
./llamafile -m models/model.gguf --server > llamafile.log 2>&1 &

# Step 5: Set up Open WebUI
echo "🌐 Setting up Open WebUI..."
sudo docker pull openwebui/open-webui:latest
sudo docker run -d --name openwebui -p 3000:3000 \
  -e OLLAMA_API_BASE_URL="http://localhost:8080" \
  openwebui/open-webui:latest

echo "🎉 Setup complete! Access Open WebUI at: http://localhost:3000"
