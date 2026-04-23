import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../utils/app_strings.dart';
import 'tutorials_data.dart';

class GuideScreen extends StatefulWidget {
  final String guideId;
  const GuideScreen({super.key, required this.guideId});
  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentStep = 0;
  bool _completed = false;

  static const _diffColor = {
    'Básico': AppTheme.primaryGreen,
    'Intermedio': AppTheme.accentOrange,
    'Avanzado': AppTheme.accentRed,
  };

  @override
  Widget build(BuildContext context) {
    final isEs = context.watch<LocaleProvider>().isSpanish;
    final s = AppStrings(isSpanish: isEs);
    final guide = guideList.firstWhere((g) => g.id == widget.guideId, orElse: () => guideList.first);
    final color = _diffColor[guide.difficulty] ?? AppTheme.primaryGreen;
    final step = guide.steps[_currentStep];
    final isLast = _currentStep == guide.steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          if (_currentStep > 0 && !_completed) {
            setState(() => _currentStep--);
          } else {
            context.go('/tutorials');
          }
        }),
        title: Text(isEs ? guide.titleEs : guide.titleEn, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(child: Text(
              '${s.step} ${_currentStep + 1} ${s.of} ${guide.steps.length}',
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
            )),
          ),
        ],
      ),
      body: _completed ? _CompletedView(guide: guide, isEs: isEs, s: s, onRestart: () => setState(() { _currentStep = 0; _completed = false; }), onBack: () => context.go('/tutorials'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / guide.steps.length,
                    backgroundColor: AppTheme.borderDark,
                    color: color,
                    minHeight: 4,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // Step indicator row
                        Row(children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: color.withOpacity(0.5))),
                            child: Center(child: Text('${_currentStep + 1}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(isEs ? step.titleEs : step.titleEn,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        ]),
                        const SizedBox(height: 14),

                        // Content
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderDark),
                          ),
                          child: Text(isEs ? step.contentEs : step.contentEn,
                              style: const TextStyle(fontSize: 14, height: 1.7)),
                        ),
                        const SizedBox(height: 14),

                        // Code example
                        if (step.codeExample != null) ...[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text('Cisco IOS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16, color: AppTheme.textSecondary),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              tooltip: s.copy,
                              onPressed: () {
                                final code = isEs ? step.codeExample! : (step.codeExampleEn ?? step.codeExample!);
                                Clipboard.setData(ClipboardData(text: code));
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(s.copied), duration: const Duration(seconds: 1)));
                              },
                            ),
                          ]),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.codeBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.borderDark),
                            ),
                            child: SelectableText(isEs ? step.codeExample! : (step.codeExampleEn ?? step.codeExample!),
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppTheme.textPrimary, height: 1.6)),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Tip
                        if (step.tip != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.accentOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.accentOrange.withOpacity(0.3)),
                            ),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('💡 ', style: TextStyle(fontSize: 16)),
                              Expanded(child: Text(
                                isEs ? step.tip! : (step.tipEn ?? step.tip!),
                                style: const TextStyle(color: AppTheme.accentOrange, fontSize: 13, height: 1.4))),
                            ]),
                          ),

                        // Step dots
                        const SizedBox(height: 20),
                        Center(child: Wrap(spacing: 6, children: List.generate(guide.steps.length, (i) =>
                          Container(
                            width: i == _currentStep ? 20 : 8, height: 8,
                            decoration: BoxDecoration(
                              color: i <= _currentStep ? color : AppTheme.borderDark,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ))),
                      ]),
                    ),
                  ),

                  // Navigation buttons
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppTheme.borderDark))),
                    child: Row(children: [
                      if (_currentStep > 0)
                        OutlinedButton.icon(
                          onPressed: () => setState(() => _currentStep--),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: Text(s.previous),
                        ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isLast) { setState(() => _completed = true); }
                          else { setState(() => _currentStep++); }
                        },
                        icon: Icon(isLast ? Icons.check : Icons.arrow_forward, size: 16),
                        label: Text(isLast ? s.finish : s.next),
                        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: AppTheme.primaryDark),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
    );
  }
}

class _CompletedView extends StatelessWidget {
  final StepGuide guide;
  final bool isEs;
  final AppStrings s;
  final VoidCallback onRestart;
  final VoidCallback onBack;
  const _CompletedView({required this.guide, required this.isEs, required this.s, required this.onRestart, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🎉', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(s.completed, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
          const SizedBox(height: 10),
          Text(isEs ? '¡Completaste "${guide.titleEs}"!' : 'You completed "${guide.titleEn}"!',
              textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
          const SizedBox(height: 8),
          Text(isEs ? 'Completaste ${guide.steps.length} pasos correctamente.' : 'You completed ${guide.steps.length} steps successfully.',
              textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton.icon(onPressed: onRestart, icon: const Icon(Icons.refresh, size: 16), label: Text(isEs ? 'Repetir' : 'Restart')),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: onBack, icon: const Icon(Icons.library_books_outlined, size: 16), label: Text(isEs ? 'Más tutoriales' : 'More tutorials')),
          ]),
        ]),
      ),
    );
  }
}
