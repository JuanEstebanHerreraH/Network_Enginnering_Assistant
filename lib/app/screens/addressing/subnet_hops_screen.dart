/// SubnetHopsScreen
/// Visual subnet hop calculator — shows subnets derived from a given
/// network address and prefix. Results are loaded on demand (paginated).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/ip_utils.dart';
import '../../../utils/validators.dart';

class SubnetHopsScreen extends StatefulWidget {
  const SubnetHopsScreen({super.key});
  @override
  State<SubnetHopsScreen> createState() => _SubnetHopsScreenState();
}

class _SubnetHopsScreenState extends State<SubnetHopsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipCtrl = TextEditingController();
  final _prefixCtrl = TextEditingController(text: '24');

  List<_SubnetRow>? _allRows;
  int _visibleCount = 20;
  static const int _pageSize = 20;

  int _blockSize = 0;
  String _network = '';
  int _prefix = 24;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final prefix = int.tryParse(_prefixCtrl.text.trim()) ?? 24;
    final ip = _ipCtrl.text.trim();
    final networkStr = IpUtils.networkAddress(ip, prefix);
    final block = IpUtils.totalAddresses(prefix);
    final networkInt = IpUtils.ipToInt(networkStr);

    int parentPrefix;
    if (prefix <= 8) parentPrefix = 0;
    else if (prefix <= 16) parentPrefix = 8;
    else if (prefix <= 24) parentPrefix = 16;
    else parentPrefix = 24;

    final parentBlock = IpUtils.totalAddresses(parentPrefix);
    final parentNetInt = parentPrefix == 0
        ? 0
        : IpUtils.ipToInt(IpUtils.networkAddress(networkStr, parentPrefix));

    final count = (parentBlock ~/ block).clamp(1, 256);
    final rows = <_SubnetRow>[];

    for (int i = 0; i < count; i++) {
      final netInt = parentNetInt + (block * i);
      if (netInt < 0 || netInt > 0xFFFFFFFF) break;
      final bcInt = (netInt + block - 1).clamp(0, 0xFFFFFFFF);
      final firstInt = (netInt + 1).clamp(0, 0xFFFFFFFF);
      final lastInt = (bcInt - 1).clamp(0, 0xFFFFFFFF);
      rows.add(_SubnetRow(
        index: i,
        network: IpUtils.intToIp(netInt),
        first: prefix >= 31 ? IpUtils.intToIp(netInt) : IpUtils.intToIp(firstInt),
        last: prefix >= 31 ? IpUtils.intToIp(bcInt) : IpUtils.intToIp(lastInt),
        broadcast: IpUtils.intToIp(bcInt),
        isCurrent: netInt == networkInt,
        crossesBoundary: i > 0 && _crossesBoundary(netInt, block),
      ));
    }

    setState(() {
      _allRows = rows;
      _visibleCount = _pageSize;
      _blockSize = block;
      _network = networkStr;
      _prefix = prefix;
    });
  }

  bool _crossesBoundary(int netInt, int block) {
    final prev = netInt - block;
    if (prev < 0) return false;
    final prevOctet3 = (prev >> 8) & 0xFF;
    final currOctet3 = (netInt >> 8) & 0xFF;
    return prevOctet3 != currOctet3;
  }

  void _loadMore() {
    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(0, _allRows!.length);
    });
  }

  void _clear() {
    _ipCtrl.clear();
    _prefixCtrl.text = '24';
    setState(() {
      _allRows = null;
      _visibleCount = _pageSize;
    });
  }

  @override
  void dispose() {
    _ipCtrl.dispose();
    _prefixCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    final isSp = s.isSpanish;

    final visibleRows = _allRows == null
        ? null
        : _allRows!.take(_visibleCount).toList();
    final hasMore = _allRows != null && _visibleCount < _allRows!.length;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/addressing')),
        title: Text(isSp ? 'Tabla de Saltos de Subred' : 'Subnet Hop Table'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Concept card ────────────────────────────────────────────────
              _ConceptCard(isSp: isSp),
              const SizedBox(height: 16),

              // ── Input form ──────────────────────────────────────────────────
              Card(child: Padding(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isSp ? 'Calcular tabla de subredes' : 'Calculate subnet table',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 14),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 3, child: IpInputField(
                        controller: _ipCtrl,
                        validator: Validators.ipv4,
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: PrefixInputField(
                        controller: _prefixCtrl,
                        validator: (v) => Validators.cidrPrefix(v, min: 0, max: 30),
                      )),
                    ]),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6, runSpacing: 4,
                      children: [16, 17, 18, 19, 20, 24, 25, 26, 27, 28, 29, 30]
                          .map((p) => ActionChip(
                                label: Text('/$p', style: const TextStyle(fontSize: 11)),
                                onPressed: () => _prefixCtrl.text = p.toString(),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.table_chart, size: 16),
                        label: Text(isSp ? 'Generar Tabla' : 'Generate Table'),
                      )),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _clear,
                        child: Text(s.clear),
                      ),
                    ]),
                  ]),
                ),
              )),
              const SizedBox(height: 16),

              // ── Unusual prefix warning ──────────────────────────────────────
              if (_allRows != null && _prefix <= 8) ...[
                _UnusualPrefixWarning(prefix: _prefix, isSp: isSp),
                const SizedBox(height: 12),
              ],

              // ── Result table ────────────────────────────────────────────────
              if (visibleRows != null) ...[
                _SubnetTable(
                  rows: visibleRows,
                  prefix: _prefix,
                  blockSize: _blockSize,
                  network: _network,
                  isSp: isSp,
                  totalCount: _allRows!.length,
                  visibleCount: _visibleCount,
                ),
                const SizedBox(height: 12),
                if (hasMore)
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: _loadMore,
                      icon: const Icon(Icons.expand_more, size: 18),
                      label: Text(
                        isSp
                          ? 'Mostrar más (${_allRows!.length - _visibleCount} restantes)'
                          : 'Show more (${_allRows!.length - _visibleCount} remaining)',
                        style: const TextStyle(fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentBlue,
                        side: const BorderSide(color: AppTheme.accentBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                if (!hasMore && _allRows!.length > _pageSize)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        isSp
                          ? '✓ Mostrando todas las ${_allRows!.length} subredes'
                          : '✓ Showing all ${_allRows!.length} subnets',
                        style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Concept explanation card ───────────────────────────────────────────────────
class _ConceptCard extends StatelessWidget {
  final bool isSp;
  const _ConceptCard({required this.isSp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('📶', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(
            isSp ? '¿Qué son los saltos de subred?' : 'What are subnet hops?',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          )),
        ]),
        const SizedBox(height: 8),
        Text(
          isSp
            ? 'Cuando divides una red con un prefijo /N, el espacio de IPs se parte en bloques del mismo tamaño. '
              'Cada bloque es una subred. El "salto" es la diferencia entre la dirección de red de una subred y la siguiente.\n\n'
              'Ejemplo con /26 (bloques de 64):\n'
              '  .0   → .63    (primera subred)\n'
              '  .64  → .127   (segunda subred, salto +64)\n'
              '  .128 → .191   (tercera subred, salto +64)\n'
              '  .192 → .255   (cuarta subred, salto +64)\n\n'
              'Cuando el último octeto llega a 255, el tercero incrementa en 1 y el cuarto vuelve a 0.'
            : 'When you subnet with prefix /N, the IP space is split into equal-sized blocks. '
              'Each block is a subnet. The "hop" is the difference between consecutive network addresses.\n\n'
              'Example with /26 (64-address blocks):\n'
              '  .0   → .63    (first subnet)\n'
              '  .64  → .127   (second subnet, hop +64)\n'
              '  .128 → .191   (third subnet, hop +64)\n'
              '  .192 → .255   (fourth subnet, hop +64)\n\n'
              'When the last octet reaches 255, the third octet increments by 1 and the fourth resets to 0.',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5, fontFamily: 'monospace'),
        ),
      ]),
    );
  }
}

// ── Subnet Table ───────────────────────────────────────────────────────────────
class _SubnetTable extends StatelessWidget {
  final List<_SubnetRow> rows;
  final int prefix;
  final int blockSize;
  final String network;
  final bool isSp;
  final int totalCount;
  final int visibleCount;

  const _SubnetTable({
    required this.rows,
    required this.prefix,
    required this.blockSize,
    required this.network,
    required this.isSp,
    required this.totalCount,
    required this.visibleCount,
  });

  @override
  Widget build(BuildContext context) {
    final usable = blockSize <= 2 ? 0 : blockSize - 2;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Summary chips
      Wrap(spacing: 8, runSpacing: 6, children: [
        _InfoChip(
          label: isSp ? 'Bloque: $blockSize IPs' : 'Block: $blockSize IPs',
          color: AppTheme.accentBlue,
        ),
        _InfoChip(
          label: isSp ? 'Salto: +$blockSize' : 'Hop: +$blockSize',
          color: AppTheme.accentOrange,
        ),
        _InfoChip(
          label: isSp ? 'Hosts útiles: $usable' : 'Usable hosts: $usable',
          color: AppTheme.primaryGreen,
        ),
        _InfoChip(
          label: isSp ? '$totalCount subredes' : '$totalCount subnets',
          color: AppTheme.accentPurple,
        ),
      ]),
      const SizedBox(height: 8),
      Text(
        isSp
          ? 'Mostrando $visibleCount de $totalCount subredes'
          : 'Showing $visibleCount of $totalCount subnets',
        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
      ),
      const SizedBox(height: 10),

      // Table — columnas con Expanded para llenar todo el ancho disponible
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(children: [
              const SizedBox(width: 32,
                child: Text('#', style: _hStyle)),
              const SizedBox(width: 6),
              Expanded(flex: 3, child: Text(isSp ? 'Red' : 'Network', style: _hStyle)),
              Expanded(flex: 3, child: Text(isSp ? 'Primer host' : 'First host', style: _hStyle)),
              Expanded(flex: 3, child: Text(isSp ? 'Último host' : 'Last host', style: _hStyle)),
              Expanded(flex: 3, child: Text('Broadcast', style: _hStyle)),
            ]),
          ),
          // Table rows
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderDark),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Column(children: [
              for (int i = 0; i < rows.length; i++) ...[
                if (rows[i].crossesBoundary)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    color: AppTheme.accentOrange.withOpacity(0.08),
                    child: Text(
                      isSp ? '▼ Nuevo octeto (salto de segmento)' : '▼ New octet (segment hop)',
                      style: const TextStyle(
                        color: AppTheme.accentOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                _TableRow(row: rows[i], prefix: prefix, isSp: isSp, isLast: i == rows.length - 1),
              ],
            ]),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        isSp
          ? '* Red = dirección no asignable. Broadcast = última dirección, no asignable.'
          : '* Network = non-assignable. Broadcast = last address, non-assignable.',
        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
      ),
    ]);
  }

  static const _hStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: AppTheme.accentBlue,
  );
}

class _TableRow extends StatelessWidget {
  final _SubnetRow row;
  final int prefix;
  final bool isSp;
  final bool isLast;

  const _TableRow({required this.row, required this.prefix, required this.isSp, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final bg = row.isCurrent
        ? AppTheme.primaryGreen.withOpacity(0.10)
        : (row.index % 2 == 0 ? Colors.transparent : AppTheme.surfaceDark.withOpacity(0.5));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        border: row.isCurrent
            ? Border.all(color: AppTheme.primaryGreen.withOpacity(0.4))
            : null,
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(9)) : null,
      ),
      child: Row(children: [
        SizedBox(
          width: 32,
          child: Text(
            '${row.index + 1}',
            style: TextStyle(
              fontSize: 11,
              color: row.isCurrent ? AppTheme.primaryGreen : AppTheme.textSecondary,
              fontWeight: row.isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(flex: 3, child: _cell('${row.network}/$prefix',
            row.isCurrent ? AppTheme.primaryGreen : AppTheme.textPrimary, row.isCurrent)),
        Expanded(flex: 3, child: _cell(row.first, AppTheme.accentBlue.withOpacity(row.isCurrent ? 1.0 : 0.7), false)),
        Expanded(flex: 3, child: _cell(row.last, AppTheme.accentBlue.withOpacity(row.isCurrent ? 1.0 : 0.7), false)),
        Expanded(flex: 3, child: _cell(row.broadcast, AppTheme.accentRed.withOpacity(row.isCurrent ? 1.0 : 0.6), false)),
      ]),
    );
  }

  Widget _cell(String text, Color color, bool bold) => Text(
    text,
    style: TextStyle(
      fontSize: 11,
      fontFamily: 'monospace',
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    ),
    overflow: TextOverflow.ellipsis,
  );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Unusual prefix warning widget ─────────────────────────────────────────────
class _UnusualPrefixWarning extends StatelessWidget {
  final int prefix;
  final bool isSp;
  const _UnusualPrefixWarning({required this.prefix, required this.isSp});

  String get _maskDotted {
    final bits = prefix == 0 ? 0 : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    return '${(bits >> 24) & 0xFF}.${(bits >> 16) & 0xFF}.${(bits >> 8) & 0xFF}.${bits & 0xFF}';
  }

  int get _subnets => prefix == 0 ? 1 : 2;
  String get _hostsPerSubnet {
    final h = (1 << (32 - prefix)) - 2;
    if (h >= 1000000000) return '${(h / 1000000000).toStringAsFixed(1)}B';
    if (h >= 1000000) return '${(h / 1000000).toStringAsFixed(1)}M';
    return h.toString();
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9800);
    final tipEs = prefix <= 4
        ? 'Mascara /$prefix = $_maskDotted — genera solo $_subnets subred(es) con ~$_hostsPerSubnet hosts cada una. Esto cubre una porcion enorme del espacio IPv4 y rara vez se usa en redes reales. Para subnetting practico usa /16 a /30.'
        : 'Mascara /$prefix = $_maskDotted — genera pocas subredes muy grandes (~$_hostsPerSubnet hosts c/u). Las mascaras menores a /8 son inusuales en redes tipicas. Si buscas subnetting practico, prueba con /24, /25 o /26.';
    final tipEn = prefix <= 4
        ? 'Mask /$prefix = $_maskDotted — generates only $_subnets subnet(s) with ~$_hostsPerSubnet hosts each. This covers a huge portion of the IPv4 space and is rarely used in real networks. For practical subnetting use /16 to /30.'
        : 'Mask /$prefix = $_maskDotted — generates very few but huge subnets (~$_hostsPerSubnet hosts each). Prefixes smaller than /8 are unusual in typical networks. For practical subnetting try /24, /25, or /26.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: orange.withOpacity(0.45), width: 1.4),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.warning_amber_rounded, color: orange, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            isSp ? 'Mascara inusual detectada (/$prefix)' : 'Unusual mask detected (/$prefix)',
            style: const TextStyle(color: orange, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            isSp ? tipEs : tipEn,
            style: const TextStyle(fontSize: 12, height: 1.45),
          ),
        ])),
      ]),
    );
  }
}

class _SubnetRow {
  final int index;
  final String network, first, last, broadcast;
  final bool isCurrent, crossesBoundary;
  const _SubnetRow({
    required this.index,
    required this.network,
    required this.first,
    required this.last,
    required this.broadcast,
    required this.isCurrent,
    required this.crossesBoundary,
  });
}
