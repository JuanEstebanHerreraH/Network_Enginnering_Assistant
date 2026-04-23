import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../utils/app_strings.dart';
import '../../../components/app_card.dart';

class AddressingScreen extends StatelessWidget {
  const AddressingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(s.addressingTools)),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.addressingSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          _ToolCard(icon: '🔢', title: s.ipv4Calculator, description: s.ipv4Desc, color: AppTheme.primaryGreen, onTap: () => context.go('/addressing/ipv4')),
          const SizedBox(height: 10),
          _ToolCard(icon: '🌐', title: s.ipv6Analyzer, description: s.ipv6Desc, color: AppTheme.accentBlue, onTap: () => context.go('/addressing/ipv6')),
          const SizedBox(height: 10),
          _ToolCard(icon: '📐', title: s.vlsmCalculator, description: s.vlsmDesc, color: AppTheme.accentOrange, onTap: () => context.go('/addressing/vlsm')),
          const SizedBox(height: 10),
          _ToolCard(
            icon: '📶',
            title: s.isSpanish ? 'Tabla de Saltos de Subred' : 'Subnet Hop Table',
            description: s.isSpanish
                ? 'Visualiza todos los bloques de una red: red, primer host, último host y broadcast.'
                : 'Visualize all subnets in a network: network, first host, last host and broadcast.',
            color: const Color(0xFF26C6DA),
            onTap: () => context.go('/addressing/hops'),
          ),
        ])),
      )),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String icon, title, description;
  final Color color;
  final VoidCallback onTap;
  const _ToolCard({required this.icon, required this.title, required this.description, required this.color, required this.onTap});

  void _showInfo(BuildContext context) {
    showDialog(context: context, builder: (dialogCtx) => AlertDialog(
      backgroundColor: AppTheme.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
      ]),
      content: Text(description,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cerrar / Close')),
        ElevatedButton(onPressed: () { Navigator.of(dialogCtx).pop(); onTap(); }, child: const Text('Abrir / Open')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: AppCard(child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(icon, style: const TextStyle(fontSize: 22)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(description, style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2, overflow: TextOverflow.ellipsis),
      ])),
      GestureDetector(
        onTap: () => _showInfo(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.info_outline, size: 18, color: AppTheme.textSecondary.withOpacity(0.6)),
        ),
      ),
      Icon(Icons.chevron_right, color: color, size: 18),
    ])));
  }
}
