import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme.dart';
import '../../utils/app_strings.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ShellScreen({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  static const _routes = [
    '/', '/addressing', '/designer', '/routing',
    '/services', '/learning', '/tutorials'
  ];

  int _locationToIndex(String loc) {
    for (int i = 0; i < _routes.length; i++) {
      if (loc == _routes[i] || loc.startsWith('${_routes[i]}/')) return i;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) => context.go(_routes[index]);

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final s = AppStrings(isSpanish: locale.isSpanish);
    final idx = _locationToIndex(currentLocation);
    final isDesktop = MediaQuery.of(context).size.width > 700;

    final destinations = [
      _NavItem(Icons.home_outlined,        Icons.home,           s.home),
      _NavItem(Icons.calculate_outlined,   Icons.calculate,      s.addressing),
      _NavItem(Icons.account_tree_outlined,Icons.account_tree,   s.designer),
      _NavItem(Icons.route_outlined,       Icons.route,          s.routing),
      _NavItem(Icons.security_outlined,    Icons.security,       'ACL/NAT'),
      _NavItem(Icons.school_outlined,      Icons.school,         s.learning),
      _NavItem(Icons.menu_book_outlined,   Icons.menu_book,      locale.isSpanish ? 'Guías' : 'Guides'),
    ];

    final langButton = InkWell(
      onTap: locale.toggle,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          locale.isSpanish ? 'ES' : 'EN',
          style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );

    if (isDesktop) {
      return Scaffold(
        body: Row(children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 1100,
            selectedIndex: idx,
            onDestinationSelected: (i) => _onTap(context, i),
            backgroundColor: AppTheme.surfaceDark,
            indicatorColor: AppTheme.primaryGreen.withOpacity(0.18),
            selectedIconTheme: const IconThemeData(color: AppTheme.primaryGreen),
            selectedLabelTextStyle: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelTextStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(children: [
                const Text('⬡', style: TextStyle(fontSize: 22, color: AppTheme.primaryGreen)),
                const SizedBox(height: 8),
                langButton,
              ]),
            ),
            destinations: destinations.map((d) => NavigationRailDestination(
              icon: Icon(d.icon, size: 20),
              selectedIcon: Icon(d.selectedIcon, size: 20),
              label: Text(d.label, style: const TextStyle(fontSize: 12)),
            )).toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ]),
      );
    }

    // Mobile: hamburger drawer
    return _MobileShell(
      child: child,
      destinations: destinations,
      selectedIndex: idx,
      onTap: (i) => _onTap(context, i),
      langButton: langButton,
      s: s,
      locale: locale,
    );
  }
}

class _MobileShell extends StatelessWidget {
  final Widget child;
  final List<_NavItem> destinations;
  final int selectedIndex;
  final void Function(int) onTap;
  final Widget langButton;
  final AppStrings s;
  final LocaleProvider locale;

  const _MobileShell({
    required this.child, required this.destinations, required this.selectedIndex,
    required this.onTap, required this.langButton, required this.s, required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final currentLabel = selectedIndex < destinations.length
        ? destinations[selectedIndex].label
        : s.appTitle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        elevation: 0,
        leading: Builder(builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          tooltip: locale.isSpanish ? 'Menú' : 'Menu',
        )),
        title: Row(children: [
          const Text('⬡ ', style: TextStyle(fontSize: 18, color: AppTheme.primaryGreen)),
          Flexible(child: Text(currentLabel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis)),
        ]),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 12), child: langButton),
        ],
      ),
      drawer: _AppDrawer(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onTap: (i) {
          Navigator.of(context).pop();
          onTap(i);
        },
        s: s,
      ),
      body: child,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final List<_NavItem> destinations;
  final int selectedIndex;
  final void Function(int) onTap;
  final AppStrings s;

  const _AppDrawer({
    required this.destinations, required this.selectedIndex,
    required this.onTap, required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surfaceDark,
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.borderDark))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('⬡', style: TextStyle(fontSize: 32, color: AppTheme.primaryGreen)),
              const SizedBox(height: 6),
              Text(s.appTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(s.isSpanish ? 'Herramienta de Redes' : 'Network Engineering Tool',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ]),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              itemCount: destinations.length,
              itemBuilder: (context, i) {
                final d = destinations[i];
                final selected = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Material(
                    color: selected ? AppTheme.primaryGreen.withOpacity(0.14) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onTap(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        child: Row(children: [
                          Icon(selected ? d.selectedIcon : d.icon, size: 22,
                              color: selected ? AppTheme.primaryGreen : AppTheme.textSecondary),
                          const SizedBox(width: 16),
                          Expanded(child: Text(d.label,
                            style: TextStyle(fontSize: 14,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                              color: selected ? AppTheme.primaryGreen : AppTheme.textPrimary))),
                          if (selected)
                            Container(width: 6, height: 6,
                              decoration: const BoxDecoration(color: AppTheme.primaryGreen, shape: BoxShape.circle)),
                        ]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(s.isSpanish ? 'Asistente de Redes v1.0' : 'Network Assistant v1.0',
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
        ]),
      ),
    );
  }
}

class _NavItem {
  final IconData icon, selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}
