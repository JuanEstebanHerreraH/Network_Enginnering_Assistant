/// ResultCard, CodeBlock, StepCard
/// Display components for subnet results, configurations, and explanations.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';

// ─── ResultCard ───────────────────────────────────────────────────────────────
class ResultCard extends StatelessWidget {
  final String title;
  final Map<String, String> data;
  final Color? accentColor;

  const ResultCard({super.key, required this.title, required this.data, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? AppTheme.primaryGreen;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 4, height: 18, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
          ]),
          const Divider(height: 20),
          ...data.entries.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 140, child: Text(e.key,
                style: TextStyle(color: isDark ? AppTheme.textSecondary : Colors.grey[600], fontSize: 13))),
              Expanded(child: SelectableText(e.value,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w500))),
            ]),
          )),
        ]),
      ),
    );
  }
}

// ─── CodeBlock ────────────────────────────────────────────────────────────────
/// Single-finger horizontal scroll on mobile (no SelectableText inside scroll area).
class CodeBlock extends StatelessWidget {
  final String code;
  final String? label;

  const CodeBlock({super.key, required this.code, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != null) ...[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label!, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13)),
          _CopyButton(text: code),
        ]),
        const SizedBox(height: 8),
      ],
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.codeBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Stack(children: [
          // Scrollable code — uses Text (not SelectableText) so single-finger scroll works on mobile
          Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              physics: const BouncingScrollPhysics(),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace', fontSize: 13,
                  color: AppTheme.textPrimary, height: 1.6,
                ),
              ),
            ),
          ),
          if (label == null)
            Positioned(top: 8, right: 8, child: _CopyButton(text: code)),
        ]),
      ),
    ]);
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton({required this.text});
  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _copied
          ? const Icon(Icons.check, color: AppTheme.primaryGreen, size: 18, key: ValueKey('check'))
          : IconButton(
              key: const ValueKey('copy'),
              icon: const Icon(Icons.copy, size: 16),
              onPressed: _copy,
              tooltip: 'Copy',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
    );
  }
}

// ─── StepCard ─────────────────────────────────────────────────────────────────
class StepCard extends StatelessWidget {
  final String step;
  final int stepNumber;
  final bool initiallyExpanded;

  const StepCard({super.key, required this.step, required this.stepNumber, this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    final lines = step.split('\n');
    final title = lines.first.trim();
    final content = lines.skip(1).join('\n').trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
          child: Center(child: Text('$stepNumber',
            style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13))),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.codeBackground, borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Text(content,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: AppTheme.textPrimary, height: 1.6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SectionHeader ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const SectionHeader({super.key, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium)],
        ])),
        if (action != null) action!,
      ]),
    );
  }
}
