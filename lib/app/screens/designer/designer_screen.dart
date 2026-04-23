/// DesignerScreen — Hub for the Network Designer module.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../components/app_card.dart';
import '../../../utils/app_strings.dart';

class DesignerScreen extends StatelessWidget {
  const DesignerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(title: Text(s.networkDesigner)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.networkDesigner, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(s.designerSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              _ToolCard(icon: '🔀', title: s.vlanPlanner, description: s.vlanPlannerDesc,
                  color: AppTheme.accentBlue, onTap: () => context.go('/designer/vlans')),
              const SizedBox(height: 12),
              _ToolCard(icon: '🍡', title: s.routerOnStick, description: s.routerOnStickDesc,
                  color: AppTheme.primaryGreen, onTap: () => context.go('/designer/router-on-stick')),
            ]),
          ),
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String icon, title, description;
  final Color color;
  final VoidCallback onTap;
  const _ToolCard({required this.icon, required this.title, required this.description,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: AppCard(child: Row(children: [
        Container(width: 52, height: 52,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 26)))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ])),
        Icon(Icons.chevron_right, color: color),
      ])),
    );
  }
}
