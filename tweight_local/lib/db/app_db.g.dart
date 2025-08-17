// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<int> itemType = GeneratedColumn<int>(
      'item_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _relationsJsonMeta =
      const VerificationMeta('relationsJson');
  @override
  late final GeneratedColumn<String> relationsJson = GeneratedColumn<String>(
      'relations_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _rowVersionMeta =
      const VerificationMeta('rowVersion');
  @override
  late final GeneratedColumn<int> rowVersion = GeneratedColumn<int>(
      'row_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        itemType,
        label,
        content,
        tagsJson,
        relationsJson,
        rowVersion,
        createdAt,
        updatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('relations_json')) {
      context.handle(
          _relationsJsonMeta,
          relationsJson.isAcceptableOrUnknown(
              data['relations_json']!, _relationsJsonMeta));
    }
    if (data.containsKey('row_version')) {
      context.handle(
          _rowVersionMeta,
          rowVersion.isAcceptableOrUnknown(
              data['row_version']!, _rowVersionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_type'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      relationsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relations_json'])!,
      rowVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}row_version'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final String id;
  final String ownerId;
  final int itemType;
  final String label;
  final String content;
  final String tagsJson;
  final String relationsJson;
  final int rowVersion;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  const Item(
      {required this.id,
      required this.ownerId,
      required this.itemType,
      required this.label,
      required this.content,
      required this.tagsJson,
      required this.relationsJson,
      required this.rowVersion,
      required this.createdAt,
      this.updatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['item_type'] = Variable<int>(itemType);
    map['label'] = Variable<String>(label);
    map['content'] = Variable<String>(content);
    map['tags_json'] = Variable<String>(tagsJson);
    map['relations_json'] = Variable<String>(relationsJson);
    map['row_version'] = Variable<int>(rowVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      itemType: Value(itemType),
      label: Value(label),
      content: Value(content),
      tagsJson: Value(tagsJson),
      relationsJson: Value(relationsJson),
      rowVersion: Value(rowVersion),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      itemType: serializer.fromJson<int>(json['itemType']),
      label: serializer.fromJson<String>(json['label']),
      content: serializer.fromJson<String>(json['content']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      relationsJson: serializer.fromJson<String>(json['relationsJson']),
      rowVersion: serializer.fromJson<int>(json['rowVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'itemType': serializer.toJson<int>(itemType),
      'label': serializer.toJson<String>(label),
      'content': serializer.toJson<String>(content),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'relationsJson': serializer.toJson<String>(relationsJson),
      'rowVersion': serializer.toJson<int>(rowVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Item copyWith(
          {String? id,
          String? ownerId,
          int? itemType,
          String? label,
          String? content,
          String? tagsJson,
          String? relationsJson,
          int? rowVersion,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isDeleted}) =>
      Item(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        itemType: itemType ?? this.itemType,
        label: label ?? this.label,
        content: content ?? this.content,
        tagsJson: tagsJson ?? this.tagsJson,
        relationsJson: relationsJson ?? this.relationsJson,
        rowVersion: rowVersion ?? this.rowVersion,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      label: data.label.present ? data.label.value : this.label,
      content: data.content.present ? data.content.value : this.content,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      relationsJson: data.relationsJson.present
          ? data.relationsJson.value
          : this.relationsJson,
      rowVersion:
          data.rowVersion.present ? data.rowVersion.value : this.rowVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('itemType: $itemType, ')
          ..write('label: $label, ')
          ..write('content: $content, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('relationsJson: $relationsJson, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ownerId, itemType, label, content,
      tagsJson, relationsJson, rowVersion, createdAt, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.itemType == this.itemType &&
          other.label == this.label &&
          other.content == this.content &&
          other.tagsJson == this.tagsJson &&
          other.relationsJson == this.relationsJson &&
          other.rowVersion == this.rowVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<int> itemType;
  final Value<String> label;
  final Value<String> content;
  final Value<String> tagsJson;
  final Value<String> relationsJson;
  final Value<int> rowVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.label = const Value.absent(),
    this.content = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.relationsJson = const Value.absent(),
    this.rowVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String ownerId,
    this.itemType = const Value.absent(),
    required String label,
    this.content = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.relationsJson = const Value.absent(),
    this.rowVersion = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        ownerId = Value(ownerId),
        label = Value(label),
        createdAt = Value(createdAt);
  static Insertable<Item> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<int>? itemType,
    Expression<String>? label,
    Expression<String>? content,
    Expression<String>? tagsJson,
    Expression<String>? relationsJson,
    Expression<int>? rowVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (itemType != null) 'item_type': itemType,
      if (label != null) 'label': label,
      if (content != null) 'content': content,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (relationsJson != null) 'relations_json': relationsJson,
      if (rowVersion != null) 'row_version': rowVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<int>? itemType,
      Value<String>? label,
      Value<String>? content,
      Value<String>? tagsJson,
      Value<String>? relationsJson,
      Value<int>? rowVersion,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ItemsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      itemType: itemType ?? this.itemType,
      label: label ?? this.label,
      content: content ?? this.content,
      tagsJson: tagsJson ?? this.tagsJson,
      relationsJson: relationsJson ?? this.relationsJson,
      rowVersion: rowVersion ?? this.rowVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<int>(itemType.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (relationsJson.present) {
      map['relations_json'] = Variable<String>(relationsJson.value);
    }
    if (rowVersion.present) {
      map['row_version'] = Variable<int>(rowVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('itemType: $itemType, ')
          ..write('label: $label, ')
          ..write('content: $content, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('relationsJson: $relationsJson, ')
          ..write('rowVersion: $rowVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemHistoryTable extends ItemHistory
    with TableInfo<$ItemHistoryTable, ItemHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _historyIdMeta =
      const VerificationMeta('historyId');
  @override
  late final GeneratedColumn<String> historyId = GeneratedColumn<String>(
      'history_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changedAtMeta =
      const VerificationMeta('changedAt');
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
      'changed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _changedByMeta =
      const VerificationMeta('changedBy');
  @override
  late final GeneratedColumn<String> changedBy = GeneratedColumn<String>(
      'changed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _changeTypeMeta =
      const VerificationMeta('changeType');
  @override
  late final GeneratedColumn<String> changeType = GeneratedColumn<String>(
      'change_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snapshotJsonMeta =
      const VerificationMeta('snapshotJson');
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
      'snapshot_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diffJsonMeta =
      const VerificationMeta('diffJson');
  @override
  late final GeneratedColumn<String> diffJson = GeneratedColumn<String>(
      'diff_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        historyId,
        itemId,
        version,
        changedAt,
        changedBy,
        changeType,
        snapshotJson,
        diffJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_history';
  @override
  VerificationContext validateIntegrity(Insertable<ItemHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('history_id')) {
      context.handle(_historyIdMeta,
          historyId.isAcceptableOrUnknown(data['history_id']!, _historyIdMeta));
    } else if (isInserting) {
      context.missing(_historyIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(_changedAtMeta,
          changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta));
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('changed_by')) {
      context.handle(_changedByMeta,
          changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta));
    }
    if (data.containsKey('change_type')) {
      context.handle(
          _changeTypeMeta,
          changeType.isAcceptableOrUnknown(
              data['change_type']!, _changeTypeMeta));
    } else if (isInserting) {
      context.missing(_changeTypeMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
          _snapshotJsonMeta,
          snapshotJson.isAcceptableOrUnknown(
              data['snapshot_json']!, _snapshotJsonMeta));
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('diff_json')) {
      context.handle(_diffJsonMeta,
          diffJson.isAcceptableOrUnknown(data['diff_json']!, _diffJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {historyId};
  @override
  ItemHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemHistoryData(
      historyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}history_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      changedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}changed_at'])!,
      changedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}changed_by']),
      changeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_type'])!,
      snapshotJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_json'])!,
      diffJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diff_json']),
    );
  }

  @override
  $ItemHistoryTable createAlias(String alias) {
    return $ItemHistoryTable(attachedDatabase, alias);
  }
}

class ItemHistoryData extends DataClass implements Insertable<ItemHistoryData> {
  final String historyId;
  final String itemId;
  final int version;
  final DateTime changedAt;
  final String? changedBy;
  final String changeType;
  final String snapshotJson;
  final String? diffJson;
  const ItemHistoryData(
      {required this.historyId,
      required this.itemId,
      required this.version,
      required this.changedAt,
      this.changedBy,
      required this.changeType,
      required this.snapshotJson,
      this.diffJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['history_id'] = Variable<String>(historyId);
    map['item_id'] = Variable<String>(itemId);
    map['version'] = Variable<int>(version);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || changedBy != null) {
      map['changed_by'] = Variable<String>(changedBy);
    }
    map['change_type'] = Variable<String>(changeType);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    if (!nullToAbsent || diffJson != null) {
      map['diff_json'] = Variable<String>(diffJson);
    }
    return map;
  }

  ItemHistoryCompanion toCompanion(bool nullToAbsent) {
    return ItemHistoryCompanion(
      historyId: Value(historyId),
      itemId: Value(itemId),
      version: Value(version),
      changedAt: Value(changedAt),
      changedBy: changedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(changedBy),
      changeType: Value(changeType),
      snapshotJson: Value(snapshotJson),
      diffJson: diffJson == null && nullToAbsent
          ? const Value.absent()
          : Value(diffJson),
    );
  }

  factory ItemHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemHistoryData(
      historyId: serializer.fromJson<String>(json['historyId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      version: serializer.fromJson<int>(json['version']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      changedBy: serializer.fromJson<String?>(json['changedBy']),
      changeType: serializer.fromJson<String>(json['changeType']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      diffJson: serializer.fromJson<String?>(json['diffJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'historyId': serializer.toJson<String>(historyId),
      'itemId': serializer.toJson<String>(itemId),
      'version': serializer.toJson<int>(version),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'changedBy': serializer.toJson<String?>(changedBy),
      'changeType': serializer.toJson<String>(changeType),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'diffJson': serializer.toJson<String?>(diffJson),
    };
  }

  ItemHistoryData copyWith(
          {String? historyId,
          String? itemId,
          int? version,
          DateTime? changedAt,
          Value<String?> changedBy = const Value.absent(),
          String? changeType,
          String? snapshotJson,
          Value<String?> diffJson = const Value.absent()}) =>
      ItemHistoryData(
        historyId: historyId ?? this.historyId,
        itemId: itemId ?? this.itemId,
        version: version ?? this.version,
        changedAt: changedAt ?? this.changedAt,
        changedBy: changedBy.present ? changedBy.value : this.changedBy,
        changeType: changeType ?? this.changeType,
        snapshotJson: snapshotJson ?? this.snapshotJson,
        diffJson: diffJson.present ? diffJson.value : this.diffJson,
      );
  ItemHistoryData copyWithCompanion(ItemHistoryCompanion data) {
    return ItemHistoryData(
      historyId: data.historyId.present ? data.historyId.value : this.historyId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      version: data.version.present ? data.version.value : this.version,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      changedBy: data.changedBy.present ? data.changedBy.value : this.changedBy,
      changeType:
          data.changeType.present ? data.changeType.value : this.changeType,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      diffJson: data.diffJson.present ? data.diffJson.value : this.diffJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemHistoryData(')
          ..write('historyId: $historyId, ')
          ..write('itemId: $itemId, ')
          ..write('version: $version, ')
          ..write('changedAt: $changedAt, ')
          ..write('changedBy: $changedBy, ')
          ..write('changeType: $changeType, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('diffJson: $diffJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(historyId, itemId, version, changedAt,
      changedBy, changeType, snapshotJson, diffJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemHistoryData &&
          other.historyId == this.historyId &&
          other.itemId == this.itemId &&
          other.version == this.version &&
          other.changedAt == this.changedAt &&
          other.changedBy == this.changedBy &&
          other.changeType == this.changeType &&
          other.snapshotJson == this.snapshotJson &&
          other.diffJson == this.diffJson);
}

class ItemHistoryCompanion extends UpdateCompanion<ItemHistoryData> {
  final Value<String> historyId;
  final Value<String> itemId;
  final Value<int> version;
  final Value<DateTime> changedAt;
  final Value<String?> changedBy;
  final Value<String> changeType;
  final Value<String> snapshotJson;
  final Value<String?> diffJson;
  final Value<int> rowid;
  const ItemHistoryCompanion({
    this.historyId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.version = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.changedBy = const Value.absent(),
    this.changeType = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.diffJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemHistoryCompanion.insert({
    required String historyId,
    required String itemId,
    required int version,
    required DateTime changedAt,
    this.changedBy = const Value.absent(),
    required String changeType,
    required String snapshotJson,
    this.diffJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : historyId = Value(historyId),
        itemId = Value(itemId),
        version = Value(version),
        changedAt = Value(changedAt),
        changeType = Value(changeType),
        snapshotJson = Value(snapshotJson);
  static Insertable<ItemHistoryData> custom({
    Expression<String>? historyId,
    Expression<String>? itemId,
    Expression<int>? version,
    Expression<DateTime>? changedAt,
    Expression<String>? changedBy,
    Expression<String>? changeType,
    Expression<String>? snapshotJson,
    Expression<String>? diffJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (historyId != null) 'history_id': historyId,
      if (itemId != null) 'item_id': itemId,
      if (version != null) 'version': version,
      if (changedAt != null) 'changed_at': changedAt,
      if (changedBy != null) 'changed_by': changedBy,
      if (changeType != null) 'change_type': changeType,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (diffJson != null) 'diff_json': diffJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemHistoryCompanion copyWith(
      {Value<String>? historyId,
      Value<String>? itemId,
      Value<int>? version,
      Value<DateTime>? changedAt,
      Value<String?>? changedBy,
      Value<String>? changeType,
      Value<String>? snapshotJson,
      Value<String?>? diffJson,
      Value<int>? rowid}) {
    return ItemHistoryCompanion(
      historyId: historyId ?? this.historyId,
      itemId: itemId ?? this.itemId,
      version: version ?? this.version,
      changedAt: changedAt ?? this.changedAt,
      changedBy: changedBy ?? this.changedBy,
      changeType: changeType ?? this.changeType,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      diffJson: diffJson ?? this.diffJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (historyId.present) {
      map['history_id'] = Variable<String>(historyId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (changedBy.present) {
      map['changed_by'] = Variable<String>(changedBy.value);
    }
    if (changeType.present) {
      map['change_type'] = Variable<String>(changeType.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (diffJson.present) {
      map['diff_json'] = Variable<String>(diffJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemHistoryCompanion(')
          ..write('historyId: $historyId, ')
          ..write('itemId: $itemId, ')
          ..write('version: $version, ')
          ..write('changedAt: $changedAt, ')
          ..write('changedBy: $changedBy, ')
          ..write('changeType: $changeType, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('diffJson: $diffJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $ItemHistoryTable itemHistory = $ItemHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [items, itemHistory];
}

typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String ownerId,
  Value<int> itemType,
  required String label,
  Value<String> content,
  Value<String> tagsJson,
  Value<String> relationsJson,
  Value<int> rowVersion,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<int> itemType,
  Value<String> label,
  Value<String> content,
  Value<String> tagsJson,
  Value<String> relationsJson,
  Value<int> rowVersion,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationsJson => $composableBuilder(
      column: $table.relationsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rowVersion => $composableBuilder(
      column: $table.rowVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationsJson => $composableBuilder(
      column: $table.relationsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rowVersion => $composableBuilder(
      column: $table.rowVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<int> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get relationsJson => $composableBuilder(
      column: $table.relationsJson, builder: (column) => column);

  GeneratedColumn<int> get rowVersion => $composableBuilder(
      column: $table.rowVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<int> itemType = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String> relationsJson = const Value.absent(),
            Value<int> rowVersion = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            ownerId: ownerId,
            itemType: itemType,
            label: label,
            content: content,
            tagsJson: tagsJson,
            relationsJson: relationsJson,
            rowVersion: rowVersion,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String ownerId,
            Value<int> itemType = const Value.absent(),
            required String label,
            Value<String> content = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String> relationsJson = const Value.absent(),
            Value<int> rowVersion = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            ownerId: ownerId,
            itemType: itemType,
            label: label,
            content: content,
            tagsJson: tagsJson,
            relationsJson: relationsJson,
            rowVersion: rowVersion,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, BaseReferences<_$AppDatabase, $ItemsTable, Item>),
    Item,
    PrefetchHooks Function()>;
typedef $$ItemHistoryTableCreateCompanionBuilder = ItemHistoryCompanion
    Function({
  required String historyId,
  required String itemId,
  required int version,
  required DateTime changedAt,
  Value<String?> changedBy,
  required String changeType,
  required String snapshotJson,
  Value<String?> diffJson,
  Value<int> rowid,
});
typedef $$ItemHistoryTableUpdateCompanionBuilder = ItemHistoryCompanion
    Function({
  Value<String> historyId,
  Value<String> itemId,
  Value<int> version,
  Value<DateTime> changedAt,
  Value<String?> changedBy,
  Value<String> changeType,
  Value<String> snapshotJson,
  Value<String?> diffJson,
  Value<int> rowid,
});

class $$ItemHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ItemHistoryTable> {
  $$ItemHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get historyId => $composableBuilder(
      column: $table.historyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeType => $composableBuilder(
      column: $table.changeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diffJson => $composableBuilder(
      column: $table.diffJson, builder: (column) => ColumnFilters(column));
}

class $$ItemHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemHistoryTable> {
  $$ItemHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get historyId => $composableBuilder(
      column: $table.historyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeType => $composableBuilder(
      column: $table.changeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diffJson => $composableBuilder(
      column: $table.diffJson, builder: (column) => ColumnOrderings(column));
}

class $$ItemHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemHistoryTable> {
  $$ItemHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get historyId =>
      $composableBuilder(column: $table.historyId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get changedBy =>
      $composableBuilder(column: $table.changedBy, builder: (column) => column);

  GeneratedColumn<String> get changeType => $composableBuilder(
      column: $table.changeType, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => column);

  GeneratedColumn<String> get diffJson =>
      $composableBuilder(column: $table.diffJson, builder: (column) => column);
}

class $$ItemHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemHistoryTable,
    ItemHistoryData,
    $$ItemHistoryTableFilterComposer,
    $$ItemHistoryTableOrderingComposer,
    $$ItemHistoryTableAnnotationComposer,
    $$ItemHistoryTableCreateCompanionBuilder,
    $$ItemHistoryTableUpdateCompanionBuilder,
    (
      ItemHistoryData,
      BaseReferences<_$AppDatabase, $ItemHistoryTable, ItemHistoryData>
    ),
    ItemHistoryData,
    PrefetchHooks Function()> {
  $$ItemHistoryTableTableManager(_$AppDatabase db, $ItemHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> historyId = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<DateTime> changedAt = const Value.absent(),
            Value<String?> changedBy = const Value.absent(),
            Value<String> changeType = const Value.absent(),
            Value<String> snapshotJson = const Value.absent(),
            Value<String?> diffJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemHistoryCompanion(
            historyId: historyId,
            itemId: itemId,
            version: version,
            changedAt: changedAt,
            changedBy: changedBy,
            changeType: changeType,
            snapshotJson: snapshotJson,
            diffJson: diffJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String historyId,
            required String itemId,
            required int version,
            required DateTime changedAt,
            Value<String?> changedBy = const Value.absent(),
            required String changeType,
            required String snapshotJson,
            Value<String?> diffJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemHistoryCompanion.insert(
            historyId: historyId,
            itemId: itemId,
            version: version,
            changedAt: changedAt,
            changedBy: changedBy,
            changeType: changeType,
            snapshotJson: snapshotJson,
            diffJson: diffJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemHistoryTable,
    ItemHistoryData,
    $$ItemHistoryTableFilterComposer,
    $$ItemHistoryTableOrderingComposer,
    $$ItemHistoryTableAnnotationComposer,
    $$ItemHistoryTableCreateCompanionBuilder,
    $$ItemHistoryTableUpdateCompanionBuilder,
    (
      ItemHistoryData,
      BaseReferences<_$AppDatabase, $ItemHistoryTable, ItemHistoryData>
    ),
    ItemHistoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ItemHistoryTableTableManager get itemHistory =>
      $$ItemHistoryTableTableManager(_db, _db.itemHistory);
}
