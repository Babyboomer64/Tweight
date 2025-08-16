import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift; // Für OrderingTerm, Value
import 'data/app_database.dart';

final _uuid = const Uuid();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TweightApp());
}

class TweightApp extends StatefulWidget {
  const TweightApp({super.key});
  @override
  State<TweightApp> createState() => _TweightAppState();
}

class _TweightAppState extends State<TweightApp> {
  late final AppDatabase db;
  final ctrl = TextEditingController();

  // UI-State
  final Set<String> _collapsed = <String>{}; // eingeklappte Knoten
  String? _selectedId;                       // aktuell markierter Eintrag

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
  }

  @override
  void dispose() {
    db.close();
    ctrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final t = ctrl.text.trim();
    if (t.isEmpty) return;
    final id = _uuid.v4();

    // Kleinsten orderIndex ermitteln und nach "oben" einfügen (kleiner = oben)
    final row = await db.customSelect(
      'SELECT MIN(order_index) AS mi FROM items',
    ).getSingle();
    final double nextTop = (row.data['mi'] as num?)?.toDouble() ?? 0.0;

    await db.into(db.items).insert(ItemsCompanion.insert(
      itemId: id,
      label: t,
      parentId: const drift.Value(null),
      orderIndex: drift.Value(nextTop - 1.0),
    ));
    ctrl.clear();
    setState(() => _selectedId = id);
  }

  // Alle Items sortiert nach orderIndex
  Stream<List<Item>> _watchAll() {
    final q = db.select(db.items)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.orderIndex)]);
    return q.watch();
  }

  // Baumstruktur -> flache Anzeige-Liste (nur sichtbare Nodes), inkl. depth
  List<_ViewNode> _buildView(List<Item> items) {
    final byParent = <String?, List<Item>>{};
    for (final it in items) {
      byParent.putIfAbsent(it.parentId, () => []).add(it);
    }
    for (final list in byParent.values) {
      list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }

    final result = <_ViewNode>[];

    void dfs(String? parentId, int depth, bool parentVisible) {
      final children = byParent[parentId] ?? const <Item>[];
      for (final it in children) {
        final bool nodeVisible = parentVisible; // Sichtbar, wenn Parent sichtbar & nicht eingeklappt
        result.add(_ViewNode(item: it, depth: depth, visible: nodeVisible));
        final isCollapsed = _collapsed.contains(it.itemId);
        // Kinder nur traversieren, wenn der Knoten nicht eingeklappt ist
        if (!isCollapsed) {
          dfs(it.itemId, depth + 1, nodeVisible);
        }
      }
    }

    dfs(null, 0, true);
    return result.where((n) => n.visible).toList();
  }

  Future<void> _delete(String id) async {
    await (db.delete(db.items)..where((t) => t.itemId.equals(id))).go();
    if (_selectedId == id) _selectedId = null;
    setState(() {});
  }

  // Einrücken: aktuelles Item wird Kind des vorherigen sichtbaren Items
  Future<void> _indent(List<_ViewNode> view, String id) async {
    final idx = view.indexWhere((n) => n.item.itemId == id);
    if (idx <= 0) return;
    final current = view[idx].item;
    final prev = view[idx - 1].item;

    // Neues parent = prev, orderIndex = letztes Kind + 1
    final lastChild = await (db.select(db.items)
          ..where((t) => t.parentId.equals(prev.itemId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.orderIndex)])
          ..limit(1))
        .getSingleOrNull();
    final newIdx = (lastChild?.orderIndex ?? 0.0) + 1.0;

    await (db.update(db.items)..where((t) => t.itemId.equals(current.itemId))).write(
      ItemsCompanion(parentId: drift.Value(prev.itemId), orderIndex: drift.Value(newIdx)),
    );
  }

  // Ausrücken: Item steigt eine Ebene hoch (Parent des Parents wird neuer Parent)
  Future<void> _outdent(List<_ViewNode> view, String id) async {
    final node = view.firstWhere((n) => n.item.itemId == id);
    final current = node.item;
    final parentId = current.parentId;
    if (parentId == null) return; // schon auf Root-Ebene

    // Parent holen, dessen Parent wird unser neuer Parent
    final parent = await (db.select(db.items)..where((t) => t.itemId.equals(parentId))).getSingle();
    final String? newParentId = parent.parentId;

    // orderIndex: direkt nach dem Parent einsortieren
    final nextAfterParent = await (db.select(db.items)
          ..where((t) => newParentId == null
              ? t.parentId.isNull()
              : t.parentId.equals(newParentId!)) // Null-safety fix
          ..where((t) => t.orderIndex.isBiggerThanValue(parent.orderIndex))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.orderIndex)])
          ..limit(1))
        .getSingleOrNull();

    final newIdx = nextAfterParent == null
        ? parent.orderIndex + 1.0
        : (parent.orderIndex + nextAfterParent.orderIndex) / 2.0;

    await (db.update(db.items)..where((t) => t.itemId.equals(current.itemId))).write(
      ItemsCompanion(parentId: drift.Value(newParentId), orderIndex: drift.Value(newIdx)),
    );
  }

  // Move up/down in gleicher Ebene (über orderIndex)
  Future<void> _moveUp(List<_ViewNode> view, String id) async {
    final node = view.firstWhere((n) => n.item.itemId == id);

    final siblings = await (db.select(db.items)
          ..where((t) => node.item.parentId == null
              ? t.parentId.isNull()
              : t.parentId.equals(node.item.parentId!)) // Null-safety fix
          ..orderBy([(t) => drift.OrderingTerm.asc(t.orderIndex)]))
        .get();

    final i = siblings.indexWhere((s) => s.itemId == id);
    if (i <= 0) return;

    final before = siblings[i - 1];
    final newIdx = (i - 2) >= 0
        ? (siblings[i - 2].orderIndex + before.orderIndex) / 2.0
        : before.orderIndex - 1.0;

    await (db.update(db.items)..where((t) => t.itemId.equals(id)))
        .write(ItemsCompanion(orderIndex: drift.Value(newIdx)));
  }

  Future<void> _moveDown(List<_ViewNode> view, String id) async {
    final node = view.firstWhere((n) => n.item.itemId == id);

    final siblings = await (db.select(db.items)
          ..where((t) => node.item.parentId == null
              ? t.parentId.isNull()
              : t.parentId.equals(node.item.parentId!)) // Null-safety fix
          ..orderBy([(t) => drift.OrderingTerm.asc(t.orderIndex)]))
        .get();

    final i = siblings.indexWhere((s) => s.itemId == id);
    if (i < 0 || i >= siblings.length - 1) return;

    final after = siblings[i + 1];
    final newIdx = (i + 2) < siblings.length
        ? (after.orderIndex + siblings[i + 2].orderIndex) / 2.0
        : after.orderIndex + 1.0;

    await (db.update(db.items)..where((t) => t.itemId.equals(id)))
        .write(ItemsCompanion(orderIndex: drift.Value(newIdx)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweight – Hierarchie MVP',
      home: Scaffold(
        appBar: AppBar(title: const Text('Tweight – Hierarchie MVP')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Schnellnotiz…',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _add, child: const Text('Add')),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<List<Item>>(
                stream: _watchAll(),
                builder: (context, snap) {
                  final items = snap.data ?? const <Item>[];
                  final view = _buildView(items);

                  if (view.isEmpty) {
                    return const Center(child: Text('Noch keine Items – leg los!'));
                  }

                  return ListView.builder(
                    itemCount: view.length,
                    itemBuilder: (_, i) {
                      final n = view[i];
                      final it = n.item;
                      final isSelected = _selectedId == it.itemId;
                      final hasChildren = items.any((x) => x.parentId == it.itemId);
                      final isCollapsed = _collapsed.contains(it.itemId);

                      return InkWell(
                        onTap: () => setState(() => _selectedId = it.itemId),
                        child: Container(
                          color: isSelected ? Colors.blue.withOpacity(0.08) : null,
                          padding: EdgeInsets.only(
                            left: 12.0 + n.depth * 18.0,
                            right: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          child: Row(
                            children: [
                              // Expand/Collapse
                              if (hasChildren)
                                IconButton(
                                  iconSize: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                  icon: Icon(isCollapsed ? Icons.chevron_right : Icons.expand_more),
                                  onPressed: () => setState(() {
                                    if (isCollapsed) {
                                      _collapsed.remove(it.itemId);
                                    } else {
                                      _collapsed.add(it.itemId);
                                    }
                                  }),
                                )
                              else
                                const SizedBox(width: 28),

                              // Label
                              Expanded(child: Text(it.label)),

                              // Controls
                              IconButton(
                                tooltip: 'Ausrücken (Ebene hoch)',
                                icon: const Icon(Icons.format_indent_decrease),
                                onPressed: () async {
                                  await _outdent(view, it.itemId);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                tooltip: 'Einrücken (als Kind des vorherigen)',
                                icon: const Icon(Icons.format_indent_increase),
                                onPressed: () async {
                                  await _indent(view, it.itemId);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                tooltip: 'Nach oben',
                                icon: const Icon(Icons.arrow_upward),
                                onPressed: () async {
                                  await _moveUp(view, it.itemId);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                tooltip: 'Nach unten',
                                icon: const Icon(Icons.arrow_downward),
                                onPressed: () async {
                                  await _moveDown(view, it.itemId);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                tooltip: 'Löschen',
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(it.itemId),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewNode {
  final Item item;
  final int depth;
  final bool visible;
  _ViewNode({required this.item, required this.depth, required this.visible});
}