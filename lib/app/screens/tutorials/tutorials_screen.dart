import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../utils/app_strings.dart';
import 'tutorials_data.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});
  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  // null = Todos
  String? _selectedDifficulty;

  static const _difficulties = ['Básico', 'Intermedio', 'Avanzado'];

  static const _difficultyColor = {
    'Básico':     AppTheme.primaryGreen,
    'Intermedio': AppTheme.accentOrange,
    'Avanzado':   AppTheme.accentRed,
  };

  static const _diffLabel = {
    'Básico':     ['Básico',     'Basic'],
    'Intermedio': ['Intermedio', 'Intermediate'],
    'Avanzado':   ['Avanzado',   'Advanced'],
  };

  List<StepGuide> get _filteredGuides => _selectedDifficulty == null
      ? guideList
      : guideList.where((g) => g.difficulty == _selectedDifficulty).toList();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    final isEs = context.watch<LocaleProvider>().isSpanish;
    final filtered = _filteredGuides;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(s.tutorialsTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Hero
              _TutorialsHero(s: s),
              const SizedBox(height: 22),

              // Equipment section
              _SectionLabel(icon: '🖥️', label: isEs ? 'Equipos de Red' : 'Network Equipment'),
              const SizedBox(height: 10),
              _EquipmentGrid(isEs: isEs),
              const SizedBox(height: 22),

              // Guides section header
              _SectionLabel(icon: '📋', label: isEs ? 'Guías Paso a Paso' : 'Step-by-Step Guides'),
              const SizedBox(height: 12),

              // ── Filtro de dificultad ───────────────────────────────────────
              _DifficultyFilter(
                selected: _selectedDifficulty,
                isEs: isEs,
                difficulties: _difficulties,
                diffLabel: _diffLabel,
                diffColor: _difficultyColor,
                onSelected: (val) => setState(() =>
                    _selectedDifficulty = _selectedDifficulty == val ? null : val),
              ),
              const SizedBox(height: 12),

              // Contador de resultados
              Text(
                isEs
                  ? '${filtered.length} guía${filtered.length == 1 ? "" : "s"}'
                    '${_selectedDifficulty != null ? " · ${_diffLabel[_selectedDifficulty]![0]}" : ""}'
                  : '${filtered.length} guide${filtered.length == 1 ? "" : "s"}'
                    '${_selectedDifficulty != null ? " · ${_diffLabel[_selectedDifficulty]![1]}" : ""}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 10),

              // Lista filtrada
              if (filtered.isEmpty)
                _EmptyFilter(isEs: isEs,
                    onClear: () => setState(() => _selectedDifficulty = null))
              else
                ...filtered.map((guide) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _GuideTile(guide: guide, isEs: isEs, s: s),
                )),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── Filtro ─────────────────────────────────────────────────────────────────────
class _DifficultyFilter extends StatelessWidget {
  final String? selected;
  final bool isEs;
  final List<String> difficulties;
  final Map<String, List<String>> diffLabel;
  final Map<String, Color> diffColor;
  final void Function(String) onSelected;

  const _DifficultyFilter({
    required this.selected,
    required this.isEs,
    required this.difficulties,
    required this.diffLabel,
    required this.diffColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        // Chip "Todos / All"
        _FilterChip(
          label: isEs ? 'Todos' : 'All',
          color: AppTheme.accentBlue,
          isActive: selected == null,
          onTap: () {
            // Si ya está en "Todos" no hace nada, sino limpia el filtro
          },
          onTapFull: () {
            // handled via parent — tapping active chip in parent deselects
          },
          isAll: true,
          onTapAll: () {
            if (selected != null) onSelected(selected!); // toggle off current
          },
        ),
        ...difficulties.map((d) {
          final color = diffColor[d] ?? AppTheme.primaryGreen;
          final label = diffLabel[d]![isEs ? 0 : 1];
          return _FilterChip(
            label: label,
            color: color,
            isActive: selected == d,
            onTap: () => onSelected(d),
            onTapFull: () => onSelected(d),
          );
        }),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onTapFull;
  final bool isAll;
  final VoidCallback? onTapAll;

  const _FilterChip({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
    required this.onTapFull,
    this.isAll = false,
    this.onTapAll,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAll ? onTapAll : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : color.withOpacity(0.35),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? color : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────
class _EmptyFilter extends StatelessWidget {
  final bool isEs;
  final VoidCallback onClear;
  const _EmptyFilter({required this.isEs, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(children: [
          const Text('🔍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            isEs ? 'No hay guías con este filtro.' : 'No guides match this filter.',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onClear,
            child: Text(isEs ? 'Ver todas' : 'Show all'),
          ),
        ]),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────
class _TutorialsHero extends StatelessWidget {
  final AppStrings s;
  const _TutorialsHero({required this.s});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF0A1628)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF26C6DA).withOpacity(0.35)),
      ),
      child: Row(children: [
        const Text('📘', style: TextStyle(fontSize: 44)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.tutorialsTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF26C6DA))),
          const SizedBox(height: 6),
          Text(s.tutorialsSubtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 4, children: [
            _StatBadge('${equipmentList.length}', s.isSpanish ? 'Equipos' : 'Devices', const Color(0xFF26C6DA)),
            _StatBadge('${guideList.length}', s.isSpanish ? 'Guías' : 'Guides', AppTheme.primaryGreen),
            _StatBadge('${guideList.fold(0, (s, g) => s + g.steps.length)}', s.isSpanish ? 'Pasos' : 'Steps', AppTheme.accentPurple),
          ]),
        ])),
      ]),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String count, label;
  final Color color;
  const _StatBadge(this.count, this.label, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(count, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ]),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String icon, label;
  const _SectionLabel({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(icon, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 8),
      Text(label, style: Theme.of(context).textTheme.headlineSmall),
    ]);
  }
}

// ── Equipment grid ─────────────────────────────────────────────────────────────
class _EquipmentGrid extends StatelessWidget {
  final bool isEs;
  const _EquipmentGrid({required this.isEs});

  static const _colors = {
    '00C896': AppTheme.primaryGreen,
    '58A6FF': AppTheme.accentBlue,
    'FF7B72': AppTheme.accentRed,
    'D2A8FF': AppTheme.accentPurple,
    'F0883E': AppTheme.accentOrange,
  };

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 800 ? 3 : (w > 500 ? 2 : 1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols, crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: cols == 1 ? 3.5 : cols == 2 ? 1.3 : 1.4,
      ),
      itemCount: equipmentList.length,
      itemBuilder: (context, i) {
        final eq = equipmentList[i];
        final color = _colors[eq.accentHex] ?? AppTheme.primaryGreen;
        return InkWell(
          onTap: () => context.go('/tutorials/equipment/${eq.id}'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: cols == 1
              ? Row(children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(eq.icon, style: const TextStyle(fontSize: 26)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(isEs ? eq.nameEs : eq.nameEn, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(eq.layer, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
                    Text(isEs ? eq.summaryEs : eq.summaryEn, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3)),
                  ])),
                  Icon(Icons.chevron_right, color: color, size: 18),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text(eq.icon, style: const TextStyle(fontSize: 22)))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                      child: Text(eq.layer.split(' — ').last, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w500)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(isEs ? eq.nameEs : eq.nameEn, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 2),
                  Flexible(child: Text(isEs ? eq.summaryEs : eq.summaryEn, maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3))),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('${eq.features.length} ${isEs ? "funciones" : "features"}',
                        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Icon(Icons.arrow_forward, color: color, size: 12),
                  ]),
                ]),
          ),
        );
      },
    );
  }
}

// ── Guide tile ─────────────────────────────────────────────────────────────────
class _GuideTile extends StatelessWidget {
  final StepGuide guide;
  final bool isEs;
  final AppStrings s;
  const _GuideTile({required this.guide, required this.isEs, required this.s});

  static const _diffColor = {
    'Básico':     AppTheme.primaryGreen,
    'Intermedio': AppTheme.accentOrange,
    'Avanzado':   AppTheme.accentRed,
  };

  static const _diffLabel = {
    'Básico':     ['Básico',     'Basic'],
    'Intermedio': ['Intermedio', 'Intermediate'],
    'Avanzado':   ['Avanzado',   'Advanced'],
  };

  @override
  Widget build(BuildContext context) {
    final color = _diffColor[guide.difficulty] ?? AppTheme.primaryGreen;
    final diffText = _diffLabel[guide.difficulty]?[isEs ? 0 : 1] ?? guide.difficulty;
    return InkWell(
      onTap: () => context.go('/tutorials/guide/${guide.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Row(children: [
          Text(guide.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isEs ? guide.titleEs : guide.titleEn, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 3),
            Text(isEs ? guide.summaryEs : guide.summaryEn, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.3)),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(diffText, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.list_alt_outlined, size: 12, color: AppTheme.textSecondary),
              const SizedBox(width: 3),
              Text('${guide.steps.length} ${isEs ? "pasos" : "steps"}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ]),
          ])),
          Icon(Icons.chevron_right, color: color, size: 18),
        ]),
      ),
    );
  }
}
