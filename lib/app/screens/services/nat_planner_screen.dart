import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';
/// NatPlannerScreen
/// UI for building NAT configurations (Static, Dynamic, PAT).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/routing_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../models/nat_model.dart';

class NatPlannerScreen extends StatefulWidget {
  const NatPlannerScreen({super.key});

  @override
  State<NatPlannerScreen> createState() => _NatPlannerScreenState();
}

class _NatPlannerScreenState extends State<NatPlannerScreen> {
  NatType _natType = NatType.pat;

  final _insideController = TextEditingController(text: 'GigabitEthernet0/0');
  final _outsideController = TextEditingController(text: 'GigabitEthernet0/1');

  // Static NAT
  final _privateIpController = TextEditingController();
  final _publicIpController = TextEditingController();

  // Dynamic NAT / PAT
  final _poolNameController = TextEditingController(text: 'PUBLIC_POOL');
  final _poolStartController = TextEditingController();
  final _poolEndController = TextEditingController();
  final _aclNumberController = TextEditingController(text: '1');
  final _insideNetworkController = TextEditingController();

  @override
  void dispose() {
    _insideController.dispose();
    _outsideController.dispose();
    _privateIpController.dispose();
    _publicIpController.dispose();
    _poolNameController.dispose();
    _poolStartController.dispose();
    _poolEndController.dispose();
    _aclNumberController.dispose();
    _insideNetworkController.dispose();
    super.dispose();
  }

  void _generate() {
    final nat = NatModel(
      type: _natType,
      insideInterface: _insideController.text.trim(),
      outsideInterface: _outsideController.text.trim(),
      privateIp: _privateIpController.text.trim().isEmpty
          ? null
          : _privateIpController.text.trim(),
      publicIp: _publicIpController.text.trim().isEmpty
          ? null
          : _publicIpController.text.trim(),
      poolName: _poolNameController.text.trim().isEmpty
          ? null
          : _poolNameController.text.trim(),
      poolStartIp: _poolStartController.text.trim().isEmpty
          ? null
          : _poolStartController.text.trim(),
      poolEndIp: _poolEndController.text.trim().isEmpty
          ? null
          : _poolEndController.text.trim(),
      aclNumber: _aclNumberController.text.trim().isEmpty
          ? null
          : _aclNumberController.text.trim(),
      insideNetwork: _insideNetworkController.text.trim().isEmpty
          ? null
          : _insideNetworkController.text.trim(),
    );
    context.read<RoutingProvider>().generateNatConfig(nat);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'),), title: Text(s.natPlanner)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── NAT type selector ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.natType,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    ...NatType.values.map(
                      (t) => RadioListTile<NatType>(
                        contentPadding: EdgeInsets.zero,
                        value: t,
                        groupValue: _natType,
                        title: Text(_natTypeLabel(t, s)),
                        subtitle: Text(_natTypeDesc(t, s),
                            style: Theme.of(context).textTheme.bodyMedium),
                        onChanged: (v) {
                          if (v != null) setState(() => _natType = v);
                        },
                        activeColor: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Interfaces ─────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.interfaces,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _insideController,
                      label: s.insideInterface,
                      hint: 'GigabitEthernet0/0',
                      prefix: const Icon(Icons.arrow_downward, size: 16,
                          color: AppTheme.primaryGreen),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _outsideController,
                      label: s.outsideInterface,
                      hint: 'GigabitEthernet0/1',
                      prefix: const Icon(Icons.arrow_upward, size: 16,
                          color: AppTheme.accentBlue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Type-specific fields ───────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.natParameters,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    if (_natType == NatType.staticNat) ...[
                      AppTextField(
                        controller: _privateIpController,
                        label: 'Private IP',
                        hint: '192.168.1.10',
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _publicIpController,
                        label: 'Public IP',
                        hint: '203.0.113.10',
                      ),
                    ],
                    if (_natType == NatType.dynamicNat) ...[
                      AppTextField(
                        controller: _poolNameController,
                        label: 'Pool Name',
                        hint: 'PUBLIC_POOL',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _poolStartController,
                              label: 'Pool Start IP',
                              hint: '203.0.113.1',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppTextField(
                              controller: _poolEndController,
                              label: 'Pool End IP',
                              hint: '203.0.113.10',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _insideNetworkController,
                        label: 'Inside Network',
                        hint: '192.168.1.0',
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _aclNumberController,
                        label: 'ACL Number',
                        hint: '1',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    if (_natType == NatType.pat) ...[
                      AppTextField(
                        controller: _insideNetworkController,
                        label: 'Inside Network',
                        hint: '192.168.1.0',
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _aclNumberController,
                        label: 'ACL Number',
                        hint: '1',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.terminal),
              label: Text(s.generateNatConfig),
            ),
            const SizedBox(height: 14),

            // ── Output ─────────────────────────────────────────────────────
            Consumer<RoutingProvider>(
              builder: (context, provider, _) {
                if (provider.natConfig == null) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: s.generatedConfig),
                    CodeBlock(
                      code: provider.natConfig!,
                      label: 'nat-config.txt',
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

  String _natTypeLabel(NatType t, AppStrings s) {
    switch (t) {
      case NatType.staticNat: return s.natStatic;
      case NatType.dynamicNat: return s.natDynamic;
      case NatType.pat: return s.natPat;
    }
  }

  String _natTypeDesc(NatType t, AppStrings s) {
    switch (t) {
      case NatType.staticNat: return s.natStaticDesc;
      case NatType.dynamicNat: return s.natDynamicDesc;
      case NatType.pat: return s.natPatDesc;
    }
  }
}
