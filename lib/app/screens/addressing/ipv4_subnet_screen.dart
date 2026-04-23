import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';

import 'package:flutter/material.dart';
import '../../../app/providers/addressing_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../utils/validators.dart';
import '../../../models/subnet_result.dart';

class IPv4SubnetScreen extends StatefulWidget {
  const IPv4SubnetScreen({super.key});

  @override
  State<IPv4SubnetScreen> createState() => _IPv4SubnetScreenState();
}

class _IPv4SubnetScreenState extends State<IPv4SubnetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _prefixController = TextEditingController();
  bool _showSteps = false;

  @override
  void dispose() {
    _ipController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final prefix = int.tryParse(_prefixController.text.trim()) ?? 0;
    context.read<AddressingProvider>().calculateIPv4(_ipController.text.trim(), prefix);
  }

  void _clear() {
    _ipController.clear();
    _prefixController.clear();
    context.read<AddressingProvider>().clearIPv4();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        title: Text(s.ipv4Calculator),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Input Form ─────────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.input, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: IpInputField(
                              controller: _ipController,
                              validator: Validators.ipv4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: PrefixInputField(
                              controller: _prefixController,
                              validator: (v) => Validators.cidrPrefix(v, min: 0, max: 32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [8, 16, 24, 25, 26, 27, 28, 29, 30]
                            .map((p) => ActionChip(
                                  label: Text('/$p'),
                                  onPressed: () => _prefixController.text = p.toString(),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _calculate,
                              icon: const Icon(Icons.calculate),
                              label: Text(s.calculate),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: _clear,
                            child: Text(s.clear),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Results ────────────────────────────────────────────────────
            Consumer<AddressingProvider>(
              builder: (context, provider, _) {
                if (provider.ipv4Error != null) {
                  return _ErrorBanner(message: provider.ipv4Error!);
                }
                final result = provider.ipv4Result;
                if (result == null) return _PlaceholderHint(s: s);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResultCard(
                      title: s.subnetDetails,
                      data: result.toDisplayMap(),
                      accentColor: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        _Badge(label: 'Class ${result.ipClass}', color: AppTheme.accentBlue),
                        _Badge(
                          label: result.isPrivate ? '🔒 Private (RFC 1918)' : '🌐 Public',
                          color: result.isPrivate ? AppTheme.accentOrange : AppTheme.primaryGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.stepByStepExplanation,
                            style: Theme.of(context).textTheme.headlineSmall),
                        Switch(
                          value: _showSteps,
                          onChanged: (v) => setState(() => _showSteps = v),
                          activeColor: AppTheme.primaryGreen,
                        ),
                      ],
                    ),
                    if (_showSteps) ...[
                      const SizedBox(height: 8),
                      ...(s.isSpanish ? result.steps : result.stepsEn).asMap().entries.map(
                            (e) => StepCard(
                              step: e.value,
                              stepNumber: e.key + 1,
                              initiallyExpanded: e.key == 0,
                            ),
                          ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final didYouMeanMatch = RegExp(r'Did you mean the network (\S+)?').firstMatch(message);
    final suggestedNet = didYouMeanMatch?.group(1);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.error_outline, color: AppTheme.accentRed, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(
            message,
            style: const TextStyle(color: AppTheme.accentRed),
          )),
        ]),
        if (suggestedNet != null) ...[
          const SizedBox(height: 10),
          Builder(builder: (ctx) {
            final s = AppStrings(isSpanish: ctx.watch<LocaleProvider>().isSpanish);
            return OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
                side: const BorderSide(color: AppTheme.primaryGreen),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: () {
                final netOnly = suggestedNet.split('/').first;
                context.read<AddressingProvider>().calculateIPv4(
                  netOnly,
                  int.tryParse(suggestedNet.split('/').last) ?? 24,
                );
              },
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: Text(
                s.isSpanish
                  ? 'Usar dirección de red: $suggestedNet'
                  : 'Use network address: $suggestedNet',
                style: const TextStyle(fontSize: 12),
              ),
            );
          }),
        ],
      ]),
    );
  }
}

class _PlaceholderHint extends StatelessWidget {
  final AppStrings s;
  const _PlaceholderHint({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('🔢', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              s.enterIpAndPrefix,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
