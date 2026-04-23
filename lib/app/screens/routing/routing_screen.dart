import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../components/app_card.dart';
import '../../../components/result_card.dart';
import '../../../engine/explanation_engine.dart';
import '../../../utils/app_strings.dart';

class RoutingScreen extends StatelessWidget {
  const RoutingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    final isSpanish = s.isSpanish;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(s.routingAssistant)),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.routingSubtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          InkWell(onTap: () => context.go('/routing/static'), borderRadius: BorderRadius.circular(12),
            child: AppCard(child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppTheme.accentOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(11)),
                child: const Center(child: Text('🗺️', style: TextStyle(fontSize: 24)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.staticRouteGenerator, style: Theme.of(context).textTheme.labelLarge),
                Text(s.staticRouteDesc, style: Theme.of(context).textTheme.bodyMedium),
              ])),
              const Icon(Icons.chevron_right, color: AppTheme.accentOrange),
            ]))),
          const SizedBox(height: 18),
          Text(s.routingConcepts, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          ...['rip', 'ospf', 'static_routing'].map<Widget>((key) {
            final lesson = ExplanationEngine.lessons[key];
            if (lesson == null) return const SizedBox();
            return Padding(padding: const EdgeInsets.only(bottom: 8), child: AppCard(child: ExpansionTile(
              tilePadding: EdgeInsets.zero, dense: true,
              leading: Text(lesson.icon, style: const TextStyle(fontSize: 20)),
              title: Text(lesson.title(isSpanish), style: Theme.of(context).textTheme.labelLarge),
              subtitle: Text(lesson.summary(isSpanish), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
              children: [Padding(padding: const EdgeInsets.only(bottom: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(),
                ...lesson.sections.map<Widget>((sec) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(sec.heading(isSpanish), style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryGreen, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(sec.content(isSpanish), style: const TextStyle(fontSize: 12, height: 1.5)),
                  if (sec.codeExample(isSpanish) != null) ...[const SizedBox(height: 6), CodeBlock(code: sec.codeExample(isSpanish)!)],
                ]))).toList(),
              ]))],
            )));
          }).toList(),
        ])),
      )),
    );
  }
}
