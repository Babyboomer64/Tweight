import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tweight_local/db/app_db.dart';

/// Small helper to describe an item's parent relation (with optional rank).
class _ParentInfo {
  final String id;
  final double? rank;
  const _ParentInfo(this.id, this.rank);
}

/// Hierarchy model in relationsJson:
///   [{"type":"parent","target":"<PARENT_ID>","rank":123.45}]
/// For top-level ordering we use a hidden root item with id "_root".
/// Every top-level item has parent "_root" (so "rank" works consistently).
class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});
  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  static const String kRootId = "_root";

  late final AppDatabase db;
  bool _loading = true;
  List<Item> _items = [];

  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  // horizontal drag state (indent / outdent)
  String? _activeDragId;
  double _dragDx = 0.0;        // accumulated horizontal delta while dragging

  // vertical DnD (drop highlight)
  String? _hoverTargetId;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
    _load();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  Future<void> _ensureRoot() async {
    // Create hidden root item if missing
    final root = _items.where((x) => x.id == kRootId).toList();
    if (root.isEmpty) {
      await db.createItem(
        id: kRootId,
        ownerId: 'owner-local',
        label: 'ROOT',
        content: '',
        tagsJson: jsonEncode(['system:root']),
        relationsJson: '[]',
      );
      final rows = await db.listActiveItems();
      _items = rows;
    }
  }

  Future<void> _load() async {
    final rows = await db.listActiveItems();
    _items = rows;
    await _ensureRoot();
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    db.close();
    super.dispose();
  }

  // ---------- TAGS ----------
  List<String> _tagsOf(Item it) {
    try {
      final decoded = jsonDecode(it.tagsJson);
      if (decoded is List) {
        return decoded
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      if (decoded is Map) {
        return decoded.keys.map((s) => s.toString()).toList();
      }
    } catch (_) {}
    return const [];
  }

  // ---------- PARENT RELATION (with optional rank) ----------
  _ParentInfo? _parentOf(Item it) {
    try {
      final list = (jsonDecode(it.relationsJson) as List).cast<dynamic>();
      for (final e in list) {
        if (e is Map && e['type'] == 'parent' && e['target'] is String) {
          final id = e['target'] as String;
          final r = e['rank'];
          final rank = (r is num) ? r.toDouble() : null;
          return _ParentInfo(id, rank);
        }
      }
    } catch (_) {}
    // If no explicit parent and item is not root, treat as root-child by default
    if (it.id != kRootId) return _ParentInfo(kRootId, null);
    return null; // root has no parent
  }

  String _setParentInJson(String relationsJson, {String? parentId, double? rank}) {
    // return updated JSON with exactly 0/1 parent relation (optionally with rank)
    List<dynamic> list;
    try {
      final raw = jsonDecode(relationsJson);
      list = raw is List ? List<dynamic>.from(raw) : <dynamic>[];
    } catch (_) {
      list = <dynamic>[];
    }
    list = list.where((e) => !(e is Map && e['type'] == 'parent')).toList();
    if (parentId != null) {
      final m = <String, dynamic>{'type': 'parent', 'target': parentId};
      if (rank != null) m['rank'] = rank;
      list.add(m);
    }
    return jsonEncode(list);
  }

  // ---------- TREE HELPERS ----------
  int _cmpNullableDouble(double? a, double? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1; // nulls last
    if (b == null) return -1;
    return a.compareTo(b);
  }

  List<Item> _childrenOf(String parentId, Map<String, Item> byId) {
    final children = _items.where((x) {
      final p = _parentOf(x);
      return p != null && p.id == parentId && x.id != kRootId;
    }).toList();

    children.sort((a, b) {
      final pa = _parentOf(a), pb = _parentOf(b);
      final ra = pa?.rank, rb = pb?.rank;
      final cr = _cmpNullableDouble(ra, rb);
      if (cr != 0) return cr;
      final ca = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final cb = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final cc = ca.compareTo(cb);
      if (cc != 0) return cc;
      return a.id.compareTo(b.id);
    });
    return children;
  }

  bool _matchesQuery(Item it) {
    if (_query.isEmpty) return true;
    final q = _query;
    if (it.label.toLowerCase().contains(q)) return true;
    if (it.content.toLowerCase().contains(q)) return true;
    return _tagsOf(it).any((t) => t.toLowerCase().contains(q));
  }

  bool _subtreeMatches(String rootId, Map<String, Item> byId) {
    for (final child in _childrenOf(rootId, byId)) {
      if (_matchesQuery(child)) return true;
      if (_subtreeMatches(child.id, byId)) return true;
    }
    return false;
  }

  int _indentLevel(Item it, Map<String, Item> byId) {
    if (it.id == kRootId) return 0;
    var lvl = 0;
    var cur = it;
    var seen = <String>{it.id};
    while (true) {
      final p = _parentOf(cur);
      if (p == null || p.id == kRootId) break;
      final par = byId[p.id];
      if (par == null) break;
      if (seen.contains(par.id)) break;
      seen.add(par.id);
      lvl++;
      cur = par;
      if (lvl > 64) break;
    }
    return lvl;
  }

  bool _isAncestor(String ancestorId, String nodeId, Map<String, Item> byId) {
    if (ancestorId == kRootId) return false;
    var cur = byId[nodeId];
    var guard = 0;
    while (cur != null && guard++ < 64) {
      final p = _parentOf(cur);
      if (p == null) return false;
      if (p.id == ancestorId) return true;
      cur = byId[p.id];
    }
    return false;
  }

  /// Flatten for view: start at ROOT's children and DFS down.
  List<Item> _flattenForView() {
    final byId = {for (final it in _items) it.id: it};
    final out = <Item>[];
    for (final top in _childrenOf(kRootId, byId)) {
      if (_matchesQuery(top) || _subtreeMatches(top.id, byId)) {
        void dfs(Item n) {
          out.add(n);
          for (final ch in _childrenOf(n.id, byId)) {
            if (_matchesQuery(ch) || _subtreeMatches(ch.id, byId)) {
              dfs(ch);
            }
          }
        }
        dfs(top);
      }
    }
    return out;
  }

  // ---------- CRUD ----------
  Future<void> _createItemDialog() async {
    final labelCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Label')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Content')),
            TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final tags = tagsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final tagsJson = jsonEncode(tags);

    // Place new items at the end among root children (rank = max + 1)
    final byId = {for (final it in _items) it.id: it};
    final rootChildren = _childrenOf(kRootId, byId);
    final maxRank = rootChildren
        .map((e) => _parentOf(e)?.rank ?? 0.0)
        .fold<double>(0.0, (p, e) => e > p ? e : p);
    final rank = rootChildren.isEmpty ? 0.0 : (maxRank + 1.0);

    final relationsJson = jsonEncode([
      {'type': 'parent', 'target': kRootId, 'rank': rank}
    ]);

    await db.createItem(
      id: id,
      ownerId: 'owner-local',
      label: labelCtrl.text.trim(),
      content: contentCtrl.text.trim(),
      tagsJson: tagsJson,
      relationsJson: relationsJson,
    );
    await _load();
  }

  Future<void> _editItemDialog(Item item) async {
    final labelCtrl = TextEditingController(text: item.label);
    final contentCtrl = TextEditingController(text: item.content);
    final tagsCtrl = TextEditingController(text: _tagsOf(item).join(', '));

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Label')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Content')),
            TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'delete'),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, 'save'), child: const Text('Save')),
        ],
      ),
    );

    if (action == 'delete') {
      await db.softDeleteItem(id: item.id);
      await _load();
      return;
    }
    if (action == 'save') {
      final tags = tagsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      final tagsJson = jsonEncode(tags);
      await db.updateItem(
        id: item.id,
        label: labelCtrl.text.trim(),
        content: contentCtrl.text.trim(),
        tagsJson: tagsJson,
      );
      await _load();
      return;
    }
  }

  // ---------- INDENT / OUTDENT ----------
  Future<void> _indent(String itemId, List<Item> currentVisible) async {
    final idx = currentVisible.indexWhere((e) => e.id == itemId);
    if (idx <= 0) return;

    final byId = {for (final it in _items) it.id: it};
    final candidate = currentVisible[idx - 1];

    if (_isAncestor(itemId, candidate.id, byId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot indent under your own descendant.')),
      );
      return;
    }

    // Make item FIRST child of candidate
    final children = _childrenOf(candidate.id, byId);
    final newRank = children.isEmpty
        ? 0.0
        : ((_parentOf(children.first)?.rank ?? 0.0) - 1.0);

    final item = byId[itemId]!;
    final newRel = _setParentInJson(item.relationsJson, parentId: candidate.id, rank: newRank);
    await db.updateItem(id: item.id, relationsJson: newRel);
    await _load();
  }

  Future<void> _outdent(String itemId) async {
    final byId = {for (final it in _items) it.id: it};
    final item = byId[itemId];
    if (item == null || item.id == kRootId) return;

    final parent = _parentOf(item);
    if (parent == null) return;

    final pItem = byId[parent.id];
    final gp = (pItem == null || pItem.id == kRootId) ? null : _parentOf(pItem);

    if (gp == null) {
      // New parent = ROOT, place directly AFTER current parent within ROOT children
      final rootChildren = _childrenOf(kRootId, byId);
      final pRankTop = _parentOf(pItem!)?.rank ?? 0.0;

      Item? nextAfterParent;
      for (int i = 0; i < rootChildren.length - 1; i++) {
        if (rootChildren[i].id == pItem.id) {
          nextAfterParent = rootChildren[i + 1];
          break;
        }
      }

      double newRank;
      if (nextAfterParent != null) {
        final nRank = _parentOf(nextAfterParent)?.rank ?? (pRankTop + 1.0);
        newRank = (pRankTop + nRank) / 2.0;
        if (newRank == pRankTop || newRank == nRank) newRank = pRankTop + 0.0001;
      } else {
        newRank = pRankTop + 1.0;
      }

      final newRel = _setParentInJson(item.relationsJson, parentId: kRootId, rank: newRank);
      await db.updateItem(id: item.id, relationsJson: newRel);
      await _load();
      return;
    } else {
      // New parent = grandparent.id
      final gpId = gp.id;
      final gpChildren = _childrenOf(gpId, byId);
      final pRank = _parentOf(pItem!)?.rank ?? 0.0;

      Item? nextAfterParent;
      for (int i = 0; i < gpChildren.length - 1; i++) {
        if (gpChildren[i].id == pItem.id) {
          nextAfterParent = gpChildren[i + 1];
          break;
        }
      }

      double newRank;
      if (nextAfterParent != null) {
        final nRank = _parentOf(nextAfterParent)?.rank ?? (pRank + 1.0);
        newRank = (pRank + nRank) / 2.0;
        if (newRank == pRank || newRank == nRank) newRank = pRank + 0.0001;
      } else {
        newRank = pRank + 1.0;
      }

      final newRel = _setParentInJson(item.relationsJson, parentId: gpId, rank: newRank);
      await db.updateItem(id: item.id, relationsJson: newRel);
      await _load();
    }
  }

  // ---------- DROP ONTO OTHER NODE ----------
  Future<void> _dropUnder(String draggedId, String targetId) async {
    if (draggedId == targetId || targetId == kRootId) return;
    final byId = {for (final it in _items) it.id: it};
    if (_isAncestor(draggedId, targetId, byId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot drop onto your own descendant.')),
      );
      return;
    }

    // Attach dragged root as FIRST child of target
    final targetChildren = _childrenOf(targetId, byId);
    final newRank = targetChildren.isEmpty
        ? 0.0
        : ((_parentOf(targetChildren.first)?.rank ?? 0.0) - 1.0);

    final root = byId[draggedId]!;
    final newRel = _setParentInJson(root.relationsJson, parentId: targetId, rank: newRank);
    await db.updateItem(id: root.id, relationsJson: newRel);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _flattenForView();
    final byId = {for (final it in _items) it.id: it};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search label, content, or tags…',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createItemDialog,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : visible.isEmpty
              ? const Center(child: Text('No items match. Tap + to add.'))
              : ListView.separated(
                  itemCount: visible.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final it = visible[i];
                    final level = _indentLevel(it, byId);
                    final isDragged = _activeDragId == it.id;
                    final isDraggedSubtree =
                        _activeDragId != null && _isAncestor(_activeDragId!, it.id, byId);
                    final dragOffset =
                        (isDragged || isDraggedSubtree) ? _dragDx.clamp(-40.0, 60.0) : 0.0;

                    final baseIndent = 16.0 + level * 20.0;
                    final leftPadding = (baseIndent + dragOffset).clamp(0.0, double.infinity);

                    final tags = _tagsOf(it);
                    final isHover = _hoverTargetId == it.id;

                    final row = AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: EdgeInsets.only(left: leftPadding, right: 12, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        border: isHover
                            ? Border(
                                left: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                ),
                              )
                            : null,
                        color: (isDragged || isDraggedSubtree)
                            ? (_dragDx > 28
                                ? Colors.green.withOpacity(0.12)
                                : _dragDx < -28
                                    ? Colors.orange.withOpacity(0.12)
                                    : Theme.of(context).colorScheme.surface)
                            : Theme.of(context).colorScheme.surface,
                      ),
                      child: Row(
                        children: [
                          if (level > 0)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.subdirectory_arrow_right,
                                  size: 16, color: Colors.grey.shade600),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                                if (it.content.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      it.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (tags.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: -8,
                                      children: [
                                        for (final t in tags)
                                          Chip(
                                            label: Text(t),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.drag_indicator, size: 18, color: Colors.grey),
                        ],
                      ),
                    );

                    final target = DragTarget<String>(
                      onWillAccept: (data) {
                        setState(() => _hoverTargetId = it.id);
                        return data != null && data != it.id;
                      },
                      onLeave: (_) {
                        if (_hoverTargetId == it.id) {
                          setState(() => _hoverTargetId = null);
                        }
                      },
                      onAccept: (draggedId) async {
                        setState(() => _hoverTargetId = null);
                        await _dropUnder(draggedId, it.id);
                      },
                      builder: (context, cand, rej) => row,
                    );

                    return LongPressDraggable<String>(
                      data: it.id,
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      feedback: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Opacity(
                            opacity: 0.9,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: 1)],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 12 + level * 20.0, right: 12, top: 8, bottom: 8),
                                child: Text(it.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onDragStarted: () {
                        setState(() {
                          _activeDragId = it.id;
                          _dragDx = 0.0;
                        });
                      },
                      onDragUpdate: (details) {
                        // Use delta, accumulate horizontal movement
                        setState(() => _dragDx += details.delta.dx);
                      },
                      onDragEnd: (details) async {
                        final dx = _dragDx;
                        setState(() {
                          _activeDragId = null;
                          _dragDx = 0.0;
                          _hoverTargetId = null;
                        });
                        // Horizontal indent/outdent if drop wasn't accepted onto a node:
                        if (!details.wasAccepted) {
                          final currentVisible = _flattenForView();
                          if (dx > 28) {
                            await _indent(it.id, currentVisible);
                          } else if (dx < -28) {
                            await _outdent(it.id);
                          }
                        }
                      },
                      child: target,
                    );
                  },
                ),
    );
  }
}