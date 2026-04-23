/// AppStrings
/// All UI strings in Spanish and English.
/// Access via: AppStrings.of(context).someKey

class AppStrings {
  final bool isSpanish;
  const AppStrings({required this.isSpanish});

  // ── General ───────────────────────────────────────────────────────────────
  String get appTitle => isSpanish ? 'Asistente de Redes' : 'Network Engineering Assistant';
  String get open => isSpanish ? 'Abrir' : 'Open';
  String get calculate => isSpanish ? 'Calcular' : 'Calculate';
  String get clear => isSpanish ? 'Limpiar' : 'Clear';
  String get add => isSpanish ? 'Agregar' : 'Add';
  String get generate => isSpanish ? 'Generar' : 'Generate';
  String get back => isSpanish ? 'Volver' : 'Back';
  String get copy => isSpanish ? 'Copiar' : 'Copy';
  String get copied => isSpanish ? '¡Copiado!' : 'Copied!';
  String get save => isSpanish ? 'Guardar' : 'Save';
  String get delete => isSpanish ? 'Eliminar' : 'Delete';
  String get close => isSpanish ? 'Cerrar' : 'Close';
  String get required => isSpanish ? 'Requerido' : 'Required';
  String get optional => isSpanish ? 'Opcional' : 'Optional';
  String get error => isSpanish ? 'Error' : 'Error';
  String get tools => isSpanish ? 'Herramientas' : 'Tools';
  String get selectModule => isSpanish ? 'Selecciona un módulo para comenzar' : 'Select a module to get started';
  String get explanation => isSpanish ? 'Explicación' : 'Explanation';
  String get stepByStep => isSpanish ? 'Paso a Paso' : 'Step-by-Step';
  String get summary => isSpanish ? 'Resumen' : 'Summary';
  String get results => isSpanish ? 'Resultados' : 'Results';
  String get preview => isSpanish ? 'Vista previa' : 'Preview';
  String get input => isSpanish ? 'Entrada' : 'Input';
  String get output => isSpanish ? 'Salida' : 'Output';
  String get apply => isSpanish ? 'Aplicar' : 'Apply';
  String get configured => isSpanish ? 'configurado(s)' : 'configured';
  String get noItems => isSpanish ? 'Sin elementos' : 'No items';
  String get language => isSpanish ? 'Idioma' : 'Language';
  String get clearAll => isSpanish ? 'Limpiar todo' : 'Clear all';

  // ── Home ──────────────────────────────────────────────────────────────────
  String get homeSubtitle => isSpanish
      ? 'Calcula subredes · Diseña VLANs · Genera configs Cisco\nAprende redes paso a paso'
      : 'Calculate subnets · Design VLANs · Generate Cisco configs\nLearn networking step by step';
  String get learningMode => isSpanish ? 'Modo Aprendizaje' : 'Learning Mode';

  // ── Addressing ────────────────────────────────────────────────────────────
  String get addressingTools => isSpanish ? 'Herramientas de Direccionamiento' : 'Addressing Tools';
  String get addressingSubtitle => isSpanish
      ? 'Calcula subredes, analiza IPv6 y planifica VLSM.'
      : 'Calculate subnets, analyze IPv6 addresses, and plan VLSM allocations.';
  String get ipv4Calculator => isSpanish ? 'Calculadora IPv4' : 'IPv4 Subnet Calculator';
  String get ipv4Desc => isSpanish
      ? 'Calcula red, broadcast, hosts, máscara wildcard y análisis binario.'
      : 'Calculate network, broadcast, usable hosts, wildcard mask, and binary analysis.';
  String get ipv6Analyzer => isSpanish ? 'Analizador IPv6' : 'IPv6 Analyzer';
  String get ipv6Desc => isSpanish
      ? 'Expande/comprime direcciones IPv6, identifica tipo y calcula prefijos.'
      : 'Expand/compress IPv6 addresses, identify type, calculate prefix ranges.';
  String get vlsmCalculator => isSpanish ? 'Calculadora VLSM' : 'VLSM Calculator';
  String get vlsmDesc => isSpanish
      ? 'Asigna subredes de longitud variable de un bloque de direcciones.'
      : 'Allocate variable-length subnets from a single address block.';
  String get ipAddress => isSpanish ? 'Dirección IP' : 'IP Address';
  String get prefixLength => isSpanish ? 'Longitud de Prefijo' : 'Prefix Length';
  String get subnetDetails => isSpanish ? 'Detalles de Subred' : 'Subnet Details';
  String get networkAddress => isSpanish ? 'Dirección de Red' : 'Network Address';
  String get broadcastAddress => isSpanish ? 'Dirección Broadcast' : 'Broadcast Address';
  String get subnetMask => isSpanish ? 'Máscara de Subred' : 'Subnet Mask';
  String get wildcardMask => isSpanish ? 'Máscara Wildcard' : 'Wildcard Mask';
  String get firstHost => isSpanish ? 'Primer Host' : 'First Host';
  String get lastHost => isSpanish ? 'Último Host' : 'Last Host';
  String get totalHosts => isSpanish ? 'Total Hosts' : 'Total Hosts';
  String get usableHosts => isSpanish ? 'Hosts Utilizables' : 'Usable Hosts';
  String get ipClass => isSpanish ? 'Clase IP' : 'IP Class';
  String get privateRange => isSpanish ? 'Rango Privado' : 'Private Range';
  String get enterIpAndPrefix => isSpanish
      ? 'Ingresa una IP y prefijo para calcular\nlos detalles de la subred'
      : 'Enter an IP address and prefix to calculate\nsubnet details';
  String get baseNetwork => isSpanish ? 'Red Base' : 'Base Network';
  String get networkSegments => isSpanish ? 'Segmentos de Red' : 'Network Segments';
  String get segmentName => isSpanish ? 'Nombre del Segmento' : 'Segment Name';
  String get hosts => isSpanish ? 'Hosts' : 'Hosts';
  String get addSegment => isSpanish ? 'Agregar Segmento' : 'Add Segment';
  String get vlsmAllocation => isSpanish ? 'Asignación VLSM' : 'VLSM Allocation';
  String get requiredHosts => isSpanish ? 'Hosts requeridos' : 'Required hosts';
  String get addAtLeastOneSegment => isSpanish ? 'Agrega al menos un segmento' : 'Add at least one segment';
  String get noSegmentsYet => isSpanish
      ? 'Sin segmentos aún.\nAgrega segmentos arriba.'
      : 'No segments yet.\nAdd segments above.';

  // ── Designer ──────────────────────────────────────────────────────────────
  String get networkDesigner => isSpanish ? 'Diseñador de Red' : 'Network Designer';
  String get designerSubtitle => isSpanish
      ? 'Planifica VLANs y genera configuraciones Cisco IOS para enrutamiento inter-VLAN.'
      : 'Plan VLANs and generate Cisco IOS configurations for inter-VLAN routing.';
  String get vlanPlanner => isSpanish ? 'Planificador VLAN' : 'VLAN Planner';
  String get vlanPlannerDesc => isSpanish
      ? 'Define VLANs con IDs, nombres y rangos IP. Valida solapamientos.'
      : 'Define VLANs with IDs, names, and IP ranges. Validates for overlaps.';
  String get routerOnStick => isSpanish ? 'Router-on-a-Stick' : 'Router-on-a-Stick';
  String get routerOnStickDesc => isSpanish
      ? 'Genera config completa Cisco IOS para Router-on-a-Stick (sub-interfaces 802.1Q).'
      : 'Generate complete Cisco IOS config for Router-on-a-Stick (802.1Q sub-interfaces).';
  String get addVlan => isSpanish ? 'Agregar VLAN' : 'Add VLAN';
  String get vlanId => isSpanish ? 'ID de VLAN' : 'VLAN ID';
  String get vlanName => isSpanish ? 'Nombre VLAN' : 'VLAN Name';
  String get networkAddressField => isSpanish ? 'Dirección de Red' : 'Network Address';
  String get configuredVlans => isSpanish ? 'VLANs Configuradas' : 'Configured VLANs';
  String get noVlansYet => isSpanish
      ? 'Sin VLANs aún.\nUsa el formulario para agregar.'
      : 'No VLANs added yet.\nFill the form above to add VLANs.';
  String get noVlansConfigured => isSpanish
      ? 'Sin VLANs configuradas'
      : 'No VLANs configured yet';
  String get goToVlanPlanner => isSpanish ? 'Ir al Planificador VLAN' : 'Go to VLAN Planner';
  String get configOptions => isSpanish ? 'Opciones de Configuración' : 'Configuration Options';
  String get routerHostname => isSpanish ? 'Hostname del Router' : 'Router Hostname';
  String get switchHostname => isSpanish ? 'Hostname del Switch' : 'Switch Hostname';
  String get trunkInterface => isSpanish ? 'Interfaz Trunk (hacia Switch)' : 'Trunk Interface (to Switch)';
  String get generateConfig => isSpanish ? 'Generar Configuración' : 'Generate Configuration';
  String get routerConfig => isSpanish ? 'Config Router' : 'Router Config';
  String get switchConfig => isSpanish ? 'Config Switch' : 'Switch Config';
  String get editVlans => isSpanish ? 'Editar VLANs' : 'Edit VLANs';
  String get overlapsDetected => isSpanish ? 'Solapamiento de Direcciones' : 'Address Space Overlaps';

  // ── Routing ───────────────────────────────────────────────────────────────
  String get routingAssistant => isSpanish ? 'Asistente de Enrutamiento' : 'Routing Assistant';
  String get routingSubtitle => isSpanish
      ? 'Genera rutas estáticas y aprende sobre protocolos de enrutamiento dinámico.'
      : 'Generate static route configurations and learn about dynamic routing protocols.';
  String get staticRouteGenerator => isSpanish ? 'Generador de Rutas Estáticas' : 'Static Route Generator';
  String get staticRouteDesc => isSpanish
      ? 'Construye rutas estáticas IPv4, rutas por defecto y estáticas flotantes. Genera comandos Cisco IOS.'
      : 'Build IPv4 static routes, default routes, and floating static routes. Generates Cisco IOS commands.';
  String get routingConcepts => isSpanish ? 'Conceptos de Enrutamiento' : 'Routing Concepts';
  String get addRoute => isSpanish ? 'Agregar Ruta' : 'Add Route';
  String get routeType => isSpanish ? 'Tipo de Ruta' : 'Route Type';
  String get destinationNetwork => isSpanish ? 'Red Destino' : 'Destination Network';
  String get nextHop => isSpanish ? 'Next-Hop IP / Interfaz de Salida' : 'Next-Hop IP / Exit Interface';
  String get adminDistance => isSpanish ? 'Distancia Administrativa (opcional)' : 'Admin Distance (optional)';
  String get description => isSpanish ? 'Descripción (opcional)' : 'Description (optional)';
  String get routes => isSpanish ? 'Rutas' : 'Routes';
  String get noRoutesYet => isSpanish
      ? 'Sin rutas aún.\nUsa el formulario para agregar rutas.'
      : 'No routes added yet.\nFill the form above to add routes.';
  String get generatedConfig => isSpanish ? 'Configuración Generada' : 'Generated Configuration';

  // ── Services ──────────────────────────────────────────────────────────────
  String get networkServices => isSpanish ? 'Servicios de Red' : 'Network Services';
  String get servicesSubtitle => isSpanish
      ? 'Planifica y genera configuraciones NAT y ACL para routers Cisco IOS.'
      : 'Plan and generate NAT and ACL configurations for Cisco IOS routers.';
  String get natPlanner => isSpanish ? 'Planificador NAT' : 'NAT Planner';
  String get natDesc => isSpanish
      ? 'Configura NAT Estático, Dinámico y PAT. Genera comandos Cisco IOS completos.'
      : 'Configure Static NAT, Dynamic NAT, and PAT. Generates complete Cisco IOS commands.';
  String get aclBuilder => isSpanish ? 'Constructor ACL' : 'ACL Builder';
  String get aclDesc => isSpanish
      ? 'Construye ACLs Estándar y Extendidas con reglas permit/deny. Soporta filtrado por protocolo y puerto.'
      : 'Build Standard and Extended ACLs with permit/deny rules. Supports TCP, UDP, ICMP filtering.';
  String get natType => isSpanish ? 'Tipo de NAT' : 'NAT Type';
  String get interfaces => isSpanish ? 'Interfaces' : 'Interfaces';
  String get insideInterface => isSpanish ? 'Interfaz Interior (LAN)' : 'Inside Interface (LAN)';
  String get outsideInterface => isSpanish ? 'Interfaz Exterior (WAN)' : 'Outside Interface (WAN)';
  String get natParameters => isSpanish ? 'Parámetros NAT' : 'NAT Parameters';
  String get generateNatConfig => isSpanish ? 'Generar Config NAT' : 'Generate NAT Config';
  String get aclSettings => isSpanish ? 'Configuración ACL' : 'ACL Settings';
  String get aclType => isSpanish ? 'Tipo ACL' : 'ACL Type';
  String get aclNumber => isSpanish ? 'Número ACL' : 'ACL Number';
  String get aclNameLabel => isSpanish ? 'Nombre ACL (para ACL nombrada)' : 'ACL Name (for named ACL)';
  String get addRule => isSpanish ? 'Agregar Regla' : 'Add Rule';
  String get action => isSpanish ? 'Acción' : 'Action';
  String get protocol => isSpanish ? 'Protocolo' : 'Protocol';
  String get source => isSpanish ? 'Origen' : 'Source';
  String get destination => isSpanish ? 'Destino' : 'Destination';
  String get port => isSpanish ? 'Puerto (eq)' : 'Port (eq)';
  String get rules => isSpanish ? 'Reglas' : 'Rules';
  String get generatedAcl => isSpanish ? 'ACL Generada' : 'Generated ACL';
  String get applyToInterface => isSpanish ? 'Aplicar a Interfaz' : 'Apply to Interface';
  String get applyInbound => isSpanish ? 'Aplicar entrada' : 'Apply inbound';
  String get applyOutbound => isSpanish ? 'Aplicar salida' : 'Apply outbound';

  // ── Learning ──────────────────────────────────────────────────────────────
  String get searchTopics => isSpanish ? 'Buscar temas...' : 'Search topics...';
  String get sections => isSpanish ? 'secciones' : 'sections';
  String get keyPoints => isSpanish ? 'Puntos Clave' : 'Key Points';
  String get content => isSpanish ? 'Contenido' : 'Content';
  String get ciscoExample => isSpanish ? 'Ejemplo Cisco IOS' : 'Cisco IOS Example';
  String get backToTopics => isSpanish ? 'Volver a temas' : 'Back to Topics';
  String get keyPointsLabel => isSpanish ? 'puntos clave' : 'key points';

  // ── Shell nav labels ───────────────────────────────────────────────────────
  String get home => isSpanish ? 'Inicio' : 'Home';
  String get addressing => isSpanish ? 'IPs' : 'IPs';
  String get designer => isSpanish ? 'Diseño' : 'Design';
  String get routing => isSpanish ? 'Ruteo' : 'Routing';
  String get services => isSpanish ? 'Servicios' : 'Services';
  String get learning => isSpanish ? 'Aprender' : 'Learn';
  String get tutorials => isSpanish ? 'Tutoriales' : 'Tutorials';

  // ── Tutorial section ───────────────────────────────────────────────────────
  String get tutorialsTitle => isSpanish ? 'Tutoriales y Guías' : 'Tutorials & Guides';
  String get tutorialsSubtitle => isSpanish
      ? 'Equipos de red, guías paso a paso y laboratorios prácticos.'
      : 'Network equipment, step-by-step guides and practical labs.';
  String get equipment => isSpanish ? 'Equipos de Red' : 'Network Equipment';
  String get stepByStepGuides => isSpanish ? 'Guías Paso a Paso' : 'Step-by-Step Guides';
  String get startGuide => isSpanish ? 'Iniciar Guía' : 'Start Guide';
  String get step => isSpanish ? 'Paso' : 'Step';
  String get of => isSpanish ? 'de' : 'of';
  String get next => isSpanish ? 'Siguiente' : 'Next';
  String get previous => isSpanish ? 'Anterior' : 'Previous';
  String get finish => isSpanish ? 'Finalizar' : 'Finish';
  String get completed => isSpanish ? '¡Completado!' : 'Completed!';
  String get learnMore => isSpanish ? 'Ver más' : 'Learn more';
  String get categories => isSpanish ? 'Categorías' : 'Categories';
  String get all => isSpanish ? 'Todos' : 'All';
  String get filterByCategory => isSpanish ? 'Filtrar' : 'Filter';

  // ── IPv6 Screen ───────────────────────────────────────────────────────────
  String get ipv6AddressInput => isSpanish ? 'Entrada Dirección IPv6' : 'IPv6 Address Input';
  String get ipv6AddressLabel => isSpanish ? 'Dirección IPv6' : 'IPv6 Address';
  String get analyze => isSpanish ? 'Analizar' : 'Analyze';
  String get addressAnalysis => isSpanish ? 'Análisis de Dirección' : 'Address Analysis';
  String get enterIPv6Hint => isSpanish
      ? 'Ingresa una dirección IPv6 para analizarla.\nSoporta notación comprimida y completa.'
      : 'Enter an IPv6 address to analyze it.\nSupports both compressed and full notation.';
  String get exampleAddresses => isSpanish ? 'Direcciones de Ejemplo' : 'Example addresses';

  // ── IPv4 / VLSM Screen ────────────────────────────────────────────────────
  String get calculateVlsm => isSpanish ? 'Calcular VLSM' : 'Calculate VLSM';
  String get stepByStepExplanation => isSpanish ? 'Explicación Paso a Paso' : 'Step-by-Step Explanation';

  // ── NAT type labels ───────────────────────────────────────────────────────
  String get natStatic => isSpanish ? 'NAT Estático' : 'Static NAT';
  String get natDynamic => isSpanish ? 'NAT Dinámico (Pool)' : 'Dynamic NAT (Pool)';
  String get natPat => 'PAT / NAT Overload';
  String get natStaticDesc => isSpanish
      ? 'Una IP privada → una IP pública (servidores, DMZ)'
      : 'One private IP → one public IP (servers, DMZ)';
  String get natDynamicDesc => isSpanish
      ? 'Múltiples IPs privadas mapeadas a un pool de IPs públicas'
      : 'Multiple private IPs mapped to a pool of public IPs';
  String get natPatDesc => isSpanish
      ? 'Muchas IPs privadas → una IP pública con puertos (más común)'
      : 'Many private IPs → one public IP using port numbers (most common)';

  // ── Route types ───────────────────────────────────────────────────────────
  String get ipv4StaticRoute => isSpanish ? 'Ruta Estática IPv4' : 'IPv4 Static Route';
  String get ipv4DefaultRoute => isSpanish ? 'Ruta por Defecto IPv4 (0.0.0.0/0)' : 'IPv4 Default Route (0.0.0.0/0)';
  String get ipv6StaticRoute => isSpanish ? 'Ruta Estática IPv6' : 'IPv6 Static Route';
  String get ipv6DefaultRoute => isSpanish ? 'Ruta por Defecto IPv6 (::/0)' : 'IPv6 Default Route (::/0)';
  String get clearAllRoutes => isSpanish ? 'Limpiar todas las rutas' : 'Clear all routes';
  String get routeCountLabel => isSpanish ? 'ruta(s) agregada(s)' : 'route(s) added';

  // ── VlanPlanner ───────────────────────────────────────────────────────────
  String get deleteAllVlansMsg => isSpanish ? '¿Eliminar todas las VLANs?' : 'Delete all VLANs?';
  String get vlanAdded => isSpanish ? 'VLAN agregada' : 'VLAN added';

  // ── RouterOnStick ─────────────────────────────────────────────────────────
  String get noVlansGoTo => isSpanish
      ? 'Ve al Planificador VLAN primero y agrega tus VLANs.\nLuego regresa aquí para generar la config del router.'
      : 'Go to VLAN Planner first and add your VLANs.\nThen come back here to generate the router config.';
  String get vlanCountConfigured => isSpanish ? 'VLAN(s) configuradas · Trunk:' : 'VLAN(s) configured · Trunk:';

  // ── ACL Builder ───────────────────────────────────────────────────────────
  String get addAclRule => isSpanish ? 'Agregar Regla ACL' : 'Add ACL Rule';
  String get applyAclToInterface => isSpanish ? 'Aplicar ACL a Interfaz' : 'Apply ACL to Interface';
  String get generatedAclTitle => isSpanish ? 'ACL Generada' : 'Generated ACL';
  String get interfaceLabel => isSpanish ? 'Interfaz' : 'Interface';

  static AppStrings from(bool isSpanish) => AppStrings(isSpanish: isSpanish);
}
