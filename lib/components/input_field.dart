/// InputField components v3
/// Fixed: PrefixInputField now uses TextInputType.numberWithOptions
/// so Android shows numeric keyboard reliably.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final bool autofocus;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.maxLength,
    this.onEditingComplete,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      enabled: enabled,
      // KEY FIX: always use signed=false, decimal=false for number fields
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onEditingComplete: onEditingComplete,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        counterText: '',
        isDense: true,
      ),
    );
  }
}

class IpInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const IpInputField({
    super.key,
    required this.controller,
    this.label = 'IP Address',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: '192.168.1.0',
      // FIX: use text keyboard with digit filter so dots work on all platforms
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        LengthLimitingTextInputFormatter(15),
      ],
      prefix: const Icon(Icons.dns_outlined, size: 16),
      validator: validator,
    );
  }
}

/// PrefixInputField — FIXED for mobile keyboards
/// Previously used a prefix widget that confused Android keyboard type detection.
class PrefixInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int min;
  final int max;

  const PrefixInputField({
    super.key,
    required this.controller,
    this.validator,
    this.min = 1,
    this.max = 32,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // FIXED: explicit number keyboard that works on Android
      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      textInputAction: TextInputAction.done,
      validator: validator,
      decoration: InputDecoration(
        labelText: '/$min–$max',
        hintText: max == 32 ? '24' : '64',
        isDense: true,
        counterText: '',
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(12, 14, 0, 14),
          child: Text('/', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 28),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, isDense: true),
      isExpanded: true,
    );
  }
}
