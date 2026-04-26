# Claude Code en Android (Termux) con NVIDIA NIM API

Este repositorio es una guía técnica sobre cómo logramos instalar y ejecutar **Claude Code** de forma gratuita en Android usando Termux, superando limitaciones de arquitectura y dependencias críticas.

## 🚀 Logros del Proyecto
- **Arquitectura:** Ejecución exitosa en Android ARM64.
- **API:** Integración con NVIDIA NIM (usando Llama 3.1 70B como motor).
- **Entorno:** Bypass de librerías nativas usando Ubuntu vía `proot-distro`.
- **Hacks de Python:** Mock de `tiktoken` para evitar errores de compilación de Rust en dispositivos móviles.

## 🛠️ Paso a Paso del Setup

### 1. Servidor Proxy (Middleman)
Usamos el repo de [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code) para traducir las peticiones de Claude (formato Anthropic) al formato de NVIDIA NIM.

```bash
git clone https://github.com/Alishahryar1/free-claude-code.git
cd free-claude-code
```

### 2. El "Hack" de Tiktoken
`tiktoken` es una dependencia pesada que requiere un compilador de Rust configurado específicamente, lo cual falla en muchos entornos de Termux. La solución fue crear un mock (`tiktoken_mock.py`) que simula la interfaz del codificador:

```python
# tiktoken_mock.py
class MockEncoding:
    def encode(self, text, *args, **kwargs):
        return [0] * (len(text) // 4 + 1) # Estimación simple
    def decode(self, tokens): return ""

def get_encoding(name): return MockEncoding()
def encoding_for_model(model): return MockEncoding()
```

### 3. Parches Manuales
Para que el servidor funcionara en Python 3.13 de Termux, aplicamos:
- **Forward Annotations:** Añadimos `from __future__ import annotations` en `config/settings.py`.
- **Sintaxis de Excepciones:** Corregimos `except TypeError, ValueError:` a `except (TypeError, ValueError):` en `core/anthropic/tokens.py`.

### 4. Entorno de Compatibilidad (Ubuntu)
El CLI de Claude Code viene como un binario nativo que busca la librería `glibc` y el cargador `ld-linux-aarch64.so.1`. Como Android usa `bionic`, instalamos una distro ligera para proveer el entorno necesario:

```bash
pkg install proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
# Dentro: instalar Node.js y el CLI
apt update && apt install nodejs npm
npm install -g @anthropic-ai/claude-code
```

### 5. El Puente Termux-Ubuntu
Finalmente, creamos un script ejecutable en `~/.local/bin/claude` que conecta el Proxy (que corre en Termux nativo) con el CLI (que corre dentro de Ubuntu):

```bash
#!/bin/bash
proot-distro login ubuntu -- bash -c "export ANTHROPIC_AUTH_TOKEN=freecc; export ANTHROPIC_BASE_URL=http://127.0.0.1:8082; claude \"\$@\""
```

## 🖥️ Uso Diario
1. Iniciar el Proxy: `python ~/free-claude-code/server.py`
2. Lanzar Claude: `claude`

---
**Créditos:** Proyecto realizado y documentado con la asistencia de **Gemini CLI Agent**.
