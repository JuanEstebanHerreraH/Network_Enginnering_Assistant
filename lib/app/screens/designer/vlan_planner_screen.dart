import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/designer_provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../utils/validators.dart';
import '../../../utils/app_strings.dart';

class VlanPlannerScreen extends StatefulWidget {
  const VlanPlannerScreen({super.key});
  @override
  State<VlanPlannerScreen> createState() => _VlanPlannerScreenState();
}

class _VlanPlannerScreenState extends State<VlanPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _networkController = TextEditingController();
  final _prefixController = TextEditingController(text: '24');

  @override
  void dispose() {
    _idController.dispose(); _nameController.dispose();
    _networkController.dispose(); _prefixController.dispose();
    super.dispose();
  }

  void _addVlan(AppStrings s) {
    if (!_formKey.currentState!.validate()) return;
    try {
      context.read<DesignerProvider>().addVlan(
        vlanId: int.parse(_idController.text.trim()),
        name: _nameController.text.trim(),
        networkAddress: _networkController.text.trim(),
        cidrPrefix: int.parse(_prefixController.text.trim()),
      );
      _idController.clear(); _nameController.clear();
      _networkController.clear(); _prefixController.text = '24';
      // Single success feedback — no loop
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.vlanAdded), duration: const Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/designer')),
        title: Text(s.vlanPlanner),
        actions: [
          Consumer<DesignerProvider>(
            builder: (_, provider, __) => provider.hasVlans
                ? IconButton(icon: const Icon(Icons.delete_sweep_outlined, size: 20), onPressed: () {
                    showDialog(context: context, builder: (ctx) => AlertDialog(
                      title: Text(s.clearAll),
                      content: Text(s.deleteAllVlansMsg),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.close)),
                        ElevatedButton(onPressed: () { provider.clearVlans(); Navigator.pop(ctx); },
                            child: Text(s.delete)),
                      ],
                    ));
                  })
                : const SizedBox(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Add form ─────────────────────────────────────────────────────
          Card(child: Padding(
            padding: const EdgeInsets.all(14),
            child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.addVlan, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: AppTextField(
                  controller: _idController, label: s.vlanId, hint: '10',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.vlanId,
                )),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: AppTextField(
                  controller: _nameController, label: s.vlanName, hint: 'Ventas',
                  validator: (v) => Validators.required(v, label: 'Nombre'),
                )),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(flex: 3, child: IpInputField(
                  controller: _networkController, label: s.networkAddressField,
                  validator: Validators.ipv4,
                )),
                const SizedBox(width: 10),
                Expanded(child: PrefixInputField(
                  controller: _prefixController, validator: Validators.cidrPrefix,
                )),
              ]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(
                onPressed: () => _addVlan(s),
                icon: const Icon(Icons.add, size: 16),
                label: Text(s.addVlan),
              )),
            ])),
          )),
          const SizedBox(height: 14),

          // ── VLAN list ─────────────────────────────────────────────────────
          Consumer<DesignerProvider>(
            builder: (_, provider, __) {
              if (!provider.hasVlans) {
                return Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(children: [
                    const Text('🔀', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(s.noVlansYet, textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ));
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('${s.configuredVlans} (${provider.vlans.length})',
                      style: Theme.of(context).textTheme.headlineSmall),
                ]),
                const SizedBox(height: 8),
                if (provider.overlapWarnings.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.4)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.warning_amber, color: AppTheme.accentRed, size: 14),
                        const SizedBox(width: 6),
                        Text(s.overlapsDetected, style: const TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold, fontSize: 12)),
                      ]),
                      ...provider.overlapWarnings.map((w) => Text(w, style: const TextStyle(color: AppTheme.accentRed, fontSize: 11))),
                    ]),
                  ),
                ...provider.vlans.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(child: ListTile(
                    dense: true,
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppTheme.accentBlue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text('${e.value.vlanId}', style: const TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.bold, fontSize: 12))),
                    ),
                    title: Text('VLAN ${e.value.vlanId} — ${e.value.name}', style: const TextStyle(fontSize: 13)),
                    subtitle: Text('${e.value.networkAddress}/${e.value.cidrPrefix}  ·  GW: ${e.value.gatewayIp}  ·  ${e.value.usableHosts} hosts',
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.accentRed),
                      onPressed: () => provider.removeVlan(e.key),
                    ),
                  )),
                )),
              ]);
            },
          ),
        ]),
      ),
    );
  }
}
