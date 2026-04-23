import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/locale_provider.dart';
import '../../../app/theme.dart';
import '../../../components/result_card.dart';
import '../../../engine/explanation_engine.dart';
import '../../../utils/app_strings.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});
  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  String? _selectedTopic;
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _activeCategory = 'all';

  static const _categories = {
    'all':       {'label': 'Todos', 'labelEn': 'All',        'icon': '📚'},
    'ip':        {'label': 'Direccionamiento', 'labelEn': 'IP',         'icon': '🔢'},
    'switching': {'label': 'Switching',  'labelEn': 'Switching',  'icon': '🔀'},
    'routing':   {'label': 'Ruteo',      'labelEn': 'Routing',    'icon': '🗺️'},
    'services':  {'label': 'Servicios',  'labelEn': 'Services',   'icon': '🛡️'},
    'security':  {'label': 'Seguridad',  'labelEn': 'Security',   'icon': '🔐'},
  };

  static const _topicCategory = {
    'subnetting': 'ip', 'vlsm': 'ip', 'ipv6': 'ip',
    'vlan': 'switching', 'router_on_stick': 'switching', 'stp': 'switching', 'etherchannel': 'switching', 'cdp_lldp': 'switching',
    'static_routing': 'routing', 'rip': 'routing', 'ospf': 'routing',
    'nat': 'services', 'dhcp': 'services',
    'acl': 'security', 'ssh_hardening': 'security',
        'osi_model': 'ip', 'interfaces': 'routing',
  };

  static const _allTopics = [
    'subnetting','vlsm','ipv6',
    'vlan','router_on_stick','stp','etherchannel','cdp_lldp',
    'static_routing','rip','ospf',
    'nat','dhcp',
    'acl','ssh_hardening',
    'osi_model','interfaces',
  ];

  NetworkLesson? _getLesson(String key) =>
      ExplanationEngine.lessons[key] ?? ExplanationEngineV2.extraLessons[key];

  List<String> get _filtered {
    return _allTopics.where((String t) {
      final l = _getLesson(t);
      if (l == null) return false;
      final catOk = _activeCategory == 'all' || _topicCategory[t] == _activeCategory;
      final qLow = _query.toLowerCase();
      final qOk = _query.isEmpty ||
          l.title(true).toLowerCase().contains(qLow) ||
          l.title(false).toLowerCase().contains(qLow) ||
          l.summary(true).toLowerCase().contains(qLow) ||
          l.summary(false).toLowerCase().contains(qLow);
      return catOk && qOk;
    }).toList();
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    final lesson = _selectedTopic != null ? _getLesson(_selectedTopic!) : null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: lesson != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedTopic = null),
              )
            : null,
        title: Text(lesson != null ? lesson.title(s.isSpanish) : s.learningMode),
      ),
      body: lesson != null
          ? _LessonView(lesson: lesson, s: s, onBack: () => setState(() => _selectedTopic = null))
          : _TopicListView(
              topics: _filtered,
              allTopics: _allTopics,
              categories: _categories,
              activeCategory: _activeCategory,
              searchCtrl: _searchCtrl,
              query: _query,
              isSpanish: s.isSpanish,
              onCategoryChanged: (c) => setState(() => _activeCategory = c),
              onSearch: (q) => setState(() => _query = q),
              onSelect: (t) => setState(() => _selectedTopic = t),
              getLesson: _getLesson,
            ),
    );
  }
}

class _TopicListView extends StatelessWidget {
  final List<String> topics, allTopics;
  final Map<String, Map<String, String>> categories;
  final String activeCategory;
  final TextEditingController searchCtrl;
  final String query;
  final bool isSpanish;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onSelect;
  final NetworkLesson? Function(String) getLesson;

  const _TopicListView({
    required this.topics, required this.allTopics, required this.categories,
    required this.activeCategory, required this.searchCtrl, required this.query,
    required this.isSpanish, required this.onCategoryChanged, required this.onSearch,
    required this.onSelect, required this.getLesson,
  });

  static const _topicCategory = {
    'subnetting': 'ip', 'vlsm': 'ip', 'ipv6': 'ip',
    'vlan': 'switching', 'router_on_stick': 'switching', 'stp': 'switching', 'etherchannel': 'switching', 'cdp_lldp': 'switching',
    'static_routing': 'routing', 'rip': 'routing', 'ospf': 'routing',
    'nat': 'services', 'dhcp': 'services',
    'acl': 'security', 'ssh_hardening': 'security',
  };

  static const _catColors = {
    'all': AppTheme.textSecondary, 'ip': AppTheme.primaryGreen,
    'switching': AppTheme.accentBlue, 'routing': AppTheme.accentOrange,
    'services': AppTheme.accentRed, 'security': AppTheme.accentPurple,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: isSpanish ? 'Buscar temas...' : 'Search topics...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                suffixIcon: query.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, size: 16), onPressed: () { searchCtrl.clear(); onSearch(''); })
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: categories.entries.map<Widget>((entry) {
                final key = entry.key;
                final label = isSpanish ? entry.value['label']! : entry.value['labelEn']!;
                final icon = entry.value['icon']!;
                final color = _catColors[key] ?? AppTheme.textSecondary;
                final isActive = activeCategory == key;
                final count = key == 'all' ? allTopics.length
                    : allTopics.where((t) => _topicCategory[t] == key).length;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isActive,
                    onSelected: (_) => onCategoryChanged(key),
                    backgroundColor: Colors.transparent,
                    selectedColor: color.withValues(alpha: 0.18),
                    side: BorderSide(color: isActive ? color : AppTheme.borderDark),
                    label: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(icon, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 5),
                      Text('$label ($count)', style: TextStyle(color: isActive ? color : AppTheme.textSecondary, fontSize: 12, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
                    ]),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: topics.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔍', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(isSpanish ? 'Sin resultados' : 'No results', style: const TextStyle(color: AppTheme.textSecondary)),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                  itemCount: topics.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, i) {
                    final key = topics[i];
                    final lesson = getLesson(key);
                    if (lesson == null) return const SizedBox();
                    final cat = _topicCategory[key] ?? 'all';
                    final color = _catColors[cat] ?? AppTheme.textSecondary;
                    return _TopicTile(
                      lesson: lesson,
                      color: color,
                      isSpanish: isSpanish,
                      onTap: () => onSelect(key),
                    );
                  },
                ),
          ),
        ]),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final NetworkLesson lesson;
  final Color color;
  final bool isSpanish;
  final VoidCallback onTap;

  const _TopicTile({
    required this.lesson,
    required this.color,
    required this.isSpanish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(lesson.icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(lesson.title(isSpanish), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),

            ]),
            const SizedBox(height: 3),
            Text(lesson.summary(isSpanish), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.3)),
            const SizedBox(height: 4),
            Text(
              '${lesson.sections.length} ${isSpanish ? "secciones" : "sections"} · '
              '${lesson.keyPoints(isSpanish).length} ${isSpanish ? "puntos" : "points"}',
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ])),
          Icon(Icons.chevron_right, color: color, size: 18),
        ]),
      ),
    );
  }
}

class _LessonView extends StatelessWidget {
  final NetworkLesson lesson;
  final VoidCallback onBack;
  final AppStrings s;
  const _LessonView({required this.lesson, required this.onBack, required this.s});

  @override
  Widget build(BuildContext context) {
    final isSpanish = s.isSpanish;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Text(lesson.summary(isSpanish), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 16),
            ...lesson.sections.map<Widget>((sec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 3, height: 14, decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(sec.heading(isSpanish), style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600, fontSize: 13))),
                  ]),
                  const SizedBox(height: 8),
                  Text(sec.content(isSpanish), style: const TextStyle(height: 1.6, fontSize: 13)),
                  if (sec.codeExample(isSpanish) != null) ...[const SizedBox(height: 10), CodeBlock(code: sec.codeExample(isSpanish)!)],
                ]),
              )),
            )),
            Card(child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.keyPoints, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.primaryGreen)),
                const SizedBox(height: 8),
                ...lesson.keyPoints(isSpanish).map<Widget>((k) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('✓ ', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(k, style: const TextStyle(fontSize: 13))),
                  ]),
                )),
              ]),
            )),
            if (lesson.ciscoConcept(isSpanish) != null) ...[
              const SizedBox(height: 12),
              Text(s.ciscoExample, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              CodeBlock(code: lesson.ciscoConcept(isSpanish)!, label: 'Cisco IOS'),
            ],
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
