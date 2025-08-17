import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

/// ------------------------------
/// Item (current state)
/// ------------------------------
class Items extends Table {
  TextColumn get id => text()();                              // UUID (PK)
  TextColumn get ownerId => text()();                         // reserved for sync/tenant use
  IntColumn get itemType => integer().withDefault(const Constant(0))();
  TextColumn get label => text()();                           // short title
  TextColumn get content => text().withDefault(const Constant(''))();        // free text
  TextColumn get tagsJson => text().withDefault(const Constant('{}'))();     // JSON map
  TextColumn get relationsJson => text().withDefault(const Constant('[]'))(); // JSON list
  IntColumn get rowVersion => integer().withDefault(const Constant(1))();    // version counter
  DateTimeColumn get createdAt => dateTime()();               // created timestamp
  DateTimeColumn get updatedAt => dateTime().nullable()();    // last modification
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))(); // soft delete flag

  @override
  Set<Column> get primaryKey => {id};
}

/// ------------------------------
/// Item History (immutable journal)
/// ------------------------------
class ItemHistory extends Table {
  TextColumn get historyId => text()();           // UUID (PK)
  TextColumn get itemId => text()();              // reference -> Items.id
  IntColumn get version => integer()();           // copy of rowVersion after change
  DateTimeColumn get changedAt => dateTime()();   // timestamp of change
  TextColumn get changedBy => text().nullable()();  // optional (e.g. device:<id>)
  TextColumn get changeType => text()();          // insert | update | delete | restore
  TextColumn get snapshotJson => text()();        // full item snapshot (after change)
  TextColumn get diffJson => text().nullable()(); // optional: delta only

  @override
  Set<Column> get primaryKey => {historyId};
}

@DriftDatabase(tables: [Items, ItemHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // future migrations
    },
  );

  /// -------- Minimal CRUD operations --------

  /// List all active items (ignores soft-deleted ones), newest first
 Future<List<Item>> listActiveItems() {
    // Stable ordering: createdAt ASC (older first), then id ASC as tiebreaker
    final q = select(items)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([
        (t) => OrderingTerm.asc(t.createdAt),
        (t) => OrderingTerm.asc(t.id),
      ]);
    return q.get();
  }

  /// Insert new item + history (rowVersion=1)
  Future<void> createItem({
    required String id,
    required String ownerId,
    required String label,
    String content = '',
    String tagsJson = '{}',
    String relationsJson = '[]',
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    await transaction(() async {
      await into(items).insert(ItemsCompanion.insert(
        id: id,
        ownerId: ownerId,
        label: label,
        createdAt: ts,
        // Optional columns with defaults: pass as Value(...) ONLY if you want to override defaults
        content: Value(content),
        tagsJson: Value(tagsJson),
        relationsJson: Value(relationsJson),
        // rowVersion, itemType, isDeleted have defaults -> can be omitted
        updatedAt: const Value(null),
      ));

      await into(itemHistory).insert(ItemHistoryCompanion.insert(
        historyId: _uuidLike(),
        itemId: id,
        version: 1,
        changedAt: ts,
        changedBy: const Value(null),
        changeType: 'insert',
        snapshotJson: _snapshotOf(
          id: id, ownerId: ownerId, label: label, content: content,
          tagsJson: tagsJson, relationsJson: relationsJson,
          rowVersion: 1, createdAt: ts, updatedAt: null, isDeleted: false, itemType: 0,
        ),
        diffJson: const Value(null),
      ));
    });
  }

  /// Update existing item + history (rowVersion++)
  Future<void> updateItem({
    required String id,
    String? label,
    String? content,
    String? tagsJson,
    String? relationsJson,
    DateTime? now,
  }) async {
    final ts = now ?? DateTime.now();
    await transaction(() async {
      final current = await (select(items)..where((t) => t.id.equals(id))).getSingle();
      final nextVersion = current.rowVersion + 1;

      await (update(items)..where((t) => t.id.equals(id))).write(ItemsCompanion(
        label: label != null ? Value(label) : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
        tagsJson: tagsJson != null ? Value(tagsJson) : const Value.absent(),
        relationsJson: relationsJson != null ? Value(relationsJson) : const Value.absent(),
        rowVersion: Value(nextVersion),
        updatedAt: Value(ts),
      ));

      final after = await (select(items)..where((t) => t.id.equals(id))).getSingle();

      await into(itemHistory).insert(ItemHistoryCompanion.insert(
        historyId: _uuidLike(),
        itemId: id,
        version: nextVersion,
        changedAt: ts,
        changedBy: const Value(null),
        changeType: 'update',
        snapshotJson: _snapshotFromRow(after),
        diffJson: const Value(null),
      ));
    });
  }

  /// Soft delete item + history
  Future<void> softDeleteItem({required String id, DateTime? now}) async {
    final ts = now ?? DateTime.now();
    await transaction(() async {
      final current = await (select(items)..where((t) => t.id.equals(id))).getSingle();
      final nextVersion = current.rowVersion + 1;

      await (update(items)..where((t) => t.id.equals(id))).write(ItemsCompanion(
        isDeleted: const Value(true),
        rowVersion: Value(nextVersion),
        updatedAt: Value(ts),
      ));

      final after = await (select(items)..where((t) => t.id.equals(id))).getSingle();

      await into(itemHistory).insert(ItemHistoryCompanion.insert(
        historyId: _uuidLike(),
        itemId: id,
        version: nextVersion,
        changedAt: ts,
        changedBy: const Value(null),
        changeType: 'delete',
        snapshotJson: _snapshotFromRow(after),
        diffJson: const Value(null),
      ));
    });
  }
}

/// Open a persistent SQLite database using drift_sqflite.
LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'tweight.sqlite');
    // IMPORTANT: use named parameter `path:`
    return SqfliteQueryExecutor(path: dbPath);
  });
}

/// ---------- Helpers ----------
String _uuidLike() => DateTime.now().microsecondsSinceEpoch.toString();

String _snapshotOf({
  required String id,
  required String ownerId,
  required String label,
  required String content,
  required String tagsJson,
  required String relationsJson,
  required int rowVersion,
  required DateTime createdAt,
  required DateTime? updatedAt,
  required bool isDeleted,
  required int itemType,
}) {
  final u = updatedAt?.toIso8601String();
  return '''
{
  "id":"$id",
  "owner_id":"$ownerId",
  "item_type":$itemType,
  "label":${_j(label)},
  "content":${_j(content)},
  "tags_json":$tagsJson,
  "relations_json":$relationsJson,
  "row_version":$rowVersion,
  "created_at":"${createdAt.toIso8601String()}",
  "updated_at":${u == null ? 'null' : _j(u)},
  "is_deleted":$isDeleted
}
''';
}

String _snapshotFromRow(Item r) => _snapshotOf(
  id: r.id,
  ownerId: r.ownerId,
  label: r.label,
  content: r.content,
  tagsJson: r.tagsJson,
  relationsJson: r.relationsJson,
  rowVersion: r.rowVersion,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
  isDeleted: r.isDeleted,
  itemType: r.itemType,
);

String _j(String s) => '"${s.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';
