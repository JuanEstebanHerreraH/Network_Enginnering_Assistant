import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../utils/app_strings.dart';
/// AclBuilderScreen
/// UI for building Standard and Extended ACLs.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme.dart';
import '../../../components/input_field.dart';
import '../../../components/result_card.dart';
import '../../../core/acl_builder.dart';
import '../../../models/acl_model.dart';

class AclBuilderScreen extends StatefulWidget {
  const AclBuilderScreen({super.key});

  @override
  State<AclBuilderScreen> createState() => _AclBuilderScreenState();
}

class _AclBuilderScreenState extends State<AclBuilderScreen> {
  AclType _aclType = AclType.extended;
  AclAction _action = AclAction.permit;
  AclProtocol _protocol = AclProtocol.tcp;

  final _aclNumberController = TextEditingController(text: '100');
  final _aclNameController = TextEditingController(text: 'MY_ACL');
  final _srcNetController = TextEditingController();
  final _srcWildController = TextEditingController(text: '0.0.0.255');
  final _dstNetController = TextEditingController();
  final _dstWildController = TextEditingController(text: '0.0.0.0');
  final _portController = TextEditingController();
  final _descController = TextEditingController();
  final _ifaceController = TextEditingController(text: 'GigabitEthernet0/0');

  final List<AclEntry> _entries = [];
  List<String>? _generatedCommands;
  bool _showExplanation = false;

  @override
  void dispose() {
    _aclNumberController.dispose();
    _aclNameController.dispose();
    _srcNetController.dispose();
    _srcWildController.dispose();
    _dstNetController.dispose();
    _dstWildController.dispose();
    _portController.dispose();
    _descController.dispose();
    _ifaceController.dispose();
    super.dispose();
  }

  void _addEntry() {
    final entry = AclEntry(
      action: _action,
      protocol: _protocol,
      sourceNetwork:
          _srcNetController.text.trim().isEmpty ? 'any' : _srcNetController.text.trim(),
      sourceWildcard: _srcWildController.text.trim().isEmpty
          ? '255.255.255.255'
          : _srcWildController.text.trim(),
      destinationNetwork:
          _aclType == AclType.extended && _dstNetController.text.trim().isNotEmpty
              ? _dstNetController.text.trim()
              : null,
      destinationWildcard:
          _aclType == AclType.extended && _dstWildController.text.trim().isNotEmpty
              ? _dstWildController.text.trim()
              : null,
      destinationPort: int.tryParse(_portController.text.trim()),
      description:
          _descController.text.trim().isEmpty ? null : _descController.text.trim(),
    );
    setState(() {
      _entries.add(entry);
      _srcNetController.clear();
      _dstNetController.clear();
      _portController.clear();
      _descController.clear();
      _generatedCommands = null;
    });
  }

  void _generate() {
    final acl = AclModel(
      aclNumber: int.tryParse(_aclNumberController.text.trim()) ?? 100,
      type: _aclType,
      name: _aclNameController.text.trim(),
      entries: _entries,
    );
    setState(() {
      _generatedCommands = AclBuilderCore.generateCommands(acl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Scaffold(
      appBar: AppBar(title: Text(s.aclBuilder)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ACL Setup ──────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.aclSettings,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppDropdown<AclType>(
                            value: _aclType,
                            label: s.aclType,
                            items: const [
                              DropdownMenuItem(
                                  value: AclType.standard,
                                  child: Text('Standard')),
                              DropdownMenuItem(
                                  value: AclType.extended,
                                  child: Text('Extended')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _aclType = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            controller: _aclNumberController,
                            label: s.aclNumber,
                            hint: _aclType == AclType.standard ? '1–99' : '100–199',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _aclNameController,
                      label: s.aclNameLabel,
                      hint: 'BLOCK_GUEST',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Add Rule ───────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.addAclRule,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppDropdown<AclAction>(
                            value: _action,
                            label: s.action,
                            items: const [
                              DropdownMenuItem(
                                  value: AclAction.permit,
                                  child: Text('✅ permit')),
                              DropdownMenuItem(
                                  value: AclAction.deny,
                                  child: Text('🚫 deny')),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _action = v);
                            },
                          ),
                        ),
                        if (_aclType == AclType.extended) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppDropdown<AclProtocol>(
                              value: _protocol,
                              label: s.protocol,
                              items: AclProtocol.values
                                  .map((p) => DropdownMenuItem(
                                      value: p, child: Text(p.name)))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _protocol = v);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Source',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: IpInputField(
                            controller: _srcNetController,
                            label: 'Source Network',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: IpInputField(
                            controller: _srcWildController,
                            label: 'Wildcard Mask',
                          ),
                        ),
                      ],
                    ),
                    if (_aclType == AclType.extended) ...[
                      const SizedBox(height: 12),
                      Text('Destination',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: IpInputField(
                              controller: _dstNetController,
                              label: 'Destination Network',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: IpInputField(
                              controller: _dstWildController,
                              label: 'Wildcard Mask',
                            ),
                          ),
                          if (_protocol == AclProtocol.tcp ||
                              _protocol == AclProtocol.udp) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppTextField(
                                controller: _portController,
                                label: 'Port (eq)',
                                hint: '80',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    AppTextField(
                      controller: _descController,
                      label: s.description,
                      hint: 'Allow HTTP to web server',
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: _addEntry,
                      icon: const Icon(Icons.add),
                      label: Text(s.addRule),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Rules list ─────────────────────────────────────────────────
            if (_entries.isNotEmpty) ...[
              SectionHeader(
                title: 'Rules (${_entries.length})',
                action: ElevatedButton.icon(
                  onPressed: _generate,
                  icon: const Icon(Icons.terminal, size: 16),
                  label: Text(s.generate),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: _entries.asMap().entries.map((e) {
                      final entry = e.value;
                      final preview =
                          ' ${entry.action.name} ${entry.protocol.name} '
                          '${entry.sourceNetwork} ${entry.sourceWildcard}'
                          '${entry.destinationNetwork != null ? ' → ${entry.destinationNetwork}' : ''}';
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          entry.action == AclAction.permit
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: entry.action == AclAction.permit
                              ? AppTheme.primaryGreen
                              : AppTheme.accentRed,
                          size: 18,
                        ),
                        title: Text(preview,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: AppTheme.textPrimary, height: 1.6).copyWith(fontSize: 11)),
                        subtitle: entry.description != null
                            ? Text(entry.description!,
                                style: Theme.of(context).textTheme.bodyMedium)
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 16, color: AppTheme.accentRed),
                          onPressed: () =>
                              setState(() => _entries.removeAt(e.key)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Generated Commands ─────────────────────────────────────────
            if (_generatedCommands != null) ...[
              SectionHeader(title: s.generatedAclTitle),
              CodeBlock(
                code: _generatedCommands!.join('\n'),
                label: 'acl-config.txt',
              ),
              const SizedBox(height: 12),
              // Apply to interface
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.applyAclToInterface,
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _ifaceController,
                              label: 'Interface',
                              hint: 'GigabitEthernet0/0',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_downward, size: 14),
                              label: Text(s.applyInbound),
                              onPressed: () {
                                final cmds = AclBuilderCore.applyToInterface(
                                  _ifaceController.text.trim(),
                                  int.tryParse(
                                          _aclNumberController.text.trim()) ??
                                      100,
                                  'in',
                                );
                                _showApplyDialog(cmds.join('\n'), s);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_upward, size: 14),
                              label: Text(s.applyOutbound),
                              onPressed: () {
                                final cmds = AclBuilderCore.applyToInterface(
                                  _ifaceController.text.trim(),
                                  int.tryParse(
                                          _aclNumberController.text.trim()) ??
                                      100,
                                  'out',
                                );
                                _showApplyDialog(cmds.join('\n'), s);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showApplyDialog(String commands, AppStrings s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.applyAclToInterface),
        content: CodeBlock(code: commands),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(s.close),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy, size: 14),
            label: Text(s.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: commands));
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
