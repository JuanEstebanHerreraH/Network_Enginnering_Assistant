<div align="center">

# ⬡ Network Engineering Assistant

### Herramienta profesional para diseño de redes y configuración Cisco IOS

*Subnetting · VLSM · VLANs · Routing · NAT · ACL · Aprendizaje guiado*

---

![Flutter](https://img.shields.io/badge/Flutter_3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart_3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)

</div>

---

## 📌 ¿Qué es Network Engineering Assistant?

Network Engineering Assistant es una aplicación multiplataforma construida en Flutter para estudiantes, administradores de red y candidatos a certificaciones CCNA/CCNP. Permite realizar cálculos de direccionamiento IP, diseño de redes con VLANs, generación automática de configuraciones Cisco IOS y aprendizaje guiado con ejemplos reales.

Toda la lógica de cálculo vive en las capas `/core` y `/engine`, completamente separada de la UI y 100% testeable.

---

## 🧩 Módulos del sistema

| Ícono | Módulo | Descripción |
|:---:|---|---|
| 🌐 | **Subnetting IPv4** | Cálculo de subredes con explicación paso a paso en binario |
| 🔢 | **Análisis IPv6** | Expansión, compresión y clasificación de direcciones IPv6 |
| 📐 | **Calculadora VLSM** | Variable Length Subnet Masking optimizado por requerimientos |
| 🏷️ | **Diseñador de VLANs** | Planificación de VLANs con estándar IEEE 802.1Q |
| 🔀 | **Router-on-a-Stick** | Generador de config para inter-VLAN routing |
| 🗺️ | **Rutas Estáticas** | Generador de rutas estáticas IPv4/IPv6 y flotantes |
| 🔄 | **RIP & OSPF** | Conceptos, configuración y límites de protocolos de enrutamiento |
| 🔁 | **Planificador NAT** | Static, Dynamic y PAT/Overload con config Cisco |
| 🛡️ | **Constructor ACL** | ACLs estándar, extendidas, nombradas y máscaras wildcard |
| 📚 | **Modo Aprendizaje** | 10 lecciones completas con ejemplos en Cisco IOS |

---

## 🏗️ Arquitectura del proyecto

```
lib/
├── 📁 app/                     # Navegación, pantallas, providers (estado)
├── 📁 core/                    # Lógica de cálculo pura (sin UI)
│   ├── ipv4_calculator.dart
│   ├── ipv6_calculator.dart
│   ├── vlsm_calculator.dart
│   ├── vlan_calculator.dart
│   └── acl_builder.dart
├── 📁 engine/                  # Generación de configs y contenido de lecciones
│   ├── config_generator.dart
│   ├── explanation_engine.dart
│   └── router_config_engine.dart
├── 📁 models/                  # Tipos de datos inmutables
├── 📁 components/              # Widgets reutilizables de UI
└── 📁 utils/                   # Helpers de matemática IP y validadores
```

> 💡 **Principio clave:** Ningún cálculo ocurre en la capa de UI. Toda la lógica de negocio vive en `/core` y `/engine`.

---

## 🚀 Instalación local (Desarrolladores)

### Requisitos previos
- Flutter 3.x y Dart 3.x
- Un emulador, dispositivo físico o escritorio configurado

### Pasos

**1. Instalar Flutter**
```bash
# macOS vía Homebrew
brew install --cask flutter

# Verificar instalación
flutter doctor
```
> Para Windows, descarga el SDK desde https://docs.flutter.dev/get-started/install

**2. Clonar el repositorio**
```bash
git clone https://github.com/TU_USUARIO/network-engineering-assistant.git
cd network-engineering-assistant
```

**3. Instalar dependencias**
```bash
flutter pub get
```

**4. Ejecutar la app**
```bash
flutter run                  # Detecta dispositivo automáticamente
flutter run -d android       # Emulador/dispositivo Android
flutter run -d windows       # Escritorio Windows
flutter run -d macos         # Escritorio macOS
flutter run -d linux         # Escritorio Linux
```

Abre la app en tu dispositivo o emulador ✅

---

## 📦 Compilar ejecutables para usuarios finales

### Android APK (instalación directa)
```bash
flutter build apk --release
# Salida: build/app/outputs/flutter-apk/app-release.apk
```

### Android AAB (Google Play Store)
```bash
flutter build appbundle --release
# Salida: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA (requiere macOS + Xcode)
```bash
flutter build ipa --release
# Luego exportar desde Xcode Organizer
```

### Windows EXE
```bash
flutter build windows --release
# Salida: build/windows/x64/runner/Release/
# Comprime la carpeta Release/ completa para distribución
```

### macOS App / DMG
```bash
flutter build macos --release
# Salida: build/macos/Build/Products/Release/network_engineering_assistant.app

# Crear DMG (requiere create-dmg):
brew install create-dmg
create-dmg \
  --volname "Network Engineering Assistant" \
  --window-size 600 400 \
  --icon-size 100 \
  --app-drop-link 400 150 \
  "NetworkEngineeringAssistant.dmg" \
  "build/macos/Build/Products/Release/"
```

### Linux AppImage
```bash
flutter build linux --release
# Salida: build/linux/x64/release/bundle/
# Empaquetar con appimagetool: https://appimage.github.io/appimagetool/
```

---

## ☁️ Subir el proyecto a GitHub (Git Bash)

### 1️⃣ Crear repositorio en GitHub
1. Ve a [github.com](https://github.com) e inicia sesión
2. Clic en **New repository**
3. Nombre: `network-engineering-assistant`
4. **Sin** README, **sin** .gitignore → clic en **Create repository**

### 2️⃣ Inicializar y subir desde Git Bash

```bash
# Entrar a la carpeta del proyecto
cd /ruta/a/network-engineering-assistant

# Inicializar git
git init

# Agregar todos los archivos
git add .

# Primer commit
git commit -m "feat: initial release — Network Engineering Assistant"

# Renombrar rama principal
git branch -M main

# Conectar con tu repositorio remoto (reemplaza TU_USUARIO)
git remote add origin https://github.com/TU_USUARIO/network-engineering-assistant.git

# Subir el código
git push -u origin main
```

> 💡 Si Git Bash pide credenciales, usa un **Personal Access Token** en lugar de tu contraseña:
> GitHub → Settings → Developer settings → Personal access tokens → Generate new token

---

## 🏷️ Publicar el ZIP en GitHub Releases (para usuarios finales)

### Opción A — Desde la interfaz web de GitHub

1. Ve a tu repositorio en GitHub
2. En el panel derecho, clic en **Releases → Create a new release**
3. En **Tag version** escribe: `v1.0.0`
4. En **Release title** escribe: `Network Engineering Assistant v1.0.0`
5. En la descripción agrega las novedades o un changelog
6. En la sección **Attach binaries**, arrastra y suelta tu archivo `AppNetwork.zip`
7. Clic en **Publish release** 🚀

Los usuarios podrán descargar el ZIP directamente desde:
`https://github.com/TU_USUARIO/network-engineering-assistant/releases`

### Opción B — Desde Git Bash con GitHub CLI

```bash
# Instalar GitHub CLI si no lo tienes: https://cli.github.com
gh auth login

# Crear el release y subir el ZIP en un solo comando
gh release create v1.0.0 AppNetwork.zip \
  --title "Network Engineering Assistant v1.0.0" \
  --notes "Primera versión pública. Incluye: Subnetting IPv4/IPv6, VLSM, VLANs, NAT, ACL y modo aprendizaje."
```

### 3️⃣ Para actualizaciones futuras

```bash
# Cuando tengas cambios nuevos:
git add .
git commit -m "feat: descripción del cambio"
git push

# Crear nuevo release con nueva versión
gh release create v1.1.0 AppNetwork.zip \
  --title "Network Engineering Assistant v1.1.0" \
  --notes "- Mejora X\n- Fix en Y\n- Nueva función Z"
```

---

## 🛠️ Stack tecnológico

| Capa | Tecnología |
|---|---|
| Framework | Flutter 3.x |
| Lenguaje | Dart 3.x |
| Estado | Provider |
| Navegación | GoRouter |
| Arquitectura | Clean Architecture |
| Plataformas | Android, iOS, Windows, macOS, Linux |

---

## 📚 Temas de redes cubiertos

- IPv4 Subnetting (CIDR, binario, paso a paso)
- IPv6 Addressing (expansión, compresión, tipos)
- VLSM (Variable Length Subnet Masking)
- Diseño de VLANs (IEEE 802.1Q)
- Router-on-a-Stick (inter-VLAN routing)
- Rutas Estáticas (IPv4/IPv6, flotantes)
- RIP v2 (conceptos y limitaciones)
- OSPF (link-state, áreas, DR/BDR)
- NAT (Static, Dynamic, PAT/Overload)
- ACL (Estándar, Extendida, nombrada, wildcard masks)

---

## 📄 Licencia

MIT License — libre para usar, modificar y distribuir.

---

<div align="center">

Desarrollado con ⬡ para estudiantes y profesionales de redes

</div>
