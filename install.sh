#!/bin/bash

# ==========================================
# Claude Code Termux Auto-Installer
# Creado por: kuromi04
# Basado en: Alishahryar1/free-claude-code
# Agradecimientos: Comunidad ivan3bycinderella
# ==========================================

set -e

echo "🚀 Iniciando instalación profesional de Claude Code en Termux..."

# 1. Actualización de paquetes de Termux
echo "📦 Instalando dependencias de Termux..."
pkg update -y
pkg install -y proot-distro git python nodejs-lts rust binutils coreutils

# 2. Configuración del Proxy (free-claude-code)
if [ ! -d "$HOME/free-claude-code" ]; then
    echo "📥 Clonando servidor proxy..."
    git clone https://github.com/Alishahryar1/free-claude-code.git "$HOME/free-claude-code"
fi

cd "$HOME/free-claude-code"

# 3. Aplicando Parches de Python (Hacks de compatibilidad)
echo "🔧 Aplicando parches de compatibilidad Python..."

# Crear Mock de Tiktoken
cat << 'EOF' > tiktoken_mock.py
class MockEncoding:
    def encode(self, text, *args, **kwargs): return [0] * (len(text) // 4 + 1)
    def decode(self, tokens): return ""
def get_encoding(name): return MockEncoding()
def encoding_for_model(model): return MockEncoding()
EOF

# Parchear archivos para usar el Mock y corregir sintaxis
sed -i 's/import tiktoken/try:\n    import tiktoken\nexcept ImportError:\n    import sys, os\n    sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..\/..\/..")))\n    import tiktoken_mock as tiktoken/g' core/anthropic/tokens.py core/anthropic/sse.py

# Corregir errores de sintaxis en excepciones
find . -name "*.py" -exec sed -i 's/except \([a-zA-Z0-9._]*\), \([a-zA-Z0-9._]*\):/except (\1, \2):/g' {} +

# Añadir future annotations (si no existen)
for file in config/settings.py providers/error_mapping.py providers/openai_compat.py providers/rate_limit.py; do
    if ! grep -q "from __future__ import annotations" "$file"; then
        sed -i '1i from __future__ import annotations' "$file"
    fi
done

# Fix específico para la carga de API Key
sed -i 's/nvidia_nim_api_key: str = ""/nvidia_nim_api_key: str = Field(default="", validation_alias="NVIDIA_NIM_API_KEY")/g' config/settings.py

# 4. Instalando dependencias de Python
echo "🐍 Instalando librerías de Python..."
pip install fastapi uvicorn python-dotenv loguru aiohttp pydantic-settings httpx[socks] openai pydantic markdown-it-py

# 5. Configuración de Ubuntu (Entorno de ejecución)
echo "🐧 Configurando entorno Ubuntu (glibc)..."
if ! proot-distro list | grep -q "installed.*ubuntu"; then
    proot-distro install ubuntu
fi

echo "🌐 Instalando Claude Code dentro de Ubuntu..."
# Detectar arquitectura para nodejs
ARCH=$(uname -m)
NODE_VER="20"
proot-distro login ubuntu -- bash -c "
    apt update && apt install -y curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo \"deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VER.x nodistro main\" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt update && apt install -y nodejs && \
    npm install -g @anthropic-ai/claude-code
"

# 6. Creación del acceso directo (Lanzador Inteligente Todo-en-Uno)
echo "Bridge Creando comando todo-en-uno..."
mkdir -p ~/.local/bin
cat << 'EOF' > ~/.local/bin/claude
#!/bin/bash
# Lanzador inteligente de Claude Code para Termux
# Maneja el proxy automáticamente y asegura persistencia

PROXY_DIR="$HOME/free-claude-code"
PROXY_PORT=8082

# 1. Iniciar/Verificar Proxy
if ! lsof -Pi :$PROXY_PORT -sTCP:LISTEN -t >/dev/null ; then
    echo "🚀 Iniciando proxy free-claude-code..."
    pkill -f "python server.py" 2>/dev/null || true
    cd "$PROXY_DIR"
    python server.py > "$HOME/.claude_proxy.log" 2>&1 &
    PROXY_PID=$!
    
    # Esperar a que el proxy esté saludable
    echo -n "⏳ Esperando al proxy..."
    MAX_RETRIES=15
    COUNT=0
    while ! curl -s "http://127.0.0.1:$PROXY_PORT/v1/models" > /dev/null; do
        sleep 1
        echo -n "."
        ((COUNT++))
        if [ $COUNT -ge $MAX_RETRIES ]; then
            echo -e "\n❌ Error: El proxy no inició a tiempo. Revisa ~/.claude_proxy.log"
            exit 1
        fi
    done
    echo " ¡Listo!"
fi

# 2. Sincronizar API Key si existe en .env local
if [ -f "$PROXY_DIR/.env" ]; then
    export $(grep -v '^#' "$PROXY_DIR/.env" | xargs)
fi

# 3. Lanzar Claude dentro de Ubuntu
# Usamos --bind para compartir carpetas si es necesario en el futuro
proot-distro login ubuntu -- bash -c "
    export ANTHROPIC_AUTH_TOKEN=freecc; 
    export ANTHROPIC_BASE_URL=http://127.0.0.1:$PROXY_PORT; 
    export CLAUDE_CONFIG_DIR=/home/$(whoami)/.claude;
    claude \"\$@\"
"
EOF
chmod +x ~/.local/bin/claude

echo "✅ ¡INSTALACIÓN COMPLETADA POR KUROMI04!"
echo "-------------------------------------------------------"
echo "1. Configura tu API Key en: ~/free-claude-code/.env"
echo "2. Usa el comando directamente: claude"
echo "-------------------------------------------------------"
