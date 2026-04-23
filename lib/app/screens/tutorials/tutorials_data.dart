/// TutorialsData
/// Static content for the Tutorials & Guides section.
/// Equipment entries and step-by-step guides.

// ─── Equipment ────────────────────────────────────────────────────────────────

class NetworkEquipment {
  final String id;
  final String icon;
  final String nameEs;
  final String nameEn;
  final String summaryEs;
  final String summaryEn;
  final String layer;
  final List<String> features;
  final List<EquipmentSpec> specs;
  final List<String> useCases;
  final String? ciscoModels;
  final String accentHex;

  const NetworkEquipment({
    required this.id,
    required this.icon,
    required this.nameEs,
    required this.nameEn,
    required this.summaryEs,
    required this.summaryEn,
    required this.layer,
    required this.features,
    required this.specs,
    required this.useCases,
    this.ciscoModels,
    required this.accentHex,
  });
}

class EquipmentSpec {
  final String label;
  final String value;
  final String? labelEn;
  final String? valueEn;
  const EquipmentSpec(this.label, this.value, {this.labelEn, this.valueEn});
}

// ─── Step Guide ────────────────────────────────────────────────────────────────

class StepGuide {
  final String id;
  final String icon;
  final String titleEs;
  final String titleEn;
  final String summaryEs;
  final String summaryEn;
  final String difficulty; // 'Básico' | 'Intermedio' | 'Avanzado'
  final String category;
  final List<GuideStep> steps;

  const StepGuide({
    required this.id,
    required this.icon,
    required this.titleEs,
    required this.titleEn,
    required this.summaryEs,
    required this.summaryEn,
    required this.difficulty,
    required this.category,
    required this.steps,
  });
}

class GuideStep {
  final String titleEs;
  final String titleEn;
  final String contentEs;
  final String contentEn;
  final String? codeExample;
  final String? codeExampleEn;
  final String? tip;
  final String? tipEn;

  const GuideStep({
    required this.titleEs,
    required this.titleEn,
    required this.contentEs,
    required this.contentEn,
    this.codeExample,
    this.codeExampleEn,
    this.tip,
    this.tipEn,
  });
}

// ─── Equipment data ────────────────────────────────────────────────────────────

const equipmentList = <NetworkEquipment>[
  NetworkEquipment(
    id: 'router',
    icon: '🔌',
    nameEs: 'Router',
    nameEn: 'Router',
    summaryEs: 'El router es el dispositivo que conecta redes diferentes entre sí y dirige el tráfico de datos mediante tablas de enrutamiento.',
    summaryEn: 'A router connects different networks and directs data traffic using routing tables.',
    layer: 'Capa 3 — Red',
    features: [
      'Conecta múltiples redes (LAN, WAN, Internet)',
      'Toma decisiones de reenvío basadas en direcciones IP',
      'Soporta protocolos de enrutamiento (OSPF, RIP, BGP)',
      'Implementa NAT para traducir IPs privadas a públicas',
      'Aplica ACLs para filtrar tráfico',
      'Divide dominios de broadcast',
    ],
    specs: [
      EquipmentSpec('Capa OSI', 'Capa 3 (Red)', labelEn: 'OSI Layer', valueEn: 'Layer 3 (Network)'),
      EquipmentSpec('Direccionamiento', 'IP (IPv4 / IPv6)', labelEn: 'Addressing'),
      EquipmentSpec('PDU', 'Paquete', labelEn: 'PDU', valueEn: 'Packet'),
      EquipmentSpec('Tabla principal', 'Tabla de enrutamiento', labelEn: 'Main Table', valueEn: 'Routing Table'),
      EquipmentSpec('Dominios broadcast', 'Separa dominios', labelEn: 'Broadcast Domains', valueEn: 'Separates domains'),
    ],
    useCases: [
      'Conectar la red corporativa a Internet',
      'Interconectar sedes remotas (WAN)',
      'Enrutamiento entre VLANs (Router-on-a-Stick)',
      'Implementar NAT/PAT para acceso a Internet',
      'Aplicar políticas de seguridad con ACLs',
    ],
    ciscoModels: 'ISR 1000, ISR 4000, ASR 1000, Catalyst 8000',
    accentHex: '00C896',
  ),

  NetworkEquipment(
    id: 'switch',
    icon: '🔀',
    nameEs: 'Switch',
    nameEn: 'Switch',
    summaryEs: 'El switch opera en Capa 2 y conecta dispositivos dentro de la misma red local, aprendiendo direcciones MAC para reenviar tramas de forma inteligente.',
    summaryEn: 'A switch operates at Layer 2 and connects devices within the same LAN, learning MAC addresses to intelligently forward frames.',
    layer: 'Capa 2 — Enlace de datos',
    features: [
      'Conecta dispositivos en la misma LAN',
      'Aprende y almacena direcciones MAC en tabla CAM',
      'Reenvía tramas solo al puerto destino (no broadcast)',
      'Soporta VLANs para segmentación lógica',
      'Implementa STP para prevenir bucles',
      'Modo full-duplex: elimina colisiones',
    ],
    specs: [
      EquipmentSpec('Capa OSI', 'Capa 2 (Enlace)', labelEn: 'OSI Layer', valueEn: 'Layer 2 (Data Link)'),
      EquipmentSpec('Direccionamiento', 'MAC (48 bits)', labelEn: 'Addressing'),
      EquipmentSpec('PDU', 'Trama (Frame)', labelEn: 'PDU', valueEn: 'Frame'),
      EquipmentSpec('Tabla principal', 'Tabla CAM / MAC', labelEn: 'Main Table', valueEn: 'CAM / MAC Table'),
      EquipmentSpec('Dominios broadcast', 'Comparte dominio', labelEn: 'Broadcast Domains', valueEn: 'Shares domain'),
    ],
    useCases: [
      'Conectar PCs, impresoras y servidores en oficina',
      'Segmentar tráfico con VLANs',
      'Agregar ancho de banda con EtherChannel',
      'Distribuir VLANs entre pisos (trunking 802.1Q)',
      'Acceso a red para teléfonos IP (PoE)',
    ],
    ciscoModels: 'Catalyst 9200, 9300, 9400, Catalyst 2960',
    accentHex: '58A6FF',
  ),

  NetworkEquipment(
    id: 'firewall',
    icon: '🔥',
    nameEs: 'Firewall',
    nameEn: 'Firewall',
    summaryEs: 'El firewall inspecciona y filtra el tráfico de red según políticas de seguridad, protegiendo la red interna de amenazas externas.',
    summaryEn: 'A firewall inspects and filters network traffic based on security policies, protecting the internal network from external threats.',
    layer: 'Capas 3–7',
    features: [
      'Filtra tráfico por IP, puerto y protocolo',
      'Inspección stateful de conexiones TCP/UDP',
      'Deep Packet Inspection (DPI) en firewalls NGFW',
      'Crea zonas de seguridad (inside, outside, DMZ)',
      'Bloquea ataques de red conocidos',
      'VPN gateway para acceso remoto seguro',
    ],
    specs: [
      EquipmentSpec('Capas OSI', '3 a 7', labelEn: 'OSI Layers', valueEn: '3 to 7'),
      EquipmentSpec('Inspección', 'Stateful / NGFW', labelEn: 'Inspection'),
      EquipmentSpec('Zonas', 'Inside · Outside · DMZ', labelEn: 'Zones'),
      EquipmentSpec('Throughput típico', '1 Gbps — 100 Gbps', labelEn: 'Typical Throughput'),
      EquipmentSpec('VPN', 'IPSec / SSL', labelEn: 'VPN'),
    ],
    useCases: [
      'Separar red interna de Internet',
      'Crear zona DMZ para servidores públicos',
      'Control de acceso basado en aplicación (NGFW)',
      'VPN para empleados remotos',
      'Prevención de intrusiones (IPS)',
    ],
    ciscoModels: 'Cisco ASA 5500-X, Firepower 1000/2100/4100',
    accentHex: 'FF7B72',
  ),

  NetworkEquipment(
    id: 'access_point',
    icon: '📡',
    nameEs: 'Access Point (AP)',
    nameEn: 'Wireless Access Point',
    summaryEs: 'El Access Point proporciona conectividad WiFi a dispositivos inalámbricos, actuando como puente entre la red cableada y los clientes wireless.',
    summaryEn: 'An Access Point provides WiFi connectivity, bridging the wired network and wireless clients.',
    layer: 'Capa 2 — Enlace inalámbrico',
    features: [
      'Transmite señal WiFi (2.4 GHz, 5 GHz, 6 GHz)',
      'Soporta múltiples SSIDs (redes inalámbricas)',
      'Autenticación WPA2/WPA3 Enterprise (802.1X)',
      'Roaming entre APs en la misma red',
      'PoE: se alimenta por cable Ethernet',
      'MU-MIMO: múltiples usuarios simultáneos',
    ],
    specs: [
      EquipmentSpec('Estándares', '802.11a/b/g/n/ac/ax (WiFi 6)', labelEn: 'Standards'),
      EquipmentSpec('Bandas', '2.4 GHz · 5 GHz · 6 GHz', labelEn: 'Bands'),
      EquipmentSpec('Alimentación', 'PoE (802.3af/at)', labelEn: 'Power Supply'),
      EquipmentSpec('Clientes típicos', '50–200 por AP', labelEn: 'Typical Clients', valueEn: '50–200 per AP'),
      EquipmentSpec('Seguridad', 'WPA2/WPA3, 802.1X', labelEn: 'Security'),
    ],
    useCases: [
      'WiFi en oficinas, campus y hospitales',
      'Redes de invitados aisladas (Guest SSID)',
      'Cobertura outdoor con APs exteriores',
      'Gestión centralizada con Cisco DNA Center',
      'Integración con VLANs por SSID',
    ],
    ciscoModels: 'Catalyst 9130, 9120, Aironet 2800/3800',
    accentHex: 'D2A8FF',
  ),

  NetworkEquipment(
    id: 'hub',
    icon: '📦',
    nameEs: 'Hub (Concentrador)',
    nameEn: 'Hub',
    summaryEs: 'El hub es un dispositivo legacy de Capa 1 que repite la señal a todos los puertos. Hoy está obsoleto — los switches lo reemplazan completamente.',
    summaryEn: 'A hub is a legacy Layer 1 device that repeats signals to all ports. Today it is obsolete — replaced entirely by switches.',
    layer: 'Capa 1 — Física',
    features: [
      'Repite la señal eléctrica a TODOS los puertos',
      'Sin inteligencia: no aprende direcciones MAC',
      'Crea un solo dominio de colisión',
      'Half-duplex: un dispositivo transmite a la vez',
      'Ancho de banda compartido entre todos',
      '⚠️ Obsoleto — no usar en redes modernas',
    ],
    specs: [
      EquipmentSpec('Capa OSI', 'Capa 1 (Física)', labelEn: 'OSI Layer', valueEn: 'Layer 1 (Physical)'),
      EquipmentSpec('PDU', 'Bits', labelEn: 'PDU'),
      EquipmentSpec('Dominios colisión', '1 (todos comparten)', labelEn: 'Collision Domains', valueEn: '1 (all share)'),
      EquipmentSpec('Inteligencia', 'Ninguna', labelEn: 'Intelligence', valueEn: 'None'),
      EquipmentSpec('Estado', '⚠️ Obsoleto', labelEn: 'Status', valueEn: '⚠️ Obsolete'),
    ],
    useCases: [
      '⚠️ Aplicaciones actuales: casi ninguna',
      'Análisis de tráfico (network sniffer) en laboratorio',
      'Entender conceptos de Capa 1 y colisiones',
      'Comparar con switch para ver la diferencia',
    ],
    ciscoModels: 'Obsoleto — no tiene equivalente moderno',
    accentHex: 'F0883E',
  ),

  NetworkEquipment(
    id: 'serial_cable',
    icon: '🔗',
    nameEs: 'Cable Serial (DCE/DTE)',
    nameEn: 'Serial Cable (DCE/DTE)',
    summaryEs: 'Los cables seriales conectan routers directamente para enlaces WAN punto a punto. El extremo DCE provee el clock rate; el DTE lo recibe.',
    summaryEn: 'Serial cables connect routers directly for point-to-point WAN links. The DCE end provides the clock rate; the DTE receives it.',
    layer: 'Capa 1 — Física',
    features: [
      'Conector DB-60 o Smart Serial en routers Cisco',
      'DCE: provee señal de reloj (clock rate)',
      'DTE: recibe el reloj del extremo DCE',
      'Velocidades típicas: 56k, 64k, 1.544 Mbps (T1)',
      'Usado en laboratorio para simular enlaces WAN',
    ],
    specs: [
      EquipmentSpec('Tipo', 'DB-60 / Smart Serial', labelEn: 'Type'),
      EquipmentSpec('Identificación', 'show controllers s0/0/0', labelEn: 'Identification'),
      EquipmentSpec('Clock rate típico', '64000 bps', labelEn: 'Typical clock rate'),
      EquipmentSpec('Máximo', '8 Mbps', labelEn: 'Maximum'),
    ],
    useCases: [
      'Simulación de enlace WAN en laboratorio',
      'Conexión punto a punto entre routers',
      'Redes legacy HDLC/PPP',
    ],
    ciscoModels: 'WIC-1T, WIC-2T, HWIC-2T (tarjetas WAN para ISR)',
    accentHex: 'F0883E',
  ),
  NetworkEquipment(
    id: 'server',
    icon: '🖥️',
    nameEs: 'Servidor',
    nameEn: 'Server',
    summaryEs: 'Equipos que proveen servicios centralizados a la red: DHCP, DNS, web, correo, autenticación, almacenamiento y más.',
    summaryEn: 'Devices that provide centralized services to the network: DHCP, DNS, web, mail, authentication, storage and more.',
    layer: 'Capa 7 — Aplicación',
    features: [
      'DHCP: asignación automática de IPs',
      'DNS: resolución de nombres a IPs',
      'Web (HTTP/HTTPS): Apache, Nginx, IIS',
      'RADIUS/TACACS+: autenticación de red',
      'Syslog: centralización de logs',
    ],
    specs: [
      EquipmentSpec('Interfaces', '1–4 NICs (1G/10G)', labelEn: 'Interfaces'),
      EquipmentSpec('Gestión', 'iDRAC, iLO, IPMI (fuera de banda)', labelEn: 'Management', valueEn: 'iDRAC, iLO, IPMI (out of band)'),
      EquipmentSpec('Rack', '1U, 2U, 4U', labelEn: 'Rack Form Factor'),
    ],
    useCases: [
      'Servidor DHCP y DNS para la LAN',
      'Servidor web en DMZ',
      'Autenticación centralizada (RADIUS)',
      'Almacenamiento compartido (NAS/SAN)',
    ],
    ciscoModels: 'Cisco UCS C220, C240, C480',
    accentHex: '58A6FF',
  ),
  NetworkEquipment(
    id: 'cloud',
    icon: '☁️',
    nameEs: 'Nube (Cloud)',
    nameEn: 'Cloud',
    summaryEs: 'La nube representa servicios e infraestructura remotos accedidos por Internet o enlaces dedicados. IaaS, PaaS y SaaS son los modelos principales.',
    summaryEn: 'The cloud represents remote services and infrastructure accessed over the Internet or dedicated links. IaaS, PaaS and SaaS are the main models.',
    layer: 'Todos — WAN/Internet',
    features: [
      'IaaS: VMs, almacenamiento, redes virtuales',
      'PaaS: plataforma de desarrollo gestionada',
      'SaaS: aplicaciones listas para usar',
      'Conexión: VPN IPSec o Direct Connect',
      'Escalabilidad elástica bajo demanda',
    ],
    specs: [
      EquipmentSpec('Proveedores', 'AWS, Azure, GCP, Oracle Cloud', labelEn: 'Providers'),
      EquipmentSpec('Conexión WAN', 'Internet VPN / Direct Connect', labelEn: 'WAN Connection'),
      EquipmentSpec('Latencia VPN', '10–80 ms (variable)', labelEn: 'VPN Latency'),
      EquipmentSpec('Latencia Direct', '2–10 ms (dedicado)', labelEn: 'Direct Latency', valueEn: '2–10 ms (dedicated)'),
    ],
    useCases: [
      'Backup y DR (Disaster Recovery)',
      'Servidores web escalables',
      'Redes híbridas (on-premise + cloud)',
      'Collaboration: Webex, Teams, Zoom',
    ],
    accentHex: '26C6DA',
  ),
];

// ─── Guide data ────────────────────────────────────────────────────────────────

const guideList = <StepGuide>[
  StepGuide(
    id: 'basic_router_config',
    icon: '🔌',
    titleEs: 'Configuración Básica de Router Cisco',
    titleEn: 'Basic Cisco Router Configuration',
    summaryEs: 'Aprende a realizar la configuración inicial de un router Cisco IOS desde cero.',
    summaryEn: 'Learn to perform initial configuration of a Cisco IOS router from scratch.',
    difficulty: 'Básico',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: 'Acceder al modo privilegiado',
        titleEn: 'Enter privileged mode',
        contentEs: 'Desde el prompt inicial, entra al modo EXEC privilegiado. Este modo te da acceso completo de administración.',
        contentEn: 'From the initial prompt, enter privileged EXEC mode for full admin access.',
        codeExample: 'Router> enable\nRouter# ',
        tip: 'El símbolo # indica que estás en modo privilegiado.',
        tipEn: 'The # symbol means you are in privileged EXEC mode.',
      ),
      GuideStep(
        titleEs: 'Entrar al modo de configuración global',
        titleEn: 'Enter global configuration mode',
        contentEs: 'El modo de configuración global permite modificar la configuración del dispositivo.',
        contentEn: 'Global configuration mode allows you to modify the device configuration.',
        codeExample: 'Router# configure terminal\nRouter(config)# ',
        tip: '(config) en el prompt indica modo de configuración global.',
        tipEn: '(config) in the prompt means you are in global configuration mode.',
      ),
      GuideStep(
        titleEs: 'Asignar nombre al dispositivo',
        titleEn: 'Assign device hostname',
        contentEs: 'Define un nombre descriptivo para identificar el router en la red.',
        contentEn: 'Set a descriptive name to identify the router on the network.',
        codeExample: 'Router(config)# hostname R1\nR1(config)# ',
        tip: 'Usa nombres que indiquen ubicación: R1-Bogota, SW-Piso2, etc.',
        tipEn: 'Use location-based names: R1-NYC, SW-Floor2, etc.',
      ),
      GuideStep(
        titleEs: 'Configurar contraseña enable',
        titleEn: 'Set enable password',
        contentEs: 'La contraseña enable protege el acceso al modo privilegiado. Usa "secret" (cifrado MD5) en lugar de "password" (texto plano).',
        contentEn: 'The enable password protects privileged mode. Use "secret" (MD5 hash) instead of "password" (plain text).',
        codeExample: 'R1(config)# enable secret Cisco@2024\n! NO usar: enable password (texto plano)',
        tip: '"enable secret" cifra la contraseña. "enable password" la deja en texto plano.',
        tipEn: '"enable secret" hashes the password (MD5). Never use "enable password" — it stores it in plain text.',
      ),
      GuideStep(
        titleEs: 'Configurar interfaz con IP',
        titleEn: 'Configure interface IP address',
        contentEs: 'Asigna una dirección IP a la interfaz y actívala. Sin "no shutdown" la interfaz queda administrativamente apagada.',
        contentEn: 'Assign an IP address to the interface and activate it. Without "no shutdown" it stays admin down.',
        codeExample: 'R1(config)# interface GigabitEthernet0/0\nR1(config-if)# ip address 192.168.1.1 255.255.255.0\nR1(config-if)# description LAN-Oficina\nR1(config-if)# no shutdown',
        tip: '"no shutdown" es OBLIGATORIO para activar la interfaz.',
        tipEn: '"no shutdown" is REQUIRED to activate the interface. Without it the port stays admin-down.',
      ),
      GuideStep(
        titleEs: 'Guardar la configuración',
        titleEn: 'Save the configuration',
        contentEs: 'La configuración en RAM (running-config) se pierde al reiniciar. Guárdala en NVRAM (startup-config).',
        contentEn: 'RAM configuration (running-config) is lost on reboot. Save it to NVRAM (startup-config).',
        codeExample: 'R1# copy running-config startup-config\n! Abreviado:\nR1# wr',
        tip: '"wr" es el atajo de "write memory" — guarda la config permanentemente.',
        tipEn: '"wr" is short for "write memory" — saves the config to NVRAM permanently.',
      ),
    ],
  ),

  StepGuide(
    id: 'vlan_setup',
    icon: '🔀',
    titleEs: 'Configurar VLANs en Switch Cisco',
    titleEn: 'Configure VLANs on Cisco Switch',
    summaryEs: 'Crea y asigna VLANs en un switch Cisco Catalyst, incluyendo puertos de acceso y trunk.',
    summaryEn: 'Create and assign VLANs on a Cisco Catalyst switch, including access and trunk ports.',
    difficulty: 'Intermedio',
    category: 'switch',
    steps: [
      GuideStep(
        titleEs: 'Crear la VLAN en la base de datos',
        titleEn: 'Create VLAN in database',
        contentEs: 'Primero crea la VLAN con su ID y nombre descriptivo en la base de datos del switch.',
        contentEn: 'First create the VLAN with its ID and descriptive name in the switch database.',
        codeExample: 'Switch(config)# vlan 10\nSwitch(config-vlan)# name Ventas\n!\nSwitch(config)# vlan 20\nSwitch(config-vlan)# name TI',
        tip: 'VLANs válidas: 2–4094 (evitar 1, 1002–1005 que son reservadas). Nunca uses la VLAN 1 — es la VLAN nativa por defecto y representa un riesgo de seguridad.',
        tipEn: 'Valid VLANs: 2–4094 (avoid 1 and 1002–1005, they are reserved). Never use VLAN 1 — it is the default native VLAN and a security risk.',
      ),
      GuideStep(
        titleEs: 'Asignar puertos de acceso',
        titleEn: 'Assign access ports',
        contentEs: 'Los puertos de acceso conectan dispositivos finales (PCs, impresoras) a una VLAN específica.',
        contentEn: 'Access ports connect end devices (PCs, printers) to a specific VLAN.',
        codeExample: 'Switch(config)# interface FastEthernet0/1\nSwitch(config-if)# switchport mode access\nSwitch(config-if)# switchport access vlan 10\nSwitch(config-if)# no shutdown',
        tip: 'Un puerto de acceso solo pertenece a UNA VLAN.',
        tipEn: 'An access port belongs to exactly ONE VLAN.',
      ),
      GuideStep(
        titleEs: 'Configurar puerto trunk',
        titleEn: 'Configure trunk port',
        contentEs: 'El puerto trunk transporta múltiples VLANs simultáneamente usando etiquetas 802.1Q. Se usa entre switches o hacia el router.',
        contentEn: 'Trunk ports carry multiple VLANs simultaneously using 802.1Q tags. Used between switches or to routers.',
        codeExample: '! Crear VLAN 99 como VLAN nativa (en lugar de la VLAN 1)\nSwitch(config)# vlan 99\nSwitch(config-vlan)# name NATIVE\n!\nSwitch(config)# interface GigabitEthernet0/1\nSwitch(config-if)# switchport mode trunk\nSwitch(config-if)# switchport trunk encapsulation dot1q\nSwitch(config-if)# switchport trunk native vlan 99\nSwitch(config-if)# switchport trunk allowed vlan 10,20,99\nSwitch(config-if)# no shutdown',
        tip: 'Cambia siempre la VLAN nativa de 1 a otra (ej: 99). La VLAN 1 por defecto es un riesgo de VLAN hopping.',
        tipEn: 'Always change the native VLAN from 1 to another (e.g. 99). VLAN 1 as native is a VLAN hopping security risk.',
      ),
      GuideStep(
        titleEs: 'Verificar configuración VLAN',
        titleEn: 'Verify VLAN configuration',
        contentEs: 'Usa los comandos show para confirmar que las VLANs están correctamente configuradas.',
        contentEn: 'Use show commands to confirm VLANs are correctly configured.',
        codeExample: '! Ver todas las VLANs y sus puertos\nshow vlan brief\n!\n! Ver detalles de un puerto\nshow interfaces Fa0/1 switchport\n!\n! Ver estado del trunk\nshow interfaces trunk',
      ),
    ],
  ),

  StepGuide(
    id: 'ssh_setup',
    icon: '🔐',
    titleEs: 'Habilitar SSH en Dispositivos Cisco',
    titleEn: 'Enable SSH on Cisco Devices',
    summaryEs: 'Configura acceso remoto seguro por SSH v2 en routers y switches Cisco, deshabilitando Telnet.',
    summaryEn: 'Configure secure SSH v2 remote access on Cisco routers and switches, disabling Telnet.',
    difficulty: 'Básico',
    category: 'security',
    steps: [
      GuideStep(
        titleEs: 'Prerequisitos: hostname y dominio',
        titleEn: 'Prerequisites: hostname and domain',
        contentEs: 'SSH necesita un hostname y dominio configurados para generar el certificado RSA.',
        contentEn: 'SSH requires a hostname and domain to generate the RSA certificate.',
        codeExample: 'Router(config)# hostname R1\nR1(config)# ip domain-name empresa.local',
        tip: 'El par hostname + dominio forma la identidad del certificado RSA.',
        tipEn: 'The hostname + domain pair forms the RSA certificate identity.',
      ),
      GuideStep(
        titleEs: 'Generar clave RSA',
        titleEn: 'Generate RSA key',
        contentEs: 'La clave RSA cifra la sesión SSH. Usa 2048 bits mínimo (nunca menos de 1024).',
        contentEn: 'The RSA key encrypts the SSH session. Use minimum 2048 bits.',
        codeExample: 'R1(config)# crypto key generate rsa modulus 2048\n! Esto activa SSH automáticamente\nR1(config)# ip ssh version 2',
        codeExampleEn: 'R1(config)# crypto key generate rsa modulus 2048\n! This automatically enables SSH\nR1(config)# ip ssh version 2',
        tip: '2048 bits es el estándar actual. 4096 bits es más seguro pero más lento.',
        tipEn: '2048 bits is the current standard. 4096 bits is more secure but slower to generate.',
      ),
      GuideStep(
        titleEs: 'Crear usuario local',
        titleEn: 'Create local user',
        contentEs: 'Define un usuario con privilegio 15 (acceso total) para autenticación local.',
        contentEn: 'Define a user with privilege 15 (full access) for local authentication.',
        codeExample: 'R1(config)# username admin privilege 15 secret MiClave@Segura',
      ),
      GuideStep(
        titleEs: 'Configurar líneas VTY para SSH',
        titleEn: 'Configure VTY lines for SSH',
        contentEs: 'Las líneas VTY controlan el acceso remoto. Restringe a solo SSH y usa autenticación local.',
        contentEn: 'VTY lines control remote access. Restrict to SSH only and use local authentication.',
        codeExample: 'R1(config)# line vty 0 4\nR1(config-line)# login local\nR1(config-line)# transport input ssh\nR1(config-line)# exec-timeout 10 0\n! exec-timeout 10 0 = cierra sesión inactiva a los 10 min',
        codeExampleEn: 'R1(config)# line vty 0 4\nR1(config-line)# login local\nR1(config-line)# transport input ssh\nR1(config-line)# exec-timeout 10 0\n! exec-timeout 10 0 = closes inactive session after 10 min',
        tip: '"transport input ssh" deshabilita Telnet automáticamente.',
        tipEn: '"transport input ssh" automatically disables Telnet — only SSH connections are accepted.',
      ),
      GuideStep(
        titleEs: 'Verificar y conectar',
        titleEn: 'Verify and connect',
        contentEs: 'Verifica la configuración SSH y prueba la conexión desde un cliente.',
        contentEn: 'Verify the SSH configuration and test the connection from a client.',
        codeExample: '! Verificar en el router:\nshow ip ssh\nshow ssh\n!\n! Conectar desde PC (Linux/Mac):\n\$ ssh admin@192.168.1.1\n!\n! En Windows (PuTTY o terminal):\n\$ ssh admin@192.168.1.1',
        tip: 'Si no conecta: verifica que el firewall del router no bloquee el puerto 22.',
        tipEn: 'If connection fails: verify the router firewall is not blocking port 22.',
      ),
    ],
  ),

  StepGuide(
    id: 'ospf_basic',
    icon: '🕸️',
    titleEs: 'Configurar OSPF Básico (Single Area)',
    titleEn: 'Configure Basic OSPF (Single Area)',
    summaryEs: 'Implementa OSPF en una red simple de área única para enrutamiento dinámico automático.',
    summaryEn: 'Implement OSPF in a simple single-area network for automatic dynamic routing.',
    difficulty: 'Intermedio',
    category: 'routing',
    steps: [
      GuideStep(
        titleEs: 'Entender el Router ID',
        titleEn: 'Understand the Router ID',
        contentEs: 'OSPF identifica cada router con un Router ID (RID). Se selecciona automáticamente o se configura manualmente. Es recomendable configurarlo manualmente para mayor control.',
        contentEn: 'OSPF identifies each router with a Router ID (RID). It can be auto-selected or manually configured. Manual configuration is recommended for control.',
        codeExample: 'R1(config)# router ospf 1\nR1(config-router)# router-id 1.1.1.1\n! Convención: usar IP de Loopback como Router ID',
        codeExampleEn: 'R1(config)# router ospf 1\nR1(config-router)# router-id 1.1.1.1\n! Convention: use Loopback IP as Router ID',
        tip: 'El Router ID debe ser único en el área OSPF. Si no se configura, OSPF elige la IP más alta de una Loopback activa, o si no hay, la IP más alta de una interfaz activa.',
        tipEn: 'Router ID must be unique per OSPF area. If not set, OSPF picks the highest Loopback IP, or highest active interface IP.',
      ),
      GuideStep(
        titleEs: 'Anunciar redes con "network"',
        titleEn: 'Advertise networks with "network"',
        contentEs: 'El comando network indica a OSPF qué interfaces participan en el proceso de enrutamiento y qué redes se van a anunciar.',
        contentEn: 'The network command tells OSPF which interfaces participate in routing and which networks to advertise.',
        codeExample: 'R1(config-router)# network 192.168.1.0 0.0.0.255 area 0\nR1(config-router)# network 10.0.0.0 0.0.0.3 area 0\n! Wildcard mask = inverso de la máscara de subred',
        codeExampleEn: 'R1(config-router)# network 192.168.1.0 0.0.0.255 area 0\nR1(config-router)# network 10.0.0.0 0.0.0.3 area 0\n! Wildcard mask = inverse of the subnet mask',
        tip: 'Area 0 = backbone area. Siempre debe existir en una red OSPF.',
        tipEn: 'Area 0 = backbone area. It must always exist in an OSPF network. All other areas connect to Area 0.',
      ),
      GuideStep(
        titleEs: 'Interfaces pasivas',
        titleEn: 'Passive interfaces',
        contentEs: 'Las interfaces pasivas no envían Hello OSPF pero sí anuncian su red. Úsalas en interfaces que conectan hosts finales (no otros routers).',
        contentEn: 'Passive interfaces do not send OSPF Hellos but still advertise their network. Use them on interfaces connecting end hosts.',
        codeExample: 'R1(config-router)# passive-interface GigabitEthernet0/1\n! Buena práctica: hacer todas pasivas y activar solo las necesarias\nR1(config-router)# passive-interface default\nR1(config-router)# no passive-interface GigabitEthernet0/0',
        codeExampleEn: 'R1(config-router)# passive-interface GigabitEthernet0/1\n! Best practice: make all passive, then activate only needed ones\nR1(config-router)# passive-interface default\nR1(config-router)# no passive-interface GigabitEthernet0/0',
      ),
      GuideStep(
        titleEs: 'Verificar OSPF',
        titleEn: 'Verify OSPF',
        contentEs: 'Usa estos comandos para verificar que OSPF está funcionando correctamente.',
        contentEn: 'Use these commands to verify OSPF is working correctly.',
        codeExample: '! Ver vecinos OSPF establecidos\nshow ip ospf neighbor\n!\n! Ver tabla de enrutamiento OSPF (rutas con O)\nshow ip route ospf\n!\n! Ver detalles del proceso OSPF\nshow ip ospf\n!\n! Ver base de datos de estado de enlace\nshow ip ospf database',
        tip: 'Estado "FULL" en "show ip ospf neighbor" indica vecindad establecida correctamente.',
        tipEn: '"FULL" state in "show ip ospf neighbor" means the neighbor relationship is fully established.',
      ),
    ],
  ),

  StepGuide(
    id: 'acl_standard',
    icon: '🛡️',
    titleEs: 'Listas de Control de Acceso (ACL) Estándar',
    titleEn: 'Standard Access Control Lists (ACL)',
    summaryEs: 'Filtra tráfico de red por IP origen usando ACLs estándar en routers Cisco. Incluye ACLs nombradas y verificación.',
    summaryEn: 'Filter network traffic by source IP using standard ACLs on Cisco routers. Includes named ACLs and verification.',
    difficulty: 'Intermedio',
    category: 'security',
    steps: [
      GuideStep(
        titleEs: '¿Qué es una ACL estándar?',
        titleEn: 'What is a Standard ACL?',
        contentEs: 'Una ACL estándar filtra tráfico basándose ÚNICAMENTE en la IP de origen. Se numeran del 1 al 99. Cisco las evalúa línea por línea — la primera coincidencia gana. Al final hay un "deny all" implícito invisible.',
        contentEn: 'A standard ACL filters traffic based ONLY on the source IP. Numbered 1–99. Cisco evaluates line by line — first match wins. There is an invisible implicit "deny all" at the end.',
        codeExample: '! Estructura:\n! access-list [1-99] [permit|deny] [source-ip] [wildcard]\n!\n! Ejemplo: permitir solo la red 192.168.1.0/24\naccess-list 10 permit 192.168.1.0 0.0.0.255\n! El deny implícito bloquea todo lo demás automáticamente',
        codeExampleEn: '! Structure:\n! access-list [1-99] [permit|deny] [source-ip] [wildcard]\n!\n! Example: allow only the 192.168.1.0/24 network\naccess-list 10 permit 192.168.1.0 0.0.0.255\n! The implicit deny blocks everything else automatically',
        tip: 'Coloca ACLs estándar LO MÁS CERCA del DESTINO posible — filtran solo por origen, por lo que si las pones cerca del origen bloqueas también otras rutas legítimas.',
        tipEn: 'Place standard ACLs as CLOSE to the DESTINATION as possible — they filter by source only, so placing them near the source would block legitimate traffic to other destinations.',
      ),
      GuideStep(
        titleEs: 'Crear la ACL',
        titleEn: 'Create the ACL',
        contentEs: 'Define las reglas. La wildcard mask es el inverso de la máscara de subred (/24 = 0.0.0.255). Para un solo host usa la keyword "host" o wildcard 0.0.0.0.',
        contentEn: 'Define the rules. Wildcard mask is the inverse of subnet mask (/24 = 0.0.0.255). For a single host use the "host" keyword or 0.0.0.0 wildcard.',
        codeExample: '! Permitir red 10.0.0.0/8\nR1(config)# access-list 1 permit 10.0.0.0 0.255.255.255\n!\n! Permitir un solo host (dos formas equivalentes)\nR1(config)# access-list 1 permit host 192.168.1.50\nR1(config)# access-list 1 permit 192.168.1.50 0.0.0.0\n!\n! Bloquear red y permitir el resto\nR1(config)# access-list 1 deny 172.16.0.0 0.0.255.255\nR1(config)# access-list 1 permit any',
        tip: 'El orden de las reglas importa. Las reglas más específicas deben ir primero para que no sean anuladas por las generales.',
        tipEn: 'Rule order matters. Most specific rules must go first so they are not overridden by general rules.',
      ),
      GuideStep(
        titleEs: 'Aplicar la ACL a una interfaz',
        titleEn: 'Apply the ACL to an interface',
        contentEs: 'Una ACL no hace nada hasta que la aplicas a una interfaz con una dirección: IN (tráfico entrante al router) o OUT (tráfico saliente del router).',
        contentEn: 'An ACL does nothing until applied to an interface with a direction: IN (traffic entering the router) or OUT (traffic leaving the router).',
        codeExample: '! Aplicar saliente (OUT) — cerca del destino\nR1(config)# interface GigabitEthernet0/1\nR1(config-if)# ip access-group 1 out\n!\n! Aplicar entrante (IN) — cerca del origen\nR1(config-if)# ip access-group 1 in\n!\n! LÍMITE: solo 1 ACL por interfaz por dirección\n! (1 IN + 1 OUT es válido en la misma interfaz)',
        codeExampleEn: '! Apply outbound (OUT) — near the destination\nR1(config)# interface GigabitEthernet0/1\nR1(config-if)# ip access-group 1 out\n!\n! Apply inbound (IN) — near the source\nR1(config-if)# ip access-group 1 in\n!\n! LIMIT: only 1 ACL per interface per direction\n! (1 IN + 1 OUT is valid on the same interface)',
        tip: 'IN procesa el paquete ANTES de enrutar (más eficiente). OUT procesa DESPUÉS. Ambas son válidas pero tienen diferentes efectos en el tráfico del propio router.',
        tipEn: 'IN processes the packet BEFORE routing (more efficient). OUT processes AFTER. Both are valid but have different effects on traffic generated by the router itself.',
      ),
      GuideStep(
        titleEs: 'ACLs nombradas (buena práctica)',
        titleEn: 'Named ACLs (best practice)',
        contentEs: 'Las ACLs nombradas son más flexibles: tienen nombres descriptivos, permiten eliminar líneas individuales sin borrar toda la ACL, y son más fáciles de auditar.',
        contentEn: 'Named ACLs are more flexible: descriptive names, allow deleting individual lines without removing the entire ACL, and are easier to audit.',
        codeExample: 'R1(config)# ip access-list standard BLOQUEAR-INVITADOS\nR1(config-std-nacl)# deny 192.168.99.0 0.0.0.255\nR1(config-std-nacl)# permit any\n!\n! Aplicar a interfaz:\nR1(config)# interface GigabitEthernet0/1\nR1(config-if)# ip access-group BLOQUEAR-INVITADOS out\n!\n! Eliminar solo una línea (imposible en ACLs numeradas):\nR1(config-std-nacl)# no deny 192.168.99.0 0.0.0.255',
        codeExampleEn: 'R1(config)# ip access-list standard BLOCK-GUESTS\nR1(config-std-nacl)# deny 192.168.99.0 0.0.0.255\nR1(config-std-nacl)# permit any\n!\n! Apply to interface:\nR1(config)# interface GigabitEthernet0/1\nR1(config-if)# ip access-group BLOCK-GUESTS out\n!\n! Remove a single line (not possible with numbered ACLs):\nR1(config-std-nacl)# no deny 192.168.99.0 0.0.0.255',
        tip: 'Con ACLs numeradas no puedes eliminar una sola línea — borras toda la ACL. Con nombradas sí. En producción siempre usa nombradas.',
        tipEn: 'With numbered ACLs you cannot delete a single line — you delete the entire ACL. Named ACLs allow it. In production, always use named ACLs.',
      ),
      GuideStep(
        titleEs: 'Verificar y monitorear',
        titleEn: 'Verify and monitor',
        contentEs: 'Los contadores de "matches" en show access-lists te dicen cuántos paquetes coincidieron con cada regla — esencial para troubleshooting.',
        contentEn: 'The "matches" counters in show access-lists tell you how many packets matched each rule — essential for troubleshooting.',
        codeExample: '! Ver todas las ACLs con contadores\nshow ip access-lists\n!\n! Ver ACL específica\nshow ip access-lists BLOQUEAR-INVITADOS\n!\n! Ver qué ACLs están aplicadas por interfaz\nshow ip interface GigabitEthernet0/1\n!\n! Resetear contadores (sin borrar la ACL)\nclear ip access-list counters BLOQUEAR-INVITADOS',
        codeExampleEn: '! Show all ACLs with counters\nshow ip access-lists\n!\n! Show specific ACL\nshow ip access-lists BLOCK-GUESTS\n!\n! Show which ACLs are applied per interface\nshow ip interface GigabitEthernet0/1\n!\n! Reset counters (without deleting the ACL)\nclear ip access-list counters BLOCK-GUESTS',
        tip: 'Si todo el tráfico se bloquea, verifica: 1) que tienes "permit any" al final, 2) que la ACL está aplicada en la interfaz y dirección correctas.',
        tipEn: 'If all traffic is blocked, verify: 1) you have "permit any" at the end, 2) the ACL is applied on the correct interface and direction.',
      ),
    ],
  ),

  StepGuide(
    id: 'serial_dce_dte',
    icon: '🔗',
    titleEs: 'Conexión Serial entre Routers (DCE/DTE)',
    titleEn: 'Serial Router-to-Router Connection (DCE/DTE)',
    summaryEs: 'Conecta dos routers Cisco por interfaz serial, identifica DCE/DTE, configura clock rate y verifica con ping y show controllers.',
    summaryEn: 'Connect two Cisco routers via serial interface, identify DCE/DTE, configure clock rate and verify with ping and show controllers.',
    difficulty: 'Intermedio',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: 'Identificar DCE y DTE',
        titleEn: 'Identify DCE and DTE',
        contentEs: 'Antes de configurar, identifica cuál router tiene el cable DCE (provee reloj) y cuál tiene el DTE. El comando show controllers lo muestra directamente.',
        contentEn: 'Before configuring, identify which router has the DCE cable (provides clock) and which has DTE. The show controllers command shows this directly.',
        codeExample: '''! En ambos routers, ejecuta:
R1# show controllers Serial0/0/0
!
! Busca en la salida:
! "DCE cable, clock rate XXXXX" → este es el DCE
! "DTE cable"                  → este es el DTE
! "No cable"                   → sin cable conectado''',
        tip: 'En Packet Tracer o GNS3, el extremo conectado primero suele ser DCE. Siempre confirma con show controllers.',
        tipEn: 'In Packet Tracer or GNS3, the end connected first is usually DCE. Always confirm with show controllers.',
      ),
      GuideStep(
        titleEs: 'Configurar el router DCE',
        titleEn: 'Configure the DCE router',
        contentEs: 'El router DCE debe configurar la IP, el clock rate (frecuencia de reloj) y activar la interfaz. Sin clock rate el enlace no levanta.',
        contentEn: 'The DCE router must configure the IP, clock rate (clock frequency) and activate the interface. Without clock rate the link will not come up.',
        codeExample: '''R1(config)# interface Serial0/0/0
R1(config-if)# description Enlace-WAN-a-R2
R1(config-if)# ip address 10.0.0.1 255.255.255.252
R1(config-if)# clock rate 64000
R1(config-if)# no shutdown''',
        tip: 'Usa /30 (255.255.255.252) para enlaces punto a punto — solo necesitas 2 IPs (host). Ahorra espacio de direccionamiento.',
        tipEn: 'Use /30 (255.255.255.252) for point-to-point links — you only need 2 IPs (hosts). Saves address space.',
      ),
      GuideStep(
        titleEs: 'Configurar el router DTE',
        titleEn: 'Configure the DTE router',
        contentEs: 'El router DTE configura IP y activa la interfaz. NO configura clock rate — lo recibe del DCE.',
        contentEn: 'The DTE router configures IP and activates the interface. It does NOT configure clock rate — it receives it from the DCE.',
        codeExample: '''R2(config)# interface Serial0/0/0
R2(config-if)# description Enlace-WAN-a-R1
R2(config-if)# ip address 10.0.0.2 255.255.255.252
R2(config-if)# no shutdown
! NO escribas clock rate aquí''',
        codeExampleEn: '''R2(config)# interface Serial0/0/0
R2(config-if)# description WAN-Link-to-R1
R2(config-if)# ip address 10.0.0.2 255.255.255.252
R2(config-if)# no shutdown
! DO NOT set clock rate here''',
        tip: 'Si configuras clock rate en el DTE, el IOS lo ignora. No causa error pero es innecesario.',
        tipEn: 'If you configure clock rate on the DTE, IOS ignores it. It does not cause an error but is unnecessary.',
      ),
      GuideStep(
        titleEs: 'Verificar con do ping',
        titleEn: 'Verify with do ping',
        contentEs: 'Prueba la conectividad con ping. Usa "do ping" si estás en modo de configuración para no tener que salir.',
        contentEn: 'Test connectivity with ping. Use "do ping" if you are in configuration mode so you do not have to exit.',
        codeExample: '''! Desde modo privilegiado:
R1# ping 10.0.0.2
! Resultado esperado: !!!!!
!
! Desde dentro de configuración:
R1(config-if)# do ping 10.0.0.2
!
! Si falla (.....):
! 1. Verifica no shutdown en ambos extremos
! 2. Verifica clock rate en el DCE
! 3. Verifica que las IPs son de la misma subred''',
        codeExampleEn: '''! From privileged mode:
R1# ping 10.0.0.2
! Expected result: !!!!!
!
! From within configuration:
R1(config-if)# do ping 10.0.0.2
!
! If it fails (.....):
! 1. Verify no shutdown on both ends
! 2. Verify clock rate on the DCE side
! 3. Verify IPs are on the same subnet''',
        tip: '"do" es un prefijo que permite ejecutar comandos EXEC desde cualquier modo de configuración sin salir.',
        tipEn: '"do" is a prefix that allows running EXEC commands from any configuration mode without exiting.',
      ),
      GuideStep(
        titleEs: 'Verificar estado final',
        titleEn: 'Verify final state',
        contentEs: 'Confirma que el enlace está operativo revisando el estado de la interfaz y la tabla de enrutamiento.',
        contentEn: 'Confirm the link is operational by checking the interface status and routing table.',
        codeExample: '''! Ver estado de interfaces:
R1# show ip interface brief
! Debe mostrar: Serial0/0/0 up/up
!
! Ver detalles del enlace serial:
R1# show interfaces Serial0/0/0
!
! Ver tabla de rutas (ruta directamente conectada):
R1# show ip route
! Debe mostrar: C 10.0.0.0/30 via Serial0/0/0''',
        tip: '"up/up" en show ip interface brief = línea física OK + protocolo OK. "up/down" = física OK pero falta clock rate o encapsulación.',
        tipEn: '"up/up" in show ip interface brief = physical line OK + protocol OK. "up/down" = physical OK but missing clock rate or encapsulation.',
      ),
    ],
  ),

  StepGuide(
    id: 'console_connection',
    icon: '💻',
    titleEs: 'Conectar Laptop por Consola a Router/Switch',
    titleEn: 'Connect Laptop via Console to Router/Switch',
    summaryEs: 'Accede a la CLI de un router o switch Cisco usando cable consola y PuTTY. Funciona sin IP configurada.',
    summaryEn: 'Access the CLI of a Cisco router or switch using a console cable and PuTTY. Works without any IP configured.',
    difficulty: 'Básico',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: 'Material necesario',
        titleEn: 'Required materials',
        contentEs: '''Para conectar por consola necesitas uno de estos cables:

Opción 1 — Cable RS-232 / DB-9 (equipos antiguos):
• Cable Rollover azul RJ-45 + adaptador RJ-45 a DB-9 (RS-232)
• Requiere puerto serial DB-9 en la laptop (o adaptador DB-9 a USB)

Opción 2 — Adaptador USB (más común hoy):
• Cable Rollover RJ-45 azul + adaptador DB-9 a USB (Prolific/FTDI)
• Driver automático en Windows 10/11

Opción 3 — USB mini-B directo (equipos modernos):
• Cable USB-A a USB mini-B (Cisco 1941, 2900, switches Cat 2960-X)
• Puerto marcado como "USB CONSOLE" en el equipo

Software: PuTTY (Windows) o screen/minicom (Linux/Mac)''',
        contentEn: '''To connect via console you need one of these cables:

Option 1 — RS-232 / DB-9 cable (legacy devices):
• Blue RJ-45 Rollover cable + RJ-45 to DB-9 (RS-232) adapter
• Requires DB-9 serial port on laptop (or DB-9 to USB adapter)

Option 2 — USB adapter (most common today):
• Blue RJ-45 Rollover cable + DB-9 to USB adapter (Prolific/FTDI)
• Automatic driver on Windows 10/11

Option 3 — Direct USB mini-B (modern devices):
• USB-A to USB mini-B cable (Cisco 1941, 2900, Cat 2960-X switches)
• Port labeled "USB CONSOLE" on the device

Software: PuTTY (Windows) or screen/minicom (Linux/Mac)''',
        tip: 'RS-232 usa señal serial ±12V — es el estándar original de consola Cisco. El adaptador DB-9 a USB convierte RS-232 a USB. Verifica que tu adaptador usa chip Prolific PL2303 o FTDI FT232 para mayor compatibilidad.',
        tipEn: 'RS-232 uses ±12V serial signal — the original Cisco console standard. A DB-9 to USB adapter converts RS-232 to USB. Check that your adapter uses Prolific PL2303 or FTDI FT232 chip for best compatibility.',
      ),
      GuideStep(
        titleEs: 'Conectar el cable',
        titleEn: 'Connect the cable',
        contentEs: '''1. Conecta el cable al puerto CONSOLE del router/switch
2. Conecta el otro extremo al USB del laptop
3. Windows instalará el driver automáticamente (o usa el driver Cisco USB)
4. Abre el Administrador de dispositivos → Puertos COM y LPT → anota el número de COM (ej: COM3)''',
        contentEn: '''1. Connect the cable to the CONSOLE port of the router/switch
2. Connect the other end to the laptop USB
3. Windows will install the driver automatically (or use the Cisco USB driver)
4. Open Device Manager → Ports COM & LPT → note the COM number (e.g. COM3)''',
        codeExample: '''! En Linux/Mac — identificar el puerto:
ls /dev/ttyUSB*
! o
ls /dev/tty.*''',
      ),
      GuideStep(
        titleEs: 'Abrir PuTTY y configurar Serial',
        titleEn: 'Open PuTTY and configure Serial',
        contentEs: '''1. Abre PuTTY
2. En "Connection type" selecciona: Serial
3. Serial line: COM3 (el número que anotaste)
4. Speed: 9600
5. Click Open
6. Presiona Enter si la pantalla aparece en blanco''',
        contentEn: '''1. Open PuTTY
2. In "Connection type" select: Serial
3. Serial line: COM3 (the number you noted)
4. Speed: 9600
5. Click Open
6. Press Enter if the screen appears blank''',
        tip: 'Parámetros Cisco siempre: 9600 baud, 8 bits de datos, sin paridad, 1 bit de parada, sin control de flujo (9600 8N1).',
        tipEn: 'Cisco parameters always: 9600 baud, 8 data bits, no parity, 1 stop bit, no flow control (9600 8N1).',
      ),
      GuideStep(
        titleEs: 'Primeros comandos en la CLI',
        titleEn: 'First commands in the CLI',
        contentEs: 'Una vez conectado verás el prompt del router. Navega entre modos y realiza la configuración inicial.',
        contentEn: 'Once connected you will see the router prompt. Navigate between modes and perform initial configuration.',
        codeExample: '''Router>          ← modo usuario
Router> enable
Router#          ← modo privilegiado
Router# conf t
Router(config)#  ← modo configuración global
!
! Si pide contraseña y no la sabes:
! → Recuperación de contraseña (password recovery)
! → Requiere acceso físico + reiniciar con break sequence''',
        codeExampleEn: '''Router>          ← user mode
Router> enable
Router#          ← privileged mode
Router# conf t
Router(config)#  ← global configuration mode
!
! If it asks for a password and you don't know it:
! → Password recovery procedure
! → Requires physical access + reboot with break sequence''',
        tip: 'Si ves caracteres extraños (basura), verifica que el baud rate es 9600. Si está en blanco, presiona Enter varias veces.',
        tipEn: 'If you see garbage characters, verify the baud rate is 9600. If blank, press Enter several times.',
      ),
    ],
  ),

  StepGuide(
    id: 'dhcp_server_cisco',
    icon: '🖥️',
    titleEs: 'Configurar Servidor DHCP en Router Cisco',
    titleEn: 'Configure DHCP Server on Cisco Router',
    summaryEs: 'Convierte un router Cisco IOS en servidor DHCP para asignar IPs automáticamente a los dispositivos de la red.',
    summaryEn: 'Turn a Cisco IOS router into a DHCP server to automatically assign IPs to network devices.',
    difficulty: 'Básico',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: '¿Qué es DHCP y cómo funciona?',
        titleEn: 'What is DHCP and how does it work?',
        contentEs: 'DHCP (Dynamic Host Configuration Protocol) asigna automáticamente: IP, máscara, gateway y DNS a cada dispositivo de la red. El proceso es: Discover → Offer → Request → Acknowledge (DORA).',
        contentEn: 'DHCP (Dynamic Host Configuration Protocol) automatically assigns: IP, subnet mask, gateway and DNS to each network device. The process is: Discover → Offer → Request → Acknowledge (DORA).',
        codeExample: '''! Sin DHCP: debes configurar cada PC manualmente
! Con DHCP: el router asigna todo automáticamente
!
! Flujo DORA:
! PC     → broadcast "necesito IP"     (Discover)
! Router → "te ofrezco 192.168.1.10"   (Offer)
! PC     → "acepto 192.168.1.10"       (Request)
! Router → "confirmado, es tuya"       (Acknowledge)''',
        codeExampleEn: '''! Without DHCP: you must configure each PC manually
! With DHCP: the router assigns everything automatically
!
! DORA flow:
! PC     → broadcast "I need an IP"        (Discover)
! Router → "I offer you 192.168.1.10"      (Offer)
! PC     → "I accept 192.168.1.10"         (Request)
! Router → "confirmed, it is yours"        (Acknowledge)''',
        tip: 'DHCP por defecto asigna IPs por 1 día (86400 segundos). Puedes cambiarlo con "lease".',
        tipEn: 'DHCP assigns IPs for 1 day by default (86400 seconds). You can change this with the "lease" command.',
      ),
      GuideStep(
        titleEs: 'Excluir IPs estáticas del pool',
        titleEn: 'Exclude static IPs from the pool',
        contentEs: 'Antes de crear el pool, excluye las IPs que usarán dispositivos estáticos: gateway, servidores, impresoras. Así DHCP no las asignará a otros.',
        contentEn: 'Before creating the pool, exclude IPs used by static devices: gateway, servers, printers. This prevents DHCP from assigning them to others.',
        codeExample: '''R1(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.10
! Excluye .1 a .10 (10 IPs reservadas para estáticos)
! El pool empezará a asignar desde .11
!
! Para excluir solo una IP:
R1(config)# ip dhcp excluded-address 192.168.1.1''',
        codeExampleEn: '''R1(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.10
! Excludes .1 to .10 (10 IPs reserved for static devices)
! The pool will start assigning from .11
!
! To exclude a single IP:
R1(config)# ip dhcp excluded-address 192.168.1.1''',
        tip: 'Siempre excluye al menos la IP del gateway (.1). Si tienes servidores o impresoras con IP fija, exclúyelas también.',
        tipEn: 'Always exclude at least the gateway IP (.1). If you have servers or printers with static IPs, exclude those too.',
      ),
      GuideStep(
        titleEs: 'Crear el pool DHCP',
        titleEn: 'Create the DHCP pool',
        contentEs: 'El pool define el rango de red, gateway y DNS que el router enviará a los clientes.',
        contentEn: 'The pool defines the network range, gateway and DNS that the router will send to clients.',
        codeExample: '''R1(config)# ip dhcp pool LAN-OFICINA
R1(dhcp-config)# network 192.168.1.0 255.255.255.0
R1(dhcp-config)# default-router 192.168.1.1
R1(dhcp-config)# dns-server 8.8.8.8 8.8.4.4
R1(dhcp-config)# domain-name empresa.local
R1(dhcp-config)# lease 1
! lease 1 = 1 día. lease 0 12 = 12 horas. lease infinite = sin expiración''',
        codeExampleEn: '''R1(config)# ip dhcp pool LAN-OFFICE
R1(dhcp-config)# network 192.168.1.0 255.255.255.0
R1(dhcp-config)# default-router 192.168.1.1
R1(dhcp-config)# dns-server 8.8.8.8 8.8.4.4
R1(dhcp-config)# domain-name company.local
R1(dhcp-config)# lease 1
! lease 1 = 1 day. lease 0 12 = 12 hours. lease infinite = never expires''',
        tip: 'El nombre del pool (LAN-OFICINA) es solo local — no afecta la red. Usa nombres descriptivos por VLAN o segmento.',
        tipEn: 'The pool name (LAN-OFICINA) is local only — it does not affect the network. Use descriptive names per VLAN or segment.',
      ),
      GuideStep(
        titleEs: 'Verificar el servidor DHCP',
        titleEn: 'Verify the DHCP server',
        contentEs: 'Comprueba que el servidor está activo y que está asignando IPs correctamente.',
        contentEn: 'Verify the server is active and assigning IPs correctly.',
        codeExample: '''! Ver leases activos (IPs asignadas):
R1# show ip dhcp binding
!
! Ver estadísticas del servidor:
R1# show ip dhcp server statistics
!
! Ver conflictos detectados:
R1# show ip dhcp conflict
!
! Limpiar conflictos:
R1# clear ip dhcp conflict *''',
        codeExampleEn: '''! Show active leases (assigned IPs):
R1# show ip dhcp binding
!
! Show server statistics:
R1# show ip dhcp server statistics
!
! Show detected conflicts:
R1# show ip dhcp conflict
!
! Clear conflicts:
R1# clear ip dhcp conflict *''',
        tip: '"show ip dhcp binding" muestra cada IP asignada con la MAC del dispositivo y la expiración. Úsalo para verificar qué dispositivo tiene qué IP.',
        tipEn: '"show ip dhcp binding" shows each assigned IP with the device MAC and expiration time. Use it to verify which device has which IP.',
      ),
      GuideStep(
        titleEs: 'DHCP para múltiples VLANs (ip helper-address)',
        titleEn: 'DHCP for multiple VLANs (ip helper-address)',
        contentEs: 'Si tienes múltiples VLANs, el broadcast DHCP no cruza entre ellas. Usa "ip helper-address" para redirigir las peticiones al servidor DHCP centralizado.',
        contentEn: 'With multiple VLANs, DHCP broadcasts do not cross between them. Use "ip helper-address" to forward requests to the central DHCP server.',
        codeExample: '''! En la sub-interfaz de cada VLAN (Router-on-a-Stick):
R1(config)# interface GigabitEthernet0/0.10
R1(config-subif)# ip helper-address 192.168.1.254
! 192.168.1.254 = IP del servidor DHCP centralizado
!
! Si el router mismo es el servidor, el helper no es necesario
! (el router atiende directamente la VLAN configurada)''',
        tip: '"ip helper-address" convierte el broadcast DHCP en unicast y lo reenvía al servidor especificado. Funciona también para DNS, TFTP y otros servicios UDP.',
        tipEn: '"ip helper-address" converts the DHCP broadcast into a unicast and forwards it to the specified server. It also works for DNS, TFTP and other UDP services.',
      ),
    ],
  ),

  StepGuide(
    id: 'cloud_vpn_config',
    icon: '☁️',
    titleEs: 'Conectar Red Local a la Nube (VPN IPSec)',
    titleEn: 'Connect Local Network to Cloud (IPSec VPN)',
    summaryEs: 'Configura un túnel VPN IPSec Site-to-Site entre un router Cisco y un proveedor de nube (AWS/Azure). Incluye conceptos clave y comandos IOS.',
    summaryEn: 'Configure an IPSec Site-to-Site VPN tunnel between a Cisco router and a cloud provider (AWS/Azure). Includes key concepts and IOS commands.',
    difficulty: 'Avanzado',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: '¿Qué es una VPN Site-to-Site?',
        titleEn: 'What is a Site-to-Site VPN?',
        contentEs: 'Una VPN Site-to-Site crea un túnel cifrado entre dos redes sobre Internet. La red local y la nube se ven como si estuvieran directamente conectadas. Usa IPSec para cifrado y autenticación.',
        contentEn: 'A Site-to-Site VPN creates an encrypted tunnel between two networks over the Internet. The local network and the cloud appear directly connected. Uses IPSec for encryption and authentication.',
        codeExample: '''! Arquitectura:
! [Red Local 10.0.1.0/24] --- Internet --- [AWS VPC 172.31.0.0/16]
!        R1 (IP pública: 200.1.1.1)         (IP pública AWS: 52.x.x.x)
!
! El tráfico entre ambas redes viaja cifrado por Internet
! IPSec fase 1 (IKE) = negocia parámetros de seguridad
! IPSec fase 2 (IPSec SA) = cifra el tráfico de datos''',
        codeExampleEn: '''! Architecture:
! [Local Network 10.0.1.0/24] --- Internet --- [AWS VPC 172.31.0.0/16]
!        R1 (public IP: 200.1.1.1)            (AWS public IP: 52.x.x.x)
!
! Traffic between both networks travels encrypted over the Internet
! IPSec phase 1 (IKE) = negotiates security parameters
! IPSec phase 2 (IPSec SA) = encrypts data traffic''',
        tip: 'AWS y Azure generan automáticamente la configuración IOS cuando creas una VPN en su consola. Descarga el archivo y úsalo como referencia.',
        tipEn: 'AWS and Azure automatically generate the IOS configuration when you create a VPN in their console. Download the file and use it as a reference.',
      ),
      GuideStep(
        titleEs: 'Fase 1 — Configurar ISAKMP (IKE)',
        titleEn: 'Phase 1 — Configure ISAKMP (IKE)',
        contentEs: 'La Fase 1 negocia los parámetros de seguridad entre los dos extremos (peers). Define el cifrado, hash, autenticación y grupo Diffie-Hellman.',
        contentEn: 'Phase 1 negotiates security parameters between both endpoints (peers). Defines encryption, hash, authentication and Diffie-Hellman group.',
        codeExample: '''R1(config)# crypto isakmp policy 10
R1(config-isakmp)# encryption aes 256
R1(config-isakmp)# hash sha256
R1(config-isakmp)# authentication pre-share
R1(config-isakmp)# group 14
R1(config-isakmp)# lifetime 86400
!
! Pre-shared key (clave compartida con el peer remoto):
R1(config)# crypto isakmp key MiClaveSegura2024 address 52.x.x.x
! 52.x.x.x = IP pública del peer remoto (AWS/Azure)''',
        codeExampleEn: '''R1(config)# crypto isakmp policy 10
R1(config-isakmp)# encryption aes 256
R1(config-isakmp)# hash sha256
R1(config-isakmp)# authentication pre-share
R1(config-isakmp)# group 14
R1(config-isakmp)# lifetime 86400
!
! Pre-shared key (shared secret with the remote peer):
R1(config)# crypto isakmp key MySecureKey2024 address 52.x.x.x
! 52.x.x.x = remote peer public IP (AWS/Azure)''',
        tip: 'AES-256 + SHA-256 + grupo DH 14 es la configuración mínima recomendada para 2024. Evita DES, MD5 y grupos DH 1/2 — son inseguros.',
        tipEn: 'AES-256 + SHA-256 + DH group 14 is the minimum recommended configuration for 2024. Avoid DES, MD5 and DH groups 1/2 — they are insecure.',
      ),
      GuideStep(
        titleEs: 'Fase 2 — Configurar IPSec Transform Set',
        titleEn: 'Phase 2 — Configure IPSec Transform Set',
        contentEs: 'La Fase 2 define cómo se cifra el tráfico de datos real. El Transform Set especifica los algoritmos de cifrado e integridad para el túnel IPSec.',
        contentEn: 'Phase 2 defines how actual data traffic is encrypted. The Transform Set specifies the encryption and integrity algorithms for the IPSec tunnel.',
        codeExample: '''! Transform set: algoritmos para el túnel de datos
R1(config)# crypto ipsec transform-set AWS-TS esp-aes 256 esp-sha256-hmac
R1(cfg-crypto-trans)# mode tunnel
!
! ACL: define qué tráfico va por el túnel
R1(config)# ip access-list extended VPN-TRAFICO
R1(config-ext-nacl)# permit ip 10.0.1.0 0.0.0.255 172.31.0.0 0.0.255.255
! 10.0.1.0/24 = red local, 172.31.0.0/16 = VPC remota''',
        codeExampleEn: '''! Transform set: algorithms for the data tunnel
R1(config)# crypto ipsec transform-set AWS-TS esp-aes 256 esp-sha256-hmac
R1(cfg-crypto-trans)# mode tunnel
!
! ACL: defines which traffic goes through the tunnel
R1(config)# ip access-list extended VPN-TRAFFIC
R1(config-ext-nacl)# permit ip 10.0.1.0 0.0.0.255 172.31.0.0 0.0.255.255
! 10.0.1.0/24 = local network, 172.31.0.0/16 = remote VPC''',
        tip: 'La ACL de crypto debe ser "espejo" en ambos extremos: lo que un lado permite como origen, el otro lo permite como destino.',
        tipEn: 'The crypto ACL must be a "mirror" on both ends: what one side permits as source, the other permits as destination.',
      ),
      GuideStep(
        titleEs: 'Crear el Crypto Map y aplicarlo',
        titleEn: 'Create the Crypto Map and apply it',
        contentEs: 'El Crypto Map une todos los componentes: peer, transform set y ACL. Se aplica a la interfaz WAN del router.',
        contentEn: 'The Crypto Map ties everything together: peer, transform set and ACL. It is applied to the router WAN interface.',
        codeExample: '''R1(config)# crypto map AWS-VPN 10 ipsec-isakmp
R1(config-crypto-map)# set peer 52.x.x.x
R1(config-crypto-map)# set transform-set AWS-TS
R1(config-crypto-map)# match address VPN-TRAFICO
R1(config-crypto-map)# set security-association lifetime seconds 3600
!
! Aplicar a la interfaz WAN:
R1(config)# interface GigabitEthernet0/1
R1(config-if)# crypto map AWS-VPN''',
        tip: 'El túnel IPSec se levanta automáticamente cuando hay tráfico que coincide con la ACL de crypto. No necesitas iniciarlo manualmente.',
        tipEn: 'The IPSec tunnel comes up automatically when traffic matches the crypto ACL. You do not need to initiate it manually.',
      ),
      GuideStep(
        titleEs: 'Verificar el túnel VPN',
        titleEn: 'Verify the VPN tunnel',
        contentEs: 'Verifica que las fases IKE e IPSec están establecidas y que el tráfico está pasando por el túnel.',
        contentEn: 'Verify that the IKE and IPSec phases are established and traffic is flowing through the tunnel.',
        codeExample: '''! Ver estado de Fase 1 (IKE):
R1# show crypto isakmp sa
! Estado esperado: QM_IDLE
!
! Ver estado de Fase 2 (IPSec SAs):
R1# show crypto ipsec sa
! Busca "pkts encaps" y "pkts decaps" incrementando
!
! Ver el crypto map aplicado:
R1# show crypto map
!
! Probar conectividad (ping desde la red local a la nube):
R1# ping 172.31.0.1 source 10.0.1.1''',
        tip: 'Si "pkts encaps" sube pero "pkts decaps" no, el tráfico sale pero no regresa. Verifica la configuración del peer remoto y las rutas de retorno.',
        tipEn: 'If "pkts encaps" increases but "pkts decaps" does not, traffic is leaving but not returning. Check the remote peer configuration and return routes.',
      ),
    ],
  ),

  StepGuide(
    id: 'ipv4_config',
    icon: '🌐',
    titleEs: 'Configurar IPv4 en Router Cisco',
    titleEn: 'Configure IPv4 on a Cisco Router',
    summaryEs: 'Asigna una dirección IPv4 estática a una interfaz, verifica la conectividad y entiende los comandos esenciales.',
    summaryEn: 'Assign a static IPv4 address to an interface, verify connectivity and understand the essential commands.',
    difficulty: 'Básico',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: 'Conceptos clave de IPv4',
        titleEn: 'Key IPv4 concepts',
        contentEs: 'IPv4 usa direcciones de 32 bits (ej. 192.168.1.1). Cada interfaz del router necesita una IP única dentro de su subred. La máscara define qué parte es red y qué parte es host.',
        contentEn: 'IPv4 uses 32-bit addresses (e.g. 192.168.1.1). Each router interface needs a unique IP within its subnet. The mask defines which part is network and which is host.',
        tip: 'Una /24 permite 254 hosts. Una /30 solo 2 hosts — ideal para enlaces punto a punto entre routers.',
        tipEn: 'A /24 allows 254 hosts. A /30 allows only 2 — ideal for point-to-point links between routers.',
      ),
      GuideStep(
        titleEs: 'Asignar IP a una interfaz',
        titleEn: 'Assign IP to an interface',
        contentEs: 'Entra al modo de configuración de la interfaz, asigna la IP con su máscara y activa la interfaz con "no shutdown".',
        contentEn: 'Enter interface configuration mode, assign the IP with its mask and activate the interface with "no shutdown".',
        codeExample: 'R1(config)# interface GigabitEthernet0/0\nR1(config-if)# ip address 192.168.1.1 255.255.255.0\nR1(config-if)# description LAN-Oficina\nR1(config-if)# no shutdown\nR1(config-if)# exit',
        codeExampleEn: 'R1(config)# interface GigabitEthernet0/0\nR1(config-if)# ip address 192.168.1.1 255.255.255.0\nR1(config-if)# description LAN-Office\nR1(config-if)# no shutdown\nR1(config-if)# exit',
        tip: 'Si la interfaz muestra "administratively down", ejecuta "no shutdown". Si dice solo "down", hay un problema físico (cable, velocidad).',
        tipEn: 'If the interface shows "administratively down", run "no shutdown". If it says just "down", there is a physical problem (cable, speed).',
      ),
      GuideStep(
        titleEs: 'Verificar configuración IPv4',
        titleEn: 'Verify IPv4 configuration',
        contentEs: 'Usa los comandos "show" para confirmar que la IP fue asignada correctamente y la interfaz está activa.',
        contentEn: 'Use "show" commands to confirm the IP was assigned correctly and the interface is active.',
        codeExample: '! Resumen de todas las interfaces:\nR1# show ip interface brief\n!\n! Ver tabla de routing:\nR1# show ip route\n!\n! Ping a otro dispositivo:\nR1# ping 192.168.1.10\n!\n! Guardar:\nR1# copy running-config startup-config',
        tip: '"show ip interface brief" es el comando más útil del día a día: todas las interfaces, IP y estado en una tabla.',
        tipEn: '"show ip interface brief" is the most useful everyday command: all interfaces, IP and state in one table.',
      ),
      GuideStep(
        titleEs: 'Configurar LAN + WAN + ruta por defecto',
        titleEn: 'Configure LAN + WAN + default route',
        contentEs: 'Un router típico tiene una interfaz LAN (red interna) y una WAN (Internet u otra red). Agrega una ruta por defecto para salir a Internet.',
        contentEn: 'A typical router has a LAN interface (internal network) and a WAN interface (Internet or another network). Add a default route to reach the Internet.',
        codeExample: '! LAN:\nR1(config)# interface GigabitEthernet0/0\nR1(config-if)# ip address 192.168.1.1 255.255.255.0\nR1(config-if)# no shutdown\nR1(config-if)# exit\n!\n! WAN:\nR1(config)# interface GigabitEthernet0/1\nR1(config-if)# ip address 10.0.0.1 255.255.255.252\nR1(config-if)# no shutdown\nR1(config-if)# exit\n!\n! Ruta por defecto:\nR1(config)# ip route 0.0.0.0 0.0.0.0 10.0.0.2',
        tip: 'Usa /30 para enlaces punto a punto entre routers — solo necesitas 2 IPs. Usar /24 desperdiciaría 252 direcciones.',
        tipEn: 'Use /30 for point-to-point links between routers — you only need 2 IPs. Using /24 would waste 252 addresses.',
      ),
    ],
  ),
  StepGuide(
    id: 'ipv6_config',
    icon: '🔷',
    titleEs: 'Configurar IPv6 en Router Cisco',
    titleEn: 'Configure IPv6 on a Cisco Router',
    summaryEs: 'Habilita IPv6 en el router, asigna direcciones estáticas y link-local, y verifica conectividad con los comandos IOS correctos.',
    summaryEn: 'Enable IPv6 on the router, assign static and link-local addresses, and verify connectivity with the correct IOS commands.',
    difficulty: 'Intermedio',
    category: 'router',
    steps: [
      GuideStep(
        titleEs: 'Conceptos clave de IPv6',
        titleEn: 'Key IPv6 concepts',
        contentEs: 'IPv6 usa direcciones de 128 bits en hexadecimal (ej. 2001:db8:1::1/64). Cada interfaz puede tener múltiples IPs simultáneas: una global unicast, una link-local (FE80::/10) y opcionalmente una anycast.',
        contentEn: 'IPv6 uses 128-bit addresses in hexadecimal (e.g. 2001:db8:1::1/64). Each interface can have multiple simultaneous IPs: one global unicast, one link-local (FE80::/10) and optionally one anycast.',
        tip: 'La dirección link-local es automática y obligatoria. Sin ella, IPv6 no funciona. Se usa para routing, NDP y Router Advertisements.',
        tipEn: 'The link-local address is automatic and mandatory. Without it, IPv6 does not work. It is used for routing, NDP and Router Advertisements.',
      ),
      GuideStep(
        titleEs: 'Habilitar IPv6 routing (obligatorio)',
        titleEn: 'Enable IPv6 routing (mandatory)',
        contentEs: 'A diferencia de IPv4, el routing IPv6 está deshabilitado por defecto en IOS. Sin este comando, el router no reenvía paquetes IPv6 entre interfaces.',
        contentEn: 'Unlike IPv4, IPv6 routing is disabled by default in IOS. Without this command, the router does not forward IPv6 packets between interfaces.',
        codeExample: 'R1(config)# ipv6 unicast-routing\n!\n! Verificar:\nR1# show ipv6 protocols',
        tip: 'Este es el error más común al configurar IPv6 por primera vez: olvidar "ipv6 unicast-routing". Las interfaces tendrán IP pero el router no encaminará nada.',
        tipEn: 'This is the most common mistake when configuring IPv6 for the first time: forgetting "ipv6 unicast-routing". Interfaces will have an IP but the router will not route anything.',
      ),
      GuideStep(
        titleEs: 'Asignar dirección IPv6 a una interfaz',
        titleEn: 'Assign an IPv6 address to an interface',
        contentEs: 'Usa /64 para redes LAN (estándar recomendado). Puedes asignar la dirección manualmente o dejar que EUI-64 genere la parte de host desde la MAC.',
        contentEn: 'Use /64 for LAN networks (recommended standard). You can assign the address manually or let EUI-64 generate the host portion from the MAC.',
        codeExample: '! Estática (recomendado para routers):\nR1(config)# interface GigabitEthernet0/0\nR1(config-if)# ipv6 address 2001:db8:1::1/64\nR1(config-if)# no shutdown\nR1(config-if)# exit\n!\n! EUI-64 (genera la parte de host desde la MAC):\nR1(config-if)# ipv6 address 2001:db8:2::/64 eui-64\n!\n! Link-local personalizada (facilita debug):\nR1(config-if)# ipv6 address FE80::1 link-local',
        tip: 'Para dual-stack (IPv4 + IPv6 simultáneo), configura ambas versiones en la misma interfaz. IOS las gestiona de forma independiente.',
        tipEn: 'For dual-stack (IPv4 + IPv6 simultaneously), configure both versions on the same interface. IOS manages them independently.',
      ),
      GuideStep(
        titleEs: 'Verificar IPv6 y ruta por defecto',
        titleEn: 'Verify IPv6 and default route',
        contentEs: 'Los comandos de verificación IPv6 son idénticos a IPv4 pero con el prefijo "ipv6". La ruta por defecto usa ::/0 en lugar de 0.0.0.0/0.',
        contentEn: 'IPv6 verification commands are identical to IPv4 but with the "ipv6" prefix. The default route uses ::/0 instead of 0.0.0.0/0.',
        codeExample: '! Resumen de interfaces IPv6:\nR1# show ipv6 interface brief\n!\n! Tabla de routing IPv6:\nR1# show ipv6 route\n!\n! Ping IPv6:\nR1# ping ipv6 2001:db8:1::10\n!\n! Vecinos (equivalente a ARP):\nR1# show ipv6 neighbors\n!\n! Ruta por defecto IPv6:\nR1(config)# ipv6 route ::/0 2001:db8:ff::2',
        tip: '"show ipv6 neighbors" es el equivalente de "show arp" — muestra los dispositivos vecinos aprendidos via NDP en lugar de ARP.',
        tipEn: '"show ipv6 neighbors" is the equivalent of "show arp" — shows neighbor devices learned via NDP instead of ARP.',
      ),
    ],
  ),
  StepGuide(
    id: 'hotmart_update',
    icon: '🚀',
    titleEs: 'Subir Nueva Versión a Hotmart',
    titleEn: 'Upload a New Version to Hotmart',
    summaryEs: 'Cómo actualizar un producto digital ya publicado en Hotmart: reemplazar archivos, verificar acceso y notificar a compradores.',
    summaryEn: 'How to update an already-published digital product on Hotmart: replace files, verify access and notify buyers.',
    difficulty: 'Básico',
    category: 'tools',
    steps: [
      GuideStep(
        titleEs: 'Acceder y editar el producto',
        titleEn: 'Access and edit the product',
        contentEs: 'Entra a Hotmart, ve a Productos y selecciona el producto. Los compradores anteriores conservan acceso automáticamente — Hotmart no borra el historial de ventas al actualizar.',
        contentEn: 'Log into Hotmart, go to Products and select the product. Previous buyers automatically retain access — Hotmart does not erase sales history when updating.',
        codeExample: 'Pasos:\n1. hotmart.com → iniciar sesión\n2. Menú → Productos\n3. Seleccionar producto → "Editar"\n4. Sección "Archivos" o "Contenido"\n5. Eliminar archivo anterior → subir nuevo archivo',
        tip: 'Hotmart NO envía notificaciones automáticas cuando actualizas un archivo. Deberás avisar a los compradores manualmente.',
        tipEn: 'Hotmart does NOT send automatic notifications when you update a file. You must notify buyers manually.',
      ),
      GuideStep(
        titleEs: 'Reemplazar el archivo del producto',
        titleEn: 'Replace the product file',
        contentEs: 'Elimina el archivo anterior y sube la nueva versión. Usa un nombre descriptivo que incluya el número de versión para que los compradores puedan identificarlo fácilmente.',
        contentEn: 'Delete the old file and upload the new version. Use a descriptive name that includes the version number so buyers can easily identify it.',
        codeExample: 'Naming recomendado:\n  NetCalc_v2.1.apk          (Android)\n  NetCalc_Setup_v2.1.exe    (Windows con instalador)\n  NetCalc_Windows_v2.1.zip  (Windows carpeta ZIP)\n\nFormatos aceptados por Hotmart:\n  APK, EXE, ZIP, PDF, MP4, y otros',
        tip: 'Incluir la versión en el nombre del archivo reduce confusión y tickets de soporte. Los compradores pueden confirmar fácilmente que tienen la versión más reciente.',
        tipEn: 'Including the version in the filename reduces confusion and support tickets. Buyers can easily confirm they have the latest version.',
      ),
      GuideStep(
        titleEs: 'Verificar antes de notificar',
        titleEn: 'Verify before notifying',
        contentEs: 'Antes de avisar a todos los compradores, prueba el flujo completo: descarga el archivo desde el área de miembros e instálalo en un dispositivo limpio.',
        contentEn: 'Before notifying all buyers, test the full flow: download the file from the member area and install it on a clean device.',
        codeExample: 'Lista de verificación:\n☐ Archivo subido correctamente (verificar nombre y tamaño)\n☐ Descargué desde el área de miembros de Hotmart\n☐ Instalé en dispositivo limpio (sin versión anterior)\n☐ La versión en la app muestra el número correcto (ej. v2.1)\n☐ Las funciones nuevas/corregidas funcionan\n☐ Probé en todos los sistemas que apliquen (Android + Windows)',
        tip: 'Hotmart permite crear "test buyers" (compradores de prueba). Úsalos para simular la experiencia del comprador sin gastar una venta real.',
        tipEn: 'Hotmart allows creating "test buyers". Use them to simulate the buyer experience without spending a real sale.',
      ),
      GuideStep(
        titleEs: 'Notificar a los compradores',
        titleEn: 'Notify buyers',
        contentEs: 'Una vez verificado el archivo, notifica a tus compradores via email directo desde Hotmart o con tu herramienta de email marketing.',
        contentEn: 'Once the file is verified, notify your buyers via direct email from Hotmart or with your email marketing tool.',
        codeExample: 'Desde Hotmart:\n  Clientes → Filtrar por producto → Seleccionar todos → Enviar email\n\nPlantilla sugerida:\n─────────────────────────────\nAsunto: ¡Nueva versión! NetCalc v2.1\n\nHola,\nActualizamos NetCalc v2.1 con:\n  • [Mejora 1]\n  • [Correcciones de bugs]\n\nDescarga en tu área de miembros:\n  [link Hotmart]\n─────────────────────────────',
        tip: 'Un changelog claro (qué cambió y por qué) aumenta la percepción de valor del producto incluso si los cambios son pequeños.',
        tipEn: 'A clear changelog (what changed and why) increases the perceived value of the product even if the changes are small.',
      ),
    ],
  ),
  StepGuide(
    id: 'flutter_rebuild',
    icon: '🔨',
    titleEs: 'Reconstruir EXE y APK con Flutter',
    titleEn: 'Rebuild EXE and APK with Flutter',
    summaryEs: 'Cómo generar de nuevo el instalador Windows (.exe) y el paquete Android (.apk) después de modificar el código Flutter.',
    summaryEn: 'How to regenerate the Windows installer (.exe) and Android package (.apk) after modifying Flutter code.',
    difficulty: 'Intermedio',
    category: 'tools',
    steps: [
      GuideStep(
        titleEs: 'Preparar el entorno antes de compilar',
        titleEn: 'Prepare the environment before building',
        contentEs: 'Actualiza el número de versión en pubspec.yaml, limpia el proyecto y verifica dependencias. Estos pasos previenen errores por caché de compilaciones anteriores.',
        contentEn: 'Update the version number in pubspec.yaml, clean the project and verify dependencies. These steps prevent errors from cached previous builds.',
        codeExample: '# 1. Actualizar pubspec.yaml:\n#    version: 2.1.0+4\n#    (major.minor.patch+buildNumber)\n#    buildNumber SIEMPRE debe incrementar\n\n# 2. Limpiar compilaciones anteriores:\nflutter clean\n\n# 3. Obtener dependencias:\nflutter pub get\n\n# 4. Verificar entorno (opcional):\nflutter doctor',
        codeExampleEn: '# 1. Update pubspec.yaml:\n#    version: 2.1.0+4\n#    (major.minor.patch+buildNumber)\n#    buildNumber MUST always increment\n\n# 2. Clean previous builds:\nflutter clean\n\n# 3. Get dependencies:\nflutter pub get\n\n# 4. Verify environment (optional):\nflutter doctor',
        tip: 'El buildNumber (versionCode en Android) debe siempre incrementar. Android rechaza instalar un APK con buildNumber igual o menor al instalado.',
        tipEn: 'The buildNumber (versionCode in Android) must always increment. Android rejects installing an APK with a buildNumber equal or lower than the installed one.',
      ),
      GuideStep(
        titleEs: 'Compilar el APK para Android',
        titleEn: 'Build the APK for Android',
        contentEs: 'Flutter compila el APK en modo release con todas las optimizaciones. El APK release es más pequeño y rápido que el debug y es el que distribuyes.',
        contentEn: 'Flutter compiles the APK in release mode with all optimizations. The release APK is smaller and faster than debug and is the one you distribute.',
        codeExample: '# APK universal (recomendado para distribución directa / Hotmart):\nflutter build apk --release\n# Resultado: build/app/outputs/flutter-apk/app-release.apk\n\n# APK por arquitectura (más pequeño, ideal para Play Store):\nflutter build apk --release --split-per-abi\n# arm64-v8a-release.apk  → Android moderno 64-bit\n# armeabi-v7a-release.apk → Android antiguo 32-bit\n\n# App Bundle (solo Google Play Store):\nflutter build appbundle --release',
        codeExampleEn: '# Universal APK (recommended for direct distribution / Hotmart):\nflutter build apk --release\n# Output: build/app/outputs/flutter-apk/app-release.apk\n\n# Per-architecture APK (smaller, ideal for Play Store):\nflutter build apk --release --split-per-abi\n# arm64-v8a-release.apk  → modern 64-bit Android\n# armeabi-v7a-release.apk → older 32-bit Android\n\n# App Bundle (Google Play Store only):\nflutter build appbundle --release',
        tip: 'Para distribución directa (Hotmart, Discord, tu web), usa el APK universal "app-release.apk". Funciona en todos los dispositivos sin que el usuario tenga que elegir.',
        tipEn: 'For direct distribution (Hotmart, Discord, your website), use the universal "app-release.apk". It works on all devices without the user having to choose.',
      ),
      GuideStep(
        titleEs: 'Compilar el EXE para Windows',
        titleEn: 'Build the EXE for Windows',
        contentEs: 'Flutter genera un ejecutable nativo de Windows. La carpeta de salida contiene el EXE más todos los DLLs necesarios — distribuye siempre la carpeta completa, nunca solo el .exe.',
        contentEn: 'Flutter generates a native Windows executable. The output folder contains the EXE plus all necessary DLLs — always distribute the complete folder, never just the .exe.',
        codeExample: '# Compilar para Windows (ejecutar EN Windows):\nflutter build windows --release\n\n# Resultado en:\n#   build/windows/x64/runner/Release/\n#   Contiene: App.exe + data/ + *.dll\n\n# ── Opción A: ZIP directo (más simple) ──\n# Comprimir toda la carpeta Release/ como ZIP\n# → NetCalc_Windows_v2.1.zip\n# Usuario extrae y ejecuta App.exe\n\n# ── Opción B: Instalador Inno Setup (profesional) ──\n# Instalar: jrsoftware.org/isinfo.php\n# Apuntar al contenido de Release/\n# Genera: NetCalc_Setup_v2.1.exe',
        codeExampleEn: '# Build for Windows (run ON Windows):\nflutter build windows --release\n\n# Output at:\n#   build/windows/x64/runner/Release/\n#   Contains: App.exe + data/ + *.dll\n\n# ── Option A: Direct ZIP (simpler) ──\n# Compress entire Release/ folder as ZIP\n# → NetCalc_Windows_v2.1.zip\n# User extracts and runs App.exe\n\n# ── Option B: Inno Setup installer (professional) ──\n# Install from: jrsoftware.org/isinfo.php\n# Point to contents of Release/\n# Generates: NetCalc_Setup_v2.1.exe',
        tip: '⚠️ NUNCA distribuyas solo el .exe — la app no abrirá sin los DLLs. Siempre distribuye la carpeta completa comprimida en ZIP o empaquetada con un instalador.',
        tipEn: '⚠️ NEVER distribute just the .exe — the app will not open without the DLLs. Always distribute the complete folder compressed as ZIP or packaged with an installer.',
      ),
      GuideStep(
        titleEs: 'Firmar el APK con keystore',
        titleEn: 'Sign the APK with a keystore',
        contentEs: 'Para que Android permita actualizar la app sin desinstalar, el APK debe estar firmado siempre con el mismo keystore. Sin firma consistente, el sistema rechaza la actualización.',
        contentEn: 'For Android to allow updating the app without uninstalling, the APK must always be signed with the same keystore. Without consistent signing, the system rejects the update.',
        codeExample: '# Crear keystore (SOLO la primera vez):\nkeytool -genkey -v -keystore netcalc.keystore ^\n  -alias netcalc -keyalg RSA -keysize 2048 -validity 10000\n\n# Crear android/key.properties:\n#   storePassword=PASSWORD_AQUI\n#   keyPassword=PASSWORD_AQUI\n#   keyAlias=netcalc\n#   storeFile=../../netcalc.keystore\n\n# Configurar android/app/build.gradle (ver docs Flutter)\n# Luego compilar normalmente — Flutter firma automático:\nflutter build apk --release\n\n# ⚠️ Guarda el keystore en 3 lugares:\n#   1. Nube cifrada (Drive/Dropbox)\n#   2. Disco externo\n#   3. Contraseña en gestor de contraseñas',
        codeExampleEn: '# Create keystore (ONLY the first time):\nkeytool -genkey -v -keystore netcalc.keystore ^\n  -alias netcalc -keyalg RSA -keysize 2048 -validity 10000\n\n# Create android/key.properties:\n#   storePassword=PASSWORD_HERE\n#   keyPassword=PASSWORD_HERE\n#   keyAlias=netcalc\n#   storeFile=../../netcalc.keystore\n\n# Configure android/app/build.gradle (see Flutter docs)\n# Then build normally — Flutter signs automatically:\nflutter build apk --release\n\n# ⚠️ Save the keystore in 3 places:\n#   1. Encrypted cloud (Drive/Dropbox)\n#   2. External drive\n#   3. Password in a password manager',
        tip: 'Si pierdes el keystore es IMPOSIBLE recuperarlo. Los usuarios tendrían que desinstalar la app vieja e instalar la nueva, perdiendo todos sus datos locales.',
        tipEn: 'If you lose the keystore it is IMPOSSIBLE to recover. Users would have to uninstall the old app and install the new one, losing all their local data.',
      ),
    ],
  ),
];
