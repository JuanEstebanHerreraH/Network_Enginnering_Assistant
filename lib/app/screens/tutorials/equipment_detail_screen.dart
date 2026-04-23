import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import 'tutorials_data.dart';

class EquipmentDetailScreen extends StatelessWidget {
  final String equipmentId;
  const EquipmentDetailScreen({super.key, required this.equipmentId});

  static const _colors = {
    '00C896': AppTheme.primaryGreen,
    '58A6FF': AppTheme.accentBlue,
    'FF7B72': AppTheme.accentRed,
    'D2A8FF': AppTheme.accentPurple,
    'F0883E': AppTheme.accentOrange,
    '26C6DA': AppTheme.accentBlue,   // cloud teal
  };

  @override
  Widget build(BuildContext context) {
    final eq = equipmentList.firstWhere((e) => e.id == equipmentId, orElse: () => equipmentList.first);
    final isEs = context.watch<LocaleProvider>().isSpanish;

    // Strip '#' in case it slips through, then look up color
    final hexKey = eq.accentHex.replaceAll('#', '');
    final color = _colors[hexKey] ?? AppTheme.primaryGreen;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/tutorials')),
        title: Text(isEs ? eq.nameEs : eq.nameEn),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Hero card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(children: [
                  Text(eq.icon, style: const TextStyle(fontSize: 52)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isEs ? eq.nameEs : eq.nameEn,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(eq.layer,
                          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Text(isEs ? eq.summaryEs : eq.summaryEn,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
                  ])),
                ]),
              ),
              const SizedBox(height: 16),

              // Specs table (bilingual)
              _SectionCard(
                title: isEs ? '⚙️ Especificaciones Técnicas' : '⚙️ Technical Specs',
                color: color,
                child: Column(children: eq.specs.map((spec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        isEs ? spec.label : (spec.labelEn ?? spec.label),
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ),
                    Expanded(child: Text(
                      isEs ? spec.value : (spec.valueEn ?? spec.value),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'monospace'),
                    )),
                  ]),
                )).toList()),
              ),
              const SizedBox(height: 12),

              // Features
              _SectionCard(
                title: isEs ? '✅ Características Principales' : '✅ Key Features',
                color: color,
                child: Column(children: eq.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('• ', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13, height: 1.4))),
                  ]),
                )).toList()),
              ),
              const SizedBox(height: 12),

              // Use cases
              _SectionCard(
                title: isEs ? '🏢 Casos de Uso' : '🏢 Use Cases',
                color: color,
                child: Column(children: eq.useCases.map((u) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.check_circle_outline, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(u, style: const TextStyle(fontSize: 13, height: 1.4))),
                  ]),
                )).toList()),
              ),
              const SizedBox(height: 12),

              // Cisco models
              if (eq.ciscoModels != null)
                _SectionCard(
                  title: isEs ? '🔵 Modelos Cisco' : '🔵 Cisco Models',
                  color: const Color(0xFF1BA0D7),
                  child: Row(children: [
                    const Text('🔵', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(eq.ciscoModels!,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13))),
                  ]),
                ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;
  const _SectionCard({required this.title, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 3, height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    ));
  }
}
