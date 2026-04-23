/// ExplanationEngine
/// Generates educational content for networking topics.
/// Returns structured lesson data consumed by the Learning Mode screen.
/// Bilingual: all content available in Spanish and English.
/// Usage: lesson.title(isSpanish), section.heading(isSpanish), etc.

class ExplanationEngine {
  ExplanationEngine._();

  static const Map<String, NetworkLesson> lessons = {
    'subnetting': _subnetLesson,
    'vlsm': _vlsmLesson,
    'vlan': _vlanLesson,
    'router_on_stick': _rosLesson,
    'static_routing': _staticRoutingLesson,
    'rip': _ripLesson,
    'ospf': _ospfLesson,
    'nat': _natLesson,
    'acl': _aclLesson,
    'ipv6': _ipv6Lesson,
    'osi_model': _osiLesson,
    'interfaces': _interfacesLesson,
    'serial_dce_dte': _serialDceDteLesson,
    'broadcast_bits': _broadcastBitsLesson,
    'console_connection': _consoleLesson,
    'servers': _serversLesson,
    'cloud_networking': _cloudLesson,
  };

  static NetworkLesson? getLesson(String key) => lessons[key];

  static List<String> get allTopics => lessons.keys.toList();
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class NetworkLesson {
  final String titleEs;
  final String titleEn;
  final String icon;
  final String summaryEs;
  final String summaryEn;
  final List<LessonSection> sections;
  final List<String> keyPointsEs;
  final List<String> keyPointsEn;
  final String? ciscoConceptEs;
  final String? ciscoConceptEn;

  const NetworkLesson({
    required this.titleEs,
    required this.titleEn,
    required this.icon,
    required this.summaryEs,
    required this.summaryEn,
    required this.sections,
    required this.keyPointsEs,
    required this.keyPointsEn,
    this.ciscoConceptEs,
    this.ciscoConceptEn,
  });

  String title(bool isSpanish) => isSpanish ? titleEs : titleEn;
  String summary(bool isSpanish) => isSpanish ? summaryEs : summaryEn;
  List<String> keyPoints(bool isSpanish) => isSpanish ? keyPointsEs : keyPointsEn;
  String? ciscoConcept(bool isSpanish) => isSpanish ? ciscoConceptEs : ciscoConceptEn;
}

class LessonSection {
  final String headingEs;
  final String headingEn;
  final String contentEs;
  final String contentEn;
  final String? codeExampleEs;
  final String? codeExampleEn;

  const LessonSection({
    required this.headingEs,
    required this.headingEn,
    required this.contentEs,
    required this.contentEn,
    this.codeExampleEs,
    this.codeExampleEn,
  });

  String heading(bool isSpanish) => isSpanish ? headingEs : headingEn;
  String content(bool isSpanish) => isSpanish ? contentEs : contentEn;
  String? codeExample(bool isSpanish) => isSpanish ? codeExampleEs : codeExampleEn;
}

// ─── Lesson definitions ───────────────────────────────────────────────────────

const _subnetLesson = NetworkLesson(
  titleEs: 'Subnetting IPv4',
  titleEn: 'IPv4 Subnetting',
  icon: '🔢',
  summaryEs:
      'El subnetting divide una red grande en segmentos más pequeños y manejables. '
      'Mejora la seguridad, reduce los dominios de broadcast y permite una asignación eficiente de IPs.',
  summaryEn:
      'Subnetting divides a large network into smaller, manageable segments. '
      'It improves security, reduces broadcast domains, and enables efficient IP allocation.',
  sections: [
    LessonSection(
      headingEs: '¿Qué es una subred?',
      headingEn: 'What is a subnet?',
      contentEs:
          'Una subred es una división lógica de una red IP. '
          'La máscara de subred define qué bits pertenecen a la red y cuáles a los hosts.\n\n'
          'Una máscara /24 (255.255.255.0) significa 24 bits de red y 8 bits de host, '
          'lo que da 254 hosts utilizables.',
      contentEn:
          'A subnet is a logical division of an IP network. '
          'The subnet mask defines which bits belong to the network and which to hosts.\n\n'
          'A /24 mask (255.255.255.0) means 24 network bits and 8 host bits, '
          'giving 254 usable hosts.',
    ),
    LessonSection(
      headingEs: 'Notación CIDR',
      headingEn: 'CIDR Notation',
      contentEs:
          'CIDR (Enrutamiento Inter-Dominio sin Clases) usa un prefijo "/" para indicar la longitud de la máscara.\n'
          '   /8  → 255.0.0.0   → 16,777,214 hosts\n'
          '   /16 → 255.255.0.0 → 65,534 hosts\n'
          '   /24 → 255.255.255.0 → 254 hosts\n'
          '   /30 → 255.255.255.252 → 2 hosts (punto a punto)',
      contentEn:
          'CIDR (Classless Inter-Domain Routing) uses a "/" prefix to denote the mask length.\n'
          '   /8  → 255.0.0.0   → 16,777,214 hosts\n'
          '   /16 → 255.255.0.0 → 65,534 hosts\n'
          '   /24 → 255.255.255.0 → 254 hosts\n'
          '   /30 → 255.255.255.252 → 2 hosts (point-to-point)',
    ),
    LessonSection(
      headingEs: 'Fórmulas clave',
      headingEn: 'Key formulas',
      contentEs:
          '• Hosts utilizables = 2^(32-prefijo) - 2\n'
          '• Subredes de un bloque = 2^(nuevo_prefijo - viejo_prefijo)\n'
          '• Dirección de red = IP AND máscara\n'
          '• Broadcast = IP OR wildcard',
      contentEn:
          '• Usable hosts = 2^(32-prefix) - 2\n'
          '• Subnets from a block = 2^(new_prefix - old_prefix)\n'
          '• Network = IP AND mask\n'
          '• Broadcast = IP OR wildcard',
    ),
  ],
  keyPointsEs: [
    'Dirección de red: todos los bits de host = 0',
    'Dirección de broadcast: todos los bits de host = 1',
    'Primer host utilizable = dirección de red + 1',
    'Último host utilizable = broadcast - 1',
    'Wildcard = NOT bit a bit de la máscara de subred',
  ],
  keyPointsEn: [
    'Network address: all host bits = 0',
    'Broadcast address: all host bits = 1',
    'First usable = network + 1',
    'Last usable = broadcast - 1',
    'Wildcard = bitwise NOT of subnet mask',
  ],
  ciscoConceptEs:
      'ip address 192.168.1.1 255.255.255.0\n'
      '! Asigna la IP y máscara a una interfaz',
  ciscoConceptEn:
      'ip address 192.168.1.1 255.255.255.0\n'
      '! Assigns IP and mask to an interface',
);

const _vlsmLesson = NetworkLesson(
  titleEs: 'VLSM',
  titleEn: 'VLSM',
  icon: '📐',
  summaryEs:
      'El Enmascaramiento de Subred de Longitud Variable asigna subredes de distintos tamaños '
      'desde un bloque de direcciones, minimizando el desperdicio de IPs.',
  summaryEn:
      'Variable Length Subnet Masking allocates different-sized subnets '
      'from one address block, minimizing wasted IP space.',
  sections: [
    LessonSection(
      headingEs: '¿Por qué VLSM?',
      headingEn: 'Why VLSM?',
      contentEs:
          'Las subredes de longitud fija desperdician direcciones. '
          'Un /24 para un enlace punto a punto de 2 hosts desperdicia 252 direcciones. '
          'VLSM asigna a cada segmento exactamente el tamaño que necesita.',
      contentEn:
          'Fixed-length subnets waste addresses. '
          'A /24 for a 2-host point-to-point link wastes 252 addresses. '
          'VLSM assigns each segment exactly the size it needs.',
    ),
    LessonSection(
      headingEs: 'Algoritmo VLSM',
      headingEn: 'VLSM Algorithm',
      contentEs:
          '1. Ordenar segmentos de mayor a menor\n'
          '2. Asignar la subred más pequeña que satisfaga cada segmento\n'
          '3. Avanzar el puntero a la siguiente red disponible\n'
          '4. Repetir hasta asignar todos los segmentos',
      contentEn:
          '1. Sort segments largest → smallest\n'
          '2. Allocate the smallest subnet that fits each segment\n'
          '3. Advance the pointer to the next available network\n'
          '4. Repeat until all segments are allocated',
    ),
    LessonSection(
      headingEs: 'Ejemplo',
      headingEn: 'Example',
      contentEs:
          'Base: 192.168.1.0/24\n'
          'Segmentos:\n'
          '  Ventas    → 50 hosts → /26 (62 utilizables)\n'
          '  IT        → 25 hosts → /27 (30 utilizables)\n'
          '  Admin     →  5 hosts → /29  (6 utilizables)\n'
          '  Enlace A-B →  2 hosts → /30  (2 utilizables)',
      contentEn:
          'Base: 192.168.1.0/24\n'
          'Segments:\n'
          '  Sales     → 50 hosts → /26 (62 usable)\n'
          '  IT        → 25 hosts → /27 (30 usable)\n'
          '  Mgmt      →  5 hosts → /29  (6 usable)\n'
          '  Link A-B  →  2 hosts → /30  (2 usable)',
    ),
  ],
  keyPointsEs: [
    'Siempre ordenar por el segmento más grande primero',
    'Elegir el bloque más pequeño que satisfaga los requisitos',
    'Sin solapamientos — asignación secuencial',
    'Ahorra espacio de direcciones vs. subnetting de longitud fija',
  ],
  keyPointsEn: [
    'Always sort by largest segment first',
    'Choose the smallest block that satisfies requirements',
    'No overlaps — sequential allocation',
    'Saves address space vs. fixed-length subnetting',
  ],
);

const _vlanLesson = NetworkLesson(
  titleEs: 'VLANs',
  titleEn: 'VLANs',
  icon: '🔀',
  summaryEs:
      'Las VLANs crean redes lógicamente separadas en el mismo switch físico, '
      'mejorando la seguridad y la gestión del tráfico.',
  summaryEn:
      'VLANs create logically separate networks on the same physical switch, '
      'improving security and traffic management.',
  sections: [
    LessonSection(
      headingEs: '¿Qué es una VLAN?',
      headingEn: 'What is a VLAN?',
      contentEs:
          'Una LAN Virtual agrupa dispositivos lógicamente sin importar su ubicación física. '
          'Los dispositivos en distintas VLANs no pueden comunicarse sin un dispositivo de Capa 3 (router o switch L3).',
      contentEn:
          'A Virtual LAN logically groups devices regardless of physical location. '
          'Devices in different VLANs cannot communicate without a Layer 3 device (router or L3 switch).',
    ),
    LessonSection(
      headingEs: 'Puertos Access vs. Trunk',
      headingEn: 'Access vs. Trunk ports',
      contentEs:
          'Puerto Access: transporta tráfico de UNA sola VLAN (dispositivos finales)\n'
          'Puerto Trunk: transporta tráfico de MÚLTIPLES VLANs (switch-switch, switch-router)\n\n'
          'Los puertos trunk etiquetan las tramas con IEEE 802.1Q para identificar la VLAN.',
      contentEn:
          'Access port: carries traffic for ONE VLAN (end devices)\n'
          'Trunk port: carries traffic for MULTIPLE VLANs (switch-to-switch, switch-to-router)\n\n'
          'Trunk ports tag frames with IEEE 802.1Q to identify the VLAN.',
    ),
    LessonSection(
      headingEs: 'Configuración Cisco',
      headingEn: 'Cisco Configuration',
      contentEs: 'Crear VLAN y asignar puerto de acceso:',
      contentEn: 'Create VLAN and assign access port:',
      codeExampleEs:
          'vlan 10\n'
          ' name Ventas\n'
          '!\n'
          'interface FastEthernet0/1\n'
          ' switchport mode access\n'
          ' switchport access vlan 10',
      codeExampleEn:
          'vlan 10\n'
          ' name Sales\n'
          '!\n'
          'interface FastEthernet0/1\n'
          ' switchport mode access\n'
          ' switchport access vlan 10',
    ),
  ],
  keyPointsEs: [
    'IDs de VLAN: 1–4094 (1002–1005 reservadas)',
    'VLAN 1 = predeterminada (evitar para gestión)',
    'Trunk usa etiquetado 802.1Q',
    'VLANs = dominios de broadcast de Capa 2',
    'El ruteo entre VLANs requiere Capa 3',
  ],
  keyPointsEn: [
    'VLAN IDs: 1–4094 (1002–1005 reserved)',
    'VLAN 1 = default (avoid for management)',
    'Trunk uses 802.1Q tagging',
    'VLANs = Layer 2 broadcast domains',
    'Routing between VLANs requires Layer 3',
  ],
);

const _rosLesson = NetworkLesson(
  titleEs: 'Router-on-a-Stick',
  titleEn: 'Router-on-a-Stick',
  icon: '🍡',
  summaryEs:
      'Router-on-a-Stick usa una sola interfaz física del router con sub-interfaces '
      'para enrutar entre múltiples VLANs sobre un único enlace trunk.',
  summaryEn:
      'Router-on-a-Stick uses one physical router interface with sub-interfaces '
      'to route between multiple VLANs over a single trunk link.',
  sections: [
    LessonSection(
      headingEs: '¿Cómo funciona?',
      headingEn: 'How it works',
      contentEs:
          'Un cable físico conecta el router a un puerto trunk del switch. '
          'El router crea sub-interfaces lógicas (G0/0.10, G0/0.20...), '
          'cada una etiquetada con un ID de VLAN mediante encapsulación 802.1Q.',
      contentEn:
          'One physical cable connects the router to a switch trunk port. '
          'The router creates logical sub-interfaces (G0/0.10, G0/0.20...), '
          'each tagged with a VLAN ID using 802.1Q encapsulation.',
    ),
    LessonSection(
      headingEs: 'Configuración de sub-interfaces',
      headingEn: 'Sub-interface configuration',
      contentEs: 'Cada sub-interface actúa como gateway predeterminado para su VLAN:',
      contentEn: 'Each sub-interface acts as the default gateway for its VLAN:',
      codeExampleEs:
          'interface GigabitEthernet0/0\n'
          ' no shutdown\n'
          '!\n'
          'interface GigabitEthernet0/0.10\n'
          ' encapsulation dot1Q 10\n'
          ' ip address 192.168.10.1 255.255.255.0\n'
          '!\n'
          'interface GigabitEthernet0/0.20\n'
          ' encapsulation dot1Q 20\n'
          ' ip address 192.168.20.1 255.255.255.0',
      codeExampleEn:
          'interface GigabitEthernet0/0\n'
          ' no shutdown\n'
          '!\n'
          'interface GigabitEthernet0/0.10\n'
          ' encapsulation dot1Q 10\n'
          ' ip address 192.168.10.1 255.255.255.0\n'
          '!\n'
          'interface GigabitEthernet0/0.20\n'
          ' encapsulation dot1Q 20\n'
          ' ip address 192.168.20.1 255.255.255.0',
    ),
  ],
  keyPointsEs: [
    'La interfaz física no tiene dirección IP',
    'Sub-interfaces: interfaz.vlan-id (ej. G0/0.10)',
    'encapsulation dot1Q <vlan-id> es obligatorio',
    'Cada sub-interface = gateway predeterminado para su VLAN',
    'El puerto del switch debe configurarse como trunk',
  ],
  keyPointsEn: [
    'Physical interface has no IP address',
    'Sub-interfaces: interface.vlan-id (e.g. G0/0.10)',
    'encapsulation dot1Q <vlan-id> is mandatory',
    'Each sub-interface = default gateway for its VLAN',
    'Switch port must be configured as trunk',
  ],
);

const _staticRoutingLesson = NetworkLesson(
  titleEs: 'Rutas Estáticas',
  titleEn: 'Static Routing',
  icon: '🗺️',
  summaryEs:
      'Las rutas estáticas son rutas configuradas manualmente. '
      'Confiables, predecibles y sin sobrecarga — ideales para topologías simples.',
  summaryEn:
      'Static routes are manually configured paths. '
      'Reliable, predictable, and zero overhead — ideal for simple topologies.',
  sections: [
    LessonSection(
      headingEs: 'Sintaxis',
      headingEn: 'Syntax',
      contentEs:
          'ip route [red destino] [máscara] [next-hop | interfaz de salida] [DA]',
      contentEn:
          'ip route [destination network] [subnet mask] [next-hop | exit-interface] [AD]',
      codeExampleEs:
          '! Ruta hacia 10.0.0.0/8 via next-hop\n'
          'ip route 10.0.0.0 255.0.0.0 192.168.1.1\n'
          '!\n'
          '! Ruta por defecto (0.0.0.0/0)\n'
          'ip route 0.0.0.0 0.0.0.0 203.0.113.1\n'
          '!\n'
          '! Ruta flotante (DA=150, respaldo)\n'
          'ip route 10.0.0.0 255.0.0.0 192.168.2.1 150',
      codeExampleEn:
          '! Route to 10.0.0.0/8 via next-hop\n'
          'ip route 10.0.0.0 255.0.0.0 192.168.1.1\n'
          '!\n'
          '! Default route (0.0.0.0/0)\n'
          'ip route 0.0.0.0 0.0.0.0 203.0.113.1\n'
          '!\n'
          '! Floating static (AD=150, backup)\n'
          'ip route 10.0.0.0 255.0.0.0 192.168.2.1 150',
    ),
    LessonSection(
      headingEs: 'Distancia Administrativa',
      headingEn: 'Administrative Distance',
      contentEs:
          'La DA determina la preferencia de ruta cuando existen múltiples rutas:\n'
          '  Conectada   = 0\n'
          '  Estática    = 1\n'
          '  OSPF        = 110\n'
          '  RIP         = 120\n'
          'Menor DA = preferida. La ruta flotante usa una DA alta como respaldo.',
      contentEn:
          'AD determines route preference when multiple routes exist:\n'
          '  Connected   = 0\n'
          '  Static      = 1\n'
          '  OSPF        = 110\n'
          '  RIP         = 120\n'
          'Lower AD = preferred. Floating static uses high AD as backup.',
    ),
  ],
  keyPointsEs: [
    'Manual — no se adapta a cambios de topología',
    'Bajo overhead — sin tráfico de protocolo de ruteo',
    'Ruta por defecto: 0.0.0.0/0 coincide con todos los destinos',
    'Ruta flotante: mayor DA = solo como respaldo',
  ],
  keyPointsEn: [
    'Manual — does not adapt to topology changes',
    'Low overhead — no routing protocol traffic',
    'Default route: 0.0.0.0/0 matches all destinations',
    'Floating static: higher AD = backup only',
  ],
);

const _ripLesson = NetworkLesson(
  titleEs: 'RIP',
  titleEn: 'RIP',
  icon: '🔄',
  summaryEs:
      'Protocolo de Información de Ruteo — un protocolo de vector de distancia que usa '
      'el conteo de saltos como métrica. Simple pero limitado a 15 saltos.',
  summaryEn:
      'Routing Information Protocol — a distance-vector protocol that uses hop count '
      'as metric. Simple but limited to 15 hops.',
  sections: [
    LessonSection(
      headingEs: 'Operación RIP v2',
      headingEn: 'RIP v2 Operation',
      contentEs:
          '• Vector de distancia: comparte toda la tabla de ruteo con los vecinos\n'
          '• Métrica: conteo de saltos (máx 15; 16 = inalcanzable)\n'
          '• Intervalo de actualización: cada 30 segundos\n'
          '• Soporta VLSM (RIPv2) y autenticación',
      contentEn:
          '• Distance-vector: shares entire routing table with neighbors\n'
          '• Metric: hop count (max 15; 16 = unreachable)\n'
          '• Update interval: every 30 seconds\n'
          '• Supports VLSM (RIPv2) and authentication',
      codeExampleEs:
          'router rip\n'
          ' version 2\n'
          ' network 192.168.1.0\n'
          ' network 10.0.0.0\n'
          ' no auto-summary',
      codeExampleEn:
          'router rip\n'
          ' version 2\n'
          ' network 192.168.1.0\n'
          ' network 10.0.0.0\n'
          ' no auto-summary',
    ),
    LessonSection(
      headingEs: 'Limitaciones',
      headingEn: 'Limitations',
      contentEs:
          '• Máximo 15 saltos — no apto para redes grandes\n'
          '• Convergencia lenta (hasta 3 minutos)\n'
          '• Vulnerable a bucles de ruteo\n'
          '• No considera el ancho de banda (solo saltos)\n'
          'Usa OSPF para redes de producción.',
      contentEn:
          '• Max 15 hops — not suitable for large networks\n'
          '• Slow convergence (up to 3 minutes)\n'
          '• Vulnerable to routing loops\n'
          '• Not load-aware (hop count only)\n'
          'Use OSPF for production networks.',
    ),
  ],
  keyPointsEs: [
    'Protocolo de vector de distancia',
    'Métrica: conteo de saltos (máx 15)',
    'RIPv2 soporta VLSM; RIPv1 no',
    'Actualizaciones cada 30s — convergencia lenta',
    'No recomendado para redes grandes o modernas',
  ],
  keyPointsEn: [
    'Distance-vector protocol',
    'Metric: hop count (max 15)',
    'RIPv2 supports VLSM; RIPv1 does not',
    'Updates every 30s — slow convergence',
    'Not recommended for large/modern networks',
  ],
);

const _ospfLesson = NetworkLesson(
  titleEs: 'OSPF',
  titleEn: 'OSPF',
  icon: '🕸️',
  summaryEs:
      'Open Shortest Path First — un protocolo de estado de enlace que construye un mapa '
      'completo de la topología y usa el algoritmo SPF de Dijkstra para el ruteo óptimo.',
  summaryEn:
      'Open Shortest Path First — a link-state protocol that builds a complete '
      'topology map and uses Dijkstra\'s SPF algorithm for optimal routing.',
  sections: [
    LessonSection(
      headingEs: '¿Cómo funciona OSPF?',
      headingEn: 'How OSPF works',
      contentEs:
          '1. Los routers descubren vecinos mediante paquetes Hello\n'
          '2. Cada router inunda LSAs (Anuncios de Estado de Enlace)\n'
          '3. Todos los routers construyen una LSDB idéntica (base de datos de topología)\n'
          '4. Dijkstra calcula el camino más corto a cada red\n'
          '5. Las mejores rutas se instalan en la tabla de ruteo',
      contentEn:
          '1. Routers discover neighbors via Hello packets\n'
          '2. Each router floods LSAs (Link State Advertisements)\n'
          '3. All routers build an identical LSDB (topology database)\n'
          '4. Dijkstra calculates the shortest path to each network\n'
          '5. Best paths are installed in the routing table',
    ),
    LessonSection(
      headingEs: 'Configuración básica OSPF',
      headingEn: 'Basic OSPF Configuration',
      contentEs: 'OSPF de área única (Área 0 = backbone):',
      contentEn: 'Single-area OSPF (Area 0 = backbone):',
      codeExampleEs:
          'router ospf 1\n'
          ' router-id 1.1.1.1\n'
          ' network 192.168.1.0 0.0.0.255 area 0\n'
          ' network 10.0.0.0 0.0.0.3 area 0\n'
          ' passive-interface GigabitEthernet0/1',
      codeExampleEn:
          'router ospf 1\n'
          ' router-id 1.1.1.1\n'
          ' network 192.168.1.0 0.0.0.255 area 0\n'
          ' network 10.0.0.0 0.0.0.3 area 0\n'
          ' passive-interface GigabitEthernet0/1',
    ),
    LessonSection(
      headingEs: 'OSPF vs RIP',
      headingEn: 'OSPF vs RIP',
      contentEs:
          '• OSPF no tiene límite de saltos\n'
          '• Convergencia rápida (segundos vs. minutos)\n'
          '• Usa el ancho de banda como métrica (costo)\n'
          '• Diseño jerárquico con áreas\n'
          '• Estándar de la industria para redes empresariales',
      contentEn:
          '• OSPF has no hop-count limit\n'
          '• Fast convergence (seconds vs. minutes)\n'
          '• Uses bandwidth as metric (cost)\n'
          '• Hierarchical design with areas\n'
          '• Industry standard for enterprise networks',
    ),
  ],
  keyPointsEs: [
    'Protocolo de estado de enlace — visión completa de la topología',
    'Métrica: costo = 100Mbps / ancho de banda de interfaz',
    'Área 0 = backbone (obligatoria)',
    'Elección DR/BDR en redes de acceso múltiple',
    'Distancia administrativa = 110',
  ],
  keyPointsEn: [
    'Link-state protocol — complete topology view',
    'Metric: cost = 100Mbps / interface bandwidth',
    'Area 0 = backbone (required)',
    'DR/BDR election on multi-access networks',
    'Administrative distance = 110',
  ],
);

const _natLesson = NetworkLesson(
  titleEs: 'NAT',
  titleEn: 'NAT',
  icon: '🔄',
  summaryEs:
      'La Traducción de Direcciones de Red mapea IPs privadas a IPs públicas, '
      'permitiendo el acceso a internet desde el espacio de direcciones RFC 1918.',
  summaryEn:
      'Network Address Translation maps private IP addresses to public IPs, '
      'enabling internet access from RFC 1918 address space.',
  sections: [
    LessonSection(
      headingEs: 'Tipos de NAT',
      headingEn: 'NAT Types',
      contentEs:
          '• NAT Estático: una IP privada ↔ una IP pública (servidores, DMZ)\n'
          '• NAT Dinámico: pool de IPs públicas, por orden de llegada\n'
          '• PAT / Sobrecarga: muchas IPs privadas → una IP pública usando números de puerto\n'
          '  (El más común — acceso a internet en hogares y oficinas)',
      contentEn:
          '• Static NAT: one private ↔ one public (servers, DMZ)\n'
          '• Dynamic NAT: pool of public IPs, first-come first-served\n'
          '• PAT / Overload: many private → one public using port numbers\n'
          '  (Most common — home/office internet access)',
    ),
    LessonSection(
      headingEs: 'Configuración PAT',
      headingEn: 'PAT Configuration',
      contentEs: 'NAT más común — sobrecarga una IP pública:',
      contentEn: 'Most common NAT — overloads one public IP:',
      codeExampleEs:
          'interface GigabitEthernet0/0\n'
          ' ip nat inside\n'
          '!\n'
          'interface GigabitEthernet0/1\n'
          ' ip nat outside\n'
          '!\n'
          'access-list 1 permit 192.168.0.0 0.0.255.255\n'
          'ip nat inside source list 1 interface G0/1 overload',
      codeExampleEn:
          'interface GigabitEthernet0/0\n'
          ' ip nat inside\n'
          '!\n'
          'interface GigabitEthernet0/1\n'
          ' ip nat outside\n'
          '!\n'
          'access-list 1 permit 192.168.0.0 0.0.255.255\n'
          'ip nat inside source list 1 interface G0/1 overload',
    ),
  ],
  keyPointsEs: [
    'inside = interfaz LAN, outside = interfaz WAN',
    'PAT usa el puerto de origen para rastrear conexiones',
    'NAT Estático requiere una IP pública por host privado',
    'NAT oculta la topología interna de internet',
    'Las traducciones expiran tras un tiempo de inactividad',
  ],
  keyPointsEn: [
    'inside = LAN interface, outside = WAN interface',
    'PAT uses source port to track connections',
    'Static NAT requires one public IP per private host',
    'NAT hides internal topology from internet',
    'Translations expire after idle timeout',
  ],
);

const _aclLesson = NetworkLesson(
  titleEs: 'Listas de Control de Acceso',
  titleEn: 'Access Control Lists',
  icon: '🛡️',
  summaryEs:
      'Las ACLs filtran el tráfico de red según IP origen/destino, protocolo '
      'y puerto. Son la principal herramienta de filtrado de paquetes de Cisco.',
  summaryEn:
      'ACLs filter network traffic based on source/destination IP, protocol, '
      'and port. They are Cisco\'s primary packet filtering tool.',
  sections: [
    LessonSection(
      headingEs: 'Tipos de ACL',
      headingEn: 'ACL Types',
      contentEs:
          '• Estándar (1–99, 1300–1999): filtra solo por IP de ORIGEN\n'
          '  → Aplicar cerca del DESTINO\n\n'
          '• Extendida (100–199, 2000–2699): filtra por origen, destino, protocolo, puerto\n'
          '  → Aplicar cerca del ORIGEN',
      contentEn:
          '• Standard (1–99, 1300–1999): filter by SOURCE IP only\n'
          '  → Apply close to DESTINATION\n\n'
          '• Extended (100–199, 2000–2699): filter by source, destination, protocol, port\n'
          '  → Apply close to SOURCE',
    ),
    LessonSection(
      headingEs: 'Máscaras Wildcard',
      headingEn: 'Wildcard Masks',
      contentEs:
          'Las ACLs usan máscaras wildcard (inverso de la máscara de subred):\n'
          '  Máscara 255.255.255.0 → Wildcard 0.0.0.255\n'
          '  Coincidir un host específico: 0.0.0.0\n'
          '  Coincidir cualquier host: 255.255.255.255\n\n'
          'Abreviaciones: "host x.x.x.x" = "x.x.x.x 0.0.0.0"\n'
          '"any" = "0.0.0.0 255.255.255.255"',
      contentEn:
          'ACLs use wildcard masks (inverse of subnet mask):\n'
          '  255.255.255.0 mask → 0.0.0.255 wildcard\n'
          '  Match a single host: 0.0.0.0\n'
          '  Match any host: 255.255.255.255\n\n'
          'Shorthand: "host x.x.x.x" = "x.x.x.x 0.0.0.0"\n'
          '"any" = "0.0.0.0 255.255.255.255"',
    ),
    LessonSection(
      headingEs: 'Ejemplo ACL Extendida',
      headingEn: 'Extended ACL example',
      contentEs: 'Permitir solo HTTP desde Ventas (10.1.1.0/24) hacia el Servidor:',
      contentEn: 'Permit only HTTP from Sales (10.1.1.0/24) to Server:',
      codeExampleEs:
          'ip access-list extended VENTAS_A_SERVIDOR\n'
          ' permit tcp 10.1.1.0 0.0.0.255 host 10.2.2.100 eq 80\n'
          ' permit tcp 10.1.1.0 0.0.0.255 host 10.2.2.100 eq 443\n'
          ' deny ip any any\n'
          '!\n'
          'interface GigabitEthernet0/0\n'
          ' ip access-group VENTAS_A_SERVIDOR in',
      codeExampleEn:
          'ip access-list extended SALES_TO_SERVER\n'
          ' permit tcp 10.1.1.0 0.0.0.255 host 10.2.2.100 eq 80\n'
          ' permit tcp 10.1.1.0 0.0.0.255 host 10.2.2.100 eq 443\n'
          ' deny ip any any\n'
          '!\n'
          'interface GigabitEthernet0/0\n'
          ' ip access-group SALES_TO_SERVER in',
    ),
  ],
  keyPointsEs: [
    'Procesamiento de arriba a abajo — primera coincidencia gana',
    'Deny all implícito al final de cada ACL',
    'ACL Estándar: solo origen → cerca del destino',
    'ACL Extendida: origen+destino+puerto → cerca del origen',
    'Las ACLs nombradas permiten editar entradas individuales',
  ],
  keyPointsEn: [
    'Top-down processing — first match wins',
    'Implicit deny all at end of every ACL',
    'Standard ACL: source only → near destination',
    'Extended ACL: src+dst+port → near source',
    'Named ACLs allow editing individual entries',
  ],
);

const _ipv6Lesson = NetworkLesson(
  titleEs: 'Fundamentos IPv6',
  titleEn: 'IPv6 Fundamentals',
  icon: '🌐',
  summaryEs:
      'IPv6 usa direcciones de 128 bits (vs. 32 bits de IPv4), proporcionando un espacio '
      'de direcciones prácticamente ilimitado y eliminando la necesidad de NAT.',
  summaryEn:
      'IPv6 uses 128-bit addresses (vs. 32-bit IPv4), providing virtually '
      'unlimited address space and eliminating the need for NAT.',
  sections: [
    LessonSection(
      headingEs: 'Formato de Dirección',
      headingEn: 'Address Format',
      contentEs:
          '128 bits escritos como 8 grupos de 4 dígitos hexadecimales:\n'
          '  2001:0db8:0000:0001:0000:0000:0000:0001\n\n'
          'Reglas de compresión:\n'
          '  1. Eliminar ceros iniciales: 0db8 → db8\n'
          '  2. Reemplazar UNA cadena de grupos todo-cero con ::\n'
          '  Resultado: 2001:db8:0:1::1',
      contentEn:
          '128 bits written as 8 groups of 4 hex digits:\n'
          '  2001:0db8:0000:0001:0000:0000:0000:0001\n\n'
          'Compression rules:\n'
          '  1. Remove leading zeros: 0db8 → db8\n'
          '  2. Replace ONE run of all-zero groups with ::\n'
          '  Result: 2001:db8:0:1::1',
    ),
    LessonSection(
      headingEs: 'Tipos de Dirección',
      headingEn: 'Address Types',
      contentEs:
          '• Unicast Global (2000::/3) — enrutable en internet\n'
          '• Link-Local (fe80::/10) — auto-configurada, no enrutable\n'
          '• Local Única (fc00::/7) — privada (como RFC 1918)\n'
          '• Multicast (ff00::/8) — reemplaza el broadcast\n'
          '• Loopback: ::1',
      contentEn:
          '• Global Unicast (2000::/3) — routable on internet\n'
          '• Link-Local (fe80::/10) — auto-configured, non-routable\n'
          '• Unique Local (fc00::/7) — private (like RFC 1918)\n'
          '• Multicast (ff00::/8) — replaces broadcast\n'
          '• Loopback: ::1',
    ),
    LessonSection(
      headingEs: 'IPv6 en Cisco IOS',
      headingEn: 'IPv6 on Cisco IOS',
      contentEs: 'Habilitar ruteo IPv6 y asignar dirección:',
      contentEn: 'Enable IPv6 routing and assign address:',
      codeExampleEs:
          'ipv6 unicast-routing\n'
          '!\n'
          'interface GigabitEthernet0/0\n'
          ' ipv6 address 2001:db8:1::1/64\n'
          ' ipv6 address fe80::1 link-local\n'
          ' no shutdown',
      codeExampleEn:
          'ipv6 unicast-routing\n'
          '!\n'
          'interface GigabitEthernet0/0\n'
          ' ipv6 address 2001:db8:1::1/64\n'
          ' ipv6 address fe80::1 link-local\n'
          ' no shutdown',
    ),
  ],
  keyPointsEs: [
    'Direcciones de 128 bits — 3.4 × 10³⁸ en total',
    'Sin broadcast — usa multicast en su lugar',
    'Link-local auto-configurada en cada interfaz',
    'SLAAC permite configuración de dirección sin estado',
    'La longitud de prefijo usa notación / como CIDR en IPv4',
  ],
  keyPointsEn: [
    '128-bit addresses — 3.4 × 10³⁸ total',
    'No broadcast — uses multicast instead',
    'Link-local auto-configured on every interface',
    'SLAAC enables stateless address configuration',
    'Prefix length uses / notation like IPv4 CIDR',
  ],
);


const _osiLesson = NetworkLesson(
  titleEs: 'Modelo OSI — Las 7 Capas',
  titleEn: 'OSI Model — The 7 Layers',
  icon: '📶',
  summaryEs:
      'El modelo OSI (Open Systems Interconnection) divide la comunicación de red en '
      '7 capas independientes. Cada capa tiene una función específica y se comunica '
      'solo con las capas adyacentes.',
  summaryEn:
      'The OSI model divides network communication into 7 independent layers. '
      'Each layer has a specific function and communicates only with adjacent layers.',
  sections: [
    LessonSection(
      headingEs: 'Las 7 Capas (de abajo hacia arriba)',
      headingEn: 'The 7 Layers (bottom to top)',
      contentEs:
          '1️⃣  Física      — Bits eléctricos/ópticos, cables, conectores\n'
          '2️⃣  Enlace      — Tramas, MAC, switches, control de errores\n'
          '3️⃣  Red         — Paquetes, IP, routers, enrutamiento\n'
          '4️⃣  Transporte  — Segmentos, TCP/UDP, puertos, confiabilidad\n'
          '5️⃣  Sesión      — Sesiones, sincronización, NetBIOS\n'
          '6️⃣  Presentación— Cifrado, compresión, formato (SSL/TLS)\n'
          '7️⃣  Aplicación  — HTTP, FTP, DNS, SMTP — servicios de usuario',
      contentEn:
          '1️⃣  Physical      — Electrical/optical bits, cables, connectors\n'
          '2️⃣  Data Link     — Frames, MAC, switches, error control\n'
          '3️⃣  Network       — Packets, IP, routers, routing\n'
          '4️⃣  Transport     — Segments, TCP/UDP, ports, reliability\n'
          '5️⃣  Session       — Sessions, synchronization, NetBIOS\n'
          '6️⃣  Presentation  — Encryption, compression, format (SSL/TLS)\n'
          '7️⃣  Application   — HTTP, FTP, DNS, SMTP — user services',
    ),
    LessonSection(
      headingEs: 'Truco para recordar las capas',
      headingEn: 'Memory trick to remember the layers',
      contentEs:
          'De abajo hacia arriba (1→7):\n'
          '"Por Favor No Tires Sopa De Arroz"\n'
          'Física · Enlace · Red · Transporte · Sesión · Presentación · Aplicación\n\n'
          'De arriba hacia abajo (7→1):\n'
          '"All People Seem To Need Data Processing"\n'
          'Application · Presentation · Session · Transport · Network · Data Link · Physical',
      contentEn:
          'Bottom to top (1→7):\n'
          '"Please Do Not Throw Sausage Pizza Away"\n'
          'Physical · Data Link · Network · Transport · Session · Presentation · Application\n\n'
          'Top to bottom (7→1):\n'
          '"All People Seem To Need Data Processing"\n'
          'Application · Presentation · Session · Transport · Network · Data Link · Physical',
    ),
    LessonSection(
      headingEs: 'Unidades de datos por capa (PDU)',
      headingEn: 'Data units per layer (PDU)',
      contentEs:
          'Capa 7-5  → Datos (Data)\n'
          'Capa 4    → Segmento / Datagrama (TCP/UDP)\n'
          'Capa 3    → Paquete (IP)\n'
          'Capa 2    → Trama (Frame)\n'
          'Capa 1    → Bits\n\n'
          'Al enviar: encapsulación (agregar cabeceras capa por capa)\n'
          'Al recibir: desencapsulación (quitar cabeceras)',
      contentEn:
          'Layer 7-5  → Data\n'
          'Layer 4    → Segment / Datagram (TCP/UDP)\n'
          'Layer 3    → Packet (IP)\n'
          'Layer 2    → Frame\n'
          'Layer 1    → Bits\n\n'
          'Sending: encapsulation (add headers layer by layer)\n'
          'Receiving: decapsulation (strip headers)',
    ),
    LessonSection(
      headingEs: 'Dispositivos por capa',
      headingEn: 'Devices per layer',
      contentEs:
          'Capa 1 — Hub, repetidor, cable UTP/fibra\n'
          'Capa 2 — Switch, bridge, tarjeta de red (NIC)\n'
          'Capa 3 — Router, switch L3, firewall\n'
          'Capa 4 — Firewall stateful, balanceador de carga\n'
          'Capa 7 — Proxy, WAF, servidor de aplicaciones',
      contentEn:
          'Layer 1 — Hub, repeater, UTP/fiber cable\n'
          'Layer 2 — Switch, bridge, NIC\n'
          'Layer 3 — Router, L3 switch, firewall\n'
          'Layer 4 — Stateful firewall, load balancer\n'
          'Layer 7 — Proxy, WAF, application server',
    ),
  ],
  keyPointsEs: [
    'El modelo OSI es de referencia — TCP/IP es el modelo real de Internet',
    'Capa 2 usa MAC (48 bits), Capa 3 usa IP (32/128 bits)',
    'TCP (Capa 4) = confiable con acuse de recibo; UDP = rápido sin garantía',
    'Encapsulación: cada capa agrega su cabecera al bajar',
    'Los switches operan en Capa 2; los routers en Capa 3',
    'SSL/TLS opera en Capa 6 (Presentación)',
  ],
  keyPointsEn: [
    'OSI is a reference model — TCP/IP is the real Internet model',
    'Layer 2 uses MAC (48-bit); Layer 3 uses IP (32/128-bit)',
    'TCP (Layer 4) = reliable with acknowledgement; UDP = fast without guarantee',
    'Encapsulation: each layer adds its header going down',
    'Switches operate at Layer 2; routers at Layer 3',
    'SSL/TLS operates at Layer 6 (Presentation)',
  ],
);

const _interfacesLesson = NetworkLesson(
  titleEs: 'Interfaces Cisco — FastEthernet, GigabitEthernet y Serial',
  titleEn: 'Cisco Interfaces — FastEthernet, GigabitEthernet & Serial',
  icon: '🔌',
  summaryEs:
      'Las interfaces físicas de un router o switch Cisco definen cómo se conecta '
      'el dispositivo a la red. Conocer sus diferencias, velocidades y usos es '
      'fundamental para configurarlas correctamente.',
  summaryEn:
      'Physical interfaces on a Cisco router or switch define how the device connects '
      'to the network. Understanding their differences, speeds, and uses is essential '
      'for correct configuration.',
  sections: [
    LessonSection(
      headingEs: 'FastEthernet (Fa) — 100 Mbps',
      headingEn: 'FastEthernet (Fa) — 100 Mbps',
      contentEs:
          'Velocidad: 100 Mbps — estándar IEEE 802.3u\n'
          'Notación: FastEthernet0/0, Fa0/0, F0/0\n'
          'Conector: RJ-45 (UTP Cat5 o superior)\n\n'
          'Usos típicos:\n'
          '  • Conexión de PCs y equipos de oficina\n'
          '  • Puertos de acceso en switches más antiguos\n'
          '  • Routers de gama baja (Cisco 1841, 2600)\n\n'
          'Ya está siendo reemplazado por GigabitEthernet en equipos modernos.',
      contentEn:
          'Speed: 100 Mbps — IEEE 802.3u standard\n'
          'Notation: FastEthernet0/0, Fa0/0, F0/0\n'
          'Connector: RJ-45 (UTP Cat5 or higher)\n\n'
          'Typical uses:\n'
          '  • PC and office equipment connections\n'
          '  • Access ports on older switches\n'
          '  • Low-end routers (Cisco 1841, 2600)\n\n'
          'Being replaced by GigabitEthernet on modern equipment.',
      codeExampleEs:
          'interface FastEthernet0/0\n'
          ' ip address 192.168.1.1 255.255.255.0\n'
          ' duplex auto\n'
          ' speed auto\n'
          ' no shutdown',
      codeExampleEn:
          'interface FastEthernet0/0\n'
          ' ip address 192.168.1.1 255.255.255.0\n'
          ' duplex auto\n'
          ' speed auto\n'
          ' no shutdown',
    ),
    LessonSection(
      headingEs: 'GigabitEthernet (Gi/G) — 1 Gbps',
      headingEn: 'GigabitEthernet (Gi/G) — 1 Gbps',
      contentEs:
          'Velocidad: 1 Gbps (1000 Mbps) — estándar IEEE 802.3z/ab\n'
          'Notación: GigabitEthernet0/0, Gi0/0, G0/0\n'
          'Conectores: RJ-45 (UTP Cat5e/6) o SFP (fibra/cobre)\n\n'
          'Usos típicos:\n'
          '  • Uplinks entre switches (troncales)\n'
          '  • Conexión router-switch principal\n'
          '  • Servidores y equipos de alto rendimiento\n'
          '  • Routers ISR 1000, ISR 4000, Catalyst 9000\n\n'
          'Es el estándar actual en redes empresariales.',
      contentEn:
          'Speed: 1 Gbps (1000 Mbps) — IEEE 802.3z/ab standard\n'
          'Notation: GigabitEthernet0/0, Gi0/0, G0/0\n'
          'Connectors: RJ-45 (UTP Cat5e/6) or SFP (fiber/copper)\n\n'
          'Typical uses:\n'
          '  • Switch-to-switch uplinks (trunks)\n'
          '  • Main router-switch connection\n'
          '  • Servers and high-performance devices\n'
          '  • ISR 1000, ISR 4000, Catalyst 9000 routers\n\n'
          'Current standard in enterprise networks.',
      codeExampleEs:
          'interface GigabitEthernet0/0\n'
          ' description WAN-Link-ISP\n'
          ' ip address 203.0.113.1 255.255.255.252\n'
          ' no shutdown\n'
          '!\n'
          'interface GigabitEthernet0/1\n'
          ' description LAN-Principal\n'
          ' ip address 192.168.1.1 255.255.255.0\n'
          ' no shutdown',
      codeExampleEn:
          'interface GigabitEthernet0/0\n'
          ' description WAN-Link-ISP\n'
          ' ip address 203.0.113.1 255.255.255.252\n'
          ' no shutdown\n'
          '!\n'
          'interface GigabitEthernet0/1\n'
          ' description LAN-Main\n'
          ' ip address 192.168.1.1 255.255.255.0\n'
          ' no shutdown',
    ),
    LessonSection(
      headingEs: 'Serial (Se/S) — WAN punto a punto',
      headingEn: 'Serial (Se/S) — Point-to-point WAN',
      contentEs:
          'Velocidad: variable (T1=1.544 Mbps, E1=2.048 Mbps, hasta 8 Mbps)\n'
          'Notación: Serial0/0/0, Se0/0/0, S0/0/0\n'
          'Conector: DB-60 o Smart Serial — cable DTE/DCE\n\n'
          'Conceptos clave:\n'
          '  • DTE (Data Terminal Equipment): router del cliente\n'
          '  • DCE (Data Circuit Equipment): router que provee el clock\n'
          '  • clock rate: debe configurarse en el lado DCE\n\n'
          'Usos típicos:\n'
          '  • Conexiones WAN heredadas (Frame Relay, PPP, HDLC)\n'
          '  • Laboratorios GNS3/Packet Tracer para simular WAN\n'
          '  • Reemplazado en producción por fibra Ethernet/MPLS',
      contentEn:
          'Speed: variable (T1=1.544 Mbps, E1=2.048 Mbps, up to 8 Mbps)\n'
          'Notation: Serial0/0/0, Se0/0/0, S0/0/0\n'
          'Connector: DB-60 or Smart Serial — DTE/DCE cable\n\n'
          'Key concepts:\n'
          '  • DTE (Data Terminal Equipment): customer router\n'
          '  • DCE (Data Circuit Equipment): router that provides the clock\n'
          '  • clock rate: must be configured on the DCE side\n\n'
          'Typical uses:\n'
          '  • Legacy WAN connections (Frame Relay, PPP, HDLC)\n'
          '  • GNS3/Packet Tracer labs to simulate WAN links\n'
          '  • Replaced in production by fiber Ethernet/MPLS',
      codeExampleEs:
          '! Lado DCE (provee clock)\n'
          'interface Serial0/0/0\n'
          ' ip address 10.0.0.1 255.255.255.252\n'
          ' clock rate 64000\n'
          ' encapsulation ppp\n'
          ' no shutdown\n'
          '!\n'
          '! Lado DTE (cliente)\n'
          'interface Serial0/0/0\n'
          ' ip address 10.0.0.2 255.255.255.252\n'
          ' encapsulation ppp\n'
          ' no shutdown',
      codeExampleEn:
          '! DCE side (provides clock)\n'
          'interface Serial0/0/0\n'
          ' ip address 10.0.0.1 255.255.255.252\n'
          ' clock rate 64000\n'
          ' encapsulation ppp\n'
          ' no shutdown\n'
          '!\n'
          '! DTE side (customer)\n'
          'interface Serial0/0/0\n'
          ' ip address 10.0.0.2 255.255.255.252\n'
          ' encapsulation ppp\n'
          ' no shutdown',
    ),
    LessonSection(
      headingEs: 'Comparación y comandos útiles',
      headingEn: 'Comparison and useful commands',
      contentEs:
          'Interfaz       Velocidad    Capa   Uso\n'
          'FastEthernet   100 Mbps     2/3    LAN legacy\n'
          'GigabitEthernet 1 Gbps      2/3    LAN/WAN actual\n'
          'Serial         ≤2 Mbps      2/3    WAN legado\n\n'
          'Verificar interfaces:\n'
          '  show interfaces — estado detallado\n'
          '  show ip interface brief — resumen rápido\n'
          '  show controllers Serial0/0/0 — ver si es DTE o DCE',
      contentEn:
          'Interface        Speed      Layer   Use\n'
          'FastEthernet     100 Mbps   2/3     Legacy LAN\n'
          'GigabitEthernet  1 Gbps     2/3     Current LAN/WAN\n'
          'Serial           ≤2 Mbps    2/3     Legacy WAN\n\n'
          'Verify interfaces:\n'
          '  show interfaces — detailed status\n'
          '  show ip interface brief — quick summary\n'
          '  show controllers Serial0/0/0 — check DTE or DCE',
    ),
  ],
  keyPointsEs: [
    'FastEthernet = 100 Mbps, GigabitEthernet = 1 Gbps',
    'Serial necesita clock rate en el lado DCE',
    'GigabitEthernet es el estándar actual de redes empresariales',
    'show ip interface brief: ver todas las interfaces y su estado',
    'no shutdown: activa la interfaz (por defecto están apagadas)',
    'description: etiqueta la interfaz para documentación',
  ],
  keyPointsEn: [
    'FastEthernet = 100 Mbps, GigabitEthernet = 1 Gbps',
    'Serial needs clock rate on the DCE side',
    'GigabitEthernet is the current enterprise networking standard',
    'show ip interface brief: see all interfaces and their status',
    'no shutdown: activates the interface (off by default)',
    'description: labels the interface for documentation',
  ],
  ciscoConceptEs:
      'show ip interface brief\n'
      '! Muestra todas las interfaces: nombre, IP, estado\n'
      '!\n'
      'show interfaces GigabitEthernet0/0\n'
      '! Estadísticas detalladas: errores, velocidad, MTU',
  ciscoConceptEn:
      'show ip interface brief\n'
      '! Shows all interfaces: name, IP, status\n'
      '!\n'
      'show interfaces GigabitEthernet0/0\n'
      '! Detailed stats: errors, speed, MTU',
);

// ─── Extended lessons (v2) ────────────────────────────────────────────────────

extension ExplanationEngineV2 on ExplanationEngine {
  static const Map<String, NetworkLesson> extraLessons = {
    'stp': _stpLesson,
    'dhcp': _dhcpLesson,
    'etherchannel': _etherchannelLesson,
    'ssh_hardening': _sshLesson,
    'cdp_lldp': _cdpLesson,
  };
}

const _stpLesson = NetworkLesson(
  titleEs: 'Spanning Tree Protocol (STP)',
  titleEn: 'Spanning Tree Protocol (STP)',
  icon: '🌳',
  summaryEs:
      'STP previene bucles de switching eligiendo un Root Bridge y bloqueando '
      'puertos redundantes. IEEE 802.1D (STP) y 802.1W (RSTP).',
  summaryEn:
      'STP prevents switching loops by electing a Root Bridge and blocking '
      'redundant ports. IEEE 802.1D (STP) and 802.1W (RSTP).',
  sections: [
    LessonSection(
      headingEs: '¿Por qué STP?',
      headingEn: 'Why STP?',
      contentEs:
          'Sin STP, los switches inundan tramas broadcast en bucle infinito '
          '(tormenta de broadcast), saturando la red en segundos.\n\n'
          'STP bloquea lógicamente los enlaces redundantes, manteniéndolos '
          'como respaldo sin formar bucles.',
      contentEn:
          'Without STP, switches flood broadcast frames in an infinite loop '
          '(broadcast storm), saturating the network in seconds.\n\n'
          'STP logically blocks redundant links, keeping them as standby '
          'without forming loops.',
    ),
    LessonSection(
      headingEs: 'Proceso de elección',
      headingEn: 'Election Process',
      contentEs:
          '1. Se elige un Root Bridge (switch con menor Bridge ID = prioridad + MAC)\n'
          '2. Cada switch calcula el camino de menor costo hacia el Root\n'
          '3. Los puertos redundantes quedan en estado Blocking\n'
          '4. Si el enlace activo falla → el puerto Blocking pasa a Forwarding',
      contentEn:
          '1. A Root Bridge is elected (switch with lowest Bridge ID = priority + MAC)\n'
          '2. Each switch calculates the lowest-cost path to the Root\n'
          '3. Redundant ports remain in Blocking state\n'
          '4. If the active link fails → the Blocking port transitions to Forwarding',
    ),
    LessonSection(
      headingEs: 'Configuración Cisco',
      headingEn: 'Cisco Configuration',
      contentEs: 'Forzar un switch como Root Bridge:',
      contentEn: 'Force a switch as Root Bridge:',
      codeExampleEs:
          '! Prioridad por defecto: 32768 (menor = Root)\n'
          'spanning-tree vlan 10 priority 4096\n'
          '!\n'
          '! O usar el comando automático:\n'
          'spanning-tree vlan 10 root primary\n'
          'spanning-tree vlan 20 root secondary\n'
          '!\n'
          '! Ver estado STP:\n'
          'show spanning-tree vlan 10',
      codeExampleEn:
          '! Default priority: 32768 (lower = Root)\n'
          'spanning-tree vlan 10 priority 4096\n'
          '!\n'
          '! Or use the automatic command:\n'
          'spanning-tree vlan 10 root primary\n'
          'spanning-tree vlan 20 root secondary\n'
          '!\n'
          '! Check STP status:\n'
          'show spanning-tree vlan 10',
    ),
    LessonSection(
      headingEs: 'RSTP (802.1W) — Rapid STP',
      headingEn: 'RSTP (802.1W) — Rapid STP',
      contentEs:
          'RSTP converge en 1-2 segundos vs. 30-50 segundos de STP clásico.\n'
          'Cisco usa PVST+ (Per-VLAN STP) o Rapid PVST+ por defecto.\n\n'
          'PortFast: salta estados STP en puertos de acceso (PCs), activado con:\n'
          'spanning-tree portfast (en la interfaz de acceso)',
      contentEn:
          'RSTP converges in 1-2 seconds vs. 30-50 seconds for classic STP.\n'
          'Cisco uses PVST+ (Per-VLAN STP) or Rapid PVST+ by default.\n\n'
          'PortFast: skips STP states on access ports (PCs), enabled with:\n'
          'spanning-tree portfast (on the access interface)',
    ),
  ],
  keyPointsEs: [
    'Root Bridge: switch con menor Bridge ID (prioridad+MAC)',
    'Costo de puerto: basado en velocidad del enlace',
    'Estados STP: Blocking → Listening → Learning → Forwarding',
    'RSTP (802.1W): convergencia en segundos',
    'PortFast: para puertos de acceso, evita delay de 30s',
    'BPDU Guard: bloquea si recibe BPDU en puerto PortFast',
  ],
  keyPointsEn: [
    'Root Bridge: switch with lowest Bridge ID (priority+MAC)',
    'Port cost: based on link speed',
    'STP states: Blocking → Listening → Learning → Forwarding',
    'RSTP (802.1W): convergence in seconds',
    'PortFast: for access ports, avoids 30s delay',
    'BPDU Guard: shuts down port if BPDU received on PortFast port',
  ],
);

const _dhcpLesson = NetworkLesson(
  titleEs: 'DHCP',
  titleEn: 'DHCP',
  icon: '📋',
  summaryEs:
      'DHCP asigna automáticamente IPs, máscara, gateway y DNS a los clientes. '
      'Cisco IOS puede actuar como servidor DHCP.',
  summaryEn:
      'DHCP automatically assigns IPs, subnet mask, gateway, and DNS to clients. '
      'Cisco IOS can act as a DHCP server.',
  sections: [
    LessonSection(
      headingEs: 'Proceso DORA',
      headingEn: 'DORA Process',
      contentEs:
          'D — Discover: cliente broadcast buscando servidor DHCP\n'
          'O — Offer: servidor ofrece una IP disponible\n'
          'R — Request: cliente solicita la IP ofrecida\n'
          'A — Acknowledge: servidor confirma la asignación\n\n'
          'La IP se asigna por un tiempo (lease time), renovable.',
      contentEn:
          'D — Discover: client broadcasts searching for a DHCP server\n'
          'O — Offer: server offers an available IP\n'
          'R — Request: client requests the offered IP\n'
          'A — Acknowledge: server confirms the assignment\n\n'
          'The IP is assigned for a period (lease time), renewable.',
    ),
    LessonSection(
      headingEs: 'Servidor DHCP en Cisco IOS',
      headingEn: 'DHCP Server on Cisco IOS',
      contentEs: 'Configurar un router como servidor DHCP:',
      contentEn: 'Configure a router as a DHCP server:',
      codeExampleEs:
          '! Excluir IPs reservadas (gateways, servidores)\n'
          'ip dhcp excluded-address 192.168.10.1 192.168.10.10\n'
          '!\n'
          '! Crear pool\n'
          'ip dhcp pool LAN_VENTAS\n'
          ' network 192.168.10.0 255.255.255.0\n'
          ' default-router 192.168.10.1\n'
          ' dns-server 8.8.8.8 8.8.4.4\n'
          ' lease 7\n'
          '!\n'
          '! Verificar asignaciones\n'
          'show ip dhcp binding\n'
          'show ip dhcp pool',
      codeExampleEn:
          '! Exclude reserved IPs (gateways, servers)\n'
          'ip dhcp excluded-address 192.168.10.1 192.168.10.10\n'
          '!\n'
          '! Create pool\n'
          'ip dhcp pool LAN_SALES\n'
          ' network 192.168.10.0 255.255.255.0\n'
          ' default-router 192.168.10.1\n'
          ' dns-server 8.8.8.8 8.8.4.4\n'
          ' lease 7\n'
          '!\n'
          '! Verify assignments\n'
          'show ip dhcp binding\n'
          'show ip dhcp pool',
    ),
    LessonSection(
      headingEs: 'DHCP Relay (ip helper-address)',
      headingEn: 'DHCP Relay (ip helper-address)',
      contentEs:
          'DHCP es broadcast — no pasa por routers. '
          'El comando ip helper-address reenvía los broadcasts DHCP '
          'como unicast hacia el servidor real.',
      contentEn:
          'DHCP is broadcast-based — it does not cross routers. '
          'The ip helper-address command forwards DHCP broadcasts '
          'as unicast to the actual server.',
      codeExampleEs:
          'interface GigabitEthernet0/0\n'
          ' ip helper-address 10.0.0.100\n'
          ' ! (10.0.0.100 = servidor DHCP centralizado)',
      codeExampleEn:
          'interface GigabitEthernet0/0\n'
          ' ip helper-address 10.0.0.100\n'
          ' ! (10.0.0.100 = centralized DHCP server)',
    ),
  ],
  keyPointsEs: [
    'DORA: Discover → Offer → Request → Acknowledge',
    'excluded-address: reservar IPs antes del pool',
    'lease: tiempo de vigencia de la IP (días)',
    'ip helper-address: relay para redes con router entre cliente y servidor',
    'show ip dhcp binding: ver todas las IPs asignadas',
  ],
  keyPointsEn: [
    'DORA: Discover → Offer → Request → Acknowledge',
    'excluded-address: reserve IPs before the pool',
    'lease: IP validity period (days)',
    'ip helper-address: relay for networks with a router between client and server',
    'show ip dhcp binding: see all assigned IPs',
  ],
  ciscoConceptEs:
      'ip dhcp excluded-address 192.168.1.1 192.168.1.10\n'
      'ip dhcp pool LAN\n'
      ' network 192.168.1.0 255.255.255.0\n'
      ' default-router 192.168.1.1\n'
      ' dns-server 8.8.8.8',
  ciscoConceptEn:
      'ip dhcp excluded-address 192.168.1.1 192.168.1.10\n'
      'ip dhcp pool LAN\n'
      ' network 192.168.1.0 255.255.255.0\n'
      ' default-router 192.168.1.1\n'
      ' dns-server 8.8.8.8',
);

const _etherchannelLesson = NetworkLesson(
  titleEs: 'EtherChannel (LACP)',
  titleEn: 'EtherChannel (LACP)',
  icon: '⚡',
  summaryEs:
      'EtherChannel agrupa múltiples enlaces físicos en uno lógico, '
      'multiplicando el ancho de banda y proporcionando redundancia.',
  summaryEn:
      'EtherChannel bundles multiple physical links into one logical link, '
      'multiplying bandwidth and providing redundancy.',
  sections: [
    LessonSection(
      headingEs: '¿Qué es EtherChannel?',
      headingEn: 'What is EtherChannel?',
      contentEs:
          'Agrupa 2, 4 u 8 interfaces en un port-channel lógico.\n\n'
          '• Ancho de banda: 2×1Gbps = 2Gbps efectivos\n'
          '• Redundancia: si cae un enlace, los demás siguen activos\n'
          '• STP ve el bundle como un solo enlace (no bloquea)\n'
          '• Balanceo de carga automático entre los enlaces',
      contentEn:
          'Groups 2, 4, or 8 interfaces into one logical port-channel.\n\n'
          '• Bandwidth: 2×1Gbps = 2Gbps effective\n'
          '• Redundancy: if one link fails, the rest remain active\n'
          '• STP sees the bundle as a single link (no blocking)\n'
          '• Automatic load balancing across links',
    ),
    LessonSection(
      headingEs: 'Protocolos de negociación',
      headingEn: 'Negotiation Protocols',
      contentEs:
          '• LACP (802.3ad): estándar IEEE, interoperable — modo active/passive\n'
          '• PAgP: protocolo Cisco propietario — modo desirable/auto\n'
          '• Static (on): sin negociación — ambos lados deben ser "on"\n\n'
          'Recomendado: LACP active en ambos lados.',
      contentEn:
          '• LACP (802.3ad): IEEE standard, interoperable — active/passive mode\n'
          '• PAgP: Cisco proprietary protocol — desirable/auto mode\n'
          '• Static (on): no negotiation — both sides must be "on"\n\n'
          'Recommended: LACP active on both sides.',
    ),
    LessonSection(
      headingEs: 'Configuración LACP',
      headingEn: 'LACP Configuration',
      contentEs: 'Agrupar Gi0/1 y Gi0/2 en port-channel 1:',
      contentEn: 'Bundle Gi0/1 and Gi0/2 into port-channel 1:',
      codeExampleEs:
          'interface range GigabitEthernet0/1 - 2\n'
          ' channel-group 1 mode active\n'
          ' ! (active = LACP activo)\n'
          '!\n'
          'interface Port-channel1\n'
          ' switchport mode trunk\n'
          ' switchport trunk encapsulation dot1q\n'
          '!\n'
          'show etherchannel summary',
      codeExampleEn:
          'interface range GigabitEthernet0/1 - 2\n'
          ' channel-group 1 mode active\n'
          ' ! (active = LACP active)\n'
          '!\n'
          'interface Port-channel1\n'
          ' switchport mode trunk\n'
          ' switchport trunk encapsulation dot1q\n'
          '!\n'
          'show etherchannel summary',
    ),
  ],
  keyPointsEs: [
    'Máximo 8 interfaces por EtherChannel',
    'Todas las interfaces deben tener misma velocidad, dúplex y VLAN',
    'LACP: estándar IEEE — recomendado para interoperabilidad',
    'Port-channel aparece como una sola interfaz lógica',
    'STP trata el bundle como un enlace → no bloquea',
    'Balanceo: src-mac, dst-mac, src-dst-ip (configurable)',
  ],
  keyPointsEn: [
    'Maximum 8 interfaces per EtherChannel',
    'All interfaces must match in speed, duplex, and VLAN',
    'LACP: IEEE standard — recommended for interoperability',
    'Port-channel appears as a single logical interface',
    'STP treats the bundle as one link → no blocking',
    'Load balancing: src-mac, dst-mac, src-dst-ip (configurable)',
  ],
);

const _sshLesson = NetworkLesson(
  titleEs: 'SSH & Hardening',
  titleEn: 'SSH & Hardening',
  icon: '🔐',
  summaryEs:
      'Asegurar acceso remoto a dispositivos Cisco usando SSH v2, '
      'deshabilitar Telnet y aplicar mejores prácticas de seguridad.',
  summaryEn:
      'Secure remote access to Cisco devices using SSH v2, '
      'disable Telnet, and apply security best practices.',
  sections: [
    LessonSection(
      headingEs: '¿Por qué SSH y no Telnet?',
      headingEn: 'Why SSH and not Telnet?',
      contentEs:
          'Telnet transmite en texto plano — contraseñas visibles en capturas.\n'
          'SSH cifra toda la sesión con criptografía asimétrica.\n\n'
          'SSH v2 es más seguro que v1 — siempre usa v2.',
      contentEn:
          'Telnet transmits in plain text — passwords visible in packet captures.\n'
          'SSH encrypts the entire session with asymmetric cryptography.\n\n'
          'SSH v2 is more secure than v1 — always use v2.',
    ),
    LessonSection(
      headingEs: 'Configuración SSH completa',
      headingEn: 'Complete SSH Configuration',
      contentEs: 'Pasos para activar SSH en un router/switch Cisco:',
      contentEn: 'Steps to enable SSH on a Cisco router/switch:',
      codeExampleEs:
          'hostname R1\n'
          'ip domain-name empresa.local\n'
          '!\n'
          '! Generar clave RSA (mínimo 2048 bits)\n'
          'crypto key generate rsa modulus 2048\n'
          'ip ssh version 2\n'
          'ip ssh time-out 60\n'
          'ip ssh authentication-retries 3\n'
          '!\n'
          '! Crear usuario local\n'
          'username admin privilege 15 secret Cisco@2024\n'
          '!\n'
          '! Configurar líneas VTY\n'
          'line vty 0 4\n'
          ' login local\n'
          ' transport input ssh\n'
          ' exec-timeout 10 0\n'
          '!\n'
          '! Verificar\n'
          'show ip ssh\n'
          'show ssh',
      codeExampleEn:
          'hostname R1\n'
          'ip domain-name company.local\n'
          '!\n'
          '! Generate RSA key (minimum 2048 bits)\n'
          'crypto key generate rsa modulus 2048\n'
          'ip ssh version 2\n'
          'ip ssh time-out 60\n'
          'ip ssh authentication-retries 3\n'
          '!\n'
          '! Create local user\n'
          'username admin privilege 15 secret Cisco@2024\n'
          '!\n'
          '! Configure VTY lines\n'
          'line vty 0 4\n'
          ' login local\n'
          ' transport input ssh\n'
          ' exec-timeout 10 0\n'
          '!\n'
          '! Verify\n'
          'show ip ssh\n'
          'show ssh',
    ),
    LessonSection(
      headingEs: 'Hardening adicional',
      headingEn: 'Additional Hardening',
      contentEs: 'Buenas prácticas de seguridad en dispositivos Cisco:',
      contentEn: 'Security best practices on Cisco devices:',
      codeExampleEs:
          '! Deshabilitar servicios innecesarios\n'
          'no ip http server\n'
          'no ip http secure-server\n'
          'no cdp run\n'
          'no ip source-route\n'
          '!\n'
          '! Proteger puerto consola\n'
          'line con 0\n'
          ' password Cisco@Con\n'
          ' login\n'
          ' exec-timeout 5 0\n'
          ' logging synchronous\n'
          '!\n'
          '! Banner de advertencia\n'
          'banner motd ^Acceso solo personal autorizado^',
      codeExampleEn:
          '! Disable unnecessary services\n'
          'no ip http server\n'
          'no ip http secure-server\n'
          'no cdp run\n'
          'no ip source-route\n'
          '!\n'
          '! Protect console port\n'
          'line con 0\n'
          ' password Cisco@Con\n'
          ' login\n'
          ' exec-timeout 5 0\n'
          ' logging synchronous\n'
          '!\n'
          '! Warning banner\n'
          'banner motd ^Authorized personnel only^',
    ),
  ],
  keyPointsEs: [
    'SSH v2: cifrado fuerte — nunca usar Telnet en producción',
    'crypto key generate rsa modulus 2048 (mínimo)',
    'transport input ssh: deshabilita Telnet en VTY',
    'login local: autenticación con usuario local',
    'exec-timeout: cierra sesión inactiva automáticamente',
    'privilege 15: acceso completo (usar con cuidado)',
  ],
  keyPointsEn: [
    'SSH v2: strong encryption — never use Telnet in production',
    'crypto key generate rsa modulus 2048 (minimum)',
    'transport input ssh: disables Telnet on VTY lines',
    'login local: authentication with local user database',
    'exec-timeout: automatically closes inactive sessions',
    'privilege 15: full access (use with caution)',
  ],
);

const _cdpLesson = NetworkLesson(
  titleEs: 'CDP y LLDP',
  titleEn: 'CDP and LLDP',
  icon: '🔍',
  summaryEs:
      'CDP (Cisco Discovery Protocol) y LLDP (IEEE 802.1AB) descubren '
      'automáticamente dispositivos vecinos en la red.',
  summaryEn:
      'CDP (Cisco Discovery Protocol) and LLDP (IEEE 802.1AB) automatically '
      'discover neighboring devices on the network.',
  sections: [
    LessonSection(
      headingEs: 'CDP — Cisco Discovery Protocol',
      headingEn: 'CDP — Cisco Discovery Protocol',
      contentEs:
          'CDP es propietario de Cisco. Activo por defecto en todos los dispositivos Cisco.\n'
          'Envía anuncios cada 60 segundos con información del dispositivo:\n'
          '• Hostname, modelo, versión IOS\n'
          '• Dirección IP de gestión\n'
          '• Interfaz local y remota del enlace\n'
          '• Capacidades (router, switch, teléfono IP)',
      contentEn:
          'CDP is Cisco proprietary. Active by default on all Cisco devices.\n'
          'Sends announcements every 60 seconds with device information:\n'
          '• Hostname, model, IOS version\n'
          '• Management IP address\n'
          '• Local and remote link interface\n'
          '• Capabilities (router, switch, IP phone)',
      codeExampleEs:
          '! Ver vecinos CDP\n'
          'show cdp neighbors\n'
          'show cdp neighbors detail\n'
          '!\n'
          '! Deshabilitar CDP globalmente (seguridad)\n'
          'no cdp run\n'
          '!\n'
          '! Deshabilitar solo en interfaz exterior\n'
          'interface GigabitEthernet0/1\n'
          ' no cdp enable',
      codeExampleEn:
          '! View CDP neighbors\n'
          'show cdp neighbors\n'
          'show cdp neighbors detail\n'
          '!\n'
          '! Disable CDP globally (security)\n'
          'no cdp run\n'
          '!\n'
          '! Disable only on external interface\n'
          'interface GigabitEthernet0/1\n'
          ' no cdp enable',
    ),
    LessonSection(
      headingEs: 'LLDP — IEEE 802.1AB',
      headingEn: 'LLDP — IEEE 802.1AB',
      contentEs:
          'LLDP es el estándar abierto equivalente a CDP.\n'
          'Funciona con dispositivos de cualquier fabricante.\n\n'
          'Desactivado por defecto en Cisco — debe activarse manualmente.',
      contentEn:
          'LLDP is the open standard equivalent of CDP.\n'
          'Works with devices from any manufacturer.\n\n'
          'Disabled by default on Cisco — must be enabled manually.',
      codeExampleEs:
          '! Activar LLDP globalmente\n'
          'lldp run\n'
          '!\n'
          '! Activar por interfaz\n'
          'interface GigabitEthernet0/0\n'
          ' lldp transmit\n'
          ' lldp receive\n'
          '!\n'
          '! Ver vecinos LLDP\n'
          'show lldp neighbors\n'
          'show lldp neighbors detail',
      codeExampleEn:
          '! Enable LLDP globally\n'
          'lldp run\n'
          '!\n'
          '! Enable per interface\n'
          'interface GigabitEthernet0/0\n'
          ' lldp transmit\n'
          ' lldp receive\n'
          '!\n'
          '! View LLDP neighbors\n'
          'show lldp neighbors\n'
          'show lldp neighbors detail',
    ),
  ],
  keyPointsEs: [
    'CDP: propietario Cisco, activo por defecto',
    'LLDP: estándar IEEE, compatible con todos los fabricantes',
    'show cdp neighbors detail: IP, hostname, modelo, interfaz',
    'Deshabilitar CDP en interfaces externas (seguridad)',
    'CDP útil para inventario y troubleshooting de topología',
  ],
  keyPointsEn: [
    'CDP: Cisco proprietary, active by default',
    'LLDP: IEEE standard, compatible with all manufacturers',
    'show cdp neighbors detail: IP, hostname, model, interface',
    'Disable CDP on external interfaces (security)',
    'CDP useful for inventory and topology troubleshooting',
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// NEW LESSONS
// ─────────────────────────────────────────────────────────────────────────────

// ── Router-to-Router Serial Links (DCE/DTE) ───────────────────────────────────
const _serialDceDteLesson = NetworkLesson(
  titleEs: 'Conexión Serial entre Routers (DCE/DTE)',
  titleEn: 'Serial Router-to-Router Links (DCE/DTE)',
  icon: '🔗',
  summaryEs:
      'Las interfaces seriales conectan routers directamente a través de WAN. '
      'Un extremo es DCE (provee reloj) y el otro DTE (recibe reloj).',
  summaryEn:
      'Serial interfaces connect routers directly over WAN links. '
      'One end is DCE (provides clock) and the other is DTE (receives clock).',
  sections: [
    LessonSection(
      headingEs: '¿Qué es DCE y DTE?',
      headingEn: 'What are DCE and DTE?',
      contentEs:
          'En un enlace serial WAN hay dos roles:\n'
          '• DCE (Data Communications Equipment): provee la señal de reloj. '
          'Generalmente el equipo del proveedor o el que tiene el cable DCE.\n'
          '• DTE (Data Terminal Equipment): recibe el reloj del DCE. '
          'Generalmente el router del cliente.\n\n'
          'En laboratorio (back-to-back), uno de los routers asume el rol DCE '
          'y debe configurarse con clock rate.',
      contentEn:
          'In a WAN serial link there are two roles:\n'
          '• DCE (Data Communications Equipment): provides the clock signal. '
          'Usually the provider equipment or the device with the DCE cable.\n'
          '• DTE (Data Terminal Equipment): receives the clock from DCE. '
          'Usually the customer router.\n\n'
          'In lab (back-to-back), one router takes the DCE role '
          'and must be configured with clock rate.',
      codeExampleEs:
          '! Identificar cuál extremo es DCE:\n'
          'show controllers s0/0/0\n'
          '! Busca: "DCE cable" o "DTE cable"\n'
          '!\n'
          '! En el router DCE — configurar clock rate:\n'
          'R1(config)# interface Serial0/0/0\n'
          'R1(config-if)# ip address 10.0.0.1 255.255.255.252\n'
          'R1(config-if)# clock rate 64000\n'
          'R1(config-if)# no shutdown\n'
          '!\n'
          '! En el router DTE — NO se configura clock rate:\n'
          'R2(config)# interface Serial0/0/0\n'
          'R2(config-if)# ip address 10.0.0.2 255.255.255.252\n'
          'R2(config-if)# no shutdown',
      codeExampleEn:
          '! Identify which end is DCE:\n'
          'show controllers s0/0/0\n'
          '! Look for: "DCE cable" or "DTE cable"\n'
          '!\n'
          '! On the DCE router — configure clock rate:\n'
          'R1(config)# interface Serial0/0/0\n'
          'R1(config-if)# ip address 10.0.0.1 255.255.255.252\n'
          'R1(config-if)# clock rate 64000\n'
          'R1(config-if)# no shutdown\n'
          '!\n'
          '! On the DTE router — do NOT configure clock rate:\n'
          'R2(config)# interface Serial0/0/0\n'
          'R2(config-if)# ip address 10.0.0.2 255.255.255.252\n'
          'R2(config-if)# no shutdown',
    ),
    LessonSection(
      headingEs: 'do ping — Probar conectividad',
      headingEn: 'do ping — Test connectivity',
      contentEs:
          'El comando "ping" verifica conectividad entre routers. '
          'La palabra clave "do" permite usarlo desde cualquier modo de configuración.\n\n'
          'Resultado: !!!!! = 5 pings exitosos (100%)\n'
          '           ..... = 5 pings fallidos\n'
          '           !.!.! = intermitente (problema de enrutamiento)',
      contentEn:
          'The "ping" command verifies connectivity between routers. '
          'The "do" keyword allows using it from any configuration mode.\n\n'
          'Result: !!!!! = 5 successful pings (100%)\n'
          '        ..... = 5 failed pings\n'
          '        !.!.! = intermittent (routing problem)',
      codeExampleEs:
          '! Desde modo EXEC privilegiado:\n'
          'R1# ping 10.0.0.2\n'
          '!\n'
          '! Desde modo de configuración (con "do"):\n'
          'R1(config-if)# do ping 10.0.0.2\n'
          '!\n'
          '! Ping extendido (más opciones):\n'
          'R1# ping\n'
          'Protocol [ip]:\n'
          'Target IP address: 10.0.0.2\n'
          'Repeat count [5]: 100\n'
          'Datagram size [100]: 1500\n'
          '!\n'
          '! Ver tabla de enrutamiento:\n'
          'R1# show ip route',
      codeExampleEn:
          '! From privileged EXEC mode:\n'
          'R1# ping 10.0.0.2\n'
          '!\n'
          '! From configuration mode (with "do"):\n'
          'R1(config-if)# do ping 10.0.0.2\n'
          '!\n'
          '! Extended ping (more options):\n'
          'R1# ping\n'
          'Protocol [ip]:\n'
          'Target IP address: 10.0.0.2\n'
          'Repeat count [5]: 100\n'
          'Datagram size [100]: 1500\n'
          '!\n'
          '! View routing table:\n'
          'R1# show ip route',
    ),
    LessonSection(
      headingEs: 'do show controllers — Verificar DCE/DTE',
      headingEn: 'do show controllers — Verify DCE/DTE',
      contentEs:
          '"show controllers" muestra información física de la interfaz serial, '
          'incluyendo si el cable conectado es DCE o DTE y la velocidad de reloj.\n\n'
          'Claves en la salida:\n'
          '• "DCE cable, clock rate 64000" → este router es DCE\n'
          '• "DTE cable" → este router es DTE\n'
          '• "No cable" → sin cable conectado',
      contentEn:
          '"show controllers" displays physical information about the serial interface, '
          'including whether the connected cable is DCE or DTE and the clock speed.\n\n'
          'Key output:\n'
          '• "DCE cable, clock rate 64000" → this router is DCE\n'
          '• "DTE cable" → this router is DTE\n'
          '• "No cable" → no cable connected',
      codeExampleEs:
          'R1# show controllers Serial0/0/0\n'
          '! Salida ejemplo:\n'
          'HD unit 0, idb = 0x...\n'
          '...\n'
          'DCE cable, clock rate 64000\n'
          '!\n'
          '! Verificar estado de interfaces serial:\n'
          'R1# show interfaces Serial0/0/0\n'
          'Serial0/0/0 is up, line protocol is up\n'
          '!\n'
          '! Si "line protocol is down" en DCE:\n'
          '! — Falta clock rate\n'
          '! — Falta "no shutdown" en algún extremo',
      codeExampleEn:
          'R1# show controllers Serial0/0/0\n'
          '! Example output:\n'
          'HD unit 0, idb = 0x...\n'
          '...\n'
          'DCE cable, clock rate 64000\n'
          '!\n'
          '! Verify serial interface status:\n'
          'R1# show interfaces Serial0/0/0\n'
          'Serial0/0/0 is up, line protocol is up\n'
          '!\n'
          '! If "line protocol is down" on DCE:\n'
          '! — Missing clock rate\n'
          '! — Missing "no shutdown" on one end',
    ),
  ],
  keyPointsEs: [
    'DCE provee el clock rate — el DTE no lo configura',
    'show controllers s0/0/0 → identifica DCE o DTE',
    'Enlace serial /30 = 2 hosts (ideal para punto a punto)',
    '"do" permite ejecutar show/ping desde cualquier modo de config',
    '!!!!! = conectividad 100% | ..... = sin conectividad',
  ],
  keyPointsEn: [
    'DCE provides the clock rate — DTE does not configure it',
    'show controllers s0/0/0 → identifies DCE or DTE',
    'Serial /30 link = 2 hosts (ideal for point-to-point)',
    '"do" allows running show/ping from any config mode',
    '!!!!! = 100% connectivity | ..... = no connectivity',
  ],
);

// ── Broadcast Address — Bit Analysis ─────────────────────────────────────────
const _broadcastBitsLesson = NetworkLesson(
  titleEs: 'Bits en Redes — Cómo funciona todo en binario',
  titleEn: 'Bits in Networking — How everything works in binary',
  icon: '🔢',
  summaryEs:
      'Las IPs, máscaras y decisiones de enrutamiento son pura aritmética de bits. '
      'Entender el binario es la clave para dominar subnetting sin memorizar.',
  summaryEn:
      'IPs, masks and routing decisions are pure bit arithmetic. '
      'Understanding binary is the key to mastering subnetting without memorizing.',
  sections: [
    LessonSection(
      headingEs: '¿Qué es un bit y por qué importa en redes?',
      headingEn: 'What is a bit and why does it matter in networking?',
      contentEs:
          'Un bit es la unidad mínima de información: solo puede valer 0 o 1.\n\n'
          'Una dirección IPv4 son exactamente 32 bits divididos en 4 grupos '
          'de 8 bits (octetos). Cada octeto se muestra en decimal para que '
          'sea más legible, pero el router trabaja en binario.\n\n'
          'Tabla de posiciones en un octeto (8 bits):\n'
          '  Posición: 128  64  32  16   8   4   2   1\n'
          '  Bit:        1   1   0   0   0   0   0   1\n'
          '  Valor:    128 +64                      +1 = 193\n\n'
          'Regla: el valor máximo de un octeto es\n'
          '  128+64+32+16+8+4+2+1 = 255\n'
          'Por eso las IPs van de 0.0.0.0 a 255.255.255.255.',
      contentEn:
          'A bit is the minimum unit of information: it can only be 0 or 1.\n\n'
          'An IPv4 address is exactly 32 bits divided into 4 groups '
          'of 8 bits (octets). Each octet is shown in decimal to make it '
          'more readable, but the router works in binary.\n\n'
          'Position table in one octet (8 bits):\n'
          '  Position: 128  64  32  16   8   4   2   1\n'
          '  Bit:        1   1   0   0   0   0   0   1\n'
          '  Value:    128 +64                      +1 = 193\n\n'
          'Rule: the maximum value of one octet is\n'
          '  128+64+32+16+8+4+2+1 = 255\n'
          'That is why IPs range from 0.0.0.0 to 255.255.255.255.',
    ),
    LessonSection(
      headingEs: 'Convertir IP a binario paso a paso',
      headingEn: 'Convert IP to binary step by step',
      contentEs:
          'Convierte cada octeto restando potencias de 2 de mayor a menor.\n\n'
          'Ejemplo: convertir 192.168.10.1\n\n'
          'Octeto 1 → 192:\n'
          '  192 ≥ 128? Sí → bit=1, resto=64\n'
          '   64 ≥  64? Sí → bit=1, resto=0\n'
          '    0 <  32? Sí → bit=0 (y el resto también 0)\n'
          '  → 11000000\n\n'
          'Octeto 2 → 168:\n'
          '  168-128=40→1 | 40<64→0 | 40-32=8→1 | 8-8=0→1 | resto 0\n'
          '  → 10101000\n\n'
          'Octeto 3 → 10:  → 00001010\n'
          'Octeto 4 →  1:  → 00000001\n\n'
          '192.168.10.1 = 11000000.10101000.00001010.00000001',
      contentEn:
          'Convert each octet by subtracting powers of 2 from largest to smallest.\n\n'
          'Example: convert 192.168.10.1\n\n'
          'Octet 1 → 192:\n'
          '  192 ≥ 128? Yes → bit=1, rest=64\n'
          '   64 ≥  64? Yes → bit=1, rest=0\n'
          '    0 <  32? Yes → bit=0 (and rest also 0)\n'
          '  → 11000000\n\n'
          'Octet 2 → 168:\n'
          '  168-128=40→1 | 40<64→0 | 40-32=8→1 | 8-8=0→1 | rest 0\n'
          '  → 10101000\n\n'
          'Octet 3 → 10:  → 00001010\n'
          'Octet 4 →  1:  → 00000001\n\n'
          '192.168.10.1 = 11000000.10101000.00001010.00000001',
    ),
    LessonSection(
      headingEs: 'La máscara: Bit 1 = RED | Bit 0 = HOST',
      headingEn: 'The mask: Bit 1 = NETWORK | Bit 0 = HOST',
      contentEs:
          'La máscara de subred tiene 32 bits que marcan qué parte de la IP '
          'es RED y qué parte es HOST.\n\n'
          'Regla fundamental:\n'
          '  Bit de máscara = 1  →  ese bit de la IP es parte de la RED\n'
          '  Bit de máscara = 0  →  ese bit de la IP es parte del HOST\n\n'
          'Ejemplo /26 (255.255.255.192):\n'
          '  Máscara: 11111111.11111111.11111111.11|000000\n'
          '                                       ↑↑\n'
          '                       2 bits de red extra en el 4.º octeto\n\n'
          '  IP:      192.168.1.100\n'
          '  Binario: 11000000.10101000.00000001.01|100100\n'
          '                                    RED|HOST\n\n'
          '  Bits RED  → 192.168.1.64   (host bits todos en 0)\n'
          '  Bits HOST → 100100 = 36 → IP .100 es el host 35 de la subred\n'
          '  Broadcast → 192.168.1.127  (host bits todos en 1 = 111111)',
      contentEn:
          'The subnet mask has 32 bits that mark which part of the IP '
          'is NETWORK and which is HOST.\n\n'
          'Fundamental rule:\n'
          '  Mask bit = 1  →  that IP bit belongs to the NETWORK\n'
          '  Mask bit = 0  →  that IP bit belongs to the HOST\n\n'
          'Example /26 (255.255.255.192):\n'
          '  Mask:    11111111.11111111.11111111.11|000000\n'
          '                                       ↑↑\n'
          '                       2 extra network bits in 4th octet\n\n'
          '  IP:      192.168.1.100\n'
          '  Binary:  11000000.10101000.00000001.01|100100\n'
          '                                    NET|HOST\n\n'
          '  NET bits  → 192.168.1.64   (host bits all 0)\n'
          '  HOST bits → 100100 = 36 → IP .100 is host 35 in the subnet\n'
          '  Broadcast → 192.168.1.127  (host bits all 1 = 111111)',
    ),
    LessonSection(
      headingEs: 'AND bit a bit — Cómo el router encuentra la red',
      headingEn: 'Bitwise AND — How the router finds the network',
      contentEs:
          'El router aplica AND bit a bit entre IP y máscara para obtener '
          'la dirección de red. Es la operación central del subnetting.\n\n'
          'Tabla AND:\n'
          '  1 AND 1 = 1  |  1 AND 0 = 0\n'
          '  0 AND 1 = 0  |  0 AND 0 = 0\n\n'
          'Ejemplo: 10.5.3.200 con máscara /22 (255.255.252.0)\n\n'
          '  IP:      00001010.00000101.00000011.11001000\n'
          '  Máscara: 11111111.11111111.11111100.00000000\n'
          '  AND:     00001010.00000101.00000000.00000000\n'
          '         = 10.5.0.0  ← dirección de red\n\n'
          'Donde la máscara tiene 0, el AND siempre da 0, '
          'borrando los bits de host y dejando solo la red.',
      contentEn:
          'The router applies bitwise AND between IP and mask to obtain '
          'the network address. This is the central operation of subnetting.\n\n'
          'AND table:\n'
          '  1 AND 1 = 1  |  1 AND 0 = 0\n'
          '  0 AND 1 = 0  |  0 AND 0 = 0\n\n'
          'Example: 10.5.3.200 with mask /22 (255.255.252.0)\n\n'
          '  IP:    00001010.00000101.00000011.11001000\n'
          '  Mask:  11111111.11111111.11111100.00000000\n'
          '  AND:   00001010.00000101.00000000.00000000\n'
          '       = 10.5.0.0  ← network address\n\n'
          'Where the mask has 0, AND always gives 0, '
          'zeroing host bits and leaving only the network.',
    ),
    LessonSection(
      headingEs: 'OR bit a bit — Broadcast, y contar hosts',
      headingEn: 'Bitwise OR — Broadcast, and counting hosts',
      contentEs:
          'Broadcast = red OR wildcard (wildcard = NOT de la máscara).\n\n'
          'Tabla OR:\n'
          '  0 OR 0 = 0  |  0 OR 1 = 1\n'
          '  1 OR 0 = 1  |  1 OR 1 = 1\n\n'
          'Ejemplo: red 10.5.0.0/22\n'
          '  Wildcard: 00000000.00000000.00000011.11111111\n'
          '  Red:      00001010.00000101.00000000.00000000\n'
          '  OR:       00001010.00000101.00000011.11111111\n'
          '          = 10.5.3.255  ← broadcast\n\n'
          'Contar hosts con bits:\n'
          '  Bits de host = 32 - prefijo\n'
          '  Total dir.   = 2^(bits host)\n'
          '  Hosts útiles = 2^(bits host) - 2\n\n'
          'Tabla rápida:\n'
          '  /30→ 2 bits→ 4 dir→  2 hosts  (P2P)\n'
          '  /29→ 3 bits→ 8 dir→  6 hosts\n'
          '  /28→ 4 bits→16 dir→ 14 hosts\n'
          '  /27→ 5 bits→32 dir→ 30 hosts\n'
          '  /26→ 6 bits→64 dir→ 62 hosts\n'
          '  /24→ 8 bits→256 dir→254 hosts',
      contentEn:
          'Broadcast = network OR wildcard (wildcard = NOT of mask).\n\n'
          'OR table:\n'
          '  0 OR 0 = 0  |  0 OR 1 = 1\n'
          '  1 OR 0 = 1  |  1 OR 1 = 1\n\n'
          'Example: network 10.5.0.0/22\n'
          '  Wildcard: 00000000.00000000.00000011.11111111\n'
          '  Network:  00001010.00000101.00000000.00000000\n'
          '  OR:       00001010.00000101.00000011.11111111\n'
          '          = 10.5.3.255  ← broadcast\n\n'
          'Count hosts with bits:\n'
          '  Host bits    = 32 - prefix\n'
          '  Total addr   = 2^(host bits)\n'
          '  Usable hosts = 2^(host bits) - 2\n\n'
          'Quick table:\n'
          '  /30→ 2 bits→ 4 addr→  2 hosts  (P2P)\n'
          '  /29→ 3 bits→ 8 addr→  6 hosts\n'
          '  /28→ 4 bits→16 addr→ 14 hosts\n'
          '  /27→ 5 bits→32 addr→ 30 hosts\n'
          '  /26→ 6 bits→64 addr→ 62 hosts\n'
          '  /24→ 8 bits→256 addr→254 hosts',
    ),
  ],
  keyPointsEs: [
    'IPv4 = 32 bits en 4 octetos. Cada octeto = 0–255',
    'Máscara bit=1 → bit de RED | bit=0 → bit de HOST',
    'AND bit a bit: IP AND Máscara = dirección de red',
    'OR bit a bit: Red OR Wildcard = dirección de broadcast',
    'Hosts = 2^(bits de host) − 2 (sin red y sin broadcast)',
    '/30 = solo 2 hosts → enlace punto a punto',
  ],
  keyPointsEn: [
    'IPv4 = 32 bits in 4 octets. Each octet = 0–255',
    'Mask bit=1 → NETWORK bit | bit=0 → HOST bit',
    'Bitwise AND: IP AND Mask = network address',
    'Bitwise OR: Network OR Wildcard = broadcast address',
    'Hosts = 2^(host bits) − 2 (no network, no broadcast)',
    '/30 = only 2 hosts → point-to-point link',
  ],
);

// ── Console Connection (Laptop → Router/Switch) ───────────────────────────────
const _consoleLesson = NetworkLesson(
  titleEs: 'Conexión Consola — Laptop a Router/Switch',
  titleEn: 'Console Connection — Laptop to Router/Switch',
  icon: '💻',
  summaryEs:
      'La consola es el acceso de gestión fuera de banda que no requiere red. '
      'Se usa para configuración inicial, recuperación de contraseñas y emergencias.',
  summaryEn:
      'The console is out-of-band management access that does not require a network. '
      'Used for initial configuration, password recovery and emergencies.',
  sections: [
    LessonSection(
      headingEs: '¿Qué equipos tienen puerto consola?',
      headingEn: 'Which devices have a console port?',
      contentEs:
          'Puerto consola (RJ-45 azul o USB mini-B) disponible en:\n'
          '• Routers Cisco (todas las series: 800, 1900, 2900, ISR 4000)\n'
          '• Switches Cisco (Catalyst 2960, 3560, 3850, 9000)\n'
          '• Firewalls Cisco ASA y FTD\n'
          '• Switches de capa 3\n'
          '• Algunos servidores y appliances\n\n'
          'Dispositivos SIN puerto consola:\n'
          '• PCs normales, impresoras, teléfonos IP\n'
          '• Access Points simples (solo vía web/SSH)',
      contentEn:
          'Console port (blue RJ-45 or USB mini-B) available on:\n'
          '• Cisco Routers (all series: 800, 1900, 2900, ISR 4000)\n'
          '• Cisco Switches (Catalyst 2960, 3560, 3850, 9000)\n'
          '• Cisco Firewalls ASA and FTD\n'
          '• Layer 3 switches\n'
          '• Some servers and appliances\n\n'
          'Devices WITHOUT console port:\n'
          '• Regular PCs, printers, IP phones\n'
          '• Simple Access Points (web/SSH only)',
    ),
    LessonSection(
      headingEs: 'Cable de consola y conexión física',
      headingEn: 'Console cable and physical connection',
      contentEs:
          'Tipos de cable consola:\n'
          '• Cable Rollover (RJ-45 a DB-9 azul): el clásico\n'
          '• Cable USB-A a USB mini-B (equipos modernos)\n'
          '• Adaptador DB-9 a USB (si el laptop no tiene puerto serial)\n\n'
          'Parámetros de comunicación (siempre iguales en Cisco):\n'
          '  Velocidad (Baud): 9600\n'
          '  Bits de datos:    8\n'
          '  Paridad:          Ninguna\n'
          '  Bits de parada:   1\n'
          '  Control de flujo: Ninguno',
      contentEn:
          'Console cable types:\n'
          '• Rollover Cable (RJ-45 to DB-9 blue): the classic\n'
          '• USB-A to USB mini-B cable (modern devices)\n'
          '• DB-9 to USB adapter (if laptop has no serial port)\n\n'
          'Communication parameters (always the same on Cisco):\n'
          '  Speed (Baud): 9600\n'
          '  Data bits:    8\n'
          '  Parity:       None\n'
          '  Stop bits:    1\n'
          '  Flow control: None',
    ),
    LessonSection(
      headingEs: 'Software de terminal — PuTTY y SecureCRT',
      headingEn: 'Terminal software — PuTTY and SecureCRT',
      contentEs:
          'Herramientas para conectarse por consola:\n\n'
          'PuTTY (gratis):\n'
          '  1. Abre PuTTY → selecciona "Serial"\n'
          '  2. Serial line: COM3 (o el puerto que asignó Windows)\n'
          '  3. Speed: 9600 → Open\n\n'
          'Windows (PowerShell/CMD):\n'
          '  mode COM3: baud=9600 parity=n data=8 stop=1\n\n'
          'Linux/Mac:\n'
          '  screen /dev/ttyUSB0 9600\n'
          '  minicom -b 9600 -D /dev/ttyUSB0',
      contentEn:
          'Tools to connect via console:\n\n'
          'PuTTY (free):\n'
          '  1. Open PuTTY → select "Serial"\n'
          '  2. Serial line: COM3 (or the port Windows assigned)\n'
          '  3. Speed: 9600 → Open\n\n'
          'Windows (PowerShell/CMD):\n'
          '  mode COM3: baud=9600 parity=n data=8 stop=1\n\n'
          'Linux/Mac:\n'
          '  screen /dev/ttyUSB0 9600\n'
          '  minicom -b 9600 -D /dev/ttyUSB0',
      codeExampleEs:
          '! Una vez conectado, verás:\n'
          'Router>\n'
          '!\n'
          '! Entrar a modo privilegiado:\n'
          'Router> enable\n'
          'Router#\n'
          '!\n'
          '! Configurar acceso por consola con contraseña:\n'
          'Router(config)# line console 0\n'
          'Router(config-line)# password cisco123\n'
          'Router(config-line)# login\n'
          'Router(config-line)# exec-timeout 10 0',
      codeExampleEn:
          '! Once connected, you will see:\n'
          'Router>\n'
          '!\n'
          '! Enter privileged mode:\n'
          'Router> enable\n'
          'Router#\n'
          '!\n'
          '! Configure console access with password:\n'
          'Router(config)# line console 0\n'
          'Router(config-line)# password cisco123\n'
          'Router(config-line)# login\n'
          'Router(config-line)# exec-timeout 10 0',
    ),
  ],
  keyPointsEs: [
    'Consola = acceso sin red — funciona aunque IP no esté configurada',
    'Baud rate siempre 9600 en Cisco',
    'Cable rollover (azul) o USB según el modelo del equipo',
    'Routers, switches y firewalls Cisco tienen puerto consola',
    'PuTTY (Serial, COM3, 9600) es la herramienta más usada en Windows',
  ],
  keyPointsEn: [
    'Console = access without network — works even with no IP configured',
    'Baud rate always 9600 on Cisco',
    'Rollover cable (blue) or USB depending on device model',
    'Cisco routers, switches and firewalls have console port',
    'PuTTY (Serial, COM3, 9600) is the most common tool on Windows',
  ],
);

// ── Servers in a Network ──────────────────────────────────────────────────────
const _serversLesson = NetworkLesson(
  titleEs: 'Servidores en la Red',
  titleEn: 'Servers in the Network',
  icon: '🖥️',
  summaryEs:
      'Los servidores proveen servicios centralizados a los clientes de la red. '
      'Conoce los tipos más comunes y cómo se integran en una topología.',
  summaryEn:
      'Servers provide centralized services to network clients. '
      'Learn the most common types and how they integrate in a topology.',
  sections: [
    LessonSection(
      headingEs: 'Tipos de servidores más comunes',
      headingEn: 'Most common server types',
      contentEs:
          '• DHCP Server: asigna IPs automáticamente a los clientes\n'
          '• DNS Server: traduce nombres (google.com) a IPs\n'
          '• Web Server (HTTP/HTTPS): sirve páginas web (Apache, Nginx, IIS)\n'
          '• FTP/SFTP Server: transferencia de archivos\n'
          '• Mail Server (SMTP/POP3/IMAP): correo electrónico\n'
          '• NTP Server: sincronización de tiempo en la red\n'
          '• RADIUS/TACACS+: autenticación centralizada de usuarios de red\n'
          '• Syslog Server: recibe y almacena logs de dispositivos\n'
          '• File Server (SMB/NFS): almacenamiento compartido\n'
          '• VoIP Server (Cisco UCM): llamadas de voz sobre IP',
      contentEn:
          '• DHCP Server: automatically assigns IPs to clients\n'
          '• DNS Server: translates names (google.com) to IPs\n'
          '• Web Server (HTTP/HTTPS): serves web pages (Apache, Nginx, IIS)\n'
          '• FTP/SFTP Server: file transfer\n'
          '• Mail Server (SMTP/POP3/IMAP): email\n'
          '• NTP Server: time synchronization across the network\n'
          '• RADIUS/TACACS+: centralized network user authentication\n'
          '• Syslog Server: receives and stores device logs\n'
          '• File Server (SMB/NFS): shared storage\n'
          '• VoIP Server (Cisco UCM): voice calls over IP',
    ),
    LessonSection(
      headingEs: 'Configurar DHCP en router Cisco',
      headingEn: 'Configure DHCP on Cisco router',
      contentEs:
          'Un router Cisco puede actuar como servidor DHCP para la LAN, '
          'eliminando la necesidad de un servidor dedicado en redes pequeñas.',
      contentEn:
          'A Cisco router can act as a DHCP server for the LAN, '
          'eliminating the need for a dedicated server in small networks.',
      codeExampleEs:
          '! Excluir IPs del pool (routers, servidores, impresoras):\n'
          'R1(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.20\n'
          '!\n'
          '! Crear pool DHCP:\n'
          'R1(config)# ip dhcp pool LAN-POOL\n'
          'R1(dhcp-config)# network 192.168.1.0 255.255.255.0\n'
          'R1(dhcp-config)# default-router 192.168.1.1\n'
          'R1(dhcp-config)# dns-server 8.8.8.8 8.8.4.4\n'
          'R1(dhcp-config)# lease 7\n'
          '!\n'
          '! Verificar:\n'
          'show ip dhcp binding\n'
          'show ip dhcp pool',
      codeExampleEn:
          '! Exclude IPs from pool (routers, servers, printers):\n'
          'R1(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.20\n'
          '!\n'
          '! Create DHCP pool:\n'
          'R1(config)# ip dhcp pool LAN-POOL\n'
          'R1(dhcp-config)# network 192.168.1.0 255.255.255.0\n'
          'R1(dhcp-config)# default-router 192.168.1.1\n'
          'R1(dhcp-config)# dns-server 8.8.8.8 8.8.4.4\n'
          'R1(dhcp-config)# lease 7\n'
          '!\n'
          '! Verify:\n'
          'show ip dhcp binding\n'
          'show ip dhcp pool',
    ),
    LessonSection(
      headingEs: 'Servidor en DMZ — zona desmilitarizada',
      headingEn: 'Server in DMZ — demilitarized zone',
      contentEs:
          'La DMZ es una red intermedia entre Internet y la LAN interna. '
          'Los servidores públicos (web, correo, FTP) van en la DMZ.\n\n'
          'Topología típica:\n'
          'Internet → [Router/Firewall] → DMZ (Servidores públicos)\n'
          '                            ↓\n'
          '                         LAN Interna\n\n'
          'Ventaja: si un servidor DMZ es comprometido, '
          'el atacante no accede directamente a la LAN interna.',
      contentEn:
          'The DMZ is an intermediate network between the Internet and the internal LAN. '
          'Public servers (web, mail, FTP) go in the DMZ.\n\n'
          'Typical topology:\n'
          'Internet → [Router/Firewall] → DMZ (Public Servers)\n'
          '                            ↓\n'
          '                         Internal LAN\n\n'
          'Advantage: if a DMZ server is compromised, '
          'the attacker does not directly access the internal LAN.',
    ),
  ],
  keyPointsEs: [
    'DHCP asigna IPs automáticamente — DNS traduce nombres a IPs',
    'Router Cisco puede hacer DHCP, DNS relay, NTP sin servidor externo',
    'DMZ: red pública separada de la LAN interna por firewall',
    'RADIUS/TACACS+: autenticación centralizada para acceso de red',
    'Syslog: recoge logs de todos los dispositivos en un solo punto',
  ],
  keyPointsEn: [
    'DHCP assigns IPs automatically — DNS translates names to IPs',
    'Cisco router can do DHCP, DNS relay, NTP without external server',
    'DMZ: public network separated from internal LAN by firewall',
    'RADIUS/TACACS+: centralized authentication for network access',
    'Syslog: collects logs from all devices in one place',
  ],
);

// ── Cloud in Networking ────────────────────────────────────────────────────────
const _cloudLesson = NetworkLesson(
  titleEs: 'La Nube en Redes (Cloud Networking)',
  titleEn: 'The Cloud in Networking (Cloud Networking)',
  icon: '☁️',
  summaryEs:
      'La nube permite acceder a recursos de red y cómputo sin infraestructura propia. '
      'Conoce los modelos IaaS, PaaS y SaaS y cómo conectar redes locales a la nube.',
  summaryEn:
      'The cloud provides access to network and compute resources without own infrastructure. '
      'Learn IaaS, PaaS and SaaS models and how to connect local networks to the cloud.',
  sections: [
    LessonSection(
      headingEs: 'Modelos de servicio: IaaS, PaaS, SaaS',
      headingEn: 'Service models: IaaS, PaaS, SaaS',
      contentEs:
          '• IaaS (Infrastructure as a Service):\n'
          '  Alquila servidores, almacenamiento, redes virtuales.\n'
          '  Tú gestionas el SO y las apps. Ej: AWS EC2, Azure VMs, GCP.\n\n'
          '• PaaS (Platform as a Service):\n'
          '  Plataforma para desarrollar sin gestionar infraestructura.\n'
          '  Ej: Heroku, Azure App Service, Google App Engine.\n\n'
          '• SaaS (Software as a Service):\n'
          '  Aplicación lista para usar por Internet.\n'
          '  Ej: Gmail, Microsoft 365, Salesforce, Webex.',
      contentEn:
          '• IaaS (Infrastructure as a Service):\n'
          '  Rent servers, storage, virtual networks.\n'
          '  You manage OS and apps. Ex: AWS EC2, Azure VMs, GCP.\n\n'
          '• PaaS (Platform as a Service):\n'
          '  Platform to develop without managing infrastructure.\n'
          '  Ex: Heroku, Azure App Service, Google App Engine.\n\n'
          '• SaaS (Software as a Service):\n'
          '  Application ready to use over the Internet.\n'
          '  Ex: Gmail, Microsoft 365, Salesforce, Webex.',
    ),
    LessonSection(
      headingEs: 'Modelos de despliegue',
      headingEn: 'Deployment models',
      contentEs:
          '• Nube Pública: recursos en data centers del proveedor (AWS, Azure, GCP).\n'
          '  Ventaja: escalable, sin inversión inicial.\n\n'
          '• Nube Privada: infraestructura propia en data center corporativo.\n'
          '  Ventaja: mayor control y seguridad.\n\n'
          '• Nube Híbrida: mezcla pública + privada.\n'
          '  Datos sensibles on-premise, carga variable en nube pública.\n\n'
          '• Multi-cloud: usar varios proveedores simultáneamente.\n'
          '  Evita dependencia de un solo proveedor (vendor lock-in).',
      contentEn:
          '• Public Cloud: resources in provider data centers (AWS, Azure, GCP).\n'
          '  Advantage: scalable, no upfront investment.\n\n'
          '• Private Cloud: own infrastructure in corporate data center.\n'
          '  Advantage: greater control and security.\n\n'
          '• Hybrid Cloud: mix of public + private.\n'
          '  Sensitive data on-premise, variable load in public cloud.\n\n'
          '• Multi-cloud: use multiple providers simultaneously.\n'
          '  Avoids dependency on a single provider (vendor lock-in).',
    ),
    LessonSection(
      headingEs: 'Conectar red local a la nube — VPN y Direct Connect',
      headingEn: 'Connect local network to cloud — VPN and Direct Connect',
      contentEs:
          'Opciones para conectar tu oficina/data center a la nube:\n\n'
          '1. VPN Site-to-Site (IPSec):\n'
          '   Tu router ↔ Internet ↔ Gateway nube\n'
          '   Cifrado pero usa Internet pública — latencia variable.\n\n'
          '2. AWS Direct Connect / Azure ExpressRoute:\n'
          '   Enlace físico privado al data center del proveedor.\n'
          '   Latencia baja y predecible — más caro.\n\n'
          '3. SD-WAN:\n'
          '   Gestión centralizada de múltiples conexiones WAN.\n'
          '   Optimiza el tráfico hacia cloud automáticamente.',
      contentEn:
          'Options to connect your office/data center to the cloud:\n\n'
          '1. Site-to-Site VPN (IPSec):\n'
          '   Your router ↔ Internet ↔ Cloud gateway\n'
          '   Encrypted but uses public Internet — variable latency.\n\n'
          '2. AWS Direct Connect / Azure ExpressRoute:\n'
          '   Private physical link to provider data center.\n'
          '   Low and predictable latency — more expensive.\n\n'
          '3. SD-WAN:\n'
          '   Centralized management of multiple WAN connections.\n'
          '   Automatically optimizes traffic to cloud.',
    ),
  ],
  keyPointsEs: [
    'IaaS = infraestructura virtual | PaaS = plataforma | SaaS = software listo',
    'Nube híbrida: datos críticos on-premise, carga variable en nube pública',
    'VPN IPSec: conexión cifrada sobre Internet (económico)',
    'Direct Connect/ExpressRoute: enlace privado dedicado (bajo latencia)',
    'SD-WAN: optimización automática de tráfico multi-WAN hacia nube',
  ],
  keyPointsEn: [
    'IaaS = virtual infra | PaaS = platform | SaaS = ready software',
    'Hybrid cloud: critical data on-premise, variable load in public cloud',
    'IPSec VPN: encrypted connection over Internet (economical)',
    'Direct Connect/ExpressRoute: dedicated private link (low latency)',
    'SD-WAN: automatic multi-WAN traffic optimization to cloud',
  ],
);
