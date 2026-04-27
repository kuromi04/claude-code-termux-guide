# 📱 Claude Code en Termux (Android) — Auto Installer 🚀

![GitHub stars](https://img.shields.io/github/stars/kuromi04/claude-code-termux-guide?style=for-the-badge&color=ffd700)
![Python Version](https://img.shields.io/badge/python-3.13+-blue?style=for-the-badge&logo=python)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Termux](https://img.shields.io/badge/platform-Termux-orange?style=for-the-badge&logo=termux)

Una solución profesional y automatizada para ejecutar el CLI oficial de **Claude Code** en dispositivos Android. Superamos las barreras de arquitectura y librerías nativas mediante hacks de ingeniería y virtualización ligera.

---

## ✨ Características Principales

*   🤖 **Motor de IA de Vanguardia:** Integración nativa con la API de **NVIDIA NIM** (Llama 3.1 70B/405B).
*   ⚡ **Instalación Relámpago:** Script "One-Tap" que configura todo por ti.
*   🐧 **Entorno Híbrido:** Usa Ubuntu vía `proot-distro` para garantizar compatibilidad con binarios `glibc`.
*   🛠️ **Mobile Optimized:** Mocking inteligente de dependencias (`tiktoken`) para evitar fallos de compilación en ARM64.
*   🛡️ **Seguridad:** Manejo seguro de variables de entorno y API keys.

---

## 📋 Requisitos y Dependencias

El instalador configura automáticamente este ecosistema:

| Categoría | Herramientas |
| :--- | :--- |
| **Sistema** | `proot-distro`, `git`, `python`, `nodejs-lts`, `rust` |
| **Backend** | `fastapi`, `uvicorn`, `pydantic-settings`, `openai` |
| **Utilidades** | `loguru`, `httpx[socks]`, `markdown-it-py` |
| **Virtualización** | Ubuntu Jammy (para compatibilidad con Claude CLI) |

---

## 🚀 Instalación Rápida

Para desplegar todo el entorno en segundos, copia y pega este comando en tu terminal de **Termux**:

```bash
curl -sSL https://raw.githubusercontent.com/kuromi04/claude-code-termux-guide/master/install.sh | bash
```

### ⚙️ Configuración de la API
1. Consigue tu llave gratuita en [NVIDIA Build](https://build.nvidia.com/).
2. Configura tu entorno:
   ```bash
   nano ~/free-claude-code/.env
   ```
   E inserta tu llave en la línea: `NVIDIA_NIM_API_KEY="TU_KEY_AQUI"`.

---

## 🖥️ Modo de Uso

Para disfrutar de Claude Code, solo necesitas dos pasos:

1.  **Activa el Proxy (Pestaña 1):**
    ```bash
    ```
2.  **Lanza Claude (Pestaña 2):**
    ```bash
    claude
    ```

---

## 🤝 Créditos y Agradecimientos

Este proyecto es posible gracias a:

*   👤 **Autor Principal:** [kuromi04](https://github.com/kuromi04) 
*   📡 **Core Proxy:** Basado en el motor de [Alishahryar1/free-claude-code](https://github.com/Alishahryar1/free-claude-code).
*   👥 **Comunidad:** Gratitud especial a la comunidad de **ivan3bycinderella** por su constante innovación y soporte.

---
<p align="center">
  Hecho con ❤️ para la comunidad de Termux
</p>
