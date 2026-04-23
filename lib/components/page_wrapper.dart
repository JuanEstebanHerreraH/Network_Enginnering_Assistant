/// PageWrapper
/// Wraps all screen body content to prevent over-stretching on wide displays.
/// - Desktop (>900px): centers content with max width 860px
/// - Tablet (600-900px): 96% width
/// - Mobile: full width with standard padding

import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool scrollable;

  const PageWrapper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    this.maxWidth = 860,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = w > 900 ? maxWidth : double.infinity;

    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );

    if (scrollable) {
      return SingleChildScrollView(child: content);
    }
    return content;
  }
}

/// ResponsiveGrid
/// 1 col on mobile, 2 on tablet, 3 on desktop.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.childAspectRatio = 1.4,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 900 ? 3 : (w > 560 ? 2 : 1);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: cols == 1 ? 4.0 : childAspectRatio,
      children: children,
    );
  }
}
