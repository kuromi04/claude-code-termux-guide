# 📱 Claude Code en Termux (Android) - Auto Installer

Una solución profesional para ejecutar el CLI de **Claude Code** en dispositivos Android mediante Termux, utilizando modelos de **NVIDIA NIM** (como Llama 3.1) de forma gratuita.

---

## ✨ Características
- 🤖 **Motor de IA:** Usa la API de NVIDIA NIM (Llama 3.1 70B/405B).
- 🚀 **Instalación One-Tap:** Script automatizado que configura todo el entorno.
- 🐧 **Compatibilidad Total:** Implementación de Ubuntu vía `proot-distro` para dar soporte a binarios `glibc`.
- 🛠️ **Optimización Móvil:** Mocking de dependencias pesadas (`tiktoken`) para evitar errores de compilación en ARM64.

## 📋 Dependencias y Requisitos
El script instala automáticamente las siguientes bibliotecas y herramientas:
- **Herramientas de Sistema:** `proot-distro`, `git`, `python`, `nodejs`, `rust`, `binutils`.
- **Librerías Python:** `fastapi`, `uvicorn`, `pydantic-settings`, `httpx`, `openai`, `loguru`.
- **Entorno Linux:** Ubuntu (dentro de proot-distro) para compatibilidad con el CLI nativo de Anthropic.

## 🚀 Instalación

Para instalar todo el entorno, simplemente copia y pega este comando en tu terminal de Termux:

```bash
curl -sSL https://raw.githubusercontent.com/kuromi04/claude-code-termux-guide/main/install.sh | bash
```

### ⚙️ Configuración Post-Instalación
1. Obtén tu API Key gratuita en [NVIDIA Build](https://build.nvidia.com/).
2. Edita el archivo de configuración:
   ```bash
   nano ~/free-claude-code/.env
   ```
   E introduce tu clave en `NVIDIA_NIM_API_KEY`.

## 🖥️ Cómo empezar
1. **Inicia el servidor proxy:**
   ```bash
   cd ~/free-claude-code && python server.py
   ```
2. **Usa Claude Code** (en una nueva sesión de Termux):
   ```bash
   claude
   ```

## 🤝 Créditos y Agradecimientos
- **Desarrollador:** [kuromi04](https://github.com/kuromi04)
- **Servidor Proxy:** Basado en el excelente trabajo de [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code).
- **Soporte Comunitario:** Un agradecimiento especial a la comunidad de **ivan3bycinderella** por sus valiosas contribuciones y apoyo.

---
*Nota: Este proyecto es con fines educativos y de investigación. Claude Code es propiedad de Anthropic.*
