/// RouterOnStickScreen
/// Generates Router-on-a-Stick and Switch configurations
/// from the VLANs defined in DesignerProvider.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/designer_provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';

class RouterOnStickScreen extends StatefulWidget {
  const RouterOnStickScreen({super.key});

  @override
  State<RouterOnStickScreen> createState() => _RouterOnStickScreenState();
}

class _RouterOnStickScreenState extends State<RouterOnStickScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _routerHostController = TextEditingController(text: 'Router');
  final _switchHostController = TextEditingController(text: 'Switch');

  final List<String> _interfaceOptions = [
    'GigabitEthernet0/0',
    'GigabitEthernet0/1',
    'FastEthernet0/0',
    'FastEthernet0/1',
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _routerHostController.dispose();
    _switchHostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        title: Text(s.routerOnStick),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: s.routerConfig),
            Tab(text: s.switchConfig),
          ],
        ),
      ),
      body: Consumer<DesignerProvider>(
        builder: (context, provider, _) {
          if (!provider.hasVlans) {
            return _NoVlansPlaceholder(s: s);
          }

          return Column(
            children: [
              // ── Control panel ────────────────────────────────────────────
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.configOptions, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _routerHostController,
                              label: s.routerHostname,
                              hint: 'Router',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _switchHostController,
                              label: s.switchHostname,
                              hint: 'Switch',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppDropdown<String>(
                        value: provider.trunkInterface,
                        label: s.trunkInterface,
                        items: _interfaceOptions
                            .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) provider.setTrunkInterface(v);
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          provider.setRouterHostname(_routerHostController.text.trim());
                          provider.setSwitchHostname(_switchHostController.text.trim());
                          provider.generateRouterOnStick();
                        },
                        icon: const Icon(Icons.bolt),
                        label: Text(s.generateConfig),
                      ),
                    ],
                  ),
                ),
              ),

              // ── VLAN Summary ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '${provider.vlans.length} ${s.vlanCountConfigured} ${provider.trunkInterface}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go('/designer/vlans'),
                      child: Text(s.editVlans),
                    ),
                  ],
                ),
              ),

              // ── Config Tabs ──────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    // Router config
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: provider.rosConfig != null
                          ? CodeBlock(code: provider.rosConfig!, label: 'router-config.txt')
                          // Fixed: use s.isSpanish (bool) instead of s (AppStrings) as a function
                          : _GenerateHint(
                              message: s.isSpanish
                                  ? 'Presiona "Generar Configuración" para construir la config'
                                  : 'Press "Generate Configuration" to build the config',
                            ),
                    ),
                    // Switch config
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: provider.switchConfig != null
                          ? CodeBlock(code: provider.switchConfig!, label: 'switch-config.txt')
                          : _GenerateHint(
                              message: s.isSpanish
                                  ? 'Presiona "Generar Configuración" para construir la config del switch'
                                  : 'Press "Generate Configuration" to build the switch config',
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Fixed: receives s as parameter instead of calling context.watch inside StatelessWidget
class _NoVlansPlaceholder extends StatelessWidget {
  final AppStrings s;
  const _NoVlansPlaceholder({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍡', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(s.noVlansConfigured, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(s.noVlansGoTo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.go('/designer/vlans'),
              icon: const Icon(Icons.add),
              label: Text(s.goToVlanPlanner),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenerateHint extends StatelessWidget {
  final String message;
  const _GenerateHint({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.terminal, size: 40, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
