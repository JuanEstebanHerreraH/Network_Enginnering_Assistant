<div align="center">

# ⬡ Network Engineering Assistant

### Herramienta profesional para diseño de redes y configuración Cisco IOS

*Subnetting · VLSM · VLANs · Routing · NAT · ACL · Aprendizaje guiado*

---

![Flutter](https://img.shields.io/badge/Flutter_3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart_3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)

</div>

---

## 📌 ¿Qué es Network Engineering Assistant?

Network Engineering Assistant es una aplicación para **Android y Windows** construida en Flutter para estudiantes, administradores de red y candidatos a certificaciones CCNA/CCNP. Permite realizar cálculos de direccionamiento IP, diseño de redes con VLANs, generación automática de configuraciones Cisco IOS y aprendizaje guiado con ejemplos reales.

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

## 📥 Instalación para usuarios finales

1. Ve a la pestaña **[Releases](../../releases)** de este repositorio
2. Descarga **`AppNetwork.zip`**
3. Extrae el ZIP y entra a la carpeta de tu plataforma:

| Carpeta | Archivo | Plataforma |
|---|---|---|
| `Android/` | `app-release.apk` | Android 6.0+ |
| `Windows/` | `network_engineering_asistant.exe` | Windows 10/11 |

**Android:** Activa *"Instalar apps de fuentes desconocidas"* en Ajustes antes de instalar el APK.

**Windows:** Doble clic en el `.exe`. Si aparece aviso de SmartScreen → *"Más información → Ejecutar de todas formas"*.

---

## 🚀 Instalación para desarrolladores

### Requisitos previos
- Flutter 3.x y Dart 3.x
- Dispositivo/emulador Android o escritorio Windows

**1. Clonar el repositorio**
```bash
git clone https://github.com/EzequielAngel0/network-engineering-assistant.git
cd network-engineering-assistant
```

**2. Instalar dependencias y ejecutar**
```bash
flutter pub get
flutter run -d android     # Android
flutter run -d windows     # Windows
```

**3. Compilar release**
```bash
# Android APK
flutter build apk --release
# Salida: build/app/outputs/flutter-apk/app-release.apk

# Windows EXE
flutter build windows --release
# Salida: build/windows/x64/runner/Release/
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
| Plataformas | Android · Windows |

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
