import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';

import 'package:flutter/material.dart';
import '../../../app/providers/addressing_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../models/vlan_model.dart';
import '../../../utils/validators.dart';

class VlsmScreen extends StatefulWidget {
  const VlsmScreen({super.key});

  @override
  State<VlsmScreen> createState() => _VlsmScreenState();
}

class _VlsmScreenState extends State<VlsmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseNetworkController = TextEditingController();
  final _basePrefixController = TextEditingController(text: '24');

  final List<_SegmentRow> _rows = [];
  final _segNameController = TextEditingController();
  final _segHostsController = TextEditingController();
  bool _showSteps = false;

  @override
  void dispose() {
    _baseNetworkController.dispose();
    _basePrefixController.dispose();
    _segNameController.dispose();
    _segHostsController.dispose();
    super.dispose();
  }

  void _addSegment() {
    final name = _segNameController.text.trim();
    final hosts = int.tryParse(_segHostsController.text.trim());
    if (name.isEmpty || hosts == null || hosts <= 0) return;
    setState(() {
      _rows.add(_SegmentRow(name: name, hosts: hosts));
      _segNameController.clear();
      _segHostsController.clear();
    });
  }

  void _removeSegment(int index) {
    setState(() => _rows.removeAt(index));
  }

  void _calculate(AppStrings s) {
    if (!_formKey.currentState!.validate()) return;
    if (_rows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.addAtLeastOneSegment)),
      );
      return;
    }
    final entries = _rows.map((r) => VlsmEntry(name: r.name, requiredHosts: r.hosts)).toList();
    final prefix = int.tryParse(_basePrefixController.text.trim()) ?? 24;
    context.read<AddressingProvider>().calculateVlsm(
          _baseNetworkController.text.trim(),
          prefix,
          entries,
          isSpanish: s.isSpanish,
        );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(title: Text(s.vlsmCalculator)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Base Network ───────────────────────────────────────────────
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.baseNetwork, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: IpInputField(
                              controller: _baseNetworkController,
                              label: s.baseNetwork,
                              validator: (v) {
                                final basic = Validators.ipv4(v);
                                if (basic != null) return basic;
                                return Validators.networkAddress(v, _basePrefixController.text);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrefixInputField(
                              controller: _basePrefixController,
                              validator: Validators.cidrPrefix,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Segments list ──────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.networkSegments, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    if (_rows.isNotEmpty) ...[
                      ..._rows.asMap().entries.map(
                            (e) => _SegmentTile(row: e.value, onRemove: () => _removeSegment(e.key)),
                          ),
                      const Divider(),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            controller: _segNameController,
                            label: s.segmentName,
                            hint: 'Sales, IT, WAN...',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            controller: _segHostsController,
                            label: s.hosts,
                            hint: '50',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: ElevatedButton(
                            onPressed: _addSegment,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              // Fixed: pass s to _calculate
              onPressed: () => _calculate(s),
              icon: const Icon(Icons.calculate),
              label: Text(s.calculateVlsm),
            ),
            const SizedBox(height: 14),

            // ── Results ────────────────────────────────────────────────────
            Consumer<AddressingProvider>(
              builder: (context, provider, _) {
                if (provider.vlsmError != null) {
                  return _ErrorCard(message: provider.vlsmError!);
                }
                final results = provider.vlsmResults;
                if (results == null) return const SizedBox();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.vlsmAllocation,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    ...results.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ResultCard(
                            title: '${r.name} — ${r.requiredHosts} hosts',
                            data: r.toDisplayMap(),
                            accentColor: AppTheme.accentOrange,
                          ),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.explanation,
                            style: Theme.of(context).textTheme.headlineSmall),
                        Switch(
                          value: _showSteps,
                          onChanged: (v) => setState(() => _showSteps = v),
                          activeColor: AppTheme.accentOrange,
                        ),
                      ],
                    ),
                    if (_showSteps)
                      ...provider.vlsmSteps.asMap().entries.map(
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

class _SegmentRow {
  final String name;
  final int hosts;
  _SegmentRow({required this.name, required this.hosts});
}

class _SegmentTile extends StatelessWidget {
  final _SegmentRow row;
  final VoidCallback onRemove;
  const _SegmentTile({required this.row, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.lan_outlined, color: AppTheme.accentOrange, size: 18),
      title: Text(row.name),
      subtitle: Text('${row.hosts} hosts required',
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: onRemove,
        color: AppTheme.accentRed,
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
      child: Text(message, style: const TextStyle(color: AppTheme.accentRed)),
    );
  }
}
