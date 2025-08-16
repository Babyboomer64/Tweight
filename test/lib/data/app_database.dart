// lib/data/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'app_database.g.dart';

class Items extends Table {
  TextColumn get itemId => text()();                 // UUID/ID als String
  TextColumn get label => text()();                  // Kurztext
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Hierarchie + Sortierung
  TextColumn get parentId => text().nullable()();    // Referenz auf Parent (itemId)
  RealColumn get orderIndex => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {itemId};
}

@DriftDatabase(tables: [Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(items, items.parentId);
        await m.addColumn(items, items.orderIndex);
        // Neueste zuerst: negative Zeitstempel -> oben
        await customStatement(
          "UPDATE items SET order_index = CAST(strftime('%s', created_at) AS REAL) * -1.0",
        );
      }
    },
  );
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'tweight.sqlite'));
    return NativeDatabase(file);
  });
}