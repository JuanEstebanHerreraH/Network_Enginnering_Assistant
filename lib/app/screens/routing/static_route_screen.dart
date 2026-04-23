import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';

import 'package:flutter/material.dart';
import '../../../app/providers/routing_provider.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../models/route_model.dart';
import '../../../utils/validators.dart';

class StaticRouteScreen extends StatefulWidget {
  const StaticRouteScreen({super.key});

  @override
  State<StaticRouteScreen> createState() => _StaticRouteScreenState();
}

class _StaticRouteScreenState extends State<StaticRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _prefixController = TextEditingController(text: '0');
  final _nextHopController = TextEditingController();
  final _adController = TextEditingController();
  final _descController = TextEditingController();
  final _hostnameController = TextEditingController(text: 'Router');

  RouteType _selectedType = RouteType.ipv4Static;

  bool get _isDefault =>
      _selectedType == RouteType.ipv4Default ||
      _selectedType == RouteType.ipv6Default;

  @override
  void dispose() {
    _destinationController.dispose();
    _prefixController.dispose();
    _nextHopController.dispose();
    _adController.dispose();
    _descController.dispose();
    _hostnameController.dispose();
    super.dispose();
  }

  void _addRoute() {
    if (!_formKey.currentState!.validate()) return;

    final ad = int.tryParse(_adController.text.trim());
    final prefix = int.tryParse(_prefixController.text.trim()) ?? 0;

    final route = RouteModel(
      destinationNetwork: _isDefault ? '0.0.0.0' : _destinationController.text.trim(),
      cidrPrefix: _isDefault ? 0 : prefix,
      nextHop: _nextHopController.text.trim(),
      adminDistance: ad,
      type: _selectedType,
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
    );

    context.read<RoutingProvider>().addRoute(route);
    _destinationController.clear();
    _nextHopController.clear();
    _adController.clear();
    _descController.clear();
  }

  void _generate() {
    context.read<RoutingProvider>().generateRouteConfig(
          hostname: _hostnameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/'),),
        title: Text(s.staticRouteGenerator),
        actions: [
          Consumer<RoutingProvider>(
            builder: (context, provider, _) => provider.routes.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    onPressed: provider.clearRoutes,
                    tooltip: s.clearAllRoutes,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Add Route Form ─────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.addRoute, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 14),

                      // Route type selector — NOT const because items use s.*
                      AppDropdown<RouteType>(
                        value: _selectedType,
                        label: s.routeType,
                        items: [
                          DropdownMenuItem(value: RouteType.ipv4Static, child: Text(s.ipv4StaticRoute)),
                          DropdownMenuItem(value: RouteType.ipv4Default, child: Text(s.ipv4DefaultRoute)),
                          DropdownMenuItem(value: RouteType.ipv6Static, child: Text(s.ipv6StaticRoute)),
                          DropdownMenuItem(value: RouteType.ipv6Default, child: Text(s.ipv6DefaultRoute)),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedType = v);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Destination (hidden for default routes)
                      if (!_isDefault) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: IpInputField(
                                controller: _destinationController,
                                label: _selectedType == RouteType.ipv6Static
                                    ? 'Destination Network (IPv6)'
                                    : 'Destination Network',
                                validator: _selectedType == RouteType.ipv4Static
                                    ? Validators.ipv4
                                    : (v) => v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrefixInputField(
                                controller: _prefixController,
                                max: _selectedType == RouteType.ipv6Static ? 128 : 32,
                                validator: (v) => Validators.cidrPrefix(v,
                                    min: 0,
                                    max: _selectedType == RouteType.ipv6Static ? 128 : 32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Next-hop
                      AppTextField(
                        controller: _nextHopController,
                        label: s.nextHop,
                        hint: '10.0.0.1 or GigabitEthernet0/1',
                        validator: (v) => Validators.required(v, label: 'Next-hop'),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _adController,
                              label: s.adminDistance,
                              hint: '1',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _descController,
                              label: s.description,
                              hint: 'Route to HQ',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addRoute,
                        icon: const Icon(Icons.add),
                        label: Text(s.addRoute),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Route list ─────────────────────────────────────────────────
            Consumer<RoutingProvider>(
              builder: (context, provider, _) {
                if (provider.routes.isEmpty) {
                  return _EmptyRoutesHint(s: s);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Routes',
                      subtitle: '${provider.routes.length} ${s.routeCountLabel}',
                      action: ElevatedButton.icon(
                        onPressed: () => _generate(),
                        icon: const Icon(Icons.terminal, size: 16),
                        label: const Text('Generate'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                      ),
                    ),

                    // Route command preview list
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.preview, style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 10),
                            ...provider.routes.asMap().entries.map(
                                  (e) => _RouteRow(
                                    command: e.value.toCiscoCommand(),
                                    desc: e.value.description,
                                    onRemove: () => provider.removeRoute(e.key),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Hostname
                    AppTextField(
                      controller: _hostnameController,
                      label: s.routerHostname,
                      hint: 'Router',
                    ),
                    const SizedBox(height: 20),

                    // Generated config
                    if (provider.routeConfig != null) ...[
                      SectionHeader(title: s.generatedConfig),
                      CodeBlock(code: provider.routeConfig!, label: 'static-routes.txt'),
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

class _RouteRow extends StatelessWidget {
  final String command;
  final String? desc;
  final VoidCallback onRemove;

  const _RouteRow({required this.command, this.desc, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(command,
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: AppTheme.textPrimary,
                        height: 1.5)),
                if (desc != null)
                  Text('  ! $desc',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 16, color: AppTheme.accentRed),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

// Fixed: receives s as parameter instead of accessing it from an undefined scope
class _EmptyRoutesHint extends StatelessWidget {
  final AppStrings s;
  const _EmptyRoutesHint({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('🗺️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(s.noRoutesYet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
