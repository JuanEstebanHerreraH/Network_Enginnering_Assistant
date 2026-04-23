import 'package:go_router/go_router.dart';
/// IPv6Screen
/// UI for IPv6 address analysis and prefix calculator.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../app/providers/addressing_provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../core/ipv6_calculator.dart';

class IPv6Screen extends StatefulWidget {
  const IPv6Screen({super.key});

  @override
  State<IPv6Screen> createState() => _IPv6ScreenState();
}

class _IPv6ScreenState extends State<IPv6Screen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _prefixController = TextEditingController(text: '64');
  bool _showSteps = false;

  @override
  void dispose() {
    _addressController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final prefix = int.tryParse(_prefixController.text.trim()) ?? 64;
    context
        .read<AddressingProvider>()
        .calculateIPv6(_addressController.text.trim(), prefix);
  }

  @override
  Widget build(BuildContext context) {
    final isSpanish = context.watch<LocaleProvider>().isSpanish;
    final s = AppStrings(isSpanish: isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'),), title: Text(s.ipv6Analyzer)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Form ───────────────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.ipv6AddressInput,
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _addressController,
                        label: s.ipv6AddressLabel,
                        hint: '2001:db8::1',
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return isSpanish ? 'Ingresa una dirección IPv6' : 'Enter an IPv6 address';
                          }
                          if (!IPv6Calculator.isValid(v.trim())) {
                            return isSpanish ? 'Dirección IPv6 inválida' : 'Invalid IPv6 address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _prefixController,
                        label: s.prefixLength,
                        hint: '64',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n < 0 || n > 128) {
                            return isSpanish ? 'El prefijo debe ser 0–128' : 'Prefix must be 0–128';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Common prefix quick-select
                      Wrap(
                        spacing: 8,
                        children: ['/48', '/64', '/96', '/128']
                            .asMap()
                            .entries
                            .map((e) => ActionChip(
                                  label:
                                      Text(['/48', '/64', '/96', '/128'][e.key]),
                                  onPressed: () {
                                    _prefixController.text =
                                        [48, 64, 96, 128][e.key].toString();
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.search),
                        label: Text(s.analyze),
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
                if (provider.ipv6Error != null) {
                  return _ErrorCard(message: provider.ipv6Error!);
                }
                final result = provider.ipv6Result;
                if (result == null) {
                  return _IPv6Placeholder();
                }

                // Expand/compress the entered address
                final expanded =
                    IPv6Calculator.expand(_addressController.text.trim());
                final compressed =
                    IPv6Calculator.compress(expanded);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResultCard(
                      title: s.addressAnalysis,
                      data: {
                        (isSpanish ? 'Entrada' : 'Input'): _addressController.text.trim(),
                        (isSpanish ? 'Expandida' : 'Expanded'): expanded,
                        (isSpanish ? 'Comprimida' : 'Compressed'): compressed,
                        (isSpanish ? 'Tipo' : 'Type'): result.addressType,
                        (isSpanish ? 'Prefijo' : 'Prefix'): '/${result.prefixLength}',
                        (isSpanish ? 'Red' : 'Network'): result.networkAddress,
                        (isSpanish ? 'Primera Dirección' : 'First Address'): result.firstHost,
                        (isSpanish ? 'Última Dirección' : 'Last Address'): result.lastHost,
                        (isSpanish ? 'Total Direcciones' : 'Total Addresses'): result.totalAddresses.toString(),
                      },
                      accentColor: AppTheme.accentBlue,
                    ),
                    const SizedBox(height: 20),

                    // Steps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.stepByStep,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Switch(
                          value: _showSteps,
                          onChanged: (v) =>
                              setState(() => _showSteps = v),
                          activeColor: AppTheme.accentBlue,
                        ),
                      ],
                    ),
                    if (_showSteps)
                      ...(isSpanish ? result.stepsEn : result.steps).asMap().entries.map(
                            (e) => StepCard(
                              step: e.value,
                              stepNumber: e.key + 1,
                              initiallyExpanded: e.key == 0,
                            ),
                          ),
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

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.4)),
      ),
      child: Text(message,
          style: const TextStyle(color: AppTheme.accentRed)),
    );
  }
}

class _IPv6Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('🌐', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Builder(builder: (ctx) {
              final s2 = AppStrings(isSpanish: ctx.watch<LocaleProvider>().isSpanish);
              return Text(s2.enterIPv6Hint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            );
            }),
            const SizedBox(height: 20),
            _ExampleCard(),
          ],
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (ctx) {
              final s2 = AppStrings(isSpanish: ctx.watch<LocaleProvider>().isSpanish);
              return Text(s2.exampleAddresses, style: Theme.of(context).textTheme.labelLarge);
            }),
            const SizedBox(height: 8),
            ...[
              '2001:db8::1',
              'fe80::1',
              'fc00::1',
              '::1',
              'ff02::1',
            ].map((a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(a, style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppTheme.textPrimary, height: 1.6)),
                )),
          ],
        ),
      ),
    );
  }
}
