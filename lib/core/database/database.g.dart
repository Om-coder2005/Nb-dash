// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ZonesTable extends Zones with TableInfo<$ZonesTable, Zone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF3B82F6));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zones';
  @override
  VerificationContext validateIntegrity(Insertable<Zone> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Zone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Zone(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $ZonesTable createAlias(String alias) {
    return $ZonesTable(attachedDatabase, alias);
  }
}

class Zone extends DataClass implements Insertable<Zone> {
  final int id;
  final String name;
  final int colorValue;
  final int sortOrder;
  const Zone(
      {required this.id,
      required this.name,
      required this.colorValue,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ZonesCompanion toCompanion(bool nullToAbsent) {
    return ZonesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
    );
  }

  factory Zone.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Zone(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Zone copyWith({int? id, String? name, int? colorValue, int? sortOrder}) =>
      Zone(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Zone copyWithCompanion(ZonesCompanion data) {
    return Zone(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Zone(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Zone &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder);
}

class ZonesCompanion extends UpdateCompanion<Zone> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  const ZonesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ZonesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Zone> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ZonesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? colorValue,
      Value<int>? sortOrder}) {
    return ZonesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $RestaurantTablesTable extends RestaurantTables
    with TableInfo<$RestaurantTablesTable, RestaurantTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestaurantTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _zoneIdMeta = const VerificationMeta('zoneId');
  @override
  late final GeneratedColumn<int> zoneId = GeneratedColumn<int>(
      'zone_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES zones (id)'));
  static const VerificationMeta _tableNumberMeta =
      const VerificationMeta('tableNumber');
  @override
  late final GeneratedColumn<String> tableNumber = GeneratedColumn<String>(
      'table_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _tableLabelMeta =
      const VerificationMeta('tableLabel');
  @override
  late final GeneratedColumn<String> tableLabel = GeneratedColumn<String>(
      'table_label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _posXMeta = const VerificationMeta('posX');
  @override
  late final GeneratedColumn<double> posX = GeneratedColumn<double>(
      'pos_x', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _posYMeta = const VerificationMeta('posY');
  @override
  late final GeneratedColumn<double> posY = GeneratedColumn<double>(
      'pos_y', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
      'shape', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('square'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        zoneId,
        tableNumber,
        tableLabel,
        capacity,
        posX,
        posY,
        shape,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'restaurant_tables';
  @override
  VerificationContext validateIntegrity(Insertable<RestaurantTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_id')) {
      context.handle(_zoneIdMeta,
          zoneId.isAcceptableOrUnknown(data['zone_id']!, _zoneIdMeta));
    } else if (isInserting) {
      context.missing(_zoneIdMeta);
    }
    if (data.containsKey('table_number')) {
      context.handle(
          _tableNumberMeta,
          tableNumber.isAcceptableOrUnknown(
              data['table_number']!, _tableNumberMeta));
    } else if (isInserting) {
      context.missing(_tableNumberMeta);
    }
    if (data.containsKey('table_label')) {
      context.handle(
          _tableLabelMeta,
          tableLabel.isAcceptableOrUnknown(
              data['table_label']!, _tableLabelMeta));
    } else if (isInserting) {
      context.missing(_tableLabelMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('pos_x')) {
      context.handle(
          _posXMeta, posX.isAcceptableOrUnknown(data['pos_x']!, _posXMeta));
    }
    if (data.containsKey('pos_y')) {
      context.handle(
          _posYMeta, posY.isAcceptableOrUnknown(data['pos_y']!, _posYMeta));
    }
    if (data.containsKey('shape')) {
      context.handle(
          _shapeMeta, shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      zoneId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}zone_id'])!,
      tableNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_number'])!,
      tableLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_label'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      posX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pos_x'])!,
      posY: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pos_y'])!,
      shape: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $RestaurantTablesTable createAlias(String alias) {
    return $RestaurantTablesTable(attachedDatabase, alias);
  }
}

class RestaurantTable extends DataClass implements Insertable<RestaurantTable> {
  final int id;
  final int zoneId;
  final String tableNumber;
  final String tableLabel;
  final int capacity;
  final double posX;
  final double posY;
  final String shape;
  final bool isActive;
  const RestaurantTable(
      {required this.id,
      required this.zoneId,
      required this.tableNumber,
      required this.tableLabel,
      required this.capacity,
      required this.posX,
      required this.posY,
      required this.shape,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_id'] = Variable<int>(zoneId);
    map['table_number'] = Variable<String>(tableNumber);
    map['table_label'] = Variable<String>(tableLabel);
    map['capacity'] = Variable<int>(capacity);
    map['pos_x'] = Variable<double>(posX);
    map['pos_y'] = Variable<double>(posY);
    map['shape'] = Variable<String>(shape);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RestaurantTablesCompanion toCompanion(bool nullToAbsent) {
    return RestaurantTablesCompanion(
      id: Value(id),
      zoneId: Value(zoneId),
      tableNumber: Value(tableNumber),
      tableLabel: Value(tableLabel),
      capacity: Value(capacity),
      posX: Value(posX),
      posY: Value(posY),
      shape: Value(shape),
      isActive: Value(isActive),
    );
  }

  factory RestaurantTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTable(
      id: serializer.fromJson<int>(json['id']),
      zoneId: serializer.fromJson<int>(json['zoneId']),
      tableNumber: serializer.fromJson<String>(json['tableNumber']),
      tableLabel: serializer.fromJson<String>(json['tableLabel']),
      capacity: serializer.fromJson<int>(json['capacity']),
      posX: serializer.fromJson<double>(json['posX']),
      posY: serializer.fromJson<double>(json['posY']),
      shape: serializer.fromJson<String>(json['shape']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneId': serializer.toJson<int>(zoneId),
      'tableNumber': serializer.toJson<String>(tableNumber),
      'tableLabel': serializer.toJson<String>(tableLabel),
      'capacity': serializer.toJson<int>(capacity),
      'posX': serializer.toJson<double>(posX),
      'posY': serializer.toJson<double>(posY),
      'shape': serializer.toJson<String>(shape),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RestaurantTable copyWith(
          {int? id,
          int? zoneId,
          String? tableNumber,
          String? tableLabel,
          int? capacity,
          double? posX,
          double? posY,
          String? shape,
          bool? isActive}) =>
      RestaurantTable(
        id: id ?? this.id,
        zoneId: zoneId ?? this.zoneId,
        tableNumber: tableNumber ?? this.tableNumber,
        tableLabel: tableLabel ?? this.tableLabel,
        capacity: capacity ?? this.capacity,
        posX: posX ?? this.posX,
        posY: posY ?? this.posY,
        shape: shape ?? this.shape,
        isActive: isActive ?? this.isActive,
      );
  RestaurantTable copyWithCompanion(RestaurantTablesCompanion data) {
    return RestaurantTable(
      id: data.id.present ? data.id.value : this.id,
      zoneId: data.zoneId.present ? data.zoneId.value : this.zoneId,
      tableNumber:
          data.tableNumber.present ? data.tableNumber.value : this.tableNumber,
      tableLabel:
          data.tableLabel.present ? data.tableLabel.value : this.tableLabel,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      posX: data.posX.present ? data.posX.value : this.posX,
      posY: data.posY.present ? data.posY.value : this.posY,
      shape: data.shape.present ? data.shape.value : this.shape,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTable(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('capacity: $capacity, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('shape: $shape, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, zoneId, tableNumber, tableLabel, capacity,
      posX, posY, shape, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTable &&
          other.id == this.id &&
          other.zoneId == this.zoneId &&
          other.tableNumber == this.tableNumber &&
          other.tableLabel == this.tableLabel &&
          other.capacity == this.capacity &&
          other.posX == this.posX &&
          other.posY == this.posY &&
          other.shape == this.shape &&
          other.isActive == this.isActive);
}

class RestaurantTablesCompanion extends UpdateCompanion<RestaurantTable> {
  final Value<int> id;
  final Value<int> zoneId;
  final Value<String> tableNumber;
  final Value<String> tableLabel;
  final Value<int> capacity;
  final Value<double> posX;
  final Value<double> posY;
  final Value<String> shape;
  final Value<bool> isActive;
  const RestaurantTablesCompanion({
    this.id = const Value.absent(),
    this.zoneId = const Value.absent(),
    this.tableNumber = const Value.absent(),
    this.tableLabel = const Value.absent(),
    this.capacity = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.shape = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  RestaurantTablesCompanion.insert({
    this.id = const Value.absent(),
    required int zoneId,
    required String tableNumber,
    required String tableLabel,
    this.capacity = const Value.absent(),
    this.posX = const Value.absent(),
    this.posY = const Value.absent(),
    this.shape = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : zoneId = Value(zoneId),
        tableNumber = Value(tableNumber),
        tableLabel = Value(tableLabel);
  static Insertable<RestaurantTable> custom({
    Expression<int>? id,
    Expression<int>? zoneId,
    Expression<String>? tableNumber,
    Expression<String>? tableLabel,
    Expression<int>? capacity,
    Expression<double>? posX,
    Expression<double>? posY,
    Expression<String>? shape,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneId != null) 'zone_id': zoneId,
      if (tableNumber != null) 'table_number': tableNumber,
      if (tableLabel != null) 'table_label': tableLabel,
      if (capacity != null) 'capacity': capacity,
      if (posX != null) 'pos_x': posX,
      if (posY != null) 'pos_y': posY,
      if (shape != null) 'shape': shape,
      if (isActive != null) 'is_active': isActive,
    });
  }

  RestaurantTablesCompanion copyWith(
      {Value<int>? id,
      Value<int>? zoneId,
      Value<String>? tableNumber,
      Value<String>? tableLabel,
      Value<int>? capacity,
      Value<double>? posX,
      Value<double>? posY,
      Value<String>? shape,
      Value<bool>? isActive}) {
    return RestaurantTablesCompanion(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      tableNumber: tableNumber ?? this.tableNumber,
      tableLabel: tableLabel ?? this.tableLabel,
      capacity: capacity ?? this.capacity,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      shape: shape ?? this.shape,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneId.present) {
      map['zone_id'] = Variable<int>(zoneId.value);
    }
    if (tableNumber.present) {
      map['table_number'] = Variable<String>(tableNumber.value);
    }
    if (tableLabel.present) {
      map['table_label'] = Variable<String>(tableLabel.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (posX.present) {
      map['pos_x'] = Variable<double>(posX.value);
    }
    if (posY.present) {
      map['pos_y'] = Variable<double>(posY.value);
    }
    if (shape.present) {
      map['shape'] = Variable<String>(shape.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTablesCompanion(')
          ..write('id: $id, ')
          ..write('zoneId: $zoneId, ')
          ..write('tableNumber: $tableNumber, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('capacity: $capacity, ')
          ..write('posX: $posX, ')
          ..write('posY: $posY, ')
          ..write('shape: $shape, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MenuCategoriesTable extends MenuCategories
    with TableInfo<$MenuCategoriesTable, MenuCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFFF59E0B));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, colorValue, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_categories';
  @override
  VerificationContext validateIntegrity(Insertable<MenuCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $MenuCategoriesTable createAlias(String alias) {
    return $MenuCategoriesTable(attachedDatabase, alias);
  }
}

class MenuCategory extends DataClass implements Insertable<MenuCategory> {
  final int id;
  final String name;
  final int colorValue;
  final int sortOrder;
  final bool isActive;
  const MenuCategory(
      {required this.id,
      required this.name,
      required this.colorValue,
      required this.sortOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MenuCategoriesCompanion toCompanion(bool nullToAbsent) {
    return MenuCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory MenuCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MenuCategory copyWith(
          {int? id,
          String? name,
          int? colorValue,
          int? sortOrder,
          bool? isActive}) =>
      MenuCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
  MenuCategory copyWithCompanion(MenuCategoriesCompanion data) {
    return MenuCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class MenuCategoriesCompanion extends UpdateCompanion<MenuCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const MenuCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MenuCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MenuCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MenuCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? colorValue,
      Value<int>? sortOrder,
      Value<bool>? isActive}) {
    return MenuCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menu_categories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isVegMeta = const VerificationMeta('isVeg');
  @override
  late final GeneratedColumn<bool> isVeg = GeneratedColumn<bool>(
      'is_veg', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_veg" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hasHalfFullMeta =
      const VerificationMeta('hasHalfFull');
  @override
  late final GeneratedColumn<bool> hasHalfFull = GeneratedColumn<bool>(
      'has_half_full', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_half_full" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _halfPriceMeta =
      const VerificationMeta('halfPrice');
  @override
  late final GeneratedColumn<double> halfPrice = GeneratedColumn<double>(
      'half_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _defaultSizeMeta =
      const VerificationMeta('defaultSize');
  @override
  late final GeneratedColumn<String> defaultSize = GeneratedColumn<String>(
      'default_size', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('full'));
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customVariantsJsonMeta =
      const VerificationMeta('customVariantsJson');
  @override
  late final GeneratedColumn<String> customVariantsJson =
      GeneratedColumn<String>('custom_variants_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        name,
        description,
        price,
        isAvailable,
        isVeg,
        sortOrder,
        hasHalfFull,
        halfPrice,
        defaultSize,
        image,
        customVariantsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items';
  @override
  VerificationContext validateIntegrity(Insertable<MenuItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('is_veg')) {
      context.handle(
          _isVegMeta, isVeg.isAcceptableOrUnknown(data['is_veg']!, _isVegMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('has_half_full')) {
      context.handle(
          _hasHalfFullMeta,
          hasHalfFull.isAcceptableOrUnknown(
              data['has_half_full']!, _hasHalfFullMeta));
    }
    if (data.containsKey('half_price')) {
      context.handle(_halfPriceMeta,
          halfPrice.isAcceptableOrUnknown(data['half_price']!, _halfPriceMeta));
    }
    if (data.containsKey('default_size')) {
      context.handle(
          _defaultSizeMeta,
          defaultSize.isAcceptableOrUnknown(
              data['default_size']!, _defaultSizeMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('custom_variants_json')) {
      context.handle(
          _customVariantsJsonMeta,
          customVariantsJson.isAcceptableOrUnknown(
              data['custom_variants_json']!, _customVariantsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      isVeg: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_veg'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      hasHalfFull: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_half_full'])!,
      halfPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}half_price'])!,
      defaultSize: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_size'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      customVariantsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_variants_json'])!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final bool isAvailable;
  final bool isVeg;
  final int sortOrder;
  final bool hasHalfFull;
  final double halfPrice;
  final String defaultSize;
  final String? image;
  final String customVariantsJson;
  const MenuItem(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.description,
      required this.price,
      required this.isAvailable,
      required this.isVeg,
      required this.sortOrder,
      required this.hasHalfFull,
      required this.halfPrice,
      required this.defaultSize,
      this.image,
      required this.customVariantsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['price'] = Variable<double>(price);
    map['is_available'] = Variable<bool>(isAvailable);
    map['is_veg'] = Variable<bool>(isVeg);
    map['sort_order'] = Variable<int>(sortOrder);
    map['has_half_full'] = Variable<bool>(hasHalfFull);
    map['half_price'] = Variable<double>(halfPrice);
    map['default_size'] = Variable<String>(defaultSize);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['custom_variants_json'] = Variable<String>(customVariantsJson);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: Value(description),
      price: Value(price),
      isAvailable: Value(isAvailable),
      isVeg: Value(isVeg),
      sortOrder: Value(sortOrder),
      hasHalfFull: Value(hasHalfFull),
      halfPrice: Value(halfPrice),
      defaultSize: Value(defaultSize),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      customVariantsJson: Value(customVariantsJson),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      isVeg: serializer.fromJson<bool>(json['isVeg']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      hasHalfFull: serializer.fromJson<bool>(json['hasHalfFull']),
      halfPrice: serializer.fromJson<double>(json['halfPrice']),
      defaultSize: serializer.fromJson<String>(json['defaultSize']),
      image: serializer.fromJson<String?>(json['image']),
      customVariantsJson:
          serializer.fromJson<String>(json['customVariantsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'price': serializer.toJson<double>(price),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'isVeg': serializer.toJson<bool>(isVeg),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'hasHalfFull': serializer.toJson<bool>(hasHalfFull),
      'halfPrice': serializer.toJson<double>(halfPrice),
      'defaultSize': serializer.toJson<String>(defaultSize),
      'image': serializer.toJson<String?>(image),
      'customVariantsJson': serializer.toJson<String>(customVariantsJson),
    };
  }

  MenuItem copyWith(
          {int? id,
          int? categoryId,
          String? name,
          String? description,
          double? price,
          bool? isAvailable,
          bool? isVeg,
          int? sortOrder,
          bool? hasHalfFull,
          double? halfPrice,
          String? defaultSize,
          Value<String?> image = const Value.absent(),
          String? customVariantsJson}) =>
      MenuItem(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        isAvailable: isAvailable ?? this.isAvailable,
        isVeg: isVeg ?? this.isVeg,
        sortOrder: sortOrder ?? this.sortOrder,
        hasHalfFull: hasHalfFull ?? this.hasHalfFull,
        halfPrice: halfPrice ?? this.halfPrice,
        defaultSize: defaultSize ?? this.defaultSize,
        image: image.present ? image.value : this.image,
        customVariantsJson: customVariantsJson ?? this.customVariantsJson,
      );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      price: data.price.present ? data.price.value : this.price,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      isVeg: data.isVeg.present ? data.isVeg.value : this.isVeg,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      hasHalfFull:
          data.hasHalfFull.present ? data.hasHalfFull.value : this.hasHalfFull,
      halfPrice: data.halfPrice.present ? data.halfPrice.value : this.halfPrice,
      defaultSize:
          data.defaultSize.present ? data.defaultSize.value : this.defaultSize,
      image: data.image.present ? data.image.value : this.image,
      customVariantsJson: data.customVariantsJson.present
          ? data.customVariantsJson.value
          : this.customVariantsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isVeg: $isVeg, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('hasHalfFull: $hasHalfFull, ')
          ..write('halfPrice: $halfPrice, ')
          ..write('defaultSize: $defaultSize, ')
          ..write('image: $image, ')
          ..write('customVariantsJson: $customVariantsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      categoryId,
      name,
      description,
      price,
      isAvailable,
      isVeg,
      sortOrder,
      hasHalfFull,
      halfPrice,
      defaultSize,
      image,
      customVariantsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.isAvailable == this.isAvailable &&
          other.isVeg == this.isVeg &&
          other.sortOrder == this.sortOrder &&
          other.hasHalfFull == this.hasHalfFull &&
          other.halfPrice == this.halfPrice &&
          other.defaultSize == this.defaultSize &&
          other.image == this.image &&
          other.customVariantsJson == this.customVariantsJson);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<String> description;
  final Value<double> price;
  final Value<bool> isAvailable;
  final Value<bool> isVeg;
  final Value<int> sortOrder;
  final Value<bool> hasHalfFull;
  final Value<double> halfPrice;
  final Value<String> defaultSize;
  final Value<String?> image;
  final Value<String> customVariantsJson;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.hasHalfFull = const Value.absent(),
    this.halfPrice = const Value.absent(),
    this.defaultSize = const Value.absent(),
    this.image = const Value.absent(),
    this.customVariantsJson = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.hasHalfFull = const Value.absent(),
    this.halfPrice = const Value.absent(),
    this.defaultSize = const Value.absent(),
    this.image = const Value.absent(),
    this.customVariantsJson = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name);
  static Insertable<MenuItem> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<bool>? isAvailable,
    Expression<bool>? isVeg,
    Expression<int>? sortOrder,
    Expression<bool>? hasHalfFull,
    Expression<double>? halfPrice,
    Expression<String>? defaultSize,
    Expression<String>? image,
    Expression<String>? customVariantsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (isAvailable != null) 'is_available': isAvailable,
      if (isVeg != null) 'is_veg': isVeg,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (hasHalfFull != null) 'has_half_full': hasHalfFull,
      if (halfPrice != null) 'half_price': halfPrice,
      if (defaultSize != null) 'default_size': defaultSize,
      if (image != null) 'image': image,
      if (customVariantsJson != null)
        'custom_variants_json': customVariantsJson,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<String>? description,
      Value<double>? price,
      Value<bool>? isAvailable,
      Value<bool>? isVeg,
      Value<int>? sortOrder,
      Value<bool>? hasHalfFull,
      Value<double>? halfPrice,
      Value<String>? defaultSize,
      Value<String?>? image,
      Value<String>? customVariantsJson}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      isVeg: isVeg ?? this.isVeg,
      sortOrder: sortOrder ?? this.sortOrder,
      hasHalfFull: hasHalfFull ?? this.hasHalfFull,
      halfPrice: halfPrice ?? this.halfPrice,
      defaultSize: defaultSize ?? this.defaultSize,
      image: image ?? this.image,
      customVariantsJson: customVariantsJson ?? this.customVariantsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (isVeg.present) {
      map['is_veg'] = Variable<bool>(isVeg.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (hasHalfFull.present) {
      map['has_half_full'] = Variable<bool>(hasHalfFull.value);
    }
    if (halfPrice.present) {
      map['half_price'] = Variable<double>(halfPrice.value);
    }
    if (defaultSize.present) {
      map['default_size'] = Variable<String>(defaultSize.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (customVariantsJson.present) {
      map['custom_variants_json'] = Variable<String>(customVariantsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isVeg: $isVeg, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('hasHalfFull: $hasHalfFull, ')
          ..write('halfPrice: $halfPrice, ')
          ..write('defaultSize: $defaultSize, ')
          ..write('image: $image, ')
          ..write('customVariantsJson: $customVariantsJson')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES restaurant_tables (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _waiterNameMeta =
      const VerificationMeta('waiterName');
  @override
  late final GeneratedColumn<String> waiterName = GeneratedColumn<String>(
      'waiter_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coversMeta = const VerificationMeta('covers');
  @override
  late final GeneratedColumn<int> covers = GeneratedColumn<int>(
      'covers', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tableId,
        status,
        waiterName,
        customerName,
        covers,
        openedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('waiter_name')) {
      context.handle(
          _waiterNameMeta,
          waiterName.isAcceptableOrUnknown(
              data['waiter_name']!, _waiterNameMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('covers')) {
      context.handle(_coversMeta,
          covers.isAcceptableOrUnknown(data['covers']!, _coversMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      waiterName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}waiter_name'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      covers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}covers'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final int tableId;
  final String status;
  final String waiterName;
  final String customerName;
  final int covers;
  final DateTime openedAt;
  final DateTime updatedAt;
  const Order(
      {required this.id,
      required this.tableId,
      required this.status,
      required this.waiterName,
      required this.customerName,
      required this.covers,
      required this.openedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_id'] = Variable<int>(tableId);
    map['status'] = Variable<String>(status);
    map['waiter_name'] = Variable<String>(waiterName);
    map['customer_name'] = Variable<String>(customerName);
    map['covers'] = Variable<int>(covers);
    map['opened_at'] = Variable<DateTime>(openedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      tableId: Value(tableId),
      status: Value(status),
      waiterName: Value(waiterName),
      customerName: Value(customerName),
      covers: Value(covers),
      openedAt: Value(openedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      tableId: serializer.fromJson<int>(json['tableId']),
      status: serializer.fromJson<String>(json['status']),
      waiterName: serializer.fromJson<String>(json['waiterName']),
      customerName: serializer.fromJson<String>(json['customerName']),
      covers: serializer.fromJson<int>(json['covers']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableId': serializer.toJson<int>(tableId),
      'status': serializer.toJson<String>(status),
      'waiterName': serializer.toJson<String>(waiterName),
      'customerName': serializer.toJson<String>(customerName),
      'covers': serializer.toJson<int>(covers),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Order copyWith(
          {int? id,
          int? tableId,
          String? status,
          String? waiterName,
          String? customerName,
          int? covers,
          DateTime? openedAt,
          DateTime? updatedAt}) =>
      Order(
        id: id ?? this.id,
        tableId: tableId ?? this.tableId,
        status: status ?? this.status,
        waiterName: waiterName ?? this.waiterName,
        customerName: customerName ?? this.customerName,
        covers: covers ?? this.covers,
        openedAt: openedAt ?? this.openedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      status: data.status.present ? data.status.value : this.status,
      waiterName:
          data.waiterName.present ? data.waiterName.value : this.waiterName,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      covers: data.covers.present ? data.covers.value : this.covers,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('status: $status, ')
          ..write('waiterName: $waiterName, ')
          ..write('customerName: $customerName, ')
          ..write('covers: $covers, ')
          ..write('openedAt: $openedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tableId, status, waiterName, customerName,
      covers, openedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.tableId == this.tableId &&
          other.status == this.status &&
          other.waiterName == this.waiterName &&
          other.customerName == this.customerName &&
          other.covers == this.covers &&
          other.openedAt == this.openedAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<int> tableId;
  final Value<String> status;
  final Value<String> waiterName;
  final Value<String> customerName;
  final Value<int> covers;
  final Value<DateTime> openedAt;
  final Value<DateTime> updatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.tableId = const Value.absent(),
    this.status = const Value.absent(),
    this.waiterName = const Value.absent(),
    this.customerName = const Value.absent(),
    this.covers = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required int tableId,
    this.status = const Value.absent(),
    this.waiterName = const Value.absent(),
    this.customerName = const Value.absent(),
    this.covers = const Value.absent(),
    required DateTime openedAt,
    required DateTime updatedAt,
  })  : tableId = Value(tableId),
        openedAt = Value(openedAt),
        updatedAt = Value(updatedAt);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<int>? tableId,
    Expression<String>? status,
    Expression<String>? waiterName,
    Expression<String>? customerName,
    Expression<int>? covers,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableId != null) 'table_id': tableId,
      if (status != null) 'status': status,
      if (waiterName != null) 'waiter_name': waiterName,
      if (customerName != null) 'customer_name': customerName,
      if (covers != null) 'covers': covers,
      if (openedAt != null) 'opened_at': openedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? tableId,
      Value<String>? status,
      Value<String>? waiterName,
      Value<String>? customerName,
      Value<int>? covers,
      Value<DateTime>? openedAt,
      Value<DateTime>? updatedAt}) {
    return OrdersCompanion(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      status: status ?? this.status,
      waiterName: waiterName ?? this.waiterName,
      customerName: customerName ?? this.customerName,
      covers: covers ?? this.covers,
      openedAt: openedAt ?? this.openedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (waiterName.present) {
      map['waiter_name'] = Variable<String>(waiterName.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (covers.present) {
      map['covers'] = Variable<int>(covers.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('status: $status, ')
          ..write('waiterName: $waiterName, ')
          ..write('customerName: $customerName, ')
          ..write('covers: $covers, ')
          ..write('openedAt: $openedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _menuItemIdMeta =
      const VerificationMeta('menuItemId');
  @override
  late final GeneratedColumn<int> menuItemId = GeneratedColumn<int>(
      'menu_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES menu_items (id)'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemPriceMeta =
      const VerificationMeta('itemPrice');
  @override
  late final GeneratedColumn<double> itemPrice = GeneratedColumn<double>(
      'item_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _kotSentMeta =
      const VerificationMeta('kotSent');
  @override
  late final GeneratedColumn<bool> kotSent = GeneratedColumn<bool>(
      'kot_sent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("kot_sent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _itemSizeMeta =
      const VerificationMeta('itemSize');
  @override
  late final GeneratedColumn<String> itemSize = GeneratedColumn<String>(
      'item_size', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('full'));
  static const VerificationMeta _printedQuantityMeta =
      const VerificationMeta('printedQuantity');
  @override
  late final GeneratedColumn<int> printedQuantity = GeneratedColumn<int>(
      'printed_quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        menuItemId,
        itemName,
        itemPrice,
        quantity,
        notes,
        kotSent,
        addedAt,
        itemSize,
        printedQuantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
          _menuItemIdMeta,
          menuItemId.isAcceptableOrUnknown(
              data['menu_item_id']!, _menuItemIdMeta));
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('item_price')) {
      context.handle(_itemPriceMeta,
          itemPrice.isAcceptableOrUnknown(data['item_price']!, _itemPriceMeta));
    } else if (isInserting) {
      context.missing(_itemPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('kot_sent')) {
      context.handle(_kotSentMeta,
          kotSent.isAcceptableOrUnknown(data['kot_sent']!, _kotSentMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('item_size')) {
      context.handle(_itemSizeMeta,
          itemSize.isAcceptableOrUnknown(data['item_size']!, _itemSizeMeta));
    }
    if (data.containsKey('printed_quantity')) {
      context.handle(
          _printedQuantityMeta,
          printedQuantity.isAcceptableOrUnknown(
              data['printed_quantity']!, _printedQuantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      menuItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_item_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      itemPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}item_price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      kotSent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}kot_sent'])!,
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
      itemSize: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_size'])!,
      printedQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}printed_quantity'])!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int menuItemId;
  final String itemName;
  final double itemPrice;
  final int quantity;
  final String notes;
  final bool kotSent;
  final DateTime addedAt;
  final String itemSize;
  final int printedQuantity;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.menuItemId,
      required this.itemName,
      required this.itemPrice,
      required this.quantity,
      required this.notes,
      required this.kotSent,
      required this.addedAt,
      required this.itemSize,
      required this.printedQuantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['menu_item_id'] = Variable<int>(menuItemId);
    map['item_name'] = Variable<String>(itemName);
    map['item_price'] = Variable<double>(itemPrice);
    map['quantity'] = Variable<int>(quantity);
    map['notes'] = Variable<String>(notes);
    map['kot_sent'] = Variable<bool>(kotSent);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['item_size'] = Variable<String>(itemSize);
    map['printed_quantity'] = Variable<int>(printedQuantity);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      menuItemId: Value(menuItemId),
      itemName: Value(itemName),
      itemPrice: Value(itemPrice),
      quantity: Value(quantity),
      notes: Value(notes),
      kotSent: Value(kotSent),
      addedAt: Value(addedAt),
      itemSize: Value(itemSize),
      printedQuantity: Value(printedQuantity),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      menuItemId: serializer.fromJson<int>(json['menuItemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      itemPrice: serializer.fromJson<double>(json['itemPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String>(json['notes']),
      kotSent: serializer.fromJson<bool>(json['kotSent']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      itemSize: serializer.fromJson<String>(json['itemSize']),
      printedQuantity: serializer.fromJson<int>(json['printedQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'menuItemId': serializer.toJson<int>(menuItemId),
      'itemName': serializer.toJson<String>(itemName),
      'itemPrice': serializer.toJson<double>(itemPrice),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String>(notes),
      'kotSent': serializer.toJson<bool>(kotSent),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'itemSize': serializer.toJson<String>(itemSize),
      'printedQuantity': serializer.toJson<int>(printedQuantity),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          int? menuItemId,
          String? itemName,
          double? itemPrice,
          int? quantity,
          String? notes,
          bool? kotSent,
          DateTime? addedAt,
          String? itemSize,
          int? printedQuantity}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        menuItemId: menuItemId ?? this.menuItemId,
        itemName: itemName ?? this.itemName,
        itemPrice: itemPrice ?? this.itemPrice,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
        kotSent: kotSent ?? this.kotSent,
        addedAt: addedAt ?? this.addedAt,
        itemSize: itemSize ?? this.itemSize,
        printedQuantity: printedQuantity ?? this.printedQuantity,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      menuItemId:
          data.menuItemId.present ? data.menuItemId.value : this.menuItemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      itemPrice: data.itemPrice.present ? data.itemPrice.value : this.itemPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      kotSent: data.kotSent.present ? data.kotSent.value : this.kotSent,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      itemSize: data.itemSize.present ? data.itemSize.value : this.itemSize,
      printedQuantity: data.printedQuantity.present
          ? data.printedQuantity.value
          : this.printedQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('itemPrice: $itemPrice, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('kotSent: $kotSent, ')
          ..write('addedAt: $addedAt, ')
          ..write('itemSize: $itemSize, ')
          ..write('printedQuantity: $printedQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, menuItemId, itemName, itemPrice,
      quantity, notes, kotSent, addedAt, itemSize, printedQuantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.menuItemId == this.menuItemId &&
          other.itemName == this.itemName &&
          other.itemPrice == this.itemPrice &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.kotSent == this.kotSent &&
          other.addedAt == this.addedAt &&
          other.itemSize == this.itemSize &&
          other.printedQuantity == this.printedQuantity);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> menuItemId;
  final Value<String> itemName;
  final Value<double> itemPrice;
  final Value<int> quantity;
  final Value<String> notes;
  final Value<bool> kotSent;
  final Value<DateTime> addedAt;
  final Value<String> itemSize;
  final Value<int> printedQuantity;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.itemPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.kotSent = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.itemSize = const Value.absent(),
    this.printedQuantity = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int menuItemId,
    required String itemName,
    required double itemPrice,
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.kotSent = const Value.absent(),
    required DateTime addedAt,
    this.itemSize = const Value.absent(),
    this.printedQuantity = const Value.absent(),
  })  : orderId = Value(orderId),
        menuItemId = Value(menuItemId),
        itemName = Value(itemName),
        itemPrice = Value(itemPrice),
        addedAt = Value(addedAt);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? menuItemId,
    Expression<String>? itemName,
    Expression<double>? itemPrice,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<bool>? kotSent,
    Expression<DateTime>? addedAt,
    Expression<String>? itemSize,
    Expression<int>? printedQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (itemName != null) 'item_name': itemName,
      if (itemPrice != null) 'item_price': itemPrice,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (kotSent != null) 'kot_sent': kotSent,
      if (addedAt != null) 'added_at': addedAt,
      if (itemSize != null) 'item_size': itemSize,
      if (printedQuantity != null) 'printed_quantity': printedQuantity,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? menuItemId,
      Value<String>? itemName,
      Value<double>? itemPrice,
      Value<int>? quantity,
      Value<String>? notes,
      Value<bool>? kotSent,
      Value<DateTime>? addedAt,
      Value<String>? itemSize,
      Value<int>? printedQuantity}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      itemName: itemName ?? this.itemName,
      itemPrice: itemPrice ?? this.itemPrice,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      kotSent: kotSent ?? this.kotSent,
      addedAt: addedAt ?? this.addedAt,
      itemSize: itemSize ?? this.itemSize,
      printedQuantity: printedQuantity ?? this.printedQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<int>(menuItemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (itemPrice.present) {
      map['item_price'] = Variable<double>(itemPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (kotSent.present) {
      map['kot_sent'] = Variable<bool>(kotSent.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (itemSize.present) {
      map['item_size'] = Variable<String>(itemSize.value);
    }
    if (printedQuantity.present) {
      map['printed_quantity'] = Variable<int>(printedQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('itemName: $itemName, ')
          ..write('itemPrice: $itemPrice, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('kotSent: $kotSent, ')
          ..write('addedAt: $addedAt, ')
          ..write('itemSize: $itemSize, ')
          ..write('printedQuantity: $printedQuantity')
          ..write(')'))
        .toString();
  }
}

class $KotRecordsTable extends KotRecords
    with TableInfo<$KotRecordsTable, KotRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KotRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _kotNumberMeta =
      const VerificationMeta('kotNumber');
  @override
  late final GeneratedColumn<int> kotNumber = GeneratedColumn<int>(
      'kot_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _printedAtMeta =
      const VerificationMeta('printedAt');
  @override
  late final GeneratedColumn<DateTime> printedAt = GeneratedColumn<DateTime>(
      'printed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kitchenStatusMeta =
      const VerificationMeta('kitchenStatus');
  @override
  late final GeneratedColumn<String> kitchenStatus = GeneratedColumn<String>(
      'kitchen_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('new'));
  static const VerificationMeta _kitchenUpdatedAtMeta =
      const VerificationMeta('kitchenUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> kitchenUpdatedAt = GeneratedColumn<DateTime>(
      'kitchen_updated_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: null);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orderId, kotNumber, itemsJson, printedAt, kitchenStatus, kitchenUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kot_records';
  @override
  VerificationContext validateIntegrity(Insertable<KotRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('kot_number')) {
      context.handle(_kotNumberMeta,
          kotNumber.isAcceptableOrUnknown(data['kot_number']!, _kotNumberMeta));
    } else if (isInserting) {
      context.missing(_kotNumberMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('printed_at')) {
      context.handle(_printedAtMeta,
          printedAt.isAcceptableOrUnknown(data['printed_at']!, _printedAtMeta));
    } else if (isInserting) {
      context.missing(_printedAtMeta);
    }
    if (data.containsKey('kitchen_status')) {
      context.handle(
          _kitchenStatusMeta,
          kitchenStatus.isAcceptableOrUnknown(
              data['kitchen_status']!, _kitchenStatusMeta));
    }
    if (data.containsKey('kitchen_updated_at')) {
      context.handle(
          _kitchenUpdatedAtMeta,
          kitchenUpdatedAt.isAcceptableOrUnknown(
              data['kitchen_updated_at']!, _kitchenUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KotRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KotRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      kotNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kot_number'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      printedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}printed_at'])!,
      kitchenStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kitchen_status'])!,
      kitchenUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}kitchen_updated_at']),
    );
  }

  @override
  $KotRecordsTable createAlias(String alias) {
    return $KotRecordsTable(attachedDatabase, alias);
  }
}

class KotRecord extends DataClass implements Insertable<KotRecord> {
  final int id;
  final int orderId;
  final int kotNumber;
  final String itemsJson;
  final DateTime printedAt;
  final String kitchenStatus;
  final DateTime? kitchenUpdatedAt;
  const KotRecord(
      {required this.id,
      required this.orderId,
      required this.kotNumber,
      required this.itemsJson,
      required this.printedAt,
      this.kitchenStatus = 'new',
      this.kitchenUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['kot_number'] = Variable<int>(kotNumber);
    map['items_json'] = Variable<String>(itemsJson);
    map['printed_at'] = Variable<DateTime>(printedAt);
    map['kitchen_status'] = Variable<String>(kitchenStatus);
    if (kitchenUpdatedAt != null) {
      map['kitchen_updated_at'] = Variable<DateTime>(kitchenUpdatedAt!);
    }
    return map;
  }

  KotRecordsCompanion toCompanion(bool nullToAbsent) {
    return KotRecordsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      kotNumber: Value(kotNumber),
      itemsJson: Value(itemsJson),
      printedAt: Value(printedAt),
      kitchenStatus: Value(kitchenStatus),
      kitchenUpdatedAt: Value(kitchenUpdatedAt),
    );
  }

  factory KotRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KotRecord(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      kotNumber: serializer.fromJson<int>(json['kotNumber']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      printedAt: serializer.fromJson<DateTime>(json['printedAt']),
      kitchenStatus: serializer.fromJson<String>(json['kitchenStatus'] ?? 'new'),
      kitchenUpdatedAt: serializer.fromJson<DateTime?>(json['kitchenUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'kotNumber': serializer.toJson<int>(kotNumber),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'printedAt': serializer.toJson<DateTime>(printedAt),
      'kitchenStatus': serializer.toJson<String>(kitchenStatus),
      'kitchenUpdatedAt': serializer.toJson<DateTime?>(kitchenUpdatedAt),
    };
  }

  KotRecord copyWith(
          {int? id,
          int? orderId,
          int? kotNumber,
          String? itemsJson,
          DateTime? printedAt,
          String? kitchenStatus,
          DateTime? kitchenUpdatedAt}) =>
      KotRecord(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        kotNumber: kotNumber ?? this.kotNumber,
        itemsJson: itemsJson ?? this.itemsJson,
        printedAt: printedAt ?? this.printedAt,
        kitchenStatus: kitchenStatus ?? this.kitchenStatus,
        kitchenUpdatedAt: kitchenUpdatedAt ?? this.kitchenUpdatedAt,
      );
  KotRecord copyWithCompanion(KotRecordsCompanion data) {
    return KotRecord(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      kotNumber: data.kotNumber.present ? data.kotNumber.value : this.kotNumber,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      printedAt: data.printedAt.present ? data.printedAt.value : this.printedAt,
      kitchenStatus: data.kitchenStatus.present ? data.kitchenStatus.value : this.kitchenStatus,
      kitchenUpdatedAt: data.kitchenUpdatedAt.present ? data.kitchenUpdatedAt.value : this.kitchenUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KotRecord(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kotNumber: $kotNumber, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('printedAt: $printedAt, ')
          ..write('kitchenStatus: $kitchenStatus, ')
          ..write('kitchenUpdatedAt: $kitchenUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, kotNumber, itemsJson, printedAt, kitchenStatus, kitchenUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KotRecord &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.kotNumber == this.kotNumber &&
          other.itemsJson == this.itemsJson &&
          other.printedAt == this.printedAt &&
          other.kitchenStatus == this.kitchenStatus &&
          other.kitchenUpdatedAt == this.kitchenUpdatedAt);
}

class KotRecordsCompanion extends UpdateCompanion<KotRecord> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> kotNumber;
  final Value<String> itemsJson;
  final Value<DateTime> printedAt;
  final Value<String> kitchenStatus;
  final Value<DateTime?> kitchenUpdatedAt;
  const KotRecordsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.kotNumber = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.printedAt = const Value.absent(),
    this.kitchenStatus = const Value.absent(),
    this.kitchenUpdatedAt = const Value.absent(),
  });
  KotRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int kotNumber,
    required String itemsJson,
    required DateTime printedAt,
    this.kitchenStatus = const Value('new'),
    this.kitchenUpdatedAt = const Value.absent(),
  })  : orderId = Value(orderId),
        kotNumber = Value(kotNumber),
        itemsJson = Value(itemsJson),
        printedAt = Value(printedAt);
  static Insertable<KotRecord> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? kotNumber,
    Expression<String>? itemsJson,
    Expression<DateTime>? printedAt,
    Expression<String>? kitchenStatus,
    Expression<DateTime>? kitchenUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (kotNumber != null) 'kot_number': kotNumber,
      if (itemsJson != null) 'items_json': itemsJson,
      if (printedAt != null) 'printed_at': printedAt,
      if (kitchenStatus != null) 'kitchen_status': kitchenStatus,
      if (kitchenUpdatedAt != null) 'kitchen_updated_at': kitchenUpdatedAt,
    });
  }

  KotRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? kotNumber,
      Value<String>? itemsJson,
      Value<DateTime>? printedAt,
      Value<String>? kitchenStatus,
      Value<DateTime?>? kitchenUpdatedAt}) {
    return KotRecordsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      kotNumber: kotNumber ?? this.kotNumber,
      itemsJson: itemsJson ?? this.itemsJson,
      printedAt: printedAt ?? this.printedAt,
      kitchenStatus: kitchenStatus ?? this.kitchenStatus,
      kitchenUpdatedAt: kitchenUpdatedAt ?? this.kitchenUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (kotNumber.present) {
      map['kot_number'] = Variable<int>(kotNumber.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (printedAt.present) {
      map['printed_at'] = Variable<DateTime>(printedAt.value);
    }
    if (kitchenStatus.present) {
      map['kitchen_status'] = Variable<String>(kitchenStatus.value);
    }
    if (kitchenUpdatedAt.present) {
      map['kitchen_updated_at'] = Variable<DateTime>(kitchenUpdatedAt.value!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KotRecordsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('kotNumber: $kotNumber, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('printedAt: $printedAt, ')
          ..write('kitchenStatus: $kitchenStatus, ')
          ..write('kitchenUpdatedAt: $kitchenUpdatedAt')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tableLabelMeta =
      const VerificationMeta('tableLabel');
  @override
  late final GeneratedColumn<String> tableLabel = GeneratedColumn<String>(
      'table_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _amountReceivedMeta =
      const VerificationMeta('amountReceived');
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
      'amount_received', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<double> change = GeneratedColumn<double>(
      'change', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _splitCashMeta =
      const VerificationMeta('splitCash');
  @override
  late final GeneratedColumn<double> splitCash = GeneratedColumn<double>(
      'split_cash', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _splitOnlineMeta =
      const VerificationMeta('splitOnline');
  @override
  late final GeneratedColumn<double> splitOnline = GeneratedColumn<double>(
      'split_online', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<int> billNumber = GeneratedColumn<int>(
      'bill_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
    static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
    @override
    late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultValue: const Constant(false));
    static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
    @override
    late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        tableId,
        tableLabel,
        subtotal,
        discount,
        total,
        paymentMethod,
        amountReceived,
        change,
        splitCash,
        splitOnline,
        itemsJson,
        createdAt,
        billNumber,
        isSynced,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(Insertable<Bill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
    if (data.containsKey('table_label')) {
      context.handle(
          _tableLabelMeta,
          tableLabel.isAcceptableOrUnknown(
              data['table_label']!, _tableLabelMeta));
    } else if (isInserting) {
      context.missing(_tableLabelMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('amount_received')) {
      context.handle(
          _amountReceivedMeta,
          amountReceived.isAcceptableOrUnknown(
              data['amount_received']!, _amountReceivedMeta));
    }
    if (data.containsKey('change')) {
      context.handle(_changeMeta,
          change.isAcceptableOrUnknown(data['change']!, _changeMeta));
    }
    if (data.containsKey('split_cash')) {
      context.handle(_splitCashMeta,
          splitCash.isAcceptableOrUnknown(data['split_cash']!, _splitCashMeta));
    }
    if (data.containsKey('split_online')) {
      context.handle(
          _splitOnlineMeta,
          splitOnline.isAcceptableOrUnknown(
              data['split_online']!, _splitOnlineMeta));
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id'])!,
      tableLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_label'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      amountReceived: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_received'])!,
      change: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change'])!,
      splitCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}split_cash'])!,
      splitOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}split_online'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bill_number']),
        isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
        syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class Bill extends DataClass implements Insertable<Bill> {
  final int id;
  final int orderId;
  final int tableId;
  final String tableLabel;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod;
  final double amountReceived;
  final double change;
  final double splitCash;
  final double splitOnline;
  final String itemsJson;
  final DateTime createdAt;
  final int? billNumber;
  final bool isSynced;
  final DateTime? syncedAt;
  const Bill(
      {required this.id,
      required this.orderId,
      required this.tableId,
      required this.tableLabel,
      required this.subtotal,
      required this.discount,
      required this.total,
      required this.paymentMethod,
      required this.amountReceived,
      required this.change,
      required this.splitCash,
      required this.splitOnline,
      required this.itemsJson,
      required this.createdAt,
      this.billNumber,
      this.isSynced = false,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['table_id'] = Variable<int>(tableId);
    map['table_label'] = Variable<String>(tableLabel);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['total'] = Variable<double>(total);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['amount_received'] = Variable<double>(amountReceived);
    map['change'] = Variable<double>(change);
    map['split_cash'] = Variable<double>(splitCash);
    map['split_online'] = Variable<double>(splitOnline);
    map['items_json'] = Variable<String>(itemsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || billNumber != null) {
      map['bill_number'] = Variable<int>(billNumber);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      tableId: Value(tableId),
      tableLabel: Value(tableLabel),
      subtotal: Value(subtotal),
      discount: Value(discount),
      total: Value(total),
      paymentMethod: Value(paymentMethod),
      amountReceived: Value(amountReceived),
      change: Value(change),
      splitCash: Value(splitCash),
      splitOnline: Value(splitOnline),
      itemsJson: Value(itemsJson),
      createdAt: Value(createdAt),
      billNumber: billNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(billNumber),
        isSynced: Value(isSynced),
        syncedAt: Value(syncedAt),
    );
  }

  factory Bill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      tableId: serializer.fromJson<int>(json['tableId']),
      tableLabel: serializer.fromJson<String>(json['tableLabel']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      total: serializer.fromJson<double>(json['total']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      amountReceived: serializer.fromJson<double>(json['amountReceived']),
      change: serializer.fromJson<double>(json['change']),
      splitCash: serializer.fromJson<double>(json['splitCash']),
      splitOnline: serializer.fromJson<double>(json['splitOnline']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      billNumber: serializer.fromJson<int?>(json['billNumber']),
      isSynced: serializer.fromJson<bool>(json['isSynced'] ?? false),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'tableId': serializer.toJson<int>(tableId),
      'tableLabel': serializer.toJson<String>(tableLabel),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'total': serializer.toJson<double>(total),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'amountReceived': serializer.toJson<double>(amountReceived),
      'change': serializer.toJson<double>(change),
      'splitCash': serializer.toJson<double>(splitCash),
      'splitOnline': serializer.toJson<double>(splitOnline),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'billNumber': serializer.toJson<int?>(billNumber),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Bill copyWith(
          {int? id,
          int? orderId,
          int? tableId,
          String? tableLabel,
          double? subtotal,
          double? discount,
          double? total,
          String? paymentMethod,
          double? amountReceived,
          double? change,
          double? splitCash,
          double? splitOnline,
          String? itemsJson,
          DateTime? createdAt,
          Value<int?> billNumber = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      Bill(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        tableId: tableId ?? this.tableId,
        tableLabel: tableLabel ?? this.tableLabel,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        total: total ?? this.total,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        amountReceived: amountReceived ?? this.amountReceived,
        change: change ?? this.change,
        splitCash: splitCash ?? this.splitCash,
        splitOnline: splitOnline ?? this.splitOnline,
        itemsJson: itemsJson ?? this.itemsJson,
        createdAt: createdAt ?? this.createdAt,
        billNumber: billNumber.present ? billNumber.value : this.billNumber,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      tableLabel:
          data.tableLabel.present ? data.tableLabel.value : this.tableLabel,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      total: data.total.present ? data.total.value : this.total,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      change: data.change.present ? data.change.value : this.change,
      splitCash: data.splitCash.present ? data.splitCash.value : this.splitCash,
      splitOnline:
          data.splitOnline.present ? data.splitOnline.value : this.splitOnline,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
        isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
        syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tableId: $tableId, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('total: $total, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('change: $change, ')
          ..write('splitCash: $splitCash, ')
          ..write('splitOnline: $splitOnline, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('billNumber: $billNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderId,
      tableId,
      tableLabel,
      subtotal,
      discount,
      total,
      paymentMethod,
      amountReceived,
      change,
      splitCash,
      splitOnline,
      itemsJson,
      createdAt,
      billNumber,
      isSynced,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.tableId == this.tableId &&
          other.tableLabel == this.tableLabel &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.total == this.total &&
          other.paymentMethod == this.paymentMethod &&
          other.amountReceived == this.amountReceived &&
          other.change == this.change &&
          other.splitCash == this.splitCash &&
          other.splitOnline == this.splitOnline &&
          other.itemsJson == this.itemsJson &&
          other.createdAt == this.createdAt &&
          other.billNumber == this.billNumber &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> tableId;
  final Value<String> tableLabel;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> total;
  final Value<String> paymentMethod;
  final Value<double> amountReceived;
  final Value<double> change;
  final Value<double> splitCash;
  final Value<double> splitOnline;
  final Value<String> itemsJson;
  final Value<DateTime> createdAt;
  final Value<int?> billNumber;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.tableId = const Value.absent(),
    this.tableLabel = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.total = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.change = const Value.absent(),
    this.splitCash = const Value.absent(),
    this.splitOnline = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int tableId,
    required String tableLabel,
    required double subtotal,
    this.discount = const Value.absent(),
    required double total,
    this.paymentMethod = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.change = const Value.absent(),
    this.splitCash = const Value.absent(),
    this.splitOnline = const Value.absent(),
    required String itemsJson,
    required DateTime createdAt,
    this.billNumber = const Value.absent(),
    this.isSynced = const Value(false),
    this.syncedAt = const Value.absent(),
  })  : orderId = Value(orderId),
        tableId = Value(tableId),
        tableLabel = Value(tableLabel),
        subtotal = Value(subtotal),
        total = Value(total),
        itemsJson = Value(itemsJson),
        createdAt = Value(createdAt);
  static Insertable<Bill> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? tableId,
    Expression<String>? tableLabel,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? total,
    Expression<String>? paymentMethod,
    Expression<double>? amountReceived,
    Expression<double>? change,
    Expression<double>? splitCash,
    Expression<double>? splitOnline,
    Expression<String>? itemsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? billNumber,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (tableId != null) 'table_id': tableId,
      if (tableLabel != null) 'table_label': tableLabel,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (total != null) 'total': total,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (change != null) 'change': change,
      if (splitCash != null) 'split_cash': splitCash,
      if (splitOnline != null) 'split_online': splitOnline,
      if (itemsJson != null) 'items_json': itemsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (billNumber != null) 'bill_number': billNumber,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  BillsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? tableId,
      Value<String>? tableLabel,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<double>? total,
      Value<String>? paymentMethod,
      Value<double>? amountReceived,
      Value<double>? change,
      Value<double>? splitCash,
      Value<double>? splitOnline,
      Value<String>? itemsJson,
      Value<DateTime>? createdAt,
      Value<int?>? billNumber,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt}) {
    return BillsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      tableId: tableId ?? this.tableId,
      tableLabel: tableLabel ?? this.tableLabel,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountReceived: amountReceived ?? this.amountReceived,
      change: change ?? this.change,
      splitCash: splitCash ?? this.splitCash,
      splitOnline: splitOnline ?? this.splitOnline,
      itemsJson: itemsJson ?? this.itemsJson,
      createdAt: createdAt ?? this.createdAt,
      billNumber: billNumber ?? this.billNumber,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (tableLabel.present) {
      map['table_label'] = Variable<String>(tableLabel.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (change.present) {
      map['change'] = Variable<double>(change.value);
    }
    if (splitCash.present) {
      map['split_cash'] = Variable<double>(splitCash.value);
    }
    if (splitOnline.present) {
      map['split_online'] = Variable<double>(splitOnline.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<int>(billNumber.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('tableId: $tableId, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('total: $total, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('change: $change, ')
          ..write('splitCash: $splitCash, ')
          ..write('splitOnline: $splitOnline, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('billNumber: $billNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $PrinterConfigsTable extends PrinterConfigs
    with TableInfo<$PrinterConfigsTable, PrinterConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _printerTypeMeta =
      const VerificationMeta('printerType');
  @override
  late final GeneratedColumn<String> printerType = GeneratedColumn<String>(
      'printer_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('bluetooth'));
  static const VerificationMeta _paperWidthMeta =
      const VerificationMeta('paperWidth');
  @override
  late final GeneratedColumn<int> paperWidth = GeneratedColumn<int>(
      'paper_width', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(80));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isConnectedMeta =
      const VerificationMeta('isConnected');
  @override
  late final GeneratedColumn<bool> isConnected = GeneratedColumn<bool>(
      'is_connected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_connected" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, address, printerType, paperWidth, isDefault, isConnected];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_configs';
  @override
  VerificationContext validateIntegrity(Insertable<PrinterConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('printer_type')) {
      context.handle(
          _printerTypeMeta,
          printerType.isAcceptableOrUnknown(
              data['printer_type']!, _printerTypeMeta));
    }
    if (data.containsKey('paper_width')) {
      context.handle(
          _paperWidthMeta,
          paperWidth.isAcceptableOrUnknown(
              data['paper_width']!, _paperWidthMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_connected')) {
      context.handle(
          _isConnectedMeta,
          isConnected.isAcceptableOrUnknown(
              data['is_connected']!, _isConnectedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      printerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}printer_type'])!,
      paperWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paper_width'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isConnected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_connected'])!,
    );
  }

  @override
  $PrinterConfigsTable createAlias(String alias) {
    return $PrinterConfigsTable(attachedDatabase, alias);
  }
}

class PrinterConfig extends DataClass implements Insertable<PrinterConfig> {
  final int id;
  final String name;
  final String address;
  final String printerType;
  final int paperWidth;
  final bool isDefault;
  final bool isConnected;
  const PrinterConfig(
      {required this.id,
      required this.name,
      required this.address,
      required this.printerType,
      required this.paperWidth,
      required this.isDefault,
      required this.isConnected});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['printer_type'] = Variable<String>(printerType);
    map['paper_width'] = Variable<int>(paperWidth);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_connected'] = Variable<bool>(isConnected);
    return map;
  }

  PrinterConfigsCompanion toCompanion(bool nullToAbsent) {
    return PrinterConfigsCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      printerType: Value(printerType),
      paperWidth: Value(paperWidth),
      isDefault: Value(isDefault),
      isConnected: Value(isConnected),
    );
  }

  factory PrinterConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterConfig(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      printerType: serializer.fromJson<String>(json['printerType']),
      paperWidth: serializer.fromJson<int>(json['paperWidth']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isConnected: serializer.fromJson<bool>(json['isConnected']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'printerType': serializer.toJson<String>(printerType),
      'paperWidth': serializer.toJson<int>(paperWidth),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isConnected': serializer.toJson<bool>(isConnected),
    };
  }

  PrinterConfig copyWith(
          {int? id,
          String? name,
          String? address,
          String? printerType,
          int? paperWidth,
          bool? isDefault,
          bool? isConnected}) =>
      PrinterConfig(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        printerType: printerType ?? this.printerType,
        paperWidth: paperWidth ?? this.paperWidth,
        isDefault: isDefault ?? this.isDefault,
        isConnected: isConnected ?? this.isConnected,
      );
  PrinterConfig copyWithCompanion(PrinterConfigsCompanion data) {
    return PrinterConfig(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      printerType:
          data.printerType.present ? data.printerType.value : this.printerType,
      paperWidth:
          data.paperWidth.present ? data.paperWidth.value : this.paperWidth,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isConnected:
          data.isConnected.present ? data.isConnected.value : this.isConnected,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrinterConfig(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('printerType: $printerType, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('isDefault: $isDefault, ')
          ..write('isConnected: $isConnected')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, address, printerType, paperWidth, isDefault, isConnected);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterConfig &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.printerType == this.printerType &&
          other.paperWidth == this.paperWidth &&
          other.isDefault == this.isDefault &&
          other.isConnected == this.isConnected);
}

class PrinterConfigsCompanion extends UpdateCompanion<PrinterConfig> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> printerType;
  final Value<int> paperWidth;
  final Value<bool> isDefault;
  final Value<bool> isConnected;
  const PrinterConfigsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.printerType = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isConnected = const Value.absent(),
  });
  PrinterConfigsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    this.printerType = const Value.absent(),
    this.paperWidth = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isConnected = const Value.absent(),
  })  : name = Value(name),
        address = Value(address);
  static Insertable<PrinterConfig> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? printerType,
    Expression<int>? paperWidth,
    Expression<bool>? isDefault,
    Expression<bool>? isConnected,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (printerType != null) 'printer_type': printerType,
      if (paperWidth != null) 'paper_width': paperWidth,
      if (isDefault != null) 'is_default': isDefault,
      if (isConnected != null) 'is_connected': isConnected,
    });
  }

  PrinterConfigsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? address,
      Value<String>? printerType,
      Value<int>? paperWidth,
      Value<bool>? isDefault,
      Value<bool>? isConnected}) {
    return PrinterConfigsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      printerType: printerType ?? this.printerType,
      paperWidth: paperWidth ?? this.paperWidth,
      isDefault: isDefault ?? this.isDefault,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (printerType.present) {
      map['printer_type'] = Variable<String>(printerType.value);
    }
    if (paperWidth.present) {
      map['paper_width'] = Variable<int>(paperWidth.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isConnected.present) {
      map['is_connected'] = Variable<bool>(isConnected.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterConfigsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('printerType: $printerType, ')
          ..write('paperWidth: $paperWidth, ')
          ..write('isDefault: $isDefault, ')
          ..write('isConnected: $isConnected')
          ..write(')'))
        .toString();
  }
}

class $QueueEntriesTable extends QueueEntries
    with TableInfo<$QueueEntriesTable, QueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _requiredSeatsMeta =
      const VerificationMeta('requiredSeats');
  @override
  late final GeneratedColumn<int> requiredSeats = GeneratedColumn<int>(
      'required_seats', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _waitingNumberMeta =
      const VerificationMeta('waitingNumber');
  @override
  late final GeneratedColumn<int> waitingNumber = GeneratedColumn<int>(
      'waiting_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('waiting'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerName,
        customerPhone,
        requiredSeats,
        waitingNumber,
        createdAt,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_entries';
  @override
  VerificationContext validateIntegrity(Insertable<QueueEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('required_seats')) {
      context.handle(
          _requiredSeatsMeta,
          requiredSeats.isAcceptableOrUnknown(
              data['required_seats']!, _requiredSeatsMeta));
    }
    if (data.containsKey('waiting_number')) {
      context.handle(
          _waitingNumberMeta,
          waitingNumber.isAcceptableOrUnknown(
              data['waiting_number']!, _waitingNumberMeta));
    } else if (isInserting) {
      context.missing(_waitingNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      requiredSeats: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}required_seats'])!,
      waitingNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}waiting_number'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $QueueEntriesTable createAlias(String alias) {
    return $QueueEntriesTable(attachedDatabase, alias);
  }
}

class QueueEntry extends DataClass implements Insertable<QueueEntry> {
  final int id;
  final String customerName;
  final String? customerPhone;
  final int requiredSeats;
  final int waitingNumber;
  final DateTime createdAt;
  final String status;
  const QueueEntry(
      {required this.id,
      required this.customerName,
      this.customerPhone,
      required this.requiredSeats,
      required this.waitingNumber,
      required this.createdAt,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    map['required_seats'] = Variable<int>(requiredSeats);
    map['waiting_number'] = Variable<int>(waitingNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  QueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return QueueEntriesCompanion(
      id: Value(id),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      requiredSeats: Value(requiredSeats),
      waitingNumber: Value(waitingNumber),
      createdAt: Value(createdAt),
      status: Value(status),
    );
  }

  factory QueueEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueEntry(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      requiredSeats: serializer.fromJson<int>(json['requiredSeats']),
      waitingNumber: serializer.fromJson<int>(json['waitingNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'requiredSeats': serializer.toJson<int>(requiredSeats),
      'waitingNumber': serializer.toJson<int>(waitingNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
    };
  }

  QueueEntry copyWith(
          {int? id,
          String? customerName,
          Value<String?> customerPhone = const Value.absent(),
          int? requiredSeats,
          int? waitingNumber,
          DateTime? createdAt,
          String? status}) =>
      QueueEntry(
        id: id ?? this.id,
        customerName: customerName ?? this.customerName,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        requiredSeats: requiredSeats ?? this.requiredSeats,
        waitingNumber: waitingNumber ?? this.waitingNumber,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
      );
  QueueEntry copyWithCompanion(QueueEntriesCompanion data) {
    return QueueEntry(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      requiredSeats: data.requiredSeats.present
          ? data.requiredSeats.value
          : this.requiredSeats,
      waitingNumber: data.waitingNumber.present
          ? data.waitingNumber.value
          : this.waitingNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueEntry(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('requiredSeats: $requiredSeats, ')
          ..write('waitingNumber: $waitingNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerName, customerPhone,
      requiredSeats, waitingNumber, createdAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueEntry &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.requiredSeats == this.requiredSeats &&
          other.waitingNumber == this.waitingNumber &&
          other.createdAt == this.createdAt &&
          other.status == this.status);
}

class QueueEntriesCompanion extends UpdateCompanion<QueueEntry> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<int> requiredSeats;
  final Value<int> waitingNumber;
  final Value<DateTime> createdAt;
  final Value<String> status;
  const QueueEntriesCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.requiredSeats = const Value.absent(),
    this.waitingNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  QueueEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    this.customerPhone = const Value.absent(),
    this.requiredSeats = const Value.absent(),
    required int waitingNumber,
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
  })  : customerName = Value(customerName),
        waitingNumber = Value(waitingNumber);
  static Insertable<QueueEntry> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<int>? requiredSeats,
    Expression<int>? waitingNumber,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (requiredSeats != null) 'required_seats': requiredSeats,
      if (waitingNumber != null) 'waiting_number': waitingNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
    });
  }

  QueueEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? customerName,
      Value<String?>? customerPhone,
      Value<int>? requiredSeats,
      Value<int>? waitingNumber,
      Value<DateTime>? createdAt,
      Value<String>? status}) {
    return QueueEntriesCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      requiredSeats: requiredSeats ?? this.requiredSeats,
      waitingNumber: waitingNumber ?? this.waitingNumber,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (requiredSeats.present) {
      map['required_seats'] = Variable<int>(requiredSeats.value);
    }
    if (waitingNumber.present) {
      map['waiting_number'] = Variable<int>(waitingNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueEntriesCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('requiredSeats: $requiredSeats, ')
          ..write('waitingNumber: $waitingNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $StaffCategoriesTable extends StaffCategories
    with TableInfo<$StaffCategoriesTable, StaffCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _defaultDailyRateMeta =
      const VerificationMeta('defaultDailyRate');
  @override
  late final GeneratedColumn<double> defaultDailyRate = GeneratedColumn<double>(
      'default_daily_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _defaultHalfDayRateMeta =
      const VerificationMeta('defaultHalfDayRate');
  @override
  late final GeneratedColumn<double> defaultHalfDayRate =
      GeneratedColumn<double>('default_half_day_rate', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, defaultDailyRate, defaultHalfDayRate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff_categories';
  @override
  VerificationContext validateIntegrity(Insertable<StaffCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_daily_rate')) {
      context.handle(
          _defaultDailyRateMeta,
          defaultDailyRate.isAcceptableOrUnknown(
              data['default_daily_rate']!, _defaultDailyRateMeta));
    }
    if (data.containsKey('default_half_day_rate')) {
      context.handle(
          _defaultHalfDayRateMeta,
          defaultHalfDayRate.isAcceptableOrUnknown(
              data['default_half_day_rate']!, _defaultHalfDayRateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      defaultDailyRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_daily_rate'])!,
      defaultHalfDayRate: attachedDatabase.typeMapping.read(DriftSqlType.double,
          data['${effectivePrefix}default_half_day_rate'])!,
    );
  }

  @override
  $StaffCategoriesTable createAlias(String alias) {
    return $StaffCategoriesTable(attachedDatabase, alias);
  }
}

class StaffCategory extends DataClass implements Insertable<StaffCategory> {
  final int id;
  final String name;
  final double defaultDailyRate;
  final double defaultHalfDayRate;
  const StaffCategory(
      {required this.id,
      required this.name,
      required this.defaultDailyRate,
      required this.defaultHalfDayRate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['default_daily_rate'] = Variable<double>(defaultDailyRate);
    map['default_half_day_rate'] = Variable<double>(defaultHalfDayRate);
    return map;
  }

  StaffCategoriesCompanion toCompanion(bool nullToAbsent) {
    return StaffCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      defaultDailyRate: Value(defaultDailyRate),
      defaultHalfDayRate: Value(defaultHalfDayRate),
    );
  }

  factory StaffCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      defaultDailyRate: serializer.fromJson<double>(json['defaultDailyRate']),
      defaultHalfDayRate:
          serializer.fromJson<double>(json['defaultHalfDayRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'defaultDailyRate': serializer.toJson<double>(defaultDailyRate),
      'defaultHalfDayRate': serializer.toJson<double>(defaultHalfDayRate),
    };
  }

  StaffCategory copyWith(
          {int? id,
          String? name,
          double? defaultDailyRate,
          double? defaultHalfDayRate}) =>
      StaffCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        defaultDailyRate: defaultDailyRate ?? this.defaultDailyRate,
        defaultHalfDayRate: defaultHalfDayRate ?? this.defaultHalfDayRate,
      );
  StaffCategory copyWithCompanion(StaffCategoriesCompanion data) {
    return StaffCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      defaultDailyRate: data.defaultDailyRate.present
          ? data.defaultDailyRate.value
          : this.defaultDailyRate,
      defaultHalfDayRate: data.defaultHalfDayRate.present
          ? data.defaultHalfDayRate.value
          : this.defaultHalfDayRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultDailyRate: $defaultDailyRate, ')
          ..write('defaultHalfDayRate: $defaultHalfDayRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, defaultDailyRate, defaultHalfDayRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.defaultDailyRate == this.defaultDailyRate &&
          other.defaultHalfDayRate == this.defaultHalfDayRate);
}

class StaffCategoriesCompanion extends UpdateCompanion<StaffCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> defaultDailyRate;
  final Value<double> defaultHalfDayRate;
  const StaffCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultDailyRate = const Value.absent(),
    this.defaultHalfDayRate = const Value.absent(),
  });
  StaffCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.defaultDailyRate = const Value.absent(),
    this.defaultHalfDayRate = const Value.absent(),
  }) : name = Value(name);
  static Insertable<StaffCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? defaultDailyRate,
    Expression<double>? defaultHalfDayRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (defaultDailyRate != null) 'default_daily_rate': defaultDailyRate,
      if (defaultHalfDayRate != null)
        'default_half_day_rate': defaultHalfDayRate,
    });
  }

  StaffCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? defaultDailyRate,
      Value<double>? defaultHalfDayRate}) {
    return StaffCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultDailyRate: defaultDailyRate ?? this.defaultDailyRate,
      defaultHalfDayRate: defaultHalfDayRate ?? this.defaultHalfDayRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultDailyRate.present) {
      map['default_daily_rate'] = Variable<double>(defaultDailyRate.value);
    }
    if (defaultHalfDayRate.present) {
      map['default_half_day_rate'] = Variable<double>(defaultHalfDayRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultDailyRate: $defaultDailyRate, ')
          ..write('defaultHalfDayRate: $defaultHalfDayRate')
          ..write(')'))
        .toString();
  }
}

class $StaffTable extends Staff with TableInfo<$StaffTable, StaffData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StaffTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES staff_categories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _payTypeMeta =
      const VerificationMeta('payType');
  @override
  late final GeneratedColumn<String> payType = GeneratedColumn<String>(
      'pay_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('daily'));
  static const VerificationMeta _payRateMeta =
      const VerificationMeta('payRate');
  @override
  late final GeneratedColumn<double> payRate = GeneratedColumn<double>(
      'pay_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _halfDayRateMeta =
      const VerificationMeta('halfDayRate');
  @override
  late final GeneratedColumn<double> halfDayRate = GeneratedColumn<double>(
      'half_day_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _monthlySalaryMeta =
      const VerificationMeta('monthlySalary');
  @override
  late final GeneratedColumn<double> monthlySalary = GeneratedColumn<double>(
      'monthly_salary', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _joiningDateMeta =
      const VerificationMeta('joiningDate');
  @override
  late final GeneratedColumn<DateTime> joiningDate = GeneratedColumn<DateTime>(
      'joining_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        name,
        phone,
        payType,
        payRate,
        halfDayRate,
        monthlySalary,
        joiningDate,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'staff';
  @override
  VerificationContext validateIntegrity(Insertable<StaffData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('pay_type')) {
      context.handle(_payTypeMeta,
          payType.isAcceptableOrUnknown(data['pay_type']!, _payTypeMeta));
    }
    if (data.containsKey('pay_rate')) {
      context.handle(_payRateMeta,
          payRate.isAcceptableOrUnknown(data['pay_rate']!, _payRateMeta));
    }
    if (data.containsKey('half_day_rate')) {
      context.handle(
          _halfDayRateMeta,
          halfDayRate.isAcceptableOrUnknown(
              data['half_day_rate']!, _halfDayRateMeta));
    }
    if (data.containsKey('monthly_salary')) {
      context.handle(
          _monthlySalaryMeta,
          monthlySalary.isAcceptableOrUnknown(
              data['monthly_salary']!, _monthlySalaryMeta));
    }
    if (data.containsKey('joining_date')) {
      context.handle(
          _joiningDateMeta,
          joiningDate.isAcceptableOrUnknown(
              data['joining_date']!, _joiningDateMeta));
    } else if (isInserting) {
      context.missing(_joiningDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StaffData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StaffData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      payType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pay_type'])!,
      payRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pay_rate'])!,
      halfDayRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}half_day_rate'])!,
      monthlySalary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monthly_salary'])!,
      joiningDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joining_date'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $StaffTable createAlias(String alias) {
    return $StaffTable(attachedDatabase, alias);
  }
}

class StaffData extends DataClass implements Insertable<StaffData> {
  final int id;
  final int categoryId;
  final String name;
  final String phone;
  final String payType;
  final double payRate;
  final double halfDayRate;
  final double monthlySalary;
  final DateTime joiningDate;
  final bool isActive;
  const StaffData(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.phone,
      required this.payType,
      required this.payRate,
      required this.halfDayRate,
      required this.monthlySalary,
      required this.joiningDate,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['pay_type'] = Variable<String>(payType);
    map['pay_rate'] = Variable<double>(payRate);
    map['half_day_rate'] = Variable<double>(halfDayRate);
    map['monthly_salary'] = Variable<double>(monthlySalary);
    map['joining_date'] = Variable<DateTime>(joiningDate);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  StaffCompanion toCompanion(bool nullToAbsent) {
    return StaffCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      phone: Value(phone),
      payType: Value(payType),
      payRate: Value(payRate),
      halfDayRate: Value(halfDayRate),
      monthlySalary: Value(monthlySalary),
      joiningDate: Value(joiningDate),
      isActive: Value(isActive),
    );
  }

  factory StaffData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StaffData(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      payType: serializer.fromJson<String>(json['payType']),
      payRate: serializer.fromJson<double>(json['payRate']),
      halfDayRate: serializer.fromJson<double>(json['halfDayRate']),
      monthlySalary: serializer.fromJson<double>(json['monthlySalary']),
      joiningDate: serializer.fromJson<DateTime>(json['joiningDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'payType': serializer.toJson<String>(payType),
      'payRate': serializer.toJson<double>(payRate),
      'halfDayRate': serializer.toJson<double>(halfDayRate),
      'monthlySalary': serializer.toJson<double>(monthlySalary),
      'joiningDate': serializer.toJson<DateTime>(joiningDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  StaffData copyWith(
          {int? id,
          int? categoryId,
          String? name,
          String? phone,
          String? payType,
          double? payRate,
          double? halfDayRate,
          double? monthlySalary,
          DateTime? joiningDate,
          bool? isActive}) =>
      StaffData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        payType: payType ?? this.payType,
        payRate: payRate ?? this.payRate,
        halfDayRate: halfDayRate ?? this.halfDayRate,
        monthlySalary: monthlySalary ?? this.monthlySalary,
        joiningDate: joiningDate ?? this.joiningDate,
        isActive: isActive ?? this.isActive,
      );
  StaffData copyWithCompanion(StaffCompanion data) {
    return StaffData(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      payType: data.payType.present ? data.payType.value : this.payType,
      payRate: data.payRate.present ? data.payRate.value : this.payRate,
      halfDayRate:
          data.halfDayRate.present ? data.halfDayRate.value : this.halfDayRate,
      monthlySalary: data.monthlySalary.present
          ? data.monthlySalary.value
          : this.monthlySalary,
      joiningDate:
          data.joiningDate.present ? data.joiningDate.value : this.joiningDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StaffData(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('payType: $payType, ')
          ..write('payRate: $payRate, ')
          ..write('halfDayRate: $halfDayRate, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, name, phone, payType, payRate,
      halfDayRate, monthlySalary, joiningDate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StaffData &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.payType == this.payType &&
          other.payRate == this.payRate &&
          other.halfDayRate == this.halfDayRate &&
          other.monthlySalary == this.monthlySalary &&
          other.joiningDate == this.joiningDate &&
          other.isActive == this.isActive);
}

class StaffCompanion extends UpdateCompanion<StaffData> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> payType;
  final Value<double> payRate;
  final Value<double> halfDayRate;
  final Value<double> monthlySalary;
  final Value<DateTime> joiningDate;
  final Value<bool> isActive;
  const StaffCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.payType = const Value.absent(),
    this.payRate = const Value.absent(),
    this.halfDayRate = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    this.joiningDate = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  StaffCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.phone = const Value.absent(),
    this.payType = const Value.absent(),
    this.payRate = const Value.absent(),
    this.halfDayRate = const Value.absent(),
    this.monthlySalary = const Value.absent(),
    required DateTime joiningDate,
    this.isActive = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name),
        joiningDate = Value(joiningDate);
  static Insertable<StaffData> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? payType,
    Expression<double>? payRate,
    Expression<double>? halfDayRate,
    Expression<double>? monthlySalary,
    Expression<DateTime>? joiningDate,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (payType != null) 'pay_type': payType,
      if (payRate != null) 'pay_rate': payRate,
      if (halfDayRate != null) 'half_day_rate': halfDayRate,
      if (monthlySalary != null) 'monthly_salary': monthlySalary,
      if (joiningDate != null) 'joining_date': joiningDate,
      if (isActive != null) 'is_active': isActive,
    });
  }

  StaffCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? payType,
      Value<double>? payRate,
      Value<double>? halfDayRate,
      Value<double>? monthlySalary,
      Value<DateTime>? joiningDate,
      Value<bool>? isActive}) {
    return StaffCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      payType: payType ?? this.payType,
      payRate: payRate ?? this.payRate,
      halfDayRate: halfDayRate ?? this.halfDayRate,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      joiningDate: joiningDate ?? this.joiningDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (payType.present) {
      map['pay_type'] = Variable<String>(payType.value);
    }
    if (payRate.present) {
      map['pay_rate'] = Variable<double>(payRate.value);
    }
    if (halfDayRate.present) {
      map['half_day_rate'] = Variable<double>(halfDayRate.value);
    }
    if (monthlySalary.present) {
      map['monthly_salary'] = Variable<double>(monthlySalary.value);
    }
    if (joiningDate.present) {
      map['joining_date'] = Variable<DateTime>(joiningDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StaffCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('payType: $payType, ')
          ..write('payRate: $payRate, ')
          ..write('halfDayRate: $halfDayRate, ')
          ..write('monthlySalary: $monthlySalary, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES staff (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, staffId, date, status, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(Insertable<AttendanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}staff_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceData extends DataClass implements Insertable<AttendanceData> {
  final int id;
  final int staffId;
  final DateTime date;
  final String status;
  final String notes;
  const AttendanceData(
      {required this.id,
      required this.staffId,
      required this.date,
      required this.status,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      staffId: Value(staffId),
      date: Value(date),
      status: Value(status),
      notes: Value(notes),
    );
  }

  factory AttendanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceData(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
    };
  }

  AttendanceData copyWith(
          {int? id,
          int? staffId,
          DateTime? date,
          String? status,
          String? notes}) =>
      AttendanceData(
        id: id ?? this.id,
        staffId: staffId ?? this.staffId,
        date: date ?? this.date,
        status: status ?? this.status,
        notes: notes ?? this.notes,
      );
  AttendanceData copyWithCompanion(AttendanceCompanion data) {
    return AttendanceData(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceData(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, staffId, date, status, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceData &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.date == this.date &&
          other.status == this.status &&
          other.notes == this.notes);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceData> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<String> notes;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AttendanceCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    required DateTime date,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  })  : staffId = Value(staffId),
        date = Value(date);
  static Insertable<AttendanceData> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    });
  }

  AttendanceCompanion copyWith(
      {Value<int>? id,
      Value<int>? staffId,
      Value<DateTime>? date,
      Value<String>? status,
      Value<String>? notes}) {
    return AttendanceCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SalaryPaymentsTable extends SalaryPayments
    with TableInfo<$SalaryPaymentsTable, SalaryPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<int> staffId = GeneratedColumn<int>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES staff (id)'));
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _presentCountMeta =
      const VerificationMeta('presentCount');
  @override
  late final GeneratedColumn<int> presentCount = GeneratedColumn<int>(
      'present_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _halfDayCountMeta =
      const VerificationMeta('halfDayCount');
  @override
  late final GeneratedColumn<int> halfDayCount = GeneratedColumn<int>(
      'half_day_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _absentCountMeta =
      const VerificationMeta('absentCount');
  @override
  late final GeneratedColumn<int> absentCount = GeneratedColumn<int>(
      'absent_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _holidayCountMeta =
      const VerificationMeta('holidayCount');
  @override
  late final GeneratedColumn<int> holidayCount = GeneratedColumn<int>(
      'holiday_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _baseSalaryMeta =
      const VerificationMeta('baseSalary');
  @override
  late final GeneratedColumn<double> baseSalary = GeneratedColumn<double>(
      'base_salary', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _calculatedSalaryMeta =
      const VerificationMeta('calculatedSalary');
  @override
  late final GeneratedColumn<double> calculatedSalary = GeneratedColumn<double>(
      'calculated_salary', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<double> bonus = GeneratedColumn<double>(
      'bonus', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _deductionsMeta =
      const VerificationMeta('deductions');
  @override
  late final GeneratedColumn<double> deductions = GeneratedColumn<double>(
      'deductions', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _holidaysUnpaidMeta =
      const VerificationMeta('holidaysUnpaid');
  @override
  late final GeneratedColumn<bool> holidaysUnpaid = GeneratedColumn<bool>(
      'holidays_unpaid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("holidays_unpaid" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        staffId,
        month,
        year,
        presentCount,
        halfDayCount,
        absentCount,
        holidayCount,
        baseSalary,
        calculatedSalary,
        bonus,
        deductions,
        paidAmount,
        paidAt,
        notes,
        holidaysUnpaid
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_payments';
  @override
  VerificationContext validateIntegrity(Insertable<SalaryPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('present_count')) {
      context.handle(
          _presentCountMeta,
          presentCount.isAcceptableOrUnknown(
              data['present_count']!, _presentCountMeta));
    }
    if (data.containsKey('half_day_count')) {
      context.handle(
          _halfDayCountMeta,
          halfDayCount.isAcceptableOrUnknown(
              data['half_day_count']!, _halfDayCountMeta));
    }
    if (data.containsKey('absent_count')) {
      context.handle(
          _absentCountMeta,
          absentCount.isAcceptableOrUnknown(
              data['absent_count']!, _absentCountMeta));
    }
    if (data.containsKey('holiday_count')) {
      context.handle(
          _holidayCountMeta,
          holidayCount.isAcceptableOrUnknown(
              data['holiday_count']!, _holidayCountMeta));
    }
    if (data.containsKey('base_salary')) {
      context.handle(
          _baseSalaryMeta,
          baseSalary.isAcceptableOrUnknown(
              data['base_salary']!, _baseSalaryMeta));
    }
    if (data.containsKey('calculated_salary')) {
      context.handle(
          _calculatedSalaryMeta,
          calculatedSalary.isAcceptableOrUnknown(
              data['calculated_salary']!, _calculatedSalaryMeta));
    }
    if (data.containsKey('bonus')) {
      context.handle(
          _bonusMeta, bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta));
    }
    if (data.containsKey('deductions')) {
      context.handle(
          _deductionsMeta,
          deductions.isAcceptableOrUnknown(
              data['deductions']!, _deductionsMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('holidays_unpaid')) {
      context.handle(
          _holidaysUnpaidMeta,
          holidaysUnpaid.isAcceptableOrUnknown(
              data['holidays_unpaid']!, _holidaysUnpaidMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalaryPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}staff_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      presentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}present_count'])!,
      halfDayCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}half_day_count'])!,
      absentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}absent_count'])!,
      holidayCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}holiday_count'])!,
      baseSalary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_salary'])!,
      calculatedSalary: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}calculated_salary'])!,
      bonus: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bonus'])!,
      deductions: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}deductions'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      holidaysUnpaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}holidays_unpaid'])!,
    );
  }

  @override
  $SalaryPaymentsTable createAlias(String alias) {
    return $SalaryPaymentsTable(attachedDatabase, alias);
  }
}

class SalaryPayment extends DataClass implements Insertable<SalaryPayment> {
  final int id;
  final int staffId;
  final int month;
  final int year;
  final int presentCount;
  final int halfDayCount;
  final int absentCount;
  final int holidayCount;
  final double baseSalary;
  final double calculatedSalary;
  final double bonus;
  final double deductions;
  final double paidAmount;
  final DateTime paidAt;
  final String notes;
  final bool holidaysUnpaid;
  const SalaryPayment(
      {required this.id,
      required this.staffId,
      required this.month,
      required this.year,
      required this.presentCount,
      required this.halfDayCount,
      required this.absentCount,
      required this.holidayCount,
      required this.baseSalary,
      required this.calculatedSalary,
      required this.bonus,
      required this.deductions,
      required this.paidAmount,
      required this.paidAt,
      required this.notes,
      required this.holidaysUnpaid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['staff_id'] = Variable<int>(staffId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['present_count'] = Variable<int>(presentCount);
    map['half_day_count'] = Variable<int>(halfDayCount);
    map['absent_count'] = Variable<int>(absentCount);
    map['holiday_count'] = Variable<int>(holidayCount);
    map['base_salary'] = Variable<double>(baseSalary);
    map['calculated_salary'] = Variable<double>(calculatedSalary);
    map['bonus'] = Variable<double>(bonus);
    map['deductions'] = Variable<double>(deductions);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['notes'] = Variable<String>(notes);
    map['holidays_unpaid'] = Variable<bool>(holidaysUnpaid);
    return map;
  }

  SalaryPaymentsCompanion toCompanion(bool nullToAbsent) {
    return SalaryPaymentsCompanion(
      id: Value(id),
      staffId: Value(staffId),
      month: Value(month),
      year: Value(year),
      presentCount: Value(presentCount),
      halfDayCount: Value(halfDayCount),
      absentCount: Value(absentCount),
      holidayCount: Value(holidayCount),
      baseSalary: Value(baseSalary),
      calculatedSalary: Value(calculatedSalary),
      bonus: Value(bonus),
      deductions: Value(deductions),
      paidAmount: Value(paidAmount),
      paidAt: Value(paidAt),
      notes: Value(notes),
      holidaysUnpaid: Value(holidaysUnpaid),
    );
  }

  factory SalaryPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryPayment(
      id: serializer.fromJson<int>(json['id']),
      staffId: serializer.fromJson<int>(json['staffId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      presentCount: serializer.fromJson<int>(json['presentCount']),
      halfDayCount: serializer.fromJson<int>(json['halfDayCount']),
      absentCount: serializer.fromJson<int>(json['absentCount']),
      holidayCount: serializer.fromJson<int>(json['holidayCount']),
      baseSalary: serializer.fromJson<double>(json['baseSalary']),
      calculatedSalary: serializer.fromJson<double>(json['calculatedSalary']),
      bonus: serializer.fromJson<double>(json['bonus']),
      deductions: serializer.fromJson<double>(json['deductions']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      notes: serializer.fromJson<String>(json['notes']),
      holidaysUnpaid: serializer.fromJson<bool>(json['holidaysUnpaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'staffId': serializer.toJson<int>(staffId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'presentCount': serializer.toJson<int>(presentCount),
      'halfDayCount': serializer.toJson<int>(halfDayCount),
      'absentCount': serializer.toJson<int>(absentCount),
      'holidayCount': serializer.toJson<int>(holidayCount),
      'baseSalary': serializer.toJson<double>(baseSalary),
      'calculatedSalary': serializer.toJson<double>(calculatedSalary),
      'bonus': serializer.toJson<double>(bonus),
      'deductions': serializer.toJson<double>(deductions),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'notes': serializer.toJson<String>(notes),
      'holidaysUnpaid': serializer.toJson<bool>(holidaysUnpaid),
    };
  }

  SalaryPayment copyWith(
          {int? id,
          int? staffId,
          int? month,
          int? year,
          int? presentCount,
          int? halfDayCount,
          int? absentCount,
          int? holidayCount,
          double? baseSalary,
          double? calculatedSalary,
          double? bonus,
          double? deductions,
          double? paidAmount,
          DateTime? paidAt,
          String? notes,
          bool? holidaysUnpaid}) =>
      SalaryPayment(
        id: id ?? this.id,
        staffId: staffId ?? this.staffId,
        month: month ?? this.month,
        year: year ?? this.year,
        presentCount: presentCount ?? this.presentCount,
        halfDayCount: halfDayCount ?? this.halfDayCount,
        absentCount: absentCount ?? this.absentCount,
        holidayCount: holidayCount ?? this.holidayCount,
        baseSalary: baseSalary ?? this.baseSalary,
        calculatedSalary: calculatedSalary ?? this.calculatedSalary,
        bonus: bonus ?? this.bonus,
        deductions: deductions ?? this.deductions,
        paidAmount: paidAmount ?? this.paidAmount,
        paidAt: paidAt ?? this.paidAt,
        notes: notes ?? this.notes,
        holidaysUnpaid: holidaysUnpaid ?? this.holidaysUnpaid,
      );
  SalaryPayment copyWithCompanion(SalaryPaymentsCompanion data) {
    return SalaryPayment(
      id: data.id.present ? data.id.value : this.id,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      presentCount: data.presentCount.present
          ? data.presentCount.value
          : this.presentCount,
      halfDayCount: data.halfDayCount.present
          ? data.halfDayCount.value
          : this.halfDayCount,
      absentCount:
          data.absentCount.present ? data.absentCount.value : this.absentCount,
      holidayCount: data.holidayCount.present
          ? data.holidayCount.value
          : this.holidayCount,
      baseSalary:
          data.baseSalary.present ? data.baseSalary.value : this.baseSalary,
      calculatedSalary: data.calculatedSalary.present
          ? data.calculatedSalary.value
          : this.calculatedSalary,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      deductions:
          data.deductions.present ? data.deductions.value : this.deductions,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      holidaysUnpaid: data.holidaysUnpaid.present
          ? data.holidaysUnpaid.value
          : this.holidaysUnpaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryPayment(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('presentCount: $presentCount, ')
          ..write('halfDayCount: $halfDayCount, ')
          ..write('absentCount: $absentCount, ')
          ..write('holidayCount: $holidayCount, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('calculatedSalary: $calculatedSalary, ')
          ..write('bonus: $bonus, ')
          ..write('deductions: $deductions, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('holidaysUnpaid: $holidaysUnpaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      staffId,
      month,
      year,
      presentCount,
      halfDayCount,
      absentCount,
      holidayCount,
      baseSalary,
      calculatedSalary,
      bonus,
      deductions,
      paidAmount,
      paidAt,
      notes,
      holidaysUnpaid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryPayment &&
          other.id == this.id &&
          other.staffId == this.staffId &&
          other.month == this.month &&
          other.year == this.year &&
          other.presentCount == this.presentCount &&
          other.halfDayCount == this.halfDayCount &&
          other.absentCount == this.absentCount &&
          other.holidayCount == this.holidayCount &&
          other.baseSalary == this.baseSalary &&
          other.calculatedSalary == this.calculatedSalary &&
          other.bonus == this.bonus &&
          other.deductions == this.deductions &&
          other.paidAmount == this.paidAmount &&
          other.paidAt == this.paidAt &&
          other.notes == this.notes &&
          other.holidaysUnpaid == this.holidaysUnpaid);
}

class SalaryPaymentsCompanion extends UpdateCompanion<SalaryPayment> {
  final Value<int> id;
  final Value<int> staffId;
  final Value<int> month;
  final Value<int> year;
  final Value<int> presentCount;
  final Value<int> halfDayCount;
  final Value<int> absentCount;
  final Value<int> holidayCount;
  final Value<double> baseSalary;
  final Value<double> calculatedSalary;
  final Value<double> bonus;
  final Value<double> deductions;
  final Value<double> paidAmount;
  final Value<DateTime> paidAt;
  final Value<String> notes;
  final Value<bool> holidaysUnpaid;
  const SalaryPaymentsCompanion({
    this.id = const Value.absent(),
    this.staffId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.presentCount = const Value.absent(),
    this.halfDayCount = const Value.absent(),
    this.absentCount = const Value.absent(),
    this.holidayCount = const Value.absent(),
    this.baseSalary = const Value.absent(),
    this.calculatedSalary = const Value.absent(),
    this.bonus = const Value.absent(),
    this.deductions = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.holidaysUnpaid = const Value.absent(),
  });
  SalaryPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int staffId,
    required int month,
    required int year,
    this.presentCount = const Value.absent(),
    this.halfDayCount = const Value.absent(),
    this.absentCount = const Value.absent(),
    this.holidayCount = const Value.absent(),
    this.baseSalary = const Value.absent(),
    this.calculatedSalary = const Value.absent(),
    this.bonus = const Value.absent(),
    this.deductions = const Value.absent(),
    this.paidAmount = const Value.absent(),
    required DateTime paidAt,
    this.notes = const Value.absent(),
    this.holidaysUnpaid = const Value.absent(),
  })  : staffId = Value(staffId),
        month = Value(month),
        year = Value(year),
        paidAt = Value(paidAt);
  static Insertable<SalaryPayment> custom({
    Expression<int>? id,
    Expression<int>? staffId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<int>? presentCount,
    Expression<int>? halfDayCount,
    Expression<int>? absentCount,
    Expression<int>? holidayCount,
    Expression<double>? baseSalary,
    Expression<double>? calculatedSalary,
    Expression<double>? bonus,
    Expression<double>? deductions,
    Expression<double>? paidAmount,
    Expression<DateTime>? paidAt,
    Expression<String>? notes,
    Expression<bool>? holidaysUnpaid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (staffId != null) 'staff_id': staffId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (presentCount != null) 'present_count': presentCount,
      if (halfDayCount != null) 'half_day_count': halfDayCount,
      if (absentCount != null) 'absent_count': absentCount,
      if (holidayCount != null) 'holiday_count': holidayCount,
      if (baseSalary != null) 'base_salary': baseSalary,
      if (calculatedSalary != null) 'calculated_salary': calculatedSalary,
      if (bonus != null) 'bonus': bonus,
      if (deductions != null) 'deductions': deductions,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (paidAt != null) 'paid_at': paidAt,
      if (notes != null) 'notes': notes,
      if (holidaysUnpaid != null) 'holidays_unpaid': holidaysUnpaid,
    });
  }

  SalaryPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? staffId,
      Value<int>? month,
      Value<int>? year,
      Value<int>? presentCount,
      Value<int>? halfDayCount,
      Value<int>? absentCount,
      Value<int>? holidayCount,
      Value<double>? baseSalary,
      Value<double>? calculatedSalary,
      Value<double>? bonus,
      Value<double>? deductions,
      Value<double>? paidAmount,
      Value<DateTime>? paidAt,
      Value<String>? notes,
      Value<bool>? holidaysUnpaid}) {
    return SalaryPaymentsCompanion(
      id: id ?? this.id,
      staffId: staffId ?? this.staffId,
      month: month ?? this.month,
      year: year ?? this.year,
      presentCount: presentCount ?? this.presentCount,
      halfDayCount: halfDayCount ?? this.halfDayCount,
      absentCount: absentCount ?? this.absentCount,
      holidayCount: holidayCount ?? this.holidayCount,
      baseSalary: baseSalary ?? this.baseSalary,
      calculatedSalary: calculatedSalary ?? this.calculatedSalary,
      bonus: bonus ?? this.bonus,
      deductions: deductions ?? this.deductions,
      paidAmount: paidAmount ?? this.paidAmount,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
      holidaysUnpaid: holidaysUnpaid ?? this.holidaysUnpaid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<int>(staffId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (presentCount.present) {
      map['present_count'] = Variable<int>(presentCount.value);
    }
    if (halfDayCount.present) {
      map['half_day_count'] = Variable<int>(halfDayCount.value);
    }
    if (absentCount.present) {
      map['absent_count'] = Variable<int>(absentCount.value);
    }
    if (holidayCount.present) {
      map['holiday_count'] = Variable<int>(holidayCount.value);
    }
    if (baseSalary.present) {
      map['base_salary'] = Variable<double>(baseSalary.value);
    }
    if (calculatedSalary.present) {
      map['calculated_salary'] = Variable<double>(calculatedSalary.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<double>(bonus.value);
    }
    if (deductions.present) {
      map['deductions'] = Variable<double>(deductions.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (holidaysUnpaid.present) {
      map['holidays_unpaid'] = Variable<bool>(holidaysUnpaid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('staffId: $staffId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('presentCount: $presentCount, ')
          ..write('halfDayCount: $halfDayCount, ')
          ..write('absentCount: $absentCount, ')
          ..write('holidayCount: $holidayCount, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('calculatedSalary: $calculatedSalary, ')
          ..write('bonus: $bonus, ')
          ..write('deductions: $deductions, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidAt: $paidAt, ')
          ..write('notes: $notes, ')
          ..write('holidaysUnpaid: $holidaysUnpaid')
          ..write(')'))
        .toString();
  }
}

class $RawItemsTable extends RawItems with TableInfo<$RawItemsTable, RawItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _minStockAlertMeta =
      const VerificationMeta('minStockAlert');
  @override
  late final GeneratedColumn<double> minStockAlert = GeneratedColumn<double>(
      'min_stock_alert', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _expiryAlertDaysMeta =
      const VerificationMeta('expiryAlertDays');
  @override
  late final GeneratedColumn<int> expiryAlertDays = GeneratedColumn<int>(
      'expiry_alert_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(7));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, unit, minStockAlert, expiryAlertDays, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_items';
  @override
  VerificationContext validateIntegrity(Insertable<RawItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('min_stock_alert')) {
      context.handle(
          _minStockAlertMeta,
          minStockAlert.isAcceptableOrUnknown(
              data['min_stock_alert']!, _minStockAlertMeta));
    }
    if (data.containsKey('expiry_alert_days')) {
      context.handle(
          _expiryAlertDaysMeta,
          expiryAlertDays.isAcceptableOrUnknown(
              data['expiry_alert_days']!, _expiryAlertDaysMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      minStockAlert: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}min_stock_alert'])!,
      expiryAlertDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expiry_alert_days'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RawItemsTable createAlias(String alias) {
    return $RawItemsTable(attachedDatabase, alias);
  }
}

class RawItem extends DataClass implements Insertable<RawItem> {
  final int id;
  final String name;
  final String unit;
  final double minStockAlert;
  final int expiryAlertDays;
  final String category;
  final DateTime createdAt;
  const RawItem(
      {required this.id,
      required this.name,
      required this.unit,
      required this.minStockAlert,
      required this.expiryAlertDays,
      required this.category,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['min_stock_alert'] = Variable<double>(minStockAlert);
    map['expiry_alert_days'] = Variable<int>(expiryAlertDays);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RawItemsCompanion toCompanion(bool nullToAbsent) {
    return RawItemsCompanion(
      id: Value(id),
      name: Value(name),
      unit: Value(unit),
      minStockAlert: Value(minStockAlert),
      expiryAlertDays: Value(expiryAlertDays),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory RawItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      minStockAlert: serializer.fromJson<double>(json['minStockAlert']),
      expiryAlertDays: serializer.fromJson<int>(json['expiryAlertDays']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'minStockAlert': serializer.toJson<double>(minStockAlert),
      'expiryAlertDays': serializer.toJson<int>(expiryAlertDays),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RawItem copyWith(
          {int? id,
          String? name,
          String? unit,
          double? minStockAlert,
          int? expiryAlertDays,
          String? category,
          DateTime? createdAt}) =>
      RawItem(
        id: id ?? this.id,
        name: name ?? this.name,
        unit: unit ?? this.unit,
        minStockAlert: minStockAlert ?? this.minStockAlert,
        expiryAlertDays: expiryAlertDays ?? this.expiryAlertDays,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
      );
  RawItem copyWithCompanion(RawItemsCompanion data) {
    return RawItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      minStockAlert: data.minStockAlert.present
          ? data.minStockAlert.value
          : this.minStockAlert,
      expiryAlertDays: data.expiryAlertDays.present
          ? data.expiryAlertDays.value
          : this.expiryAlertDays,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('expiryAlertDays: $expiryAlertDays, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, unit, minStockAlert, expiryAlertDays, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.minStockAlert == this.minStockAlert &&
          other.expiryAlertDays == this.expiryAlertDays &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class RawItemsCompanion extends UpdateCompanion<RawItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> minStockAlert;
  final Value<int> expiryAlertDays;
  final Value<String> category;
  final Value<DateTime> createdAt;
  const RawItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.minStockAlert = const Value.absent(),
    this.expiryAlertDays = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RawItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String unit,
    this.minStockAlert = const Value.absent(),
    this.expiryAlertDays = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        unit = Value(unit);
  static Insertable<RawItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? minStockAlert,
    Expression<int>? expiryAlertDays,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (minStockAlert != null) 'min_stock_alert': minStockAlert,
      if (expiryAlertDays != null) 'expiry_alert_days': expiryAlertDays,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RawItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? unit,
      Value<double>? minStockAlert,
      Value<int>? expiryAlertDays,
      Value<String>? category,
      Value<DateTime>? createdAt}) {
    return RawItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      expiryAlertDays: expiryAlertDays ?? this.expiryAlertDays,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (minStockAlert.present) {
      map['min_stock_alert'] = Variable<double>(minStockAlert.value);
    }
    if (expiryAlertDays.present) {
      map['expiry_alert_days'] = Variable<int>(expiryAlertDays.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('expiryAlertDays: $expiryAlertDays, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StockBatchesTable extends StockBatches
    with TableInfo<$StockBatchesTable, StockBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rawItemIdMeta =
      const VerificationMeta('rawItemId');
  @override
  late final GeneratedColumn<int> rawItemId = GeneratedColumn<int>(
      'raw_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES raw_items (id)'));
  static const VerificationMeta _initialQtyMeta =
      const VerificationMeta('initialQty');
  @override
  late final GeneratedColumn<double> initialQty = GeneratedColumn<double>(
      'initial_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingQtyMeta =
      const VerificationMeta('remainingQty');
  @override
  late final GeneratedColumn<double> remainingQty = GeneratedColumn<double>(
      'remaining_qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPerUnitMeta =
      const VerificationMeta('costPerUnit');
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
      'cost_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalBatchCostMeta =
      const VerificationMeta('totalBatchCost');
  @override
  late final GeneratedColumn<double> totalBatchCost = GeneratedColumn<double>(
      'total_batch_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _batchCodeMeta =
      const VerificationMeta('batchCode');
  @override
  late final GeneratedColumn<String> batchCode = GeneratedColumn<String>(
      'batch_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _supplierMeta =
      const VerificationMeta('supplier');
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
      'supplier', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        rawItemId,
        initialQty,
        remainingQty,
        costPerUnit,
        totalBatchCost,
        purchaseDate,
        expiryDate,
        batchCode,
        supplier,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_batches';
  @override
  VerificationContext validateIntegrity(Insertable<StockBatche> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('raw_item_id')) {
      context.handle(
          _rawItemIdMeta,
          rawItemId.isAcceptableOrUnknown(
              data['raw_item_id']!, _rawItemIdMeta));
    } else if (isInserting) {
      context.missing(_rawItemIdMeta);
    }
    if (data.containsKey('initial_qty')) {
      context.handle(
          _initialQtyMeta,
          initialQty.isAcceptableOrUnknown(
              data['initial_qty']!, _initialQtyMeta));
    } else if (isInserting) {
      context.missing(_initialQtyMeta);
    }
    if (data.containsKey('remaining_qty')) {
      context.handle(
          _remainingQtyMeta,
          remainingQty.isAcceptableOrUnknown(
              data['remaining_qty']!, _remainingQtyMeta));
    } else if (isInserting) {
      context.missing(_remainingQtyMeta);
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
          _costPerUnitMeta,
          costPerUnit.isAcceptableOrUnknown(
              data['cost_per_unit']!, _costPerUnitMeta));
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    if (data.containsKey('total_batch_cost')) {
      context.handle(
          _totalBatchCostMeta,
          totalBatchCost.isAcceptableOrUnknown(
              data['total_batch_cost']!, _totalBatchCostMeta));
    } else if (isInserting) {
      context.missing(_totalBatchCostMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('batch_code')) {
      context.handle(_batchCodeMeta,
          batchCode.isAcceptableOrUnknown(data['batch_code']!, _batchCodeMeta));
    }
    if (data.containsKey('supplier')) {
      context.handle(_supplierMeta,
          supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockBatche(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rawItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}raw_item_id'])!,
      initialQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}initial_qty'])!,
      remainingQty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}remaining_qty'])!,
      costPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_unit'])!,
      totalBatchCost: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_batch_cost'])!,
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      batchCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_code'])!,
      supplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $StockBatchesTable createAlias(String alias) {
    return $StockBatchesTable(attachedDatabase, alias);
  }
}

class StockBatche extends DataClass implements Insertable<StockBatche> {
  final int id;
  final int rawItemId;
  final double initialQty;
  final double remainingQty;
  final double costPerUnit;
  final double totalBatchCost;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final String batchCode;
  final String supplier;
  final String notes;
  const StockBatche(
      {required this.id,
      required this.rawItemId,
      required this.initialQty,
      required this.remainingQty,
      required this.costPerUnit,
      required this.totalBatchCost,
      required this.purchaseDate,
      this.expiryDate,
      required this.batchCode,
      required this.supplier,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['raw_item_id'] = Variable<int>(rawItemId);
    map['initial_qty'] = Variable<double>(initialQty);
    map['remaining_qty'] = Variable<double>(remainingQty);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    map['total_batch_cost'] = Variable<double>(totalBatchCost);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['batch_code'] = Variable<String>(batchCode);
    map['supplier'] = Variable<String>(supplier);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  StockBatchesCompanion toCompanion(bool nullToAbsent) {
    return StockBatchesCompanion(
      id: Value(id),
      rawItemId: Value(rawItemId),
      initialQty: Value(initialQty),
      remainingQty: Value(remainingQty),
      costPerUnit: Value(costPerUnit),
      totalBatchCost: Value(totalBatchCost),
      purchaseDate: Value(purchaseDate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      batchCode: Value(batchCode),
      supplier: Value(supplier),
      notes: Value(notes),
    );
  }

  factory StockBatche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockBatche(
      id: serializer.fromJson<int>(json['id']),
      rawItemId: serializer.fromJson<int>(json['rawItemId']),
      initialQty: serializer.fromJson<double>(json['initialQty']),
      remainingQty: serializer.fromJson<double>(json['remainingQty']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
      totalBatchCost: serializer.fromJson<double>(json['totalBatchCost']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      batchCode: serializer.fromJson<String>(json['batchCode']),
      supplier: serializer.fromJson<String>(json['supplier']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rawItemId': serializer.toJson<int>(rawItemId),
      'initialQty': serializer.toJson<double>(initialQty),
      'remainingQty': serializer.toJson<double>(remainingQty),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
      'totalBatchCost': serializer.toJson<double>(totalBatchCost),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'batchCode': serializer.toJson<String>(batchCode),
      'supplier': serializer.toJson<String>(supplier),
      'notes': serializer.toJson<String>(notes),
    };
  }

  StockBatche copyWith(
          {int? id,
          int? rawItemId,
          double? initialQty,
          double? remainingQty,
          double? costPerUnit,
          double? totalBatchCost,
          DateTime? purchaseDate,
          Value<DateTime?> expiryDate = const Value.absent(),
          String? batchCode,
          String? supplier,
          String? notes}) =>
      StockBatche(
        id: id ?? this.id,
        rawItemId: rawItemId ?? this.rawItemId,
        initialQty: initialQty ?? this.initialQty,
        remainingQty: remainingQty ?? this.remainingQty,
        costPerUnit: costPerUnit ?? this.costPerUnit,
        totalBatchCost: totalBatchCost ?? this.totalBatchCost,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        batchCode: batchCode ?? this.batchCode,
        supplier: supplier ?? this.supplier,
        notes: notes ?? this.notes,
      );
  StockBatche copyWithCompanion(StockBatchesCompanion data) {
    return StockBatche(
      id: data.id.present ? data.id.value : this.id,
      rawItemId: data.rawItemId.present ? data.rawItemId.value : this.rawItemId,
      initialQty:
          data.initialQty.present ? data.initialQty.value : this.initialQty,
      remainingQty: data.remainingQty.present
          ? data.remainingQty.value
          : this.remainingQty,
      costPerUnit:
          data.costPerUnit.present ? data.costPerUnit.value : this.costPerUnit,
      totalBatchCost: data.totalBatchCost.present
          ? data.totalBatchCost.value
          : this.totalBatchCost,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      batchCode: data.batchCode.present ? data.batchCode.value : this.batchCode,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockBatche(')
          ..write('id: $id, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('initialQty: $initialQty, ')
          ..write('remainingQty: $remainingQty, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalBatchCost: $totalBatchCost, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('batchCode: $batchCode, ')
          ..write('supplier: $supplier, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      rawItemId,
      initialQty,
      remainingQty,
      costPerUnit,
      totalBatchCost,
      purchaseDate,
      expiryDate,
      batchCode,
      supplier,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockBatche &&
          other.id == this.id &&
          other.rawItemId == this.rawItemId &&
          other.initialQty == this.initialQty &&
          other.remainingQty == this.remainingQty &&
          other.costPerUnit == this.costPerUnit &&
          other.totalBatchCost == this.totalBatchCost &&
          other.purchaseDate == this.purchaseDate &&
          other.expiryDate == this.expiryDate &&
          other.batchCode == this.batchCode &&
          other.supplier == this.supplier &&
          other.notes == this.notes);
}

class StockBatchesCompanion extends UpdateCompanion<StockBatche> {
  final Value<int> id;
  final Value<int> rawItemId;
  final Value<double> initialQty;
  final Value<double> remainingQty;
  final Value<double> costPerUnit;
  final Value<double> totalBatchCost;
  final Value<DateTime> purchaseDate;
  final Value<DateTime?> expiryDate;
  final Value<String> batchCode;
  final Value<String> supplier;
  final Value<String> notes;
  const StockBatchesCompanion({
    this.id = const Value.absent(),
    this.rawItemId = const Value.absent(),
    this.initialQty = const Value.absent(),
    this.remainingQty = const Value.absent(),
    this.costPerUnit = const Value.absent(),
    this.totalBatchCost = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.batchCode = const Value.absent(),
    this.supplier = const Value.absent(),
    this.notes = const Value.absent(),
  });
  StockBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int rawItemId,
    required double initialQty,
    required double remainingQty,
    required double costPerUnit,
    required double totalBatchCost,
    required DateTime purchaseDate,
    this.expiryDate = const Value.absent(),
    this.batchCode = const Value.absent(),
    this.supplier = const Value.absent(),
    this.notes = const Value.absent(),
  })  : rawItemId = Value(rawItemId),
        initialQty = Value(initialQty),
        remainingQty = Value(remainingQty),
        costPerUnit = Value(costPerUnit),
        totalBatchCost = Value(totalBatchCost),
        purchaseDate = Value(purchaseDate);
  static Insertable<StockBatche> custom({
    Expression<int>? id,
    Expression<int>? rawItemId,
    Expression<double>? initialQty,
    Expression<double>? remainingQty,
    Expression<double>? costPerUnit,
    Expression<double>? totalBatchCost,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expiryDate,
    Expression<String>? batchCode,
    Expression<String>? supplier,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawItemId != null) 'raw_item_id': rawItemId,
      if (initialQty != null) 'initial_qty': initialQty,
      if (remainingQty != null) 'remaining_qty': remainingQty,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
      if (totalBatchCost != null) 'total_batch_cost': totalBatchCost,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (batchCode != null) 'batch_code': batchCode,
      if (supplier != null) 'supplier': supplier,
      if (notes != null) 'notes': notes,
    });
  }

  StockBatchesCompanion copyWith(
      {Value<int>? id,
      Value<int>? rawItemId,
      Value<double>? initialQty,
      Value<double>? remainingQty,
      Value<double>? costPerUnit,
      Value<double>? totalBatchCost,
      Value<DateTime>? purchaseDate,
      Value<DateTime?>? expiryDate,
      Value<String>? batchCode,
      Value<String>? supplier,
      Value<String>? notes}) {
    return StockBatchesCompanion(
      id: id ?? this.id,
      rawItemId: rawItemId ?? this.rawItemId,
      initialQty: initialQty ?? this.initialQty,
      remainingQty: remainingQty ?? this.remainingQty,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      totalBatchCost: totalBatchCost ?? this.totalBatchCost,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      batchCode: batchCode ?? this.batchCode,
      supplier: supplier ?? this.supplier,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rawItemId.present) {
      map['raw_item_id'] = Variable<int>(rawItemId.value);
    }
    if (initialQty.present) {
      map['initial_qty'] = Variable<double>(initialQty.value);
    }
    if (remainingQty.present) {
      map['remaining_qty'] = Variable<double>(remainingQty.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    if (totalBatchCost.present) {
      map['total_batch_cost'] = Variable<double>(totalBatchCost.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (batchCode.present) {
      map['batch_code'] = Variable<String>(batchCode.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockBatchesCompanion(')
          ..write('id: $id, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('initialQty: $initialQty, ')
          ..write('remainingQty: $remainingQty, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalBatchCost: $totalBatchCost, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('batchCode: $batchCode, ')
          ..write('supplier: $supplier, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _menuItemIdMeta =
      const VerificationMeta('menuItemId');
  @override
  late final GeneratedColumn<int> menuItemId = GeneratedColumn<int>(
      'menu_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES menu_items (id)'));
  static const VerificationMeta _variantNameMeta =
      const VerificationMeta('variantName');
  @override
  late final GeneratedColumn<String> variantName = GeneratedColumn<String>(
      'variant_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _rawItemIdMeta =
      const VerificationMeta('rawItemId');
  @override
  late final GeneratedColumn<int> rawItemId = GeneratedColumn<int>(
      'raw_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES raw_items (id)'));
  static const VerificationMeta _quantityRequiredMeta =
      const VerificationMeta('quantityRequired');
  @override
  late final GeneratedColumn<double> quantityRequired = GeneratedColumn<double>(
      'quantity_required', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, menuItemId, variantName, rawItemId, quantityRequired, unit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
          _menuItemIdMeta,
          menuItemId.isAcceptableOrUnknown(
              data['menu_item_id']!, _menuItemIdMeta));
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('variant_name')) {
      context.handle(
          _variantNameMeta,
          variantName.isAcceptableOrUnknown(
              data['variant_name']!, _variantNameMeta));
    }
    if (data.containsKey('raw_item_id')) {
      context.handle(
          _rawItemIdMeta,
          rawItemId.isAcceptableOrUnknown(
              data['raw_item_id']!, _rawItemIdMeta));
    } else if (isInserting) {
      context.missing(_rawItemIdMeta);
    }
    if (data.containsKey('quantity_required')) {
      context.handle(
          _quantityRequiredMeta,
          quantityRequired.isAcceptableOrUnknown(
              data['quantity_required']!, _quantityRequiredMeta));
    } else if (isInserting) {
      context.missing(_quantityRequiredMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      menuItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_item_id'])!,
      variantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_name'])!,
      rawItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}raw_item_id'])!,
      quantityRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_required'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }
}

class RecipeItem extends DataClass implements Insertable<RecipeItem> {
  final int id;
  final int menuItemId;
  final String variantName;
  final int rawItemId;
  final double quantityRequired;
  final String unit;
  const RecipeItem(
      {required this.id,
      required this.menuItemId,
      required this.variantName,
      required this.rawItemId,
      required this.quantityRequired,
      required this.unit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['menu_item_id'] = Variable<int>(menuItemId);
    map['variant_name'] = Variable<String>(variantName);
    map['raw_item_id'] = Variable<int>(rawItemId);
    map['quantity_required'] = Variable<double>(quantityRequired);
    map['unit'] = Variable<String>(unit);
    return map;
  }

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      menuItemId: Value(menuItemId),
      variantName: Value(variantName),
      rawItemId: Value(rawItemId),
      quantityRequired: Value(quantityRequired),
      unit: Value(unit),
    );
  }

  factory RecipeItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItem(
      id: serializer.fromJson<int>(json['id']),
      menuItemId: serializer.fromJson<int>(json['menuItemId']),
      variantName: serializer.fromJson<String>(json['variantName']),
      rawItemId: serializer.fromJson<int>(json['rawItemId']),
      quantityRequired: serializer.fromJson<double>(json['quantityRequired']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'menuItemId': serializer.toJson<int>(menuItemId),
      'variantName': serializer.toJson<String>(variantName),
      'rawItemId': serializer.toJson<int>(rawItemId),
      'quantityRequired': serializer.toJson<double>(quantityRequired),
      'unit': serializer.toJson<String>(unit),
    };
  }

  RecipeItem copyWith(
          {int? id,
          int? menuItemId,
          String? variantName,
          int? rawItemId,
          double? quantityRequired,
          String? unit}) =>
      RecipeItem(
        id: id ?? this.id,
        menuItemId: menuItemId ?? this.menuItemId,
        variantName: variantName ?? this.variantName,
        rawItemId: rawItemId ?? this.rawItemId,
        quantityRequired: quantityRequired ?? this.quantityRequired,
        unit: unit ?? this.unit,
      );
  RecipeItem copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItem(
      id: data.id.present ? data.id.value : this.id,
      menuItemId:
          data.menuItemId.present ? data.menuItemId.value : this.menuItemId,
      variantName:
          data.variantName.present ? data.variantName.value : this.variantName,
      rawItemId: data.rawItemId.present ? data.rawItemId.value : this.rawItemId,
      quantityRequired: data.quantityRequired.present
          ? data.quantityRequired.value
          : this.quantityRequired,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('variantName: $variantName, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('quantityRequired: $quantityRequired, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, menuItemId, variantName, rawItemId, quantityRequired, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItem &&
          other.id == this.id &&
          other.menuItemId == this.menuItemId &&
          other.variantName == this.variantName &&
          other.rawItemId == this.rawItemId &&
          other.quantityRequired == this.quantityRequired &&
          other.unit == this.unit);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<int> id;
  final Value<int> menuItemId;
  final Value<String> variantName;
  final Value<int> rawItemId;
  final Value<double> quantityRequired;
  final Value<String> unit;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.variantName = const Value.absent(),
    this.rawItemId = const Value.absent(),
    this.quantityRequired = const Value.absent(),
    this.unit = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required int menuItemId,
    this.variantName = const Value.absent(),
    required int rawItemId,
    required double quantityRequired,
    this.unit = const Value.absent(),
  })  : menuItemId = Value(menuItemId),
        rawItemId = Value(rawItemId),
        quantityRequired = Value(quantityRequired);
  static Insertable<RecipeItem> custom({
    Expression<int>? id,
    Expression<int>? menuItemId,
    Expression<String>? variantName,
    Expression<int>? rawItemId,
    Expression<double>? quantityRequired,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (variantName != null) 'variant_name': variantName,
      if (rawItemId != null) 'raw_item_id': rawItemId,
      if (quantityRequired != null) 'quantity_required': quantityRequired,
      if (unit != null) 'unit': unit,
    });
  }

  RecipeItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? menuItemId,
      Value<String>? variantName,
      Value<int>? rawItemId,
      Value<double>? quantityRequired,
      Value<String>? unit}) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      variantName: variantName ?? this.variantName,
      rawItemId: rawItemId ?? this.rawItemId,
      quantityRequired: quantityRequired ?? this.quantityRequired,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<int>(menuItemId.value);
    }
    if (variantName.present) {
      map['variant_name'] = Variable<String>(variantName.value);
    }
    if (rawItemId.present) {
      map['raw_item_id'] = Variable<int>(rawItemId.value);
    }
    if (quantityRequired.present) {
      map['quantity_required'] = Variable<double>(quantityRequired.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('variantName: $variantName, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('quantityRequired: $quantityRequired, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $ItemSopsTable extends ItemSops with TableInfo<$ItemSopsTable, ItemSop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemSopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _menuItemIdMeta =
      const VerificationMeta('menuItemId');
  @override
  late final GeneratedColumn<int> menuItemId = GeneratedColumn<int>(
      'menu_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES menu_items (id)'));
  static const VerificationMeta _variantNameMeta =
      const VerificationMeta('variantName');
  @override
  late final GeneratedColumn<String> variantName = GeneratedColumn<String>(
      'variant_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SOP'));
  static const VerificationMeta _prepTimeMinsMeta =
      const VerificationMeta('prepTimeMins');
  @override
  late final GeneratedColumn<int> prepTimeMins = GeneratedColumn<int>(
      'prep_time_mins', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _instructionsJsonMeta =
      const VerificationMeta('instructionsJson');
  @override
  late final GeneratedColumn<String> instructionsJson = GeneratedColumn<String>(
      'instructions_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        menuItemId,
        variantName,
        title,
        prepTimeMins,
        instructionsJson,
        notes,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_sops';
  @override
  VerificationContext validateIntegrity(Insertable<ItemSop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
          _menuItemIdMeta,
          menuItemId.isAcceptableOrUnknown(
              data['menu_item_id']!, _menuItemIdMeta));
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('variant_name')) {
      context.handle(
          _variantNameMeta,
          variantName.isAcceptableOrUnknown(
              data['variant_name']!, _variantNameMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('prep_time_mins')) {
      context.handle(
          _prepTimeMinsMeta,
          prepTimeMins.isAcceptableOrUnknown(
              data['prep_time_mins']!, _prepTimeMinsMeta));
    }
    if (data.containsKey('instructions_json')) {
      context.handle(
          _instructionsJsonMeta,
          instructionsJson.isAcceptableOrUnknown(
              data['instructions_json']!, _instructionsJsonMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemSop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemSop(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      menuItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_item_id'])!,
      variantName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variant_name'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      prepTimeMins: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prep_time_mins'])!,
      instructionsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}instructions_json'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ItemSopsTable createAlias(String alias) {
    return $ItemSopsTable(attachedDatabase, alias);
  }
}

class ItemSop extends DataClass implements Insertable<ItemSop> {
  final int id;
  final int menuItemId;
  final String variantName;
  final String title;
  final int prepTimeMins;
  final String instructionsJson;
  final String notes;
  final DateTime updatedAt;
  const ItemSop(
      {required this.id,
      required this.menuItemId,
      required this.variantName,
      required this.title,
      required this.prepTimeMins,
      required this.instructionsJson,
      required this.notes,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['menu_item_id'] = Variable<int>(menuItemId);
    map['variant_name'] = Variable<String>(variantName);
    map['title'] = Variable<String>(title);
    map['prep_time_mins'] = Variable<int>(prepTimeMins);
    map['instructions_json'] = Variable<String>(instructionsJson);
    map['notes'] = Variable<String>(notes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ItemSopsCompanion toCompanion(bool nullToAbsent) {
    return ItemSopsCompanion(
      id: Value(id),
      menuItemId: Value(menuItemId),
      variantName: Value(variantName),
      title: Value(title),
      prepTimeMins: Value(prepTimeMins),
      instructionsJson: Value(instructionsJson),
      notes: Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory ItemSop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemSop(
      id: serializer.fromJson<int>(json['id']),
      menuItemId: serializer.fromJson<int>(json['menuItemId']),
      variantName: serializer.fromJson<String>(json['variantName']),
      title: serializer.fromJson<String>(json['title']),
      prepTimeMins: serializer.fromJson<int>(json['prepTimeMins']),
      instructionsJson: serializer.fromJson<String>(json['instructionsJson']),
      notes: serializer.fromJson<String>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'menuItemId': serializer.toJson<int>(menuItemId),
      'variantName': serializer.toJson<String>(variantName),
      'title': serializer.toJson<String>(title),
      'prepTimeMins': serializer.toJson<int>(prepTimeMins),
      'instructionsJson': serializer.toJson<String>(instructionsJson),
      'notes': serializer.toJson<String>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ItemSop copyWith(
          {int? id,
          int? menuItemId,
          String? variantName,
          String? title,
          int? prepTimeMins,
          String? instructionsJson,
          String? notes,
          DateTime? updatedAt}) =>
      ItemSop(
        id: id ?? this.id,
        menuItemId: menuItemId ?? this.menuItemId,
        variantName: variantName ?? this.variantName,
        title: title ?? this.title,
        prepTimeMins: prepTimeMins ?? this.prepTimeMins,
        instructionsJson: instructionsJson ?? this.instructionsJson,
        notes: notes ?? this.notes,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ItemSop copyWithCompanion(ItemSopsCompanion data) {
    return ItemSop(
      id: data.id.present ? data.id.value : this.id,
      menuItemId:
          data.menuItemId.present ? data.menuItemId.value : this.menuItemId,
      variantName:
          data.variantName.present ? data.variantName.value : this.variantName,
      title: data.title.present ? data.title.value : this.title,
      prepTimeMins: data.prepTimeMins.present
          ? data.prepTimeMins.value
          : this.prepTimeMins,
      instructionsJson: data.instructionsJson.present
          ? data.instructionsJson.value
          : this.instructionsJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemSop(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('variantName: $variantName, ')
          ..write('title: $title, ')
          ..write('prepTimeMins: $prepTimeMins, ')
          ..write('instructionsJson: $instructionsJson, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, menuItemId, variantName, title,
      prepTimeMins, instructionsJson, notes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemSop &&
          other.id == this.id &&
          other.menuItemId == this.menuItemId &&
          other.variantName == this.variantName &&
          other.title == this.title &&
          other.prepTimeMins == this.prepTimeMins &&
          other.instructionsJson == this.instructionsJson &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class ItemSopsCompanion extends UpdateCompanion<ItemSop> {
  final Value<int> id;
  final Value<int> menuItemId;
  final Value<String> variantName;
  final Value<String> title;
  final Value<int> prepTimeMins;
  final Value<String> instructionsJson;
  final Value<String> notes;
  final Value<DateTime> updatedAt;
  const ItemSopsCompanion({
    this.id = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.variantName = const Value.absent(),
    this.title = const Value.absent(),
    this.prepTimeMins = const Value.absent(),
    this.instructionsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ItemSopsCompanion.insert({
    this.id = const Value.absent(),
    required int menuItemId,
    this.variantName = const Value.absent(),
    this.title = const Value.absent(),
    this.prepTimeMins = const Value.absent(),
    this.instructionsJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : menuItemId = Value(menuItemId);
  static Insertable<ItemSop> custom({
    Expression<int>? id,
    Expression<int>? menuItemId,
    Expression<String>? variantName,
    Expression<String>? title,
    Expression<int>? prepTimeMins,
    Expression<String>? instructionsJson,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (variantName != null) 'variant_name': variantName,
      if (title != null) 'title': title,
      if (prepTimeMins != null) 'prep_time_mins': prepTimeMins,
      if (instructionsJson != null) 'instructions_json': instructionsJson,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ItemSopsCompanion copyWith(
      {Value<int>? id,
      Value<int>? menuItemId,
      Value<String>? variantName,
      Value<String>? title,
      Value<int>? prepTimeMins,
      Value<String>? instructionsJson,
      Value<String>? notes,
      Value<DateTime>? updatedAt}) {
    return ItemSopsCompanion(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      variantName: variantName ?? this.variantName,
      title: title ?? this.title,
      prepTimeMins: prepTimeMins ?? this.prepTimeMins,
      instructionsJson: instructionsJson ?? this.instructionsJson,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<int>(menuItemId.value);
    }
    if (variantName.present) {
      map['variant_name'] = Variable<String>(variantName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (prepTimeMins.present) {
      map['prep_time_mins'] = Variable<int>(prepTimeMins.value);
    }
    if (instructionsJson.present) {
      map['instructions_json'] = Variable<String>(instructionsJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemSopsCompanion(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('variantName: $variantName, ')
          ..write('title: $title, ')
          ..write('prepTimeMins: $prepTimeMins, ')
          ..write('instructionsJson: $instructionsJson, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, category, amount, date, paymentMethod, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String paymentMethod;
  final String notes;
  const Expense(
      {required this.id,
      required this.title,
      required this.category,
      required this.amount,
      required this.date,
      required this.paymentMethod,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      amount: Value(amount),
      date: Value(date),
      paymentMethod: Value(paymentMethod),
      notes: Value(notes),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Expense copyWith(
          {int? id,
          String? title,
          String? category,
          double? amount,
          DateTime? date,
          String? paymentMethod,
          String? notes}) =>
      Expense(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        notes: notes ?? this.notes,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, category, amount, date, paymentMethod, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> category;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> paymentMethod;
  final Value<String> notes;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.category = const Value.absent(),
    required double amount,
    required DateTime date,
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
  })  : title = Value(title),
        amount = Value(amount),
        date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? category,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? paymentMethod,
      Value<String>? notes}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $CustomCategoriesTable extends CustomCategories
    with TableInfo<$CustomCategoriesTable, CustomCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _optionsJsonMeta =
      const VerificationMeta('optionsJson');
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
      'options_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, optionsJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_categories';
  @override
  VerificationContext validateIntegrity(Insertable<CustomCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
          _optionsJsonMeta,
          optionsJson.isAcceptableOrUnknown(
              data['options_json']!, _optionsJsonMeta));
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      optionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}options_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomCategoriesTable createAlias(String alias) {
    return $CustomCategoriesTable(attachedDatabase, alias);
  }
}

class CustomCategory extends DataClass implements Insertable<CustomCategory> {
  final int id;
  final String name;
  final String optionsJson;
  final DateTime createdAt;
  const CustomCategory(
      {required this.id,
      required this.name,
      required this.optionsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['options_json'] = Variable<String>(optionsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CustomCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      optionsJson: Value(optionsJson),
      createdAt: Value(createdAt),
    );
  }

  factory CustomCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomCategory copyWith(
          {int? id, String? name, String? optionsJson, DateTime? createdAt}) =>
      CustomCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        optionsJson: optionsJson ?? this.optionsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomCategory copyWithCompanion(CustomCategoriesCompanion data) {
    return CustomCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      optionsJson:
          data.optionsJson.present ? data.optionsJson.value : this.optionsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, optionsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.optionsJson == this.optionsJson &&
          other.createdAt == this.createdAt);
}

class CustomCategoriesCompanion extends UpdateCompanion<CustomCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> optionsJson;
  final Value<DateTime> createdAt;
  const CustomCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String optionsJson,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        optionsJson = Value(optionsJson);
  static Insertable<CustomCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? optionsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (optionsJson != null) 'options_json': optionsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? optionsJson,
      Value<DateTime>? createdAt}) {
    return CustomCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      optionsJson: optionsJson ?? this.optionsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EditedBillsTable extends EditedBills
    with TableInfo<$EditedBillsTable, EditedBill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditedBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<int> billNumber = GeneratedColumn<int>(
      'bill_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tableLabelMeta =
      const VerificationMeta('tableLabel');
  @override
  late final GeneratedColumn<String> tableLabel = GeneratedColumn<String>(
      'table_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalTotalMeta =
      const VerificationMeta('originalTotal');
  @override
  late final GeneratedColumn<double> originalTotal = GeneratedColumn<double>(
      'original_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _newTotalMeta =
      const VerificationMeta('newTotal');
  @override
  late final GeneratedColumn<double> newTotal = GeneratedColumn<double>(
      'new_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _editedByMeta =
      const VerificationMeta('editedBy');
  @override
  late final GeneratedColumn<String> editedBy = GeneratedColumn<String>(
      'edited_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Staff'));
  static const VerificationMeta _editedAtMeta =
      const VerificationMeta('editedAt');
  @override
  late final GeneratedColumn<DateTime> editedAt = GeneratedColumn<DateTime>(
      'edited_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Quantity reduction after print'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        billNumber,
        tableLabel,
        originalTotal,
        newTotal,
        editedBy,
        editedAt,
        reason
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'edited_bills';
  @override
  VerificationContext validateIntegrity(Insertable<EditedBill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    } else if (isInserting) {
      context.missing(_billNumberMeta);
    }
    if (data.containsKey('table_label')) {
      context.handle(
          _tableLabelMeta,
          tableLabel.isAcceptableOrUnknown(
              data['table_label']!, _tableLabelMeta));
    } else if (isInserting) {
      context.missing(_tableLabelMeta);
    }
    if (data.containsKey('original_total')) {
      context.handle(
          _originalTotalMeta,
          originalTotal.isAcceptableOrUnknown(
              data['original_total']!, _originalTotalMeta));
    } else if (isInserting) {
      context.missing(_originalTotalMeta);
    }
    if (data.containsKey('new_total')) {
      context.handle(_newTotalMeta,
          newTotal.isAcceptableOrUnknown(data['new_total']!, _newTotalMeta));
    } else if (isInserting) {
      context.missing(_newTotalMeta);
    }
    if (data.containsKey('edited_by')) {
      context.handle(_editedByMeta,
          editedBy.isAcceptableOrUnknown(data['edited_by']!, _editedByMeta));
    }
    if (data.containsKey('edited_at')) {
      context.handle(_editedAtMeta,
          editedAt.isAcceptableOrUnknown(data['edited_at']!, _editedAtMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EditedBill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EditedBill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bill_number'])!,
      tableLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_label'])!,
      originalTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}original_total'])!,
      newTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}new_total'])!,
      editedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edited_by'])!,
      editedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}edited_at'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
    );
  }

  @override
  $EditedBillsTable createAlias(String alias) {
    return $EditedBillsTable(attachedDatabase, alias);
  }
}

class EditedBill extends DataClass implements Insertable<EditedBill> {
  final int id;
  final int orderId;
  final int billNumber;
  final String tableLabel;
  final double originalTotal;
  final double newTotal;
  final String editedBy;
  final DateTime editedAt;
  final String reason;
  const EditedBill(
      {required this.id,
      required this.orderId,
      required this.billNumber,
      required this.tableLabel,
      required this.originalTotal,
      required this.newTotal,
      required this.editedBy,
      required this.editedAt,
      required this.reason});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['bill_number'] = Variable<int>(billNumber);
    map['table_label'] = Variable<String>(tableLabel);
    map['original_total'] = Variable<double>(originalTotal);
    map['new_total'] = Variable<double>(newTotal);
    map['edited_by'] = Variable<String>(editedBy);
    map['edited_at'] = Variable<DateTime>(editedAt);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  EditedBillsCompanion toCompanion(bool nullToAbsent) {
    return EditedBillsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      billNumber: Value(billNumber),
      tableLabel: Value(tableLabel),
      originalTotal: Value(originalTotal),
      newTotal: Value(newTotal),
      editedBy: Value(editedBy),
      editedAt: Value(editedAt),
      reason: Value(reason),
    );
  }

  factory EditedBill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EditedBill(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      billNumber: serializer.fromJson<int>(json['billNumber']),
      tableLabel: serializer.fromJson<String>(json['tableLabel']),
      originalTotal: serializer.fromJson<double>(json['originalTotal']),
      newTotal: serializer.fromJson<double>(json['newTotal']),
      editedBy: serializer.fromJson<String>(json['editedBy']),
      editedAt: serializer.fromJson<DateTime>(json['editedAt']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'billNumber': serializer.toJson<int>(billNumber),
      'tableLabel': serializer.toJson<String>(tableLabel),
      'originalTotal': serializer.toJson<double>(originalTotal),
      'newTotal': serializer.toJson<double>(newTotal),
      'editedBy': serializer.toJson<String>(editedBy),
      'editedAt': serializer.toJson<DateTime>(editedAt),
      'reason': serializer.toJson<String>(reason),
    };
  }

  EditedBill copyWith(
          {int? id,
          int? orderId,
          int? billNumber,
          String? tableLabel,
          double? originalTotal,
          double? newTotal,
          String? editedBy,
          DateTime? editedAt,
          String? reason}) =>
      EditedBill(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        billNumber: billNumber ?? this.billNumber,
        tableLabel: tableLabel ?? this.tableLabel,
        originalTotal: originalTotal ?? this.originalTotal,
        newTotal: newTotal ?? this.newTotal,
        editedBy: editedBy ?? this.editedBy,
        editedAt: editedAt ?? this.editedAt,
        reason: reason ?? this.reason,
      );
  EditedBill copyWithCompanion(EditedBillsCompanion data) {
    return EditedBill(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      tableLabel:
          data.tableLabel.present ? data.tableLabel.value : this.tableLabel,
      originalTotal: data.originalTotal.present
          ? data.originalTotal.value
          : this.originalTotal,
      newTotal: data.newTotal.present ? data.newTotal.value : this.newTotal,
      editedBy: data.editedBy.present ? data.editedBy.value : this.editedBy,
      editedAt: data.editedAt.present ? data.editedAt.value : this.editedAt,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EditedBill(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('billNumber: $billNumber, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('originalTotal: $originalTotal, ')
          ..write('newTotal: $newTotal, ')
          ..write('editedBy: $editedBy, ')
          ..write('editedAt: $editedAt, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, billNumber, tableLabel,
      originalTotal, newTotal, editedBy, editedAt, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EditedBill &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.billNumber == this.billNumber &&
          other.tableLabel == this.tableLabel &&
          other.originalTotal == this.originalTotal &&
          other.newTotal == this.newTotal &&
          other.editedBy == this.editedBy &&
          other.editedAt == this.editedAt &&
          other.reason == this.reason);
}

class EditedBillsCompanion extends UpdateCompanion<EditedBill> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> billNumber;
  final Value<String> tableLabel;
  final Value<double> originalTotal;
  final Value<double> newTotal;
  final Value<String> editedBy;
  final Value<DateTime> editedAt;
  final Value<String> reason;
  const EditedBillsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.tableLabel = const Value.absent(),
    this.originalTotal = const Value.absent(),
    this.newTotal = const Value.absent(),
    this.editedBy = const Value.absent(),
    this.editedAt = const Value.absent(),
    this.reason = const Value.absent(),
  });
  EditedBillsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int billNumber,
    required String tableLabel,
    required double originalTotal,
    required double newTotal,
    this.editedBy = const Value.absent(),
    this.editedAt = const Value.absent(),
    this.reason = const Value.absent(),
  })  : orderId = Value(orderId),
        billNumber = Value(billNumber),
        tableLabel = Value(tableLabel),
        originalTotal = Value(originalTotal),
        newTotal = Value(newTotal);
  static Insertable<EditedBill> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? billNumber,
    Expression<String>? tableLabel,
    Expression<double>? originalTotal,
    Expression<double>? newTotal,
    Expression<String>? editedBy,
    Expression<DateTime>? editedAt,
    Expression<String>? reason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (billNumber != null) 'bill_number': billNumber,
      if (tableLabel != null) 'table_label': tableLabel,
      if (originalTotal != null) 'original_total': originalTotal,
      if (newTotal != null) 'new_total': newTotal,
      if (editedBy != null) 'edited_by': editedBy,
      if (editedAt != null) 'edited_at': editedAt,
      if (reason != null) 'reason': reason,
    });
  }

  EditedBillsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? billNumber,
      Value<String>? tableLabel,
      Value<double>? originalTotal,
      Value<double>? newTotal,
      Value<String>? editedBy,
      Value<DateTime>? editedAt,
      Value<String>? reason}) {
    return EditedBillsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      billNumber: billNumber ?? this.billNumber,
      tableLabel: tableLabel ?? this.tableLabel,
      originalTotal: originalTotal ?? this.originalTotal,
      newTotal: newTotal ?? this.newTotal,
      editedBy: editedBy ?? this.editedBy,
      editedAt: editedAt ?? this.editedAt,
      reason: reason ?? this.reason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<int>(billNumber.value);
    }
    if (tableLabel.present) {
      map['table_label'] = Variable<String>(tableLabel.value);
    }
    if (originalTotal.present) {
      map['original_total'] = Variable<double>(originalTotal.value);
    }
    if (newTotal.present) {
      map['new_total'] = Variable<double>(newTotal.value);
    }
    if (editedBy.present) {
      map['edited_by'] = Variable<String>(editedBy.value);
    }
    if (editedAt.present) {
      map['edited_at'] = Variable<DateTime>(editedAt.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditedBillsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('billNumber: $billNumber, ')
          ..write('tableLabel: $tableLabel, ')
          ..write('originalTotal: $originalTotal, ')
          ..write('newTotal: $newTotal, ')
          ..write('editedBy: $editedBy, ')
          ..write('editedAt: $editedAt, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }
}

class $EditedBillItemsTable extends EditedBillItems
    with TableInfo<$EditedBillItemsTable, EditedBillItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditedBillItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _editedBillIdMeta =
      const VerificationMeta('editedBillId');
  @override
  late final GeneratedColumn<int> editedBillId = GeneratedColumn<int>(
      'edited_bill_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES edited_bills (id)'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oldQuantityMeta =
      const VerificationMeta('oldQuantity');
  @override
  late final GeneratedColumn<int> oldQuantity = GeneratedColumn<int>(
      'old_quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _newQuantityMeta =
      const VerificationMeta('newQuantity');
  @override
  late final GeneratedColumn<int> newQuantity = GeneratedColumn<int>(
      'new_quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemPriceMeta =
      const VerificationMeta('itemPrice');
  @override
  late final GeneratedColumn<double> itemPrice = GeneratedColumn<double>(
      'item_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, editedBillId, itemName, oldQuantity, newQuantity, itemPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'edited_bill_items';
  @override
  VerificationContext validateIntegrity(Insertable<EditedBillItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('edited_bill_id')) {
      context.handle(
          _editedBillIdMeta,
          editedBillId.isAcceptableOrUnknown(
              data['edited_bill_id']!, _editedBillIdMeta));
    } else if (isInserting) {
      context.missing(_editedBillIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('old_quantity')) {
      context.handle(
          _oldQuantityMeta,
          oldQuantity.isAcceptableOrUnknown(
              data['old_quantity']!, _oldQuantityMeta));
    } else if (isInserting) {
      context.missing(_oldQuantityMeta);
    }
    if (data.containsKey('new_quantity')) {
      context.handle(
          _newQuantityMeta,
          newQuantity.isAcceptableOrUnknown(
              data['new_quantity']!, _newQuantityMeta));
    } else if (isInserting) {
      context.missing(_newQuantityMeta);
    }
    if (data.containsKey('item_price')) {
      context.handle(_itemPriceMeta,
          itemPrice.isAcceptableOrUnknown(data['item_price']!, _itemPriceMeta));
    } else if (isInserting) {
      context.missing(_itemPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EditedBillItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EditedBillItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      editedBillId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edited_bill_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      oldQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}old_quantity'])!,
      newQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_quantity'])!,
      itemPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}item_price'])!,
    );
  }

  @override
  $EditedBillItemsTable createAlias(String alias) {
    return $EditedBillItemsTable(attachedDatabase, alias);
  }
}

class EditedBillItem extends DataClass implements Insertable<EditedBillItem> {
  final int id;
  final int editedBillId;
  final String itemName;
  final int oldQuantity;
  final int newQuantity;
  final double itemPrice;
  const EditedBillItem(
      {required this.id,
      required this.editedBillId,
      required this.itemName,
      required this.oldQuantity,
      required this.newQuantity,
      required this.itemPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['edited_bill_id'] = Variable<int>(editedBillId);
    map['item_name'] = Variable<String>(itemName);
    map['old_quantity'] = Variable<int>(oldQuantity);
    map['new_quantity'] = Variable<int>(newQuantity);
    map['item_price'] = Variable<double>(itemPrice);
    return map;
  }

  EditedBillItemsCompanion toCompanion(bool nullToAbsent) {
    return EditedBillItemsCompanion(
      id: Value(id),
      editedBillId: Value(editedBillId),
      itemName: Value(itemName),
      oldQuantity: Value(oldQuantity),
      newQuantity: Value(newQuantity),
      itemPrice: Value(itemPrice),
    );
  }

  factory EditedBillItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EditedBillItem(
      id: serializer.fromJson<int>(json['id']),
      editedBillId: serializer.fromJson<int>(json['editedBillId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      oldQuantity: serializer.fromJson<int>(json['oldQuantity']),
      newQuantity: serializer.fromJson<int>(json['newQuantity']),
      itemPrice: serializer.fromJson<double>(json['itemPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'editedBillId': serializer.toJson<int>(editedBillId),
      'itemName': serializer.toJson<String>(itemName),
      'oldQuantity': serializer.toJson<int>(oldQuantity),
      'newQuantity': serializer.toJson<int>(newQuantity),
      'itemPrice': serializer.toJson<double>(itemPrice),
    };
  }

  EditedBillItem copyWith(
          {int? id,
          int? editedBillId,
          String? itemName,
          int? oldQuantity,
          int? newQuantity,
          double? itemPrice}) =>
      EditedBillItem(
        id: id ?? this.id,
        editedBillId: editedBillId ?? this.editedBillId,
        itemName: itemName ?? this.itemName,
        oldQuantity: oldQuantity ?? this.oldQuantity,
        newQuantity: newQuantity ?? this.newQuantity,
        itemPrice: itemPrice ?? this.itemPrice,
      );
  EditedBillItem copyWithCompanion(EditedBillItemsCompanion data) {
    return EditedBillItem(
      id: data.id.present ? data.id.value : this.id,
      editedBillId: data.editedBillId.present
          ? data.editedBillId.value
          : this.editedBillId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      oldQuantity:
          data.oldQuantity.present ? data.oldQuantity.value : this.oldQuantity,
      newQuantity:
          data.newQuantity.present ? data.newQuantity.value : this.newQuantity,
      itemPrice: data.itemPrice.present ? data.itemPrice.value : this.itemPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EditedBillItem(')
          ..write('id: $id, ')
          ..write('editedBillId: $editedBillId, ')
          ..write('itemName: $itemName, ')
          ..write('oldQuantity: $oldQuantity, ')
          ..write('newQuantity: $newQuantity, ')
          ..write('itemPrice: $itemPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, editedBillId, itemName, oldQuantity, newQuantity, itemPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EditedBillItem &&
          other.id == this.id &&
          other.editedBillId == this.editedBillId &&
          other.itemName == this.itemName &&
          other.oldQuantity == this.oldQuantity &&
          other.newQuantity == this.newQuantity &&
          other.itemPrice == this.itemPrice);
}

class EditedBillItemsCompanion extends UpdateCompanion<EditedBillItem> {
  final Value<int> id;
  final Value<int> editedBillId;
  final Value<String> itemName;
  final Value<int> oldQuantity;
  final Value<int> newQuantity;
  final Value<double> itemPrice;
  const EditedBillItemsCompanion({
    this.id = const Value.absent(),
    this.editedBillId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.oldQuantity = const Value.absent(),
    this.newQuantity = const Value.absent(),
    this.itemPrice = const Value.absent(),
  });
  EditedBillItemsCompanion.insert({
    this.id = const Value.absent(),
    required int editedBillId,
    required String itemName,
    required int oldQuantity,
    required int newQuantity,
    required double itemPrice,
  })  : editedBillId = Value(editedBillId),
        itemName = Value(itemName),
        oldQuantity = Value(oldQuantity),
        newQuantity = Value(newQuantity),
        itemPrice = Value(itemPrice);
  static Insertable<EditedBillItem> custom({
    Expression<int>? id,
    Expression<int>? editedBillId,
    Expression<String>? itemName,
    Expression<int>? oldQuantity,
    Expression<int>? newQuantity,
    Expression<double>? itemPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (editedBillId != null) 'edited_bill_id': editedBillId,
      if (itemName != null) 'item_name': itemName,
      if (oldQuantity != null) 'old_quantity': oldQuantity,
      if (newQuantity != null) 'new_quantity': newQuantity,
      if (itemPrice != null) 'item_price': itemPrice,
    });
  }

  EditedBillItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? editedBillId,
      Value<String>? itemName,
      Value<int>? oldQuantity,
      Value<int>? newQuantity,
      Value<double>? itemPrice}) {
    return EditedBillItemsCompanion(
      id: id ?? this.id,
      editedBillId: editedBillId ?? this.editedBillId,
      itemName: itemName ?? this.itemName,
      oldQuantity: oldQuantity ?? this.oldQuantity,
      newQuantity: newQuantity ?? this.newQuantity,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (editedBillId.present) {
      map['edited_bill_id'] = Variable<int>(editedBillId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (oldQuantity.present) {
      map['old_quantity'] = Variable<int>(oldQuantity.value);
    }
    if (newQuantity.present) {
      map['new_quantity'] = Variable<int>(newQuantity.value);
    }
    if (itemPrice.present) {
      map['item_price'] = Variable<double>(itemPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditedBillItemsCompanion(')
          ..write('id: $id, ')
          ..write('editedBillId: $editedBillId, ')
          ..write('itemName: $itemName, ')
          ..write('oldQuantity: $oldQuantity, ')
          ..write('newQuantity: $newQuantity, ')
          ..write('itemPrice: $itemPrice')
          ..write(')'))
        .toString();
  }
}

class $StockWastageTable extends StockWastage
    with TableInfo<$StockWastageTable, StockWastageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockWastageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _rawItemIdMeta =
      const VerificationMeta('rawItemId');
  @override
  late final GeneratedColumn<int> rawItemId = GeneratedColumn<int>(
      'raw_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES raw_items (id)'));
  static const VerificationMeta _quantityWastedMeta =
      const VerificationMeta('quantityWasted');
  @override
  late final GeneratedColumn<double> quantityWasted = GeneratedColumn<double>(
      'quantity_wasted', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _wastageCostMeta =
      const VerificationMeta('wastageCost');
  @override
  late final GeneratedColumn<double> wastageCost = GeneratedColumn<double>(
      'wastage_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Spoiled / Damaged'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, rawItemId, quantityWasted, wastageCost, reason, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_wastage';
  @override
  VerificationContext validateIntegrity(Insertable<StockWastageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('raw_item_id')) {
      context.handle(
          _rawItemIdMeta,
          rawItemId.isAcceptableOrUnknown(
              data['raw_item_id']!, _rawItemIdMeta));
    } else if (isInserting) {
      context.missing(_rawItemIdMeta);
    }
    if (data.containsKey('quantity_wasted')) {
      context.handle(
          _quantityWastedMeta,
          quantityWasted.isAcceptableOrUnknown(
              data['quantity_wasted']!, _quantityWastedMeta));
    } else if (isInserting) {
      context.missing(_quantityWastedMeta);
    }
    if (data.containsKey('wastage_cost')) {
      context.handle(
          _wastageCostMeta,
          wastageCost.isAcceptableOrUnknown(
              data['wastage_cost']!, _wastageCostMeta));
    } else if (isInserting) {
      context.missing(_wastageCostMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockWastageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockWastageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rawItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}raw_item_id'])!,
      quantityWasted: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_wasted'])!,
      wastageCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}wastage_cost'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $StockWastageTable createAlias(String alias) {
    return $StockWastageTable(attachedDatabase, alias);
  }
}

class StockWastageData extends DataClass
    implements Insertable<StockWastageData> {
  final int id;
  final int rawItemId;
  final double quantityWasted;
  final double wastageCost;
  final String reason;
  final DateTime date;
  final String notes;
  const StockWastageData(
      {required this.id,
      required this.rawItemId,
      required this.quantityWasted,
      required this.wastageCost,
      required this.reason,
      required this.date,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['raw_item_id'] = Variable<int>(rawItemId);
    map['quantity_wasted'] = Variable<double>(quantityWasted);
    map['wastage_cost'] = Variable<double>(wastageCost);
    map['reason'] = Variable<String>(reason);
    map['date'] = Variable<DateTime>(date);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  StockWastageCompanion toCompanion(bool nullToAbsent) {
    return StockWastageCompanion(
      id: Value(id),
      rawItemId: Value(rawItemId),
      quantityWasted: Value(quantityWasted),
      wastageCost: Value(wastageCost),
      reason: Value(reason),
      date: Value(date),
      notes: Value(notes),
    );
  }

  factory StockWastageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockWastageData(
      id: serializer.fromJson<int>(json['id']),
      rawItemId: serializer.fromJson<int>(json['rawItemId']),
      quantityWasted: serializer.fromJson<double>(json['quantityWasted']),
      wastageCost: serializer.fromJson<double>(json['wastageCost']),
      reason: serializer.fromJson<String>(json['reason']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rawItemId': serializer.toJson<int>(rawItemId),
      'quantityWasted': serializer.toJson<double>(quantityWasted),
      'wastageCost': serializer.toJson<double>(wastageCost),
      'reason': serializer.toJson<String>(reason),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String>(notes),
    };
  }

  StockWastageData copyWith(
          {int? id,
          int? rawItemId,
          double? quantityWasted,
          double? wastageCost,
          String? reason,
          DateTime? date,
          String? notes}) =>
      StockWastageData(
        id: id ?? this.id,
        rawItemId: rawItemId ?? this.rawItemId,
        quantityWasted: quantityWasted ?? this.quantityWasted,
        wastageCost: wastageCost ?? this.wastageCost,
        reason: reason ?? this.reason,
        date: date ?? this.date,
        notes: notes ?? this.notes,
      );
  StockWastageData copyWithCompanion(StockWastageCompanion data) {
    return StockWastageData(
      id: data.id.present ? data.id.value : this.id,
      rawItemId: data.rawItemId.present ? data.rawItemId.value : this.rawItemId,
      quantityWasted: data.quantityWasted.present
          ? data.quantityWasted.value
          : this.quantityWasted,
      wastageCost:
          data.wastageCost.present ? data.wastageCost.value : this.wastageCost,
      reason: data.reason.present ? data.reason.value : this.reason,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockWastageData(')
          ..write('id: $id, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('quantityWasted: $quantityWasted, ')
          ..write('wastageCost: $wastageCost, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, rawItemId, quantityWasted, wastageCost, reason, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockWastageData &&
          other.id == this.id &&
          other.rawItemId == this.rawItemId &&
          other.quantityWasted == this.quantityWasted &&
          other.wastageCost == this.wastageCost &&
          other.reason == this.reason &&
          other.date == this.date &&
          other.notes == this.notes);
}

class StockWastageCompanion extends UpdateCompanion<StockWastageData> {
  final Value<int> id;
  final Value<int> rawItemId;
  final Value<double> quantityWasted;
  final Value<double> wastageCost;
  final Value<String> reason;
  final Value<DateTime> date;
  final Value<String> notes;
  const StockWastageCompanion({
    this.id = const Value.absent(),
    this.rawItemId = const Value.absent(),
    this.quantityWasted = const Value.absent(),
    this.wastageCost = const Value.absent(),
    this.reason = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  StockWastageCompanion.insert({
    this.id = const Value.absent(),
    required int rawItemId,
    required double quantityWasted,
    required double wastageCost,
    this.reason = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  })  : rawItemId = Value(rawItemId),
        quantityWasted = Value(quantityWasted),
        wastageCost = Value(wastageCost);
  static Insertable<StockWastageData> custom({
    Expression<int>? id,
    Expression<int>? rawItemId,
    Expression<double>? quantityWasted,
    Expression<double>? wastageCost,
    Expression<String>? reason,
    Expression<DateTime>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawItemId != null) 'raw_item_id': rawItemId,
      if (quantityWasted != null) 'quantity_wasted': quantityWasted,
      if (wastageCost != null) 'wastage_cost': wastageCost,
      if (reason != null) 'reason': reason,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  StockWastageCompanion copyWith(
      {Value<int>? id,
      Value<int>? rawItemId,
      Value<double>? quantityWasted,
      Value<double>? wastageCost,
      Value<String>? reason,
      Value<DateTime>? date,
      Value<String>? notes}) {
    return StockWastageCompanion(
      id: id ?? this.id,
      rawItemId: rawItemId ?? this.rawItemId,
      quantityWasted: quantityWasted ?? this.quantityWasted,
      wastageCost: wastageCost ?? this.wastageCost,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rawItemId.present) {
      map['raw_item_id'] = Variable<int>(rawItemId.value);
    }
    if (quantityWasted.present) {
      map['quantity_wasted'] = Variable<double>(quantityWasted.value);
    }
    if (wastageCost.present) {
      map['wastage_cost'] = Variable<double>(wastageCost.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockWastageCompanion(')
          ..write('id: $id, ')
          ..write('rawItemId: $rawItemId, ')
          ..write('quantityWasted: $quantityWasted, ')
          ..write('wastageCost: $wastageCost, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ZonesTable zones = $ZonesTable(this);
  late final $RestaurantTablesTable restaurantTables =
      $RestaurantTablesTable(this);
  late final $MenuCategoriesTable menuCategories = $MenuCategoriesTable(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $KotRecordsTable kotRecords = $KotRecordsTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $PrinterConfigsTable printerConfigs = $PrinterConfigsTable(this);
  late final $QueueEntriesTable queueEntries = $QueueEntriesTable(this);
  late final $StaffCategoriesTable staffCategories =
      $StaffCategoriesTable(this);
  late final $StaffTable staff = $StaffTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  late final $SalaryPaymentsTable salaryPayments = $SalaryPaymentsTable(this);
  late final $RawItemsTable rawItems = $RawItemsTable(this);
  late final $StockBatchesTable stockBatches = $StockBatchesTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $ItemSopsTable itemSops = $ItemSopsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $CustomCategoriesTable customCategories =
      $CustomCategoriesTable(this);
  late final $EditedBillsTable editedBills = $EditedBillsTable(this);
  late final $EditedBillItemsTable editedBillItems =
      $EditedBillItemsTable(this);
  late final $StockWastageTable stockWastage = $StockWastageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        zones,
        restaurantTables,
        menuCategories,
        menuItems,
        orders,
        orderItems,
        kotRecords,
        bills,
        printerConfigs,
        queueEntries,
        staffCategories,
        staff,
        attendance,
        salaryPayments,
        rawItems,
        stockBatches,
        recipeItems,
        itemSops,
        expenses,
        customCategories,
        editedBills,
        editedBillItems,
        stockWastage
      ];
}

typedef $$ZonesTableCreateCompanionBuilder = ZonesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> colorValue,
  Value<int> sortOrder,
});
typedef $$ZonesTableUpdateCompanionBuilder = ZonesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> colorValue,
  Value<int> sortOrder,
});

final class $$ZonesTableReferences
    extends BaseReferences<_$AppDatabase, $ZonesTable, Zone> {
  $$ZonesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RestaurantTablesTable, List<RestaurantTable>>
      _restaurantTablesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.restaurantTables,
              aliasName: $_aliasNameGenerator(
                  db.zones.id, db.restaurantTables.zoneId));

  $$RestaurantTablesTableProcessedTableManager get restaurantTablesRefs {
    final manager =
        $$RestaurantTablesTableTableManager($_db, $_db.restaurantTables)
            .filter((f) => f.zoneId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_restaurantTablesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ZonesTableFilterComposer extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  Expression<bool> restaurantTablesRefs(
      Expression<bool> Function($$RestaurantTablesTableFilterComposer f) f) {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.zoneId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableFilterComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ZonesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$ZonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> restaurantTablesRefs<T extends Object>(
      Expression<T> Function($$RestaurantTablesTableAnnotationComposer a) f) {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.zoneId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableAnnotationComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ZonesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ZonesTable,
    Zone,
    $$ZonesTableFilterComposer,
    $$ZonesTableOrderingComposer,
    $$ZonesTableAnnotationComposer,
    $$ZonesTableCreateCompanionBuilder,
    $$ZonesTableUpdateCompanionBuilder,
    (Zone, $$ZonesTableReferences),
    Zone,
    PrefetchHooks Function({bool restaurantTablesRefs})> {
  $$ZonesTableTableManager(_$AppDatabase db, $ZonesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              ZonesCompanion(
            id: id,
            name: name,
            colorValue: colorValue,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> colorValue = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              ZonesCompanion.insert(
            id: id,
            name: name,
            colorValue: colorValue,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ZonesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({restaurantTablesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (restaurantTablesRefs) db.restaurantTables
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (restaurantTablesRefs)
                    await $_getPrefetchedData<Zone, $ZonesTable,
                            RestaurantTable>(
                        currentTable: table,
                        referencedTable: $$ZonesTableReferences
                            ._restaurantTablesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ZonesTableReferences(db, table, p0)
                                .restaurantTablesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.zoneId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ZonesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ZonesTable,
    Zone,
    $$ZonesTableFilterComposer,
    $$ZonesTableOrderingComposer,
    $$ZonesTableAnnotationComposer,
    $$ZonesTableCreateCompanionBuilder,
    $$ZonesTableUpdateCompanionBuilder,
    (Zone, $$ZonesTableReferences),
    Zone,
    PrefetchHooks Function({bool restaurantTablesRefs})>;
typedef $$RestaurantTablesTableCreateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  required int zoneId,
  required String tableNumber,
  required String tableLabel,
  Value<int> capacity,
  Value<double> posX,
  Value<double> posY,
  Value<String> shape,
  Value<bool> isActive,
});
typedef $$RestaurantTablesTableUpdateCompanionBuilder
    = RestaurantTablesCompanion Function({
  Value<int> id,
  Value<int> zoneId,
  Value<String> tableNumber,
  Value<String> tableLabel,
  Value<int> capacity,
  Value<double> posX,
  Value<double> posY,
  Value<String> shape,
  Value<bool> isActive,
});

final class $$RestaurantTablesTableReferences extends BaseReferences<
    _$AppDatabase, $RestaurantTablesTable, RestaurantTable> {
  $$RestaurantTablesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ZonesTable _zoneIdTable(_$AppDatabase db) => db.zones.createAlias(
      $_aliasNameGenerator(db.restaurantTables.zoneId, db.zones.id));

  $$ZonesTableProcessedTableManager get zoneId {
    final $_column = $_itemColumn<int>('zone_id')!;

    final manager = $$ZonesTableTableManager($_db, $_db.zones)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_zoneIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.orders,
          aliasName:
              $_aliasNameGenerator(db.restaurantTables.id, db.orders.tableId));

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RestaurantTablesTableFilterComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get posX => $composableBuilder(
      column: $table.posX, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get posY => $composableBuilder(
      column: $table.posY, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shape => $composableBuilder(
      column: $table.shape, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$ZonesTableFilterComposer get zoneId {
    final $$ZonesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.zoneId,
        referencedTable: $db.zones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ZonesTableFilterComposer(
              $db: $db,
              $table: $db.zones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ordersRefs(
      Expression<bool> Function($$OrdersTableFilterComposer f) f) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RestaurantTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get posX => $composableBuilder(
      column: $table.posX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get posY => $composableBuilder(
      column: $table.posY, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shape => $composableBuilder(
      column: $table.shape, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$ZonesTableOrderingComposer get zoneId {
    final $$ZonesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.zoneId,
        referencedTable: $db.zones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ZonesTableOrderingComposer(
              $db: $db,
              $table: $db.zones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RestaurantTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestaurantTablesTable> {
  $$RestaurantTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableNumber => $composableBuilder(
      column: $table.tableNumber, builder: (column) => column);

  GeneratedColumn<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<double> get posX =>
      $composableBuilder(column: $table.posX, builder: (column) => column);

  GeneratedColumn<double> get posY =>
      $composableBuilder(column: $table.posY, builder: (column) => column);

  GeneratedColumn<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ZonesTableAnnotationComposer get zoneId {
    final $$ZonesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.zoneId,
        referencedTable: $db.zones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ZonesTableAnnotationComposer(
              $db: $db,
              $table: $db.zones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ordersRefs<T extends Object>(
      Expression<T> Function($$OrdersTableAnnotationComposer a) f) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RestaurantTablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$RestaurantTablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool zoneId, bool ordersRefs})> {
  $$RestaurantTablesTableTableManager(
      _$AppDatabase db, $RestaurantTablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestaurantTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestaurantTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestaurantTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> zoneId = const Value.absent(),
            Value<String> tableNumber = const Value.absent(),
            Value<String> tableLabel = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<double> posX = const Value.absent(),
            Value<double> posY = const Value.absent(),
            Value<String> shape = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              RestaurantTablesCompanion(
            id: id,
            zoneId: zoneId,
            tableNumber: tableNumber,
            tableLabel: tableLabel,
            capacity: capacity,
            posX: posX,
            posY: posY,
            shape: shape,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int zoneId,
            required String tableNumber,
            required String tableLabel,
            Value<int> capacity = const Value.absent(),
            Value<double> posX = const Value.absent(),
            Value<double> posY = const Value.absent(),
            Value<String> shape = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              RestaurantTablesCompanion.insert(
            id: id,
            zoneId: zoneId,
            tableNumber: tableNumber,
            tableLabel: tableLabel,
            capacity: capacity,
            posX: posX,
            posY: posY,
            shape: shape,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RestaurantTablesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({zoneId = false, ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (zoneId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.zoneId,
                    referencedTable:
                        $$RestaurantTablesTableReferences._zoneIdTable(db),
                    referencedColumn:
                        $$RestaurantTablesTableReferences._zoneIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<RestaurantTable,
                            $RestaurantTablesTable, Order>(
                        currentTable: table,
                        referencedTable: $$RestaurantTablesTableReferences
                            ._ordersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RestaurantTablesTableReferences(db, table, p0)
                                .ordersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tableId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RestaurantTablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RestaurantTablesTable,
    RestaurantTable,
    $$RestaurantTablesTableFilterComposer,
    $$RestaurantTablesTableOrderingComposer,
    $$RestaurantTablesTableAnnotationComposer,
    $$RestaurantTablesTableCreateCompanionBuilder,
    $$RestaurantTablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$RestaurantTablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool zoneId, bool ordersRefs})>;
typedef $$MenuCategoriesTableCreateCompanionBuilder = MenuCategoriesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int> colorValue,
  Value<int> sortOrder,
  Value<bool> isActive,
});
typedef $$MenuCategoriesTableUpdateCompanionBuilder = MenuCategoriesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> colorValue,
  Value<int> sortOrder,
  Value<bool> isActive,
});

final class $$MenuCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $MenuCategoriesTable, MenuCategory> {
  $$MenuCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MenuItemsTable, List<MenuItem>>
      _menuItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.menuItems,
              aliasName: $_aliasNameGenerator(
                  db.menuCategories.id, db.menuItems.categoryId));

  $$MenuItemsTableProcessedTableManager get menuItemsRefs {
    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_menuItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MenuCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MenuCategoriesTable> {
  $$MenuCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> menuItemsRefs(
      Expression<bool> Function($$MenuItemsTableFilterComposer f) f) {
    final $$MenuItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableFilterComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuCategoriesTable> {
  $$MenuCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$MenuCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuCategoriesTable> {
  $$MenuCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> menuItemsRefs<T extends Object>(
      Expression<T> Function($$MenuItemsTableAnnotationComposer a) f) {
    final $$MenuItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuCategoriesTable,
    MenuCategory,
    $$MenuCategoriesTableFilterComposer,
    $$MenuCategoriesTableOrderingComposer,
    $$MenuCategoriesTableAnnotationComposer,
    $$MenuCategoriesTableCreateCompanionBuilder,
    $$MenuCategoriesTableUpdateCompanionBuilder,
    (MenuCategory, $$MenuCategoriesTableReferences),
    MenuCategory,
    PrefetchHooks Function({bool menuItemsRefs})> {
  $$MenuCategoriesTableTableManager(
      _$AppDatabase db, $MenuCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MenuCategoriesCompanion(
            id: id,
            name: name,
            colorValue: colorValue,
            sortOrder: sortOrder,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> colorValue = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              MenuCategoriesCompanion.insert(
            id: id,
            name: name,
            colorValue: colorValue,
            sortOrder: sortOrder,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MenuCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({menuItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (menuItemsRefs) db.menuItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (menuItemsRefs)
                    await $_getPrefetchedData<MenuCategory,
                            $MenuCategoriesTable, MenuItem>(
                        currentTable: table,
                        referencedTable: $$MenuCategoriesTableReferences
                            ._menuItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MenuCategoriesTableReferences(db, table, p0)
                                .menuItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MenuCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuCategoriesTable,
    MenuCategory,
    $$MenuCategoriesTableFilterComposer,
    $$MenuCategoriesTableOrderingComposer,
    $$MenuCategoriesTableAnnotationComposer,
    $$MenuCategoriesTableCreateCompanionBuilder,
    $$MenuCategoriesTableUpdateCompanionBuilder,
    (MenuCategory, $$MenuCategoriesTableReferences),
    MenuCategory,
    PrefetchHooks Function({bool menuItemsRefs})>;
typedef $$MenuItemsTableCreateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<String> description,
  Value<double> price,
  Value<bool> isAvailable,
  Value<bool> isVeg,
  Value<int> sortOrder,
  Value<bool> hasHalfFull,
  Value<double> halfPrice,
  Value<String> defaultSize,
  Value<String?> image,
  Value<String> customVariantsJson,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<String> description,
  Value<double> price,
  Value<bool> isAvailable,
  Value<bool> isVeg,
  Value<int> sortOrder,
  Value<bool> hasHalfFull,
  Value<double> halfPrice,
  Value<String> defaultSize,
  Value<String?> image,
  Value<String> customVariantsJson,
});

final class $$MenuItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem> {
  $$MenuItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MenuCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.menuCategories.createAlias(
          $_aliasNameGenerator(db.menuItems.categoryId, db.menuCategories.id));

  $$MenuCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$MenuCategoriesTableTableManager($_db, $_db.menuCategories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName:
              $_aliasNameGenerator(db.menuItems.id, db.orderItems.menuItemId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.menuItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
      _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.recipeItems,
          aliasName:
              $_aliasNameGenerator(db.menuItems.id, db.recipeItems.menuItemId));

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager($_db, $_db.recipeItems)
        .filter((f) => f.menuItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ItemSopsTable, List<ItemSop>> _itemSopsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.itemSops,
          aliasName:
              $_aliasNameGenerator(db.menuItems.id, db.itemSops.menuItemId));

  $$ItemSopsTableProcessedTableManager get itemSopsRefs {
    final manager = $$ItemSopsTableTableManager($_db, $_db.itemSops)
        .filter((f) => f.menuItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemSopsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MenuItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVeg => $composableBuilder(
      column: $table.isVeg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasHalfFull => $composableBuilder(
      column: $table.hasHalfFull, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get halfPrice => $composableBuilder(
      column: $table.halfPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultSize => $composableBuilder(
      column: $table.defaultSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customVariantsJson => $composableBuilder(
      column: $table.customVariantsJson,
      builder: (column) => ColumnFilters(column));

  $$MenuCategoriesTableFilterComposer get categoryId {
    final $$MenuCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.menuCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.menuCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recipeItemsRefs(
      Expression<bool> Function($$RecipeItemsTableFilterComposer f) f) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeItemsTableFilterComposer(
              $db: $db,
              $table: $db.recipeItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> itemSopsRefs(
      Expression<bool> Function($$ItemSopsTableFilterComposer f) f) {
    final $$ItemSopsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSops,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSopsTableFilterComposer(
              $db: $db,
              $table: $db.itemSops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVeg => $composableBuilder(
      column: $table.isVeg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasHalfFull => $composableBuilder(
      column: $table.hasHalfFull, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get halfPrice => $composableBuilder(
      column: $table.halfPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultSize => $composableBuilder(
      column: $table.defaultSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customVariantsJson => $composableBuilder(
      column: $table.customVariantsJson,
      builder: (column) => ColumnOrderings(column));

  $$MenuCategoriesTableOrderingComposer get categoryId {
    final $$MenuCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.menuCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.menuCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<bool> get isVeg =>
      $composableBuilder(column: $table.isVeg, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get hasHalfFull => $composableBuilder(
      column: $table.hasHalfFull, builder: (column) => column);

  GeneratedColumn<double> get halfPrice =>
      $composableBuilder(column: $table.halfPrice, builder: (column) => column);

  GeneratedColumn<String> get defaultSize => $composableBuilder(
      column: $table.defaultSize, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get customVariantsJson => $composableBuilder(
      column: $table.customVariantsJson, builder: (column) => column);

  $$MenuCategoriesTableAnnotationComposer get categoryId {
    final $$MenuCategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.menuCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuCategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.menuCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> recipeItemsRefs<T extends Object>(
      Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> itemSopsRefs<T extends Object>(
      Expression<T> Function($$ItemSopsTableAnnotationComposer a) f) {
    final $$ItemSopsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemSops,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemSopsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemSops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, $$MenuItemsTableReferences),
    MenuItem,
    PrefetchHooks Function(
        {bool categoryId,
        bool orderItemsRefs,
        bool recipeItemsRefs,
        bool itemSopsRefs})> {
  $$MenuItemsTableTableManager(_$AppDatabase db, $MenuItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isVeg = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> hasHalfFull = const Value.absent(),
            Value<double> halfPrice = const Value.absent(),
            Value<String> defaultSize = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String> customVariantsJson = const Value.absent(),
          }) =>
              MenuItemsCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            price: price,
            isAvailable: isAvailable,
            isVeg: isVeg,
            sortOrder: sortOrder,
            hasHalfFull: hasHalfFull,
            halfPrice: halfPrice,
            defaultSize: defaultSize,
            image: image,
            customVariantsJson: customVariantsJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<String> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isVeg = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> hasHalfFull = const Value.absent(),
            Value<double> halfPrice = const Value.absent(),
            Value<String> defaultSize = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String> customVariantsJson = const Value.absent(),
          }) =>
              MenuItemsCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            price: price,
            isAvailable: isAvailable,
            isVeg: isVeg,
            sortOrder: sortOrder,
            hasHalfFull: hasHalfFull,
            halfPrice: halfPrice,
            defaultSize: defaultSize,
            image: image,
            customVariantsJson: customVariantsJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MenuItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              orderItemsRefs = false,
              recipeItemsRefs = false,
              itemSopsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsRefs) db.orderItems,
                if (recipeItemsRefs) db.recipeItems,
                if (itemSopsRefs) db.itemSops
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$MenuItemsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$MenuItemsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<MenuItem, $MenuItemsTable,
                            OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$MenuItemsTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MenuItemsTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.menuItemId == item.id),
                        typedResults: items),
                  if (recipeItemsRefs)
                    await $_getPrefetchedData<MenuItem, $MenuItemsTable,
                            RecipeItem>(
                        currentTable: table,
                        referencedTable: $$MenuItemsTableReferences
                            ._recipeItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MenuItemsTableReferences(db, table, p0)
                                .recipeItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.menuItemId == item.id),
                        typedResults: items),
                  if (itemSopsRefs)
                    await $_getPrefetchedData<MenuItem, $MenuItemsTable,
                            ItemSop>(
                        currentTable: table,
                        referencedTable:
                            $$MenuItemsTableReferences._itemSopsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MenuItemsTableReferences(db, table, p0)
                                .itemSopsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.menuItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MenuItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, $$MenuItemsTableReferences),
    MenuItem,
    PrefetchHooks Function(
        {bool categoryId,
        bool orderItemsRefs,
        bool recipeItemsRefs,
        bool itemSopsRefs})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required int tableId,
  Value<String> status,
  Value<String> waiterName,
  Value<String> customerName,
  Value<int> covers,
  required DateTime openedAt,
  required DateTime updatedAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<int> tableId,
  Value<String> status,
  Value<String> waiterName,
  Value<String> customerName,
  Value<int> covers,
  Value<DateTime> openedAt,
  Value<DateTime> updatedAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RestaurantTablesTable _tableIdTable(_$AppDatabase db) =>
      db.restaurantTables.createAlias(
          $_aliasNameGenerator(db.orders.tableId, db.restaurantTables.id));

  $$RestaurantTablesTableProcessedTableManager get tableId {
    final $_column = $_itemColumn<int>('table_id')!;

    final manager =
        $$RestaurantTablesTableTableManager($_db, $_db.restaurantTables)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$KotRecordsTable, List<KotRecord>>
      _kotRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.kotRecords,
          aliasName: $_aliasNameGenerator(db.orders.id, db.kotRecords.orderId));

  $$KotRecordsTableProcessedTableManager get kotRecordsRefs {
    final manager = $$KotRecordsTableTableManager($_db, $_db.kotRecords)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_kotRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BillsTable, List<Bill>> _billsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.bills,
          aliasName: $_aliasNameGenerator(db.orders.id, db.bills.orderId));

  $$BillsTableProcessedTableManager get billsRefs {
    final manager = $$BillsTableTableManager($_db, $_db.bills)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get waiterName => $composableBuilder(
      column: $table.waiterName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get covers => $composableBuilder(
      column: $table.covers, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$RestaurantTablesTableFilterComposer get tableId {
    final $$RestaurantTablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableFilterComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> kotRecordsRefs(
      Expression<bool> Function($$KotRecordsTableFilterComposer f) f) {
    final $$KotRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.kotRecords,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KotRecordsTableFilterComposer(
              $db: $db,
              $table: $db.kotRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> billsRefs(
      Expression<bool> Function($$BillsTableFilterComposer f) f) {
    final $$BillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableFilterComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get waiterName => $composableBuilder(
      column: $table.waiterName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get covers => $composableBuilder(
      column: $table.covers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$RestaurantTablesTableOrderingComposer get tableId {
    final $$RestaurantTablesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableOrderingComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get waiterName => $composableBuilder(
      column: $table.waiterName, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<int> get covers =>
      $composableBuilder(column: $table.covers, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RestaurantTablesTableAnnotationComposer get tableId {
    final $$RestaurantTablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.restaurantTables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RestaurantTablesTableAnnotationComposer(
              $db: $db,
              $table: $db.restaurantTables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> kotRecordsRefs<T extends Object>(
      Expression<T> Function($$KotRecordsTableAnnotationComposer a) f) {
    final $$KotRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.kotRecords,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KotRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.kotRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> billsRefs<T extends Object>(
      Expression<T> Function($$BillsTableAnnotationComposer a) f) {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableAnnotationComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function(
        {bool tableId,
        bool orderItemsRefs,
        bool kotRecordsRefs,
        bool billsRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tableId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> waiterName = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<int> covers = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            tableId: tableId,
            status: status,
            waiterName: waiterName,
            customerName: customerName,
            covers: covers,
            openedAt: openedAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tableId,
            Value<String> status = const Value.absent(),
            Value<String> waiterName = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<int> covers = const Value.absent(),
            required DateTime openedAt,
            required DateTime updatedAt,
          }) =>
              OrdersCompanion.insert(
            id: id,
            tableId: tableId,
            status: status,
            waiterName: waiterName,
            customerName: customerName,
            covers: covers,
            openedAt: openedAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {tableId = false,
              orderItemsRefs = false,
              kotRecordsRefs = false,
              billsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsRefs) db.orderItems,
                if (kotRecordsRefs) db.kotRecords,
                if (billsRefs) db.bills
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (tableId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tableId,
                    referencedTable: $$OrdersTableReferences._tableIdTable(db),
                    referencedColumn:
                        $$OrdersTableReferences._tableIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items),
                  if (kotRecordsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, KotRecord>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._kotRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .kotRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items),
                  if (billsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, Bill>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._billsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0).billsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function(
        {bool tableId,
        bool orderItemsRefs,
        bool kotRecordsRefs,
        bool billsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int menuItemId,
  required String itemName,
  required double itemPrice,
  Value<int> quantity,
  Value<String> notes,
  Value<bool> kotSent,
  required DateTime addedAt,
  Value<String> itemSize,
  Value<int> printedQuantity,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> menuItemId,
  Value<String> itemName,
  Value<double> itemPrice,
  Value<int> quantity,
  Value<String> notes,
  Value<bool> kotSent,
  Value<DateTime> addedAt,
  Value<String> itemSize,
  Value<int> printedQuantity,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MenuItemsTable _menuItemIdTable(_$AppDatabase db) =>
      db.menuItems.createAlias(
          $_aliasNameGenerator(db.orderItems.menuItemId, db.menuItems.id));

  $$MenuItemsTableProcessedTableManager get menuItemId {
    final $_column = $_itemColumn<int>('menu_item_id')!;

    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get itemPrice => $composableBuilder(
      column: $table.itemPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get kotSent => $composableBuilder(
      column: $table.kotSent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemSize => $composableBuilder(
      column: $table.itemSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get printedQuantity => $composableBuilder(
      column: $table.printedQuantity,
      builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableFilterComposer get menuItemId {
    final $$MenuItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableFilterComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get itemPrice => $composableBuilder(
      column: $table.itemPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get kotSent => $composableBuilder(
      column: $table.kotSent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemSize => $composableBuilder(
      column: $table.itemSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get printedQuantity => $composableBuilder(
      column: $table.printedQuantity,
      builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableOrderingComposer get menuItemId {
    final $$MenuItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableOrderingComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<double> get itemPrice =>
      $composableBuilder(column: $table.itemPrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get kotSent =>
      $composableBuilder(column: $table.kotSent, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get itemSize =>
      $composableBuilder(column: $table.itemSize, builder: (column) => column);

  GeneratedColumn<int> get printedQuantity => $composableBuilder(
      column: $table.printedQuantity, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableAnnotationComposer get menuItemId {
    final $$MenuItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool menuItemId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> menuItemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<double> itemPrice = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<bool> kotSent = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<String> itemSize = const Value.absent(),
            Value<int> printedQuantity = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            itemName: itemName,
            itemPrice: itemPrice,
            quantity: quantity,
            notes: notes,
            kotSent: kotSent,
            addedAt: addedAt,
            itemSize: itemSize,
            printedQuantity: printedQuantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int menuItemId,
            required String itemName,
            required double itemPrice,
            Value<int> quantity = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<bool> kotSent = const Value.absent(),
            required DateTime addedAt,
            Value<String> itemSize = const Value.absent(),
            Value<int> printedQuantity = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            itemName: itemName,
            itemPrice: itemPrice,
            quantity: quantity,
            notes: notes,
            kotSent: kotSent,
            addedAt: addedAt,
            itemSize: itemSize,
            printedQuantity: printedQuantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false, menuItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }
                if (menuItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.menuItemId,
                    referencedTable:
                        $$OrderItemsTableReferences._menuItemIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._menuItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool menuItemId})>;
typedef $$KotRecordsTableCreateCompanionBuilder = KotRecordsCompanion Function({
  Value<int> id,
  required int orderId,
  required int kotNumber,
  required String itemsJson,
  required DateTime printedAt,
});
typedef $$KotRecordsTableUpdateCompanionBuilder = KotRecordsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> kotNumber,
  Value<String> itemsJson,
  Value<DateTime> printedAt,
});

final class $$KotRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $KotRecordsTable, KotRecord> {
  $$KotRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.kotRecords.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$KotRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $KotRecordsTable> {
  $$KotRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kotNumber => $composableBuilder(
      column: $table.kotNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get printedAt => $composableBuilder(
      column: $table.printedAt, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KotRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $KotRecordsTable> {
  $$KotRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kotNumber => $composableBuilder(
      column: $table.kotNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get printedAt => $composableBuilder(
      column: $table.printedAt, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KotRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KotRecordsTable> {
  $$KotRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kotNumber =>
      $composableBuilder(column: $table.kotNumber, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get printedAt =>
      $composableBuilder(column: $table.printedAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$KotRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KotRecordsTable,
    KotRecord,
    $$KotRecordsTableFilterComposer,
    $$KotRecordsTableOrderingComposer,
    $$KotRecordsTableAnnotationComposer,
    $$KotRecordsTableCreateCompanionBuilder,
    $$KotRecordsTableUpdateCompanionBuilder,
    (KotRecord, $$KotRecordsTableReferences),
    KotRecord,
    PrefetchHooks Function({bool orderId})> {
  $$KotRecordsTableTableManager(_$AppDatabase db, $KotRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KotRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KotRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KotRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> kotNumber = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<DateTime> printedAt = const Value.absent(),
          }) =>
              KotRecordsCompanion(
            id: id,
            orderId: orderId,
            kotNumber: kotNumber,
            itemsJson: itemsJson,
            printedAt: printedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int kotNumber,
            required String itemsJson,
            required DateTime printedAt,
          }) =>
              KotRecordsCompanion.insert(
            id: id,
            orderId: orderId,
            kotNumber: kotNumber,
            itemsJson: itemsJson,
            printedAt: printedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KotRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$KotRecordsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$KotRecordsTableReferences._orderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$KotRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KotRecordsTable,
    KotRecord,
    $$KotRecordsTableFilterComposer,
    $$KotRecordsTableOrderingComposer,
    $$KotRecordsTableAnnotationComposer,
    $$KotRecordsTableCreateCompanionBuilder,
    $$KotRecordsTableUpdateCompanionBuilder,
    (KotRecord, $$KotRecordsTableReferences),
    KotRecord,
    PrefetchHooks Function({bool orderId})>;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  required int orderId,
  required int tableId,
  required String tableLabel,
  required double subtotal,
  Value<double> discount,
  required double total,
  Value<String> paymentMethod,
  Value<double> amountReceived,
  Value<double> change,
  Value<double> splitCash,
  Value<double> splitOnline,
  required String itemsJson,
  required DateTime createdAt,
  Value<int?> billNumber,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> tableId,
  Value<String> tableLabel,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> total,
  Value<String> paymentMethod,
  Value<double> amountReceived,
  Value<double> change,
  Value<double> splitCash,
  Value<double> splitOnline,
  Value<String> itemsJson,
  Value<DateTime> createdAt,
  Value<int?> billNumber,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, Bill> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.bills.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get splitCash => $composableBuilder(
      column: $table.splitCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get splitOnline => $composableBuilder(
      column: $table.splitOnline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get splitCash => $composableBuilder(
      column: $table.splitCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get splitOnline => $composableBuilder(
      column: $table.splitOnline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tableId =>
      $composableBuilder(column: $table.tableId, builder: (column) => column);

  GeneratedColumn<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived, builder: (column) => column);

  GeneratedColumn<double> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<double> get splitCash =>
      $composableBuilder(column: $table.splitCash, builder: (column) => column);

  GeneratedColumn<double> get splitOnline => $composableBuilder(
      column: $table.splitOnline, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, $$BillsTableReferences),
    Bill,
    PrefetchHooks Function({bool orderId})> {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> tableId = const Value.absent(),
            Value<String> tableLabel = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<double> amountReceived = const Value.absent(),
            Value<double> change = const Value.absent(),
            Value<double> splitCash = const Value.absent(),
            Value<double> splitOnline = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int?> billNumber = const Value.absent(),
          }) =>
              BillsCompanion(
            id: id,
            orderId: orderId,
            tableId: tableId,
            tableLabel: tableLabel,
            subtotal: subtotal,
            discount: discount,
            total: total,
            paymentMethod: paymentMethod,
            amountReceived: amountReceived,
            change: change,
            splitCash: splitCash,
            splitOnline: splitOnline,
            itemsJson: itemsJson,
            createdAt: createdAt,
            billNumber: billNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int tableId,
            required String tableLabel,
            required double subtotal,
            Value<double> discount = const Value.absent(),
            required double total,
            Value<String> paymentMethod = const Value.absent(),
            Value<double> amountReceived = const Value.absent(),
            Value<double> change = const Value.absent(),
            Value<double> splitCash = const Value.absent(),
            Value<double> splitOnline = const Value.absent(),
            required String itemsJson,
            required DateTime createdAt,
            Value<int?> billNumber = const Value.absent(),
          }) =>
              BillsCompanion.insert(
            id: id,
            orderId: orderId,
            tableId: tableId,
            tableLabel: tableLabel,
            subtotal: subtotal,
            discount: discount,
            total: total,
            paymentMethod: paymentMethod,
            amountReceived: amountReceived,
            change: change,
            splitCash: splitCash,
            splitOnline: splitOnline,
            itemsJson: itemsJson,
            createdAt: createdAt,
            billNumber: billNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BillsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable: $$BillsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$BillsTableReferences._orderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillsTable,
    Bill,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (Bill, $$BillsTableReferences),
    Bill,
    PrefetchHooks Function({bool orderId})>;
typedef $$PrinterConfigsTableCreateCompanionBuilder = PrinterConfigsCompanion
    Function({
  Value<int> id,
  required String name,
  required String address,
  Value<String> printerType,
  Value<int> paperWidth,
  Value<bool> isDefault,
  Value<bool> isConnected,
});
typedef $$PrinterConfigsTableUpdateCompanionBuilder = PrinterConfigsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> address,
  Value<String> printerType,
  Value<int> paperWidth,
  Value<bool> isDefault,
  Value<bool> isConnected,
});

class $$PrinterConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $PrinterConfigsTable> {
  $$PrinterConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paperWidth => $composableBuilder(
      column: $table.paperWidth, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnFilters(column));
}

class $$PrinterConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrinterConfigsTable> {
  $$PrinterConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paperWidth => $composableBuilder(
      column: $table.paperWidth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnOrderings(column));
}

class $$PrinterConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrinterConfigsTable> {
  $$PrinterConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get printerType => $composableBuilder(
      column: $table.printerType, builder: (column) => column);

  GeneratedColumn<int> get paperWidth => $composableBuilder(
      column: $table.paperWidth, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => column);
}

class $$PrinterConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PrinterConfigsTable,
    PrinterConfig,
    $$PrinterConfigsTableFilterComposer,
    $$PrinterConfigsTableOrderingComposer,
    $$PrinterConfigsTableAnnotationComposer,
    $$PrinterConfigsTableCreateCompanionBuilder,
    $$PrinterConfigsTableUpdateCompanionBuilder,
    (
      PrinterConfig,
      BaseReferences<_$AppDatabase, $PrinterConfigsTable, PrinterConfig>
    ),
    PrinterConfig,
    PrefetchHooks Function()> {
  $$PrinterConfigsTableTableManager(
      _$AppDatabase db, $PrinterConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrinterConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrinterConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrinterConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> printerType = const Value.absent(),
            Value<int> paperWidth = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isConnected = const Value.absent(),
          }) =>
              PrinterConfigsCompanion(
            id: id,
            name: name,
            address: address,
            printerType: printerType,
            paperWidth: paperWidth,
            isDefault: isDefault,
            isConnected: isConnected,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String address,
            Value<String> printerType = const Value.absent(),
            Value<int> paperWidth = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isConnected = const Value.absent(),
          }) =>
              PrinterConfigsCompanion.insert(
            id: id,
            name: name,
            address: address,
            printerType: printerType,
            paperWidth: paperWidth,
            isDefault: isDefault,
            isConnected: isConnected,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrinterConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PrinterConfigsTable,
    PrinterConfig,
    $$PrinterConfigsTableFilterComposer,
    $$PrinterConfigsTableOrderingComposer,
    $$PrinterConfigsTableAnnotationComposer,
    $$PrinterConfigsTableCreateCompanionBuilder,
    $$PrinterConfigsTableUpdateCompanionBuilder,
    (
      PrinterConfig,
      BaseReferences<_$AppDatabase, $PrinterConfigsTable, PrinterConfig>
    ),
    PrinterConfig,
    PrefetchHooks Function()>;
typedef $$QueueEntriesTableCreateCompanionBuilder = QueueEntriesCompanion
    Function({
  Value<int> id,
  required String customerName,
  Value<String?> customerPhone,
  Value<int> requiredSeats,
  required int waitingNumber,
  Value<DateTime> createdAt,
  Value<String> status,
});
typedef $$QueueEntriesTableUpdateCompanionBuilder = QueueEntriesCompanion
    Function({
  Value<int> id,
  Value<String> customerName,
  Value<String?> customerPhone,
  Value<int> requiredSeats,
  Value<int> waitingNumber,
  Value<DateTime> createdAt,
  Value<String> status,
});

class $$QueueEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get requiredSeats => $composableBuilder(
      column: $table.requiredSeats, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get waitingNumber => $composableBuilder(
      column: $table.waitingNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$QueueEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get requiredSeats => $composableBuilder(
      column: $table.requiredSeats,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get waitingNumber => $composableBuilder(
      column: $table.waitingNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$QueueEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueueEntriesTable> {
  $$QueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<int> get requiredSeats => $composableBuilder(
      column: $table.requiredSeats, builder: (column) => column);

  GeneratedColumn<int> get waitingNumber => $composableBuilder(
      column: $table.waitingNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$QueueEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QueueEntriesTable,
    QueueEntry,
    $$QueueEntriesTableFilterComposer,
    $$QueueEntriesTableOrderingComposer,
    $$QueueEntriesTableAnnotationComposer,
    $$QueueEntriesTableCreateCompanionBuilder,
    $$QueueEntriesTableUpdateCompanionBuilder,
    (QueueEntry, BaseReferences<_$AppDatabase, $QueueEntriesTable, QueueEntry>),
    QueueEntry,
    PrefetchHooks Function()> {
  $$QueueEntriesTableTableManager(_$AppDatabase db, $QueueEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<int> requiredSeats = const Value.absent(),
            Value<int> waitingNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              QueueEntriesCompanion(
            id: id,
            customerName: customerName,
            customerPhone: customerPhone,
            requiredSeats: requiredSeats,
            waitingNumber: waitingNumber,
            createdAt: createdAt,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String customerName,
            Value<String?> customerPhone = const Value.absent(),
            Value<int> requiredSeats = const Value.absent(),
            required int waitingNumber,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              QueueEntriesCompanion.insert(
            id: id,
            customerName: customerName,
            customerPhone: customerPhone,
            requiredSeats: requiredSeats,
            waitingNumber: waitingNumber,
            createdAt: createdAt,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QueueEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QueueEntriesTable,
    QueueEntry,
    $$QueueEntriesTableFilterComposer,
    $$QueueEntriesTableOrderingComposer,
    $$QueueEntriesTableAnnotationComposer,
    $$QueueEntriesTableCreateCompanionBuilder,
    $$QueueEntriesTableUpdateCompanionBuilder,
    (QueueEntry, BaseReferences<_$AppDatabase, $QueueEntriesTable, QueueEntry>),
    QueueEntry,
    PrefetchHooks Function()>;
typedef $$StaffCategoriesTableCreateCompanionBuilder = StaffCategoriesCompanion
    Function({
  Value<int> id,
  required String name,
  Value<double> defaultDailyRate,
  Value<double> defaultHalfDayRate,
});
typedef $$StaffCategoriesTableUpdateCompanionBuilder = StaffCategoriesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<double> defaultDailyRate,
  Value<double> defaultHalfDayRate,
});

final class $$StaffCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $StaffCategoriesTable, StaffCategory> {
  $$StaffCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StaffTable, List<StaffData>> _staffRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.staff,
          aliasName:
              $_aliasNameGenerator(db.staffCategories.id, db.staff.categoryId));

  $$StaffTableProcessedTableManager get staffRefs {
    final manager = $$StaffTableTableManager($_db, $_db.staff)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_staffRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StaffCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StaffCategoriesTable> {
  $$StaffCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultDailyRate => $composableBuilder(
      column: $table.defaultDailyRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultHalfDayRate => $composableBuilder(
      column: $table.defaultHalfDayRate,
      builder: (column) => ColumnFilters(column));

  Expression<bool> staffRefs(
      Expression<bool> Function($$StaffTableFilterComposer f) f) {
    final $$StaffTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableFilterComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StaffCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffCategoriesTable> {
  $$StaffCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultDailyRate => $composableBuilder(
      column: $table.defaultDailyRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultHalfDayRate => $composableBuilder(
      column: $table.defaultHalfDayRate,
      builder: (column) => ColumnOrderings(column));
}

class $$StaffCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffCategoriesTable> {
  $$StaffCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultDailyRate => $composableBuilder(
      column: $table.defaultDailyRate, builder: (column) => column);

  GeneratedColumn<double> get defaultHalfDayRate => $composableBuilder(
      column: $table.defaultHalfDayRate, builder: (column) => column);

  Expression<T> staffRefs<T extends Object>(
      Expression<T> Function($$StaffTableAnnotationComposer a) f) {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableAnnotationComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StaffCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaffCategoriesTable,
    StaffCategory,
    $$StaffCategoriesTableFilterComposer,
    $$StaffCategoriesTableOrderingComposer,
    $$StaffCategoriesTableAnnotationComposer,
    $$StaffCategoriesTableCreateCompanionBuilder,
    $$StaffCategoriesTableUpdateCompanionBuilder,
    (StaffCategory, $$StaffCategoriesTableReferences),
    StaffCategory,
    PrefetchHooks Function({bool staffRefs})> {
  $$StaffCategoriesTableTableManager(
      _$AppDatabase db, $StaffCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> defaultDailyRate = const Value.absent(),
            Value<double> defaultHalfDayRate = const Value.absent(),
          }) =>
              StaffCategoriesCompanion(
            id: id,
            name: name,
            defaultDailyRate: defaultDailyRate,
            defaultHalfDayRate: defaultHalfDayRate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<double> defaultDailyRate = const Value.absent(),
            Value<double> defaultHalfDayRate = const Value.absent(),
          }) =>
              StaffCategoriesCompanion.insert(
            id: id,
            name: name,
            defaultDailyRate: defaultDailyRate,
            defaultHalfDayRate: defaultHalfDayRate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StaffCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({staffRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (staffRefs) db.staff],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (staffRefs)
                    await $_getPrefetchedData<StaffCategory,
                            $StaffCategoriesTable, StaffData>(
                        currentTable: table,
                        referencedTable: $$StaffCategoriesTableReferences
                            ._staffRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StaffCategoriesTableReferences(db, table, p0)
                                .staffRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StaffCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaffCategoriesTable,
    StaffCategory,
    $$StaffCategoriesTableFilterComposer,
    $$StaffCategoriesTableOrderingComposer,
    $$StaffCategoriesTableAnnotationComposer,
    $$StaffCategoriesTableCreateCompanionBuilder,
    $$StaffCategoriesTableUpdateCompanionBuilder,
    (StaffCategory, $$StaffCategoriesTableReferences),
    StaffCategory,
    PrefetchHooks Function({bool staffRefs})>;
typedef $$StaffTableCreateCompanionBuilder = StaffCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<String> phone,
  Value<String> payType,
  Value<double> payRate,
  Value<double> halfDayRate,
  Value<double> monthlySalary,
  required DateTime joiningDate,
  Value<bool> isActive,
});
typedef $$StaffTableUpdateCompanionBuilder = StaffCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<String> phone,
  Value<String> payType,
  Value<double> payRate,
  Value<double> halfDayRate,
  Value<double> monthlySalary,
  Value<DateTime> joiningDate,
  Value<bool> isActive,
});

final class $$StaffTableReferences
    extends BaseReferences<_$AppDatabase, $StaffTable, StaffData> {
  $$StaffTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StaffCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.staffCategories.createAlias(
          $_aliasNameGenerator(db.staff.categoryId, db.staffCategories.id));

  $$StaffCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager =
        $$StaffCategoriesTableTableManager($_db, $_db.staffCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
      _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.attendance,
          aliasName: $_aliasNameGenerator(db.staff.id, db.attendance.staffId));

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager($_db, $_db.attendance)
        .filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalaryPaymentsTable, List<SalaryPayment>>
      _salaryPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.salaryPayments,
              aliasName:
                  $_aliasNameGenerator(db.staff.id, db.salaryPayments.staffId));

  $$SalaryPaymentsTableProcessedTableManager get salaryPaymentsRefs {
    final manager = $$SalaryPaymentsTableTableManager($_db, $_db.salaryPayments)
        .filter((f) => f.staffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salaryPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StaffTableFilterComposer extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payType => $composableBuilder(
      column: $table.payType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get payRate => $composableBuilder(
      column: $table.payRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get halfDayRate => $composableBuilder(
      column: $table.halfDayRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$StaffCategoriesTableFilterComposer get categoryId {
    final $$StaffCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.staffCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.staffCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> attendanceRefs(
      Expression<bool> Function($$AttendanceTableFilterComposer f) f) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableFilterComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salaryPaymentsRefs(
      Expression<bool> Function($$SalaryPaymentsTableFilterComposer f) f) {
    final $$SalaryPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.salaryPayments,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalaryPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.salaryPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StaffTableOrderingComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payType => $composableBuilder(
      column: $table.payType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get payRate => $composableBuilder(
      column: $table.payRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get halfDayRate => $composableBuilder(
      column: $table.halfDayRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$StaffCategoriesTableOrderingComposer get categoryId {
    final $$StaffCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.staffCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.staffCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StaffTableAnnotationComposer
    extends Composer<_$AppDatabase, $StaffTable> {
  $$StaffTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get payType =>
      $composableBuilder(column: $table.payType, builder: (column) => column);

  GeneratedColumn<double> get payRate =>
      $composableBuilder(column: $table.payRate, builder: (column) => column);

  GeneratedColumn<double> get halfDayRate => $composableBuilder(
      column: $table.halfDayRate, builder: (column) => column);

  GeneratedColumn<double> get monthlySalary => $composableBuilder(
      column: $table.monthlySalary, builder: (column) => column);

  GeneratedColumn<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$StaffCategoriesTableAnnotationComposer get categoryId {
    final $$StaffCategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.staffCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffCategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.staffCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> attendanceRefs<T extends Object>(
      Expression<T> Function($$AttendanceTableAnnotationComposer a) f) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendance,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceTableAnnotationComposer(
              $db: $db,
              $table: $db.attendance,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> salaryPaymentsRefs<T extends Object>(
      Expression<T> Function($$SalaryPaymentsTableAnnotationComposer a) f) {
    final $$SalaryPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.salaryPayments,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalaryPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.salaryPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StaffTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StaffTable,
    StaffData,
    $$StaffTableFilterComposer,
    $$StaffTableOrderingComposer,
    $$StaffTableAnnotationComposer,
    $$StaffTableCreateCompanionBuilder,
    $$StaffTableUpdateCompanionBuilder,
    (StaffData, $$StaffTableReferences),
    StaffData,
    PrefetchHooks Function(
        {bool categoryId, bool attendanceRefs, bool salaryPaymentsRefs})> {
  $$StaffTableTableManager(_$AppDatabase db, $StaffTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StaffTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StaffTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StaffTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> payType = const Value.absent(),
            Value<double> payRate = const Value.absent(),
            Value<double> halfDayRate = const Value.absent(),
            Value<double> monthlySalary = const Value.absent(),
            Value<DateTime> joiningDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              StaffCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            phone: phone,
            payType: payType,
            payRate: payRate,
            halfDayRate: halfDayRate,
            monthlySalary: monthlySalary,
            joiningDate: joiningDate,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<String> phone = const Value.absent(),
            Value<String> payType = const Value.absent(),
            Value<double> payRate = const Value.absent(),
            Value<double> halfDayRate = const Value.absent(),
            Value<double> monthlySalary = const Value.absent(),
            required DateTime joiningDate,
            Value<bool> isActive = const Value.absent(),
          }) =>
              StaffCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            phone: phone,
            payType: payType,
            payRate: payRate,
            halfDayRate: halfDayRate,
            monthlySalary: monthlySalary,
            joiningDate: joiningDate,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$StaffTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              attendanceRefs = false,
              salaryPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attendanceRefs) db.attendance,
                if (salaryPaymentsRefs) db.salaryPayments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$StaffTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$StaffTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceRefs)
                    await $_getPrefetchedData<StaffData, $StaffTable,
                            AttendanceData>(
                        currentTable: table,
                        referencedTable:
                            $$StaffTableReferences._attendanceRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StaffTableReferences(db, table, p0)
                                .attendanceRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.staffId == item.id),
                        typedResults: items),
                  if (salaryPaymentsRefs)
                    await $_getPrefetchedData<StaffData, $StaffTable,
                            SalaryPayment>(
                        currentTable: table,
                        referencedTable:
                            $$StaffTableReferences._salaryPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StaffTableReferences(db, table, p0)
                                .salaryPaymentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.staffId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StaffTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StaffTable,
    StaffData,
    $$StaffTableFilterComposer,
    $$StaffTableOrderingComposer,
    $$StaffTableAnnotationComposer,
    $$StaffTableCreateCompanionBuilder,
    $$StaffTableUpdateCompanionBuilder,
    (StaffData, $$StaffTableReferences),
    StaffData,
    PrefetchHooks Function(
        {bool categoryId, bool attendanceRefs, bool salaryPaymentsRefs})>;
typedef $$AttendanceTableCreateCompanionBuilder = AttendanceCompanion Function({
  Value<int> id,
  required int staffId,
  required DateTime date,
  Value<String> status,
  Value<String> notes,
});
typedef $$AttendanceTableUpdateCompanionBuilder = AttendanceCompanion Function({
  Value<int> id,
  Value<int> staffId,
  Value<DateTime> date,
  Value<String> status,
  Value<String> notes,
});

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceData> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StaffTable _staffIdTable(_$AppDatabase db) => db.staff
      .createAlias($_aliasNameGenerator(db.attendance.staffId, db.staff.id));

  $$StaffTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$StaffTableTableManager($_db, $_db.staff)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$StaffTableFilterComposer get staffId {
    final $$StaffTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableFilterComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$StaffTableOrderingComposer get staffId {
    final $$StaffTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableOrderingComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$StaffTableAnnotationComposer get staffId {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableAnnotationComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceTable,
    AttendanceData,
    $$AttendanceTableFilterComposer,
    $$AttendanceTableOrderingComposer,
    $$AttendanceTableAnnotationComposer,
    $$AttendanceTableCreateCompanionBuilder,
    $$AttendanceTableUpdateCompanionBuilder,
    (AttendanceData, $$AttendanceTableReferences),
    AttendanceData,
    PrefetchHooks Function({bool staffId})> {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> staffId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              AttendanceCompanion(
            id: id,
            staffId: staffId,
            date: date,
            status: status,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int staffId,
            required DateTime date,
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              AttendanceCompanion.insert(
            id: id,
            staffId: staffId,
            date: date,
            status: status,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttendanceTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$AttendanceTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$AttendanceTableReferences._staffIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttendanceTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendanceTable,
    AttendanceData,
    $$AttendanceTableFilterComposer,
    $$AttendanceTableOrderingComposer,
    $$AttendanceTableAnnotationComposer,
    $$AttendanceTableCreateCompanionBuilder,
    $$AttendanceTableUpdateCompanionBuilder,
    (AttendanceData, $$AttendanceTableReferences),
    AttendanceData,
    PrefetchHooks Function({bool staffId})>;
typedef $$SalaryPaymentsTableCreateCompanionBuilder = SalaryPaymentsCompanion
    Function({
  Value<int> id,
  required int staffId,
  required int month,
  required int year,
  Value<int> presentCount,
  Value<int> halfDayCount,
  Value<int> absentCount,
  Value<int> holidayCount,
  Value<double> baseSalary,
  Value<double> calculatedSalary,
  Value<double> bonus,
  Value<double> deductions,
  Value<double> paidAmount,
  required DateTime paidAt,
  Value<String> notes,
  Value<bool> holidaysUnpaid,
});
typedef $$SalaryPaymentsTableUpdateCompanionBuilder = SalaryPaymentsCompanion
    Function({
  Value<int> id,
  Value<int> staffId,
  Value<int> month,
  Value<int> year,
  Value<int> presentCount,
  Value<int> halfDayCount,
  Value<int> absentCount,
  Value<int> holidayCount,
  Value<double> baseSalary,
  Value<double> calculatedSalary,
  Value<double> bonus,
  Value<double> deductions,
  Value<double> paidAmount,
  Value<DateTime> paidAt,
  Value<String> notes,
  Value<bool> holidaysUnpaid,
});

final class $$SalaryPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $SalaryPaymentsTable, SalaryPayment> {
  $$SalaryPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StaffTable _staffIdTable(_$AppDatabase db) => db.staff.createAlias(
      $_aliasNameGenerator(db.salaryPayments.staffId, db.staff.id));

  $$StaffTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<int>('staff_id')!;

    final manager = $$StaffTableTableManager($_db, $_db.staff)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SalaryPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $SalaryPaymentsTable> {
  $$SalaryPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get presentCount => $composableBuilder(
      column: $table.presentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get halfDayCount => $composableBuilder(
      column: $table.halfDayCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get absentCount => $composableBuilder(
      column: $table.absentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holidayCount => $composableBuilder(
      column: $table.holidayCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get calculatedSalary => $composableBuilder(
      column: $table.calculatedSalary,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get holidaysUnpaid => $composableBuilder(
      column: $table.holidaysUnpaid,
      builder: (column) => ColumnFilters(column));

  $$StaffTableFilterComposer get staffId {
    final $$StaffTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableFilterComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalaryPaymentsTable> {
  $$SalaryPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get presentCount => $composableBuilder(
      column: $table.presentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get halfDayCount => $composableBuilder(
      column: $table.halfDayCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get absentCount => $composableBuilder(
      column: $table.absentCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holidayCount => $composableBuilder(
      column: $table.holidayCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get calculatedSalary => $composableBuilder(
      column: $table.calculatedSalary,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get holidaysUnpaid => $composableBuilder(
      column: $table.holidaysUnpaid,
      builder: (column) => ColumnOrderings(column));

  $$StaffTableOrderingComposer get staffId {
    final $$StaffTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableOrderingComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalaryPaymentsTable> {
  $$SalaryPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get presentCount => $composableBuilder(
      column: $table.presentCount, builder: (column) => column);

  GeneratedColumn<int> get halfDayCount => $composableBuilder(
      column: $table.halfDayCount, builder: (column) => column);

  GeneratedColumn<int> get absentCount => $composableBuilder(
      column: $table.absentCount, builder: (column) => column);

  GeneratedColumn<int> get holidayCount => $composableBuilder(
      column: $table.holidayCount, builder: (column) => column);

  GeneratedColumn<double> get baseSalary => $composableBuilder(
      column: $table.baseSalary, builder: (column) => column);

  GeneratedColumn<double> get calculatedSalary => $composableBuilder(
      column: $table.calculatedSalary, builder: (column) => column);

  GeneratedColumn<double> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get holidaysUnpaid => $composableBuilder(
      column: $table.holidaysUnpaid, builder: (column) => column);

  $$StaffTableAnnotationComposer get staffId {
    final $$StaffTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.staff,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StaffTableAnnotationComposer(
              $db: $db,
              $table: $db.staff,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalaryPaymentsTable,
    SalaryPayment,
    $$SalaryPaymentsTableFilterComposer,
    $$SalaryPaymentsTableOrderingComposer,
    $$SalaryPaymentsTableAnnotationComposer,
    $$SalaryPaymentsTableCreateCompanionBuilder,
    $$SalaryPaymentsTableUpdateCompanionBuilder,
    (SalaryPayment, $$SalaryPaymentsTableReferences),
    SalaryPayment,
    PrefetchHooks Function({bool staffId})> {
  $$SalaryPaymentsTableTableManager(
      _$AppDatabase db, $SalaryPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> staffId = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> presentCount = const Value.absent(),
            Value<int> halfDayCount = const Value.absent(),
            Value<int> absentCount = const Value.absent(),
            Value<int> holidayCount = const Value.absent(),
            Value<double> baseSalary = const Value.absent(),
            Value<double> calculatedSalary = const Value.absent(),
            Value<double> bonus = const Value.absent(),
            Value<double> deductions = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<bool> holidaysUnpaid = const Value.absent(),
          }) =>
              SalaryPaymentsCompanion(
            id: id,
            staffId: staffId,
            month: month,
            year: year,
            presentCount: presentCount,
            halfDayCount: halfDayCount,
            absentCount: absentCount,
            holidayCount: holidayCount,
            baseSalary: baseSalary,
            calculatedSalary: calculatedSalary,
            bonus: bonus,
            deductions: deductions,
            paidAmount: paidAmount,
            paidAt: paidAt,
            notes: notes,
            holidaysUnpaid: holidaysUnpaid,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int staffId,
            required int month,
            required int year,
            Value<int> presentCount = const Value.absent(),
            Value<int> halfDayCount = const Value.absent(),
            Value<int> absentCount = const Value.absent(),
            Value<int> holidayCount = const Value.absent(),
            Value<double> baseSalary = const Value.absent(),
            Value<double> calculatedSalary = const Value.absent(),
            Value<double> bonus = const Value.absent(),
            Value<double> deductions = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            required DateTime paidAt,
            Value<String> notes = const Value.absent(),
            Value<bool> holidaysUnpaid = const Value.absent(),
          }) =>
              SalaryPaymentsCompanion.insert(
            id: id,
            staffId: staffId,
            month: month,
            year: year,
            presentCount: presentCount,
            halfDayCount: halfDayCount,
            absentCount: absentCount,
            holidayCount: holidayCount,
            baseSalary: baseSalary,
            calculatedSalary: calculatedSalary,
            bonus: bonus,
            deductions: deductions,
            paidAmount: paidAmount,
            paidAt: paidAt,
            notes: notes,
            holidaysUnpaid: holidaysUnpaid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SalaryPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$SalaryPaymentsTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$SalaryPaymentsTableReferences._staffIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SalaryPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalaryPaymentsTable,
    SalaryPayment,
    $$SalaryPaymentsTableFilterComposer,
    $$SalaryPaymentsTableOrderingComposer,
    $$SalaryPaymentsTableAnnotationComposer,
    $$SalaryPaymentsTableCreateCompanionBuilder,
    $$SalaryPaymentsTableUpdateCompanionBuilder,
    (SalaryPayment, $$SalaryPaymentsTableReferences),
    SalaryPayment,
    PrefetchHooks Function({bool staffId})>;
typedef $$RawItemsTableCreateCompanionBuilder = RawItemsCompanion Function({
  Value<int> id,
  required String name,
  required String unit,
  Value<double> minStockAlert,
  Value<int> expiryAlertDays,
  Value<String> category,
  Value<DateTime> createdAt,
});
typedef $$RawItemsTableUpdateCompanionBuilder = RawItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> unit,
  Value<double> minStockAlert,
  Value<int> expiryAlertDays,
  Value<String> category,
  Value<DateTime> createdAt,
});

final class $$RawItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RawItemsTable, RawItem> {
  $$RawItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockBatchesTable, List<StockBatche>>
      _stockBatchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.stockBatches,
          aliasName:
              $_aliasNameGenerator(db.rawItems.id, db.stockBatches.rawItemId));

  $$StockBatchesTableProcessedTableManager get stockBatchesRefs {
    final manager = $$StockBatchesTableTableManager($_db, $_db.stockBatches)
        .filter((f) => f.rawItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockBatchesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
      _recipeItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.recipeItems,
          aliasName:
              $_aliasNameGenerator(db.rawItems.id, db.recipeItems.rawItemId));

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager($_db, $_db.recipeItems)
        .filter((f) => f.rawItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StockWastageTable, List<StockWastageData>>
      _stockWastageRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.stockWastage,
          aliasName:
              $_aliasNameGenerator(db.rawItems.id, db.stockWastage.rawItemId));

  $$StockWastageTableProcessedTableManager get stockWastageRefs {
    final manager = $$StockWastageTableTableManager($_db, $_db.stockWastage)
        .filter((f) => f.rawItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockWastageRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RawItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RawItemsTable> {
  $$RawItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiryAlertDays => $composableBuilder(
      column: $table.expiryAlertDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> stockBatchesRefs(
      Expression<bool> Function($$StockBatchesTableFilterComposer f) f) {
    final $$StockBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockBatches,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockBatchesTableFilterComposer(
              $db: $db,
              $table: $db.stockBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recipeItemsRefs(
      Expression<bool> Function($$RecipeItemsTableFilterComposer f) f) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeItems,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeItemsTableFilterComposer(
              $db: $db,
              $table: $db.recipeItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stockWastageRefs(
      Expression<bool> Function($$StockWastageTableFilterComposer f) f) {
    final $$StockWastageTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockWastage,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockWastageTableFilterComposer(
              $db: $db,
              $table: $db.stockWastage,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RawItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RawItemsTable> {
  $$RawItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiryAlertDays => $composableBuilder(
      column: $table.expiryAlertDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RawItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawItemsTable> {
  $$RawItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => column);

  GeneratedColumn<int> get expiryAlertDays => $composableBuilder(
      column: $table.expiryAlertDays, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> stockBatchesRefs<T extends Object>(
      Expression<T> Function($$StockBatchesTableAnnotationComposer a) f) {
    final $$StockBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockBatches,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.stockBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> recipeItemsRefs<T extends Object>(
      Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeItems,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stockWastageRefs<T extends Object>(
      Expression<T> Function($$StockWastageTableAnnotationComposer a) f) {
    final $$StockWastageTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockWastage,
        getReferencedColumn: (t) => t.rawItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockWastageTableAnnotationComposer(
              $db: $db,
              $table: $db.stockWastage,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RawItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RawItemsTable,
    RawItem,
    $$RawItemsTableFilterComposer,
    $$RawItemsTableOrderingComposer,
    $$RawItemsTableAnnotationComposer,
    $$RawItemsTableCreateCompanionBuilder,
    $$RawItemsTableUpdateCompanionBuilder,
    (RawItem, $$RawItemsTableReferences),
    RawItem,
    PrefetchHooks Function(
        {bool stockBatchesRefs, bool recipeItemsRefs, bool stockWastageRefs})> {
  $$RawItemsTableTableManager(_$AppDatabase db, $RawItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> minStockAlert = const Value.absent(),
            Value<int> expiryAlertDays = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RawItemsCompanion(
            id: id,
            name: name,
            unit: unit,
            minStockAlert: minStockAlert,
            expiryAlertDays: expiryAlertDays,
            category: category,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String unit,
            Value<double> minStockAlert = const Value.absent(),
            Value<int> expiryAlertDays = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RawItemsCompanion.insert(
            id: id,
            name: name,
            unit: unit,
            minStockAlert: minStockAlert,
            expiryAlertDays: expiryAlertDays,
            category: category,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RawItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {stockBatchesRefs = false,
              recipeItemsRefs = false,
              stockWastageRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (stockBatchesRefs) db.stockBatches,
                if (recipeItemsRefs) db.recipeItems,
                if (stockWastageRefs) db.stockWastage
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stockBatchesRefs)
                    await $_getPrefetchedData<RawItem, $RawItemsTable,
                            StockBatche>(
                        currentTable: table,
                        referencedTable: $$RawItemsTableReferences
                            ._stockBatchesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RawItemsTableReferences(db, table, p0)
                                .stockBatchesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.rawItemId == item.id),
                        typedResults: items),
                  if (recipeItemsRefs)
                    await $_getPrefetchedData<RawItem, $RawItemsTable,
                            RecipeItem>(
                        currentTable: table,
                        referencedTable:
                            $$RawItemsTableReferences._recipeItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RawItemsTableReferences(db, table, p0)
                                .recipeItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.rawItemId == item.id),
                        typedResults: items),
                  if (stockWastageRefs)
                    await $_getPrefetchedData<RawItem, $RawItemsTable,
                            StockWastageData>(
                        currentTable: table,
                        referencedTable: $$RawItemsTableReferences
                            ._stockWastageRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RawItemsTableReferences(db, table, p0)
                                .stockWastageRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.rawItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RawItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RawItemsTable,
    RawItem,
    $$RawItemsTableFilterComposer,
    $$RawItemsTableOrderingComposer,
    $$RawItemsTableAnnotationComposer,
    $$RawItemsTableCreateCompanionBuilder,
    $$RawItemsTableUpdateCompanionBuilder,
    (RawItem, $$RawItemsTableReferences),
    RawItem,
    PrefetchHooks Function(
        {bool stockBatchesRefs, bool recipeItemsRefs, bool stockWastageRefs})>;
typedef $$StockBatchesTableCreateCompanionBuilder = StockBatchesCompanion
    Function({
  Value<int> id,
  required int rawItemId,
  required double initialQty,
  required double remainingQty,
  required double costPerUnit,
  required double totalBatchCost,
  required DateTime purchaseDate,
  Value<DateTime?> expiryDate,
  Value<String> batchCode,
  Value<String> supplier,
  Value<String> notes,
});
typedef $$StockBatchesTableUpdateCompanionBuilder = StockBatchesCompanion
    Function({
  Value<int> id,
  Value<int> rawItemId,
  Value<double> initialQty,
  Value<double> remainingQty,
  Value<double> costPerUnit,
  Value<double> totalBatchCost,
  Value<DateTime> purchaseDate,
  Value<DateTime?> expiryDate,
  Value<String> batchCode,
  Value<String> supplier,
  Value<String> notes,
});

final class $$StockBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $StockBatchesTable, StockBatche> {
  $$StockBatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RawItemsTable _rawItemIdTable(_$AppDatabase db) =>
      db.rawItems.createAlias(
          $_aliasNameGenerator(db.stockBatches.rawItemId, db.rawItems.id));

  $$RawItemsTableProcessedTableManager get rawItemId {
    final $_column = $_itemColumn<int>('raw_item_id')!;

    final manager = $$RawItemsTableTableManager($_db, $_db.rawItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rawItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialQty => $composableBuilder(
      column: $table.initialQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingQty => $composableBuilder(
      column: $table.remainingQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalBatchCost => $composableBuilder(
      column: $table.totalBatchCost,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchCode => $composableBuilder(
      column: $table.batchCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$RawItemsTableFilterComposer get rawItemId {
    final $$RawItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableFilterComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialQty => $composableBuilder(
      column: $table.initialQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingQty => $composableBuilder(
      column: $table.remainingQty,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalBatchCost => $composableBuilder(
      column: $table.totalBatchCost,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchCode => $composableBuilder(
      column: $table.batchCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplier => $composableBuilder(
      column: $table.supplier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$RawItemsTableOrderingComposer get rawItemId {
    final $$RawItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableOrderingComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get initialQty => $composableBuilder(
      column: $table.initialQty, builder: (column) => column);

  GeneratedColumn<double> get remainingQty => $composableBuilder(
      column: $table.remainingQty, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => column);

  GeneratedColumn<double> get totalBatchCost => $composableBuilder(
      column: $table.totalBatchCost, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get batchCode =>
      $composableBuilder(column: $table.batchCode, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$RawItemsTableAnnotationComposer get rawItemId {
    final $$RawItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockBatchesTable,
    StockBatche,
    $$StockBatchesTableFilterComposer,
    $$StockBatchesTableOrderingComposer,
    $$StockBatchesTableAnnotationComposer,
    $$StockBatchesTableCreateCompanionBuilder,
    $$StockBatchesTableUpdateCompanionBuilder,
    (StockBatche, $$StockBatchesTableReferences),
    StockBatche,
    PrefetchHooks Function({bool rawItemId})> {
  $$StockBatchesTableTableManager(_$AppDatabase db, $StockBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> rawItemId = const Value.absent(),
            Value<double> initialQty = const Value.absent(),
            Value<double> remainingQty = const Value.absent(),
            Value<double> costPerUnit = const Value.absent(),
            Value<double> totalBatchCost = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String> batchCode = const Value.absent(),
            Value<String> supplier = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              StockBatchesCompanion(
            id: id,
            rawItemId: rawItemId,
            initialQty: initialQty,
            remainingQty: remainingQty,
            costPerUnit: costPerUnit,
            totalBatchCost: totalBatchCost,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            batchCode: batchCode,
            supplier: supplier,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int rawItemId,
            required double initialQty,
            required double remainingQty,
            required double costPerUnit,
            required double totalBatchCost,
            required DateTime purchaseDate,
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String> batchCode = const Value.absent(),
            Value<String> supplier = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              StockBatchesCompanion.insert(
            id: id,
            rawItemId: rawItemId,
            initialQty: initialQty,
            remainingQty: remainingQty,
            costPerUnit: costPerUnit,
            totalBatchCost: totalBatchCost,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            batchCode: batchCode,
            supplier: supplier,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockBatchesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({rawItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (rawItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rawItemId,
                    referencedTable:
                        $$StockBatchesTableReferences._rawItemIdTable(db),
                    referencedColumn:
                        $$StockBatchesTableReferences._rawItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockBatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockBatchesTable,
    StockBatche,
    $$StockBatchesTableFilterComposer,
    $$StockBatchesTableOrderingComposer,
    $$StockBatchesTableAnnotationComposer,
    $$StockBatchesTableCreateCompanionBuilder,
    $$StockBatchesTableUpdateCompanionBuilder,
    (StockBatche, $$StockBatchesTableReferences),
    StockBatche,
    PrefetchHooks Function({bool rawItemId})>;
typedef $$RecipeItemsTableCreateCompanionBuilder = RecipeItemsCompanion
    Function({
  Value<int> id,
  required int menuItemId,
  Value<String> variantName,
  required int rawItemId,
  required double quantityRequired,
  Value<String> unit,
});
typedef $$RecipeItemsTableUpdateCompanionBuilder = RecipeItemsCompanion
    Function({
  Value<int> id,
  Value<int> menuItemId,
  Value<String> variantName,
  Value<int> rawItemId,
  Value<double> quantityRequired,
  Value<String> unit,
});

final class $$RecipeItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem> {
  $$RecipeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MenuItemsTable _menuItemIdTable(_$AppDatabase db) =>
      db.menuItems.createAlias(
          $_aliasNameGenerator(db.recipeItems.menuItemId, db.menuItems.id));

  $$MenuItemsTableProcessedTableManager get menuItemId {
    final $_column = $_itemColumn<int>('menu_item_id')!;

    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RawItemsTable _rawItemIdTable(_$AppDatabase db) =>
      db.rawItems.createAlias(
          $_aliasNameGenerator(db.recipeItems.rawItemId, db.rawItems.id));

  $$RawItemsTableProcessedTableManager get rawItemId {
    final $_column = $_itemColumn<int>('raw_item_id')!;

    final manager = $$RawItemsTableTableManager($_db, $_db.rawItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rawItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecipeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  $$MenuItemsTableFilterComposer get menuItemId {
    final $$MenuItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableFilterComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RawItemsTableFilterComposer get rawItemId {
    final $$RawItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableFilterComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  $$MenuItemsTableOrderingComposer get menuItemId {
    final $$MenuItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableOrderingComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RawItemsTableOrderingComposer get rawItemId {
    final $$RawItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableOrderingComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => column);

  GeneratedColumn<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$MenuItemsTableAnnotationComposer get menuItemId {
    final $$MenuItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RawItemsTableAnnotationComposer get rawItemId {
    final $$RawItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeItemsTable,
    RecipeItem,
    $$RecipeItemsTableFilterComposer,
    $$RecipeItemsTableOrderingComposer,
    $$RecipeItemsTableAnnotationComposer,
    $$RecipeItemsTableCreateCompanionBuilder,
    $$RecipeItemsTableUpdateCompanionBuilder,
    (RecipeItem, $$RecipeItemsTableReferences),
    RecipeItem,
    PrefetchHooks Function({bool menuItemId, bool rawItemId})> {
  $$RecipeItemsTableTableManager(_$AppDatabase db, $RecipeItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> menuItemId = const Value.absent(),
            Value<String> variantName = const Value.absent(),
            Value<int> rawItemId = const Value.absent(),
            Value<double> quantityRequired = const Value.absent(),
            Value<String> unit = const Value.absent(),
          }) =>
              RecipeItemsCompanion(
            id: id,
            menuItemId: menuItemId,
            variantName: variantName,
            rawItemId: rawItemId,
            quantityRequired: quantityRequired,
            unit: unit,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int menuItemId,
            Value<String> variantName = const Value.absent(),
            required int rawItemId,
            required double quantityRequired,
            Value<String> unit = const Value.absent(),
          }) =>
              RecipeItemsCompanion.insert(
            id: id,
            menuItemId: menuItemId,
            variantName: variantName,
            rawItemId: rawItemId,
            quantityRequired: quantityRequired,
            unit: unit,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipeItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({menuItemId = false, rawItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (menuItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.menuItemId,
                    referencedTable:
                        $$RecipeItemsTableReferences._menuItemIdTable(db),
                    referencedColumn:
                        $$RecipeItemsTableReferences._menuItemIdTable(db).id,
                  ) as T;
                }
                if (rawItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rawItemId,
                    referencedTable:
                        $$RecipeItemsTableReferences._rawItemIdTable(db),
                    referencedColumn:
                        $$RecipeItemsTableReferences._rawItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecipeItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeItemsTable,
    RecipeItem,
    $$RecipeItemsTableFilterComposer,
    $$RecipeItemsTableOrderingComposer,
    $$RecipeItemsTableAnnotationComposer,
    $$RecipeItemsTableCreateCompanionBuilder,
    $$RecipeItemsTableUpdateCompanionBuilder,
    (RecipeItem, $$RecipeItemsTableReferences),
    RecipeItem,
    PrefetchHooks Function({bool menuItemId, bool rawItemId})>;
typedef $$ItemSopsTableCreateCompanionBuilder = ItemSopsCompanion Function({
  Value<int> id,
  required int menuItemId,
  Value<String> variantName,
  Value<String> title,
  Value<int> prepTimeMins,
  Value<String> instructionsJson,
  Value<String> notes,
  Value<DateTime> updatedAt,
});
typedef $$ItemSopsTableUpdateCompanionBuilder = ItemSopsCompanion Function({
  Value<int> id,
  Value<int> menuItemId,
  Value<String> variantName,
  Value<String> title,
  Value<int> prepTimeMins,
  Value<String> instructionsJson,
  Value<String> notes,
  Value<DateTime> updatedAt,
});

final class $$ItemSopsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemSopsTable, ItemSop> {
  $$ItemSopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MenuItemsTable _menuItemIdTable(_$AppDatabase db) =>
      db.menuItems.createAlias(
          $_aliasNameGenerator(db.itemSops.menuItemId, db.menuItems.id));

  $$MenuItemsTableProcessedTableManager get menuItemId {
    final $_column = $_itemColumn<int>('menu_item_id')!;

    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ItemSopsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemSopsTable> {
  $$ItemSopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prepTimeMins => $composableBuilder(
      column: $table.prepTimeMins, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructionsJson => $composableBuilder(
      column: $table.instructionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$MenuItemsTableFilterComposer get menuItemId {
    final $$MenuItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableFilterComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSopsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemSopsTable> {
  $$ItemSopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prepTimeMins => $composableBuilder(
      column: $table.prepTimeMins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructionsJson => $composableBuilder(
      column: $table.instructionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$MenuItemsTableOrderingComposer get menuItemId {
    final $$MenuItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableOrderingComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemSopsTable> {
  $$ItemSopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get variantName => $composableBuilder(
      column: $table.variantName, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get prepTimeMins => $composableBuilder(
      column: $table.prepTimeMins, builder: (column) => column);

  GeneratedColumn<String> get instructionsJson => $composableBuilder(
      column: $table.instructionsJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MenuItemsTableAnnotationComposer get menuItemId {
    final $$MenuItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemSopsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemSopsTable,
    ItemSop,
    $$ItemSopsTableFilterComposer,
    $$ItemSopsTableOrderingComposer,
    $$ItemSopsTableAnnotationComposer,
    $$ItemSopsTableCreateCompanionBuilder,
    $$ItemSopsTableUpdateCompanionBuilder,
    (ItemSop, $$ItemSopsTableReferences),
    ItemSop,
    PrefetchHooks Function({bool menuItemId})> {
  $$ItemSopsTableTableManager(_$AppDatabase db, $ItemSopsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemSopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemSopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemSopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> menuItemId = const Value.absent(),
            Value<String> variantName = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> prepTimeMins = const Value.absent(),
            Value<String> instructionsJson = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ItemSopsCompanion(
            id: id,
            menuItemId: menuItemId,
            variantName: variantName,
            title: title,
            prepTimeMins: prepTimeMins,
            instructionsJson: instructionsJson,
            notes: notes,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int menuItemId,
            Value<String> variantName = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> prepTimeMins = const Value.absent(),
            Value<String> instructionsJson = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ItemSopsCompanion.insert(
            id: id,
            menuItemId: menuItemId,
            variantName: variantName,
            title: title,
            prepTimeMins: prepTimeMins,
            instructionsJson: instructionsJson,
            notes: notes,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ItemSopsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({menuItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (menuItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.menuItemId,
                    referencedTable:
                        $$ItemSopsTableReferences._menuItemIdTable(db),
                    referencedColumn:
                        $$ItemSopsTableReferences._menuItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ItemSopsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemSopsTable,
    ItemSop,
    $$ItemSopsTableFilterComposer,
    $$ItemSopsTableOrderingComposer,
    $$ItemSopsTableAnnotationComposer,
    $$ItemSopsTableCreateCompanionBuilder,
    $$ItemSopsTableUpdateCompanionBuilder,
    (ItemSop, $$ItemSopsTableReferences),
    ItemSop,
    PrefetchHooks Function({bool menuItemId})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String title,
  Value<String> category,
  required double amount,
  required DateTime date,
  Value<String> paymentMethod,
  Value<String> notes,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> category,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> paymentMethod,
  Value<String> notes,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            title: title,
            category: category,
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String> category = const Value.absent(),
            required double amount,
            required DateTime date,
            Value<String> paymentMethod = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            title: title,
            category: category,
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$CustomCategoriesTableCreateCompanionBuilder
    = CustomCategoriesCompanion Function({
  Value<int> id,
  required String name,
  required String optionsJson,
  Value<DateTime> createdAt,
});
typedef $$CustomCategoriesTableUpdateCompanionBuilder
    = CustomCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> optionsJson,
  Value<DateTime> createdAt,
});

class $$CustomCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
      column: $table.optionsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()> {
  $$CustomCategoriesTableTableManager(
      _$AppDatabase db, $CustomCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> optionsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomCategoriesCompanion(
            id: id,
            name: name,
            optionsJson: optionsJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String optionsJson,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomCategoriesCompanion.insert(
            id: id,
            name: name,
            optionsJson: optionsJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()>;
typedef $$EditedBillsTableCreateCompanionBuilder = EditedBillsCompanion
    Function({
  Value<int> id,
  required int orderId,
  required int billNumber,
  required String tableLabel,
  required double originalTotal,
  required double newTotal,
  Value<String> editedBy,
  Value<DateTime> editedAt,
  Value<String> reason,
});
typedef $$EditedBillsTableUpdateCompanionBuilder = EditedBillsCompanion
    Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> billNumber,
  Value<String> tableLabel,
  Value<double> originalTotal,
  Value<double> newTotal,
  Value<String> editedBy,
  Value<DateTime> editedAt,
  Value<String> reason,
});

final class $$EditedBillsTableReferences
    extends BaseReferences<_$AppDatabase, $EditedBillsTable, EditedBill> {
  $$EditedBillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EditedBillItemsTable, List<EditedBillItem>>
      _editedBillItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.editedBillItems,
              aliasName: $_aliasNameGenerator(
                  db.editedBills.id, db.editedBillItems.editedBillId));

  $$EditedBillItemsTableProcessedTableManager get editedBillItemsRefs {
    final manager = $$EditedBillItemsTableTableManager(
            $_db, $_db.editedBillItems)
        .filter((f) => f.editedBillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_editedBillItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EditedBillsTableFilterComposer
    extends Composer<_$AppDatabase, $EditedBillsTable> {
  $$EditedBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originalTotal => $composableBuilder(
      column: $table.originalTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get newTotal => $composableBuilder(
      column: $table.newTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get editedBy => $composableBuilder(
      column: $table.editedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get editedAt => $composableBuilder(
      column: $table.editedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  Expression<bool> editedBillItemsRefs(
      Expression<bool> Function($$EditedBillItemsTableFilterComposer f) f) {
    final $$EditedBillItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.editedBillItems,
        getReferencedColumn: (t) => t.editedBillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EditedBillItemsTableFilterComposer(
              $db: $db,
              $table: $db.editedBillItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EditedBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $EditedBillsTable> {
  $$EditedBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originalTotal => $composableBuilder(
      column: $table.originalTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get newTotal => $composableBuilder(
      column: $table.newTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get editedBy => $composableBuilder(
      column: $table.editedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get editedAt => $composableBuilder(
      column: $table.editedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));
}

class $$EditedBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EditedBillsTable> {
  $$EditedBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => column);

  GeneratedColumn<String> get tableLabel => $composableBuilder(
      column: $table.tableLabel, builder: (column) => column);

  GeneratedColumn<double> get originalTotal => $composableBuilder(
      column: $table.originalTotal, builder: (column) => column);

  GeneratedColumn<double> get newTotal =>
      $composableBuilder(column: $table.newTotal, builder: (column) => column);

  GeneratedColumn<String> get editedBy =>
      $composableBuilder(column: $table.editedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get editedAt =>
      $composableBuilder(column: $table.editedAt, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  Expression<T> editedBillItemsRefs<T extends Object>(
      Expression<T> Function($$EditedBillItemsTableAnnotationComposer a) f) {
    final $$EditedBillItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.editedBillItems,
        getReferencedColumn: (t) => t.editedBillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EditedBillItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.editedBillItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EditedBillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EditedBillsTable,
    EditedBill,
    $$EditedBillsTableFilterComposer,
    $$EditedBillsTableOrderingComposer,
    $$EditedBillsTableAnnotationComposer,
    $$EditedBillsTableCreateCompanionBuilder,
    $$EditedBillsTableUpdateCompanionBuilder,
    (EditedBill, $$EditedBillsTableReferences),
    EditedBill,
    PrefetchHooks Function({bool editedBillItemsRefs})> {
  $$EditedBillsTableTableManager(_$AppDatabase db, $EditedBillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditedBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditedBillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditedBillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> billNumber = const Value.absent(),
            Value<String> tableLabel = const Value.absent(),
            Value<double> originalTotal = const Value.absent(),
            Value<double> newTotal = const Value.absent(),
            Value<String> editedBy = const Value.absent(),
            Value<DateTime> editedAt = const Value.absent(),
            Value<String> reason = const Value.absent(),
          }) =>
              EditedBillsCompanion(
            id: id,
            orderId: orderId,
            billNumber: billNumber,
            tableLabel: tableLabel,
            originalTotal: originalTotal,
            newTotal: newTotal,
            editedBy: editedBy,
            editedAt: editedAt,
            reason: reason,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int billNumber,
            required String tableLabel,
            required double originalTotal,
            required double newTotal,
            Value<String> editedBy = const Value.absent(),
            Value<DateTime> editedAt = const Value.absent(),
            Value<String> reason = const Value.absent(),
          }) =>
              EditedBillsCompanion.insert(
            id: id,
            orderId: orderId,
            billNumber: billNumber,
            tableLabel: tableLabel,
            originalTotal: originalTotal,
            newTotal: newTotal,
            editedBy: editedBy,
            editedAt: editedAt,
            reason: reason,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EditedBillsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({editedBillItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (editedBillItemsRefs) db.editedBillItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (editedBillItemsRefs)
                    await $_getPrefetchedData<EditedBill, $EditedBillsTable,
                            EditedBillItem>(
                        currentTable: table,
                        referencedTable: $$EditedBillsTableReferences
                            ._editedBillItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EditedBillsTableReferences(db, table, p0)
                                .editedBillItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.editedBillId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EditedBillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EditedBillsTable,
    EditedBill,
    $$EditedBillsTableFilterComposer,
    $$EditedBillsTableOrderingComposer,
    $$EditedBillsTableAnnotationComposer,
    $$EditedBillsTableCreateCompanionBuilder,
    $$EditedBillsTableUpdateCompanionBuilder,
    (EditedBill, $$EditedBillsTableReferences),
    EditedBill,
    PrefetchHooks Function({bool editedBillItemsRefs})>;
typedef $$EditedBillItemsTableCreateCompanionBuilder = EditedBillItemsCompanion
    Function({
  Value<int> id,
  required int editedBillId,
  required String itemName,
  required int oldQuantity,
  required int newQuantity,
  required double itemPrice,
});
typedef $$EditedBillItemsTableUpdateCompanionBuilder = EditedBillItemsCompanion
    Function({
  Value<int> id,
  Value<int> editedBillId,
  Value<String> itemName,
  Value<int> oldQuantity,
  Value<int> newQuantity,
  Value<double> itemPrice,
});

final class $$EditedBillItemsTableReferences extends BaseReferences<
    _$AppDatabase, $EditedBillItemsTable, EditedBillItem> {
  $$EditedBillItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EditedBillsTable _editedBillIdTable(_$AppDatabase db) =>
      db.editedBills.createAlias($_aliasNameGenerator(
          db.editedBillItems.editedBillId, db.editedBills.id));

  $$EditedBillsTableProcessedTableManager get editedBillId {
    final $_column = $_itemColumn<int>('edited_bill_id')!;

    final manager = $$EditedBillsTableTableManager($_db, $_db.editedBills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editedBillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EditedBillItemsTableFilterComposer
    extends Composer<_$AppDatabase, $EditedBillItemsTable> {
  $$EditedBillItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get oldQuantity => $composableBuilder(
      column: $table.oldQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newQuantity => $composableBuilder(
      column: $table.newQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get itemPrice => $composableBuilder(
      column: $table.itemPrice, builder: (column) => ColumnFilters(column));

  $$EditedBillsTableFilterComposer get editedBillId {
    final $$EditedBillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.editedBillId,
        referencedTable: $db.editedBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EditedBillsTableFilterComposer(
              $db: $db,
              $table: $db.editedBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EditedBillItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $EditedBillItemsTable> {
  $$EditedBillItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get oldQuantity => $composableBuilder(
      column: $table.oldQuantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newQuantity => $composableBuilder(
      column: $table.newQuantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get itemPrice => $composableBuilder(
      column: $table.itemPrice, builder: (column) => ColumnOrderings(column));

  $$EditedBillsTableOrderingComposer get editedBillId {
    final $$EditedBillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.editedBillId,
        referencedTable: $db.editedBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EditedBillsTableOrderingComposer(
              $db: $db,
              $table: $db.editedBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EditedBillItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EditedBillItemsTable> {
  $$EditedBillItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get oldQuantity => $composableBuilder(
      column: $table.oldQuantity, builder: (column) => column);

  GeneratedColumn<int> get newQuantity => $composableBuilder(
      column: $table.newQuantity, builder: (column) => column);

  GeneratedColumn<double> get itemPrice =>
      $composableBuilder(column: $table.itemPrice, builder: (column) => column);

  $$EditedBillsTableAnnotationComposer get editedBillId {
    final $$EditedBillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.editedBillId,
        referencedTable: $db.editedBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EditedBillsTableAnnotationComposer(
              $db: $db,
              $table: $db.editedBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EditedBillItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EditedBillItemsTable,
    EditedBillItem,
    $$EditedBillItemsTableFilterComposer,
    $$EditedBillItemsTableOrderingComposer,
    $$EditedBillItemsTableAnnotationComposer,
    $$EditedBillItemsTableCreateCompanionBuilder,
    $$EditedBillItemsTableUpdateCompanionBuilder,
    (EditedBillItem, $$EditedBillItemsTableReferences),
    EditedBillItem,
    PrefetchHooks Function({bool editedBillId})> {
  $$EditedBillItemsTableTableManager(
      _$AppDatabase db, $EditedBillItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditedBillItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditedBillItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditedBillItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> editedBillId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<int> oldQuantity = const Value.absent(),
            Value<int> newQuantity = const Value.absent(),
            Value<double> itemPrice = const Value.absent(),
          }) =>
              EditedBillItemsCompanion(
            id: id,
            editedBillId: editedBillId,
            itemName: itemName,
            oldQuantity: oldQuantity,
            newQuantity: newQuantity,
            itemPrice: itemPrice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int editedBillId,
            required String itemName,
            required int oldQuantity,
            required int newQuantity,
            required double itemPrice,
          }) =>
              EditedBillItemsCompanion.insert(
            id: id,
            editedBillId: editedBillId,
            itemName: itemName,
            oldQuantity: oldQuantity,
            newQuantity: newQuantity,
            itemPrice: itemPrice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EditedBillItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({editedBillId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (editedBillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.editedBillId,
                    referencedTable:
                        $$EditedBillItemsTableReferences._editedBillIdTable(db),
                    referencedColumn: $$EditedBillItemsTableReferences
                        ._editedBillIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EditedBillItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EditedBillItemsTable,
    EditedBillItem,
    $$EditedBillItemsTableFilterComposer,
    $$EditedBillItemsTableOrderingComposer,
    $$EditedBillItemsTableAnnotationComposer,
    $$EditedBillItemsTableCreateCompanionBuilder,
    $$EditedBillItemsTableUpdateCompanionBuilder,
    (EditedBillItem, $$EditedBillItemsTableReferences),
    EditedBillItem,
    PrefetchHooks Function({bool editedBillId})>;
typedef $$StockWastageTableCreateCompanionBuilder = StockWastageCompanion
    Function({
  Value<int> id,
  required int rawItemId,
  required double quantityWasted,
  required double wastageCost,
  Value<String> reason,
  Value<DateTime> date,
  Value<String> notes,
});
typedef $$StockWastageTableUpdateCompanionBuilder = StockWastageCompanion
    Function({
  Value<int> id,
  Value<int> rawItemId,
  Value<double> quantityWasted,
  Value<double> wastageCost,
  Value<String> reason,
  Value<DateTime> date,
  Value<String> notes,
});

final class $$StockWastageTableReferences extends BaseReferences<_$AppDatabase,
    $StockWastageTable, StockWastageData> {
  $$StockWastageTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RawItemsTable _rawItemIdTable(_$AppDatabase db) =>
      db.rawItems.createAlias(
          $_aliasNameGenerator(db.stockWastage.rawItemId, db.rawItems.id));

  $$RawItemsTableProcessedTableManager get rawItemId {
    final $_column = $_itemColumn<int>('raw_item_id')!;

    final manager = $$RawItemsTableTableManager($_db, $_db.rawItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rawItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockWastageTableFilterComposer
    extends Composer<_$AppDatabase, $StockWastageTable> {
  $$StockWastageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityWasted => $composableBuilder(
      column: $table.quantityWasted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get wastageCost => $composableBuilder(
      column: $table.wastageCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$RawItemsTableFilterComposer get rawItemId {
    final $$RawItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableFilterComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockWastageTableOrderingComposer
    extends Composer<_$AppDatabase, $StockWastageTable> {
  $$StockWastageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityWasted => $composableBuilder(
      column: $table.quantityWasted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get wastageCost => $composableBuilder(
      column: $table.wastageCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$RawItemsTableOrderingComposer get rawItemId {
    final $$RawItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableOrderingComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockWastageTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockWastageTable> {
  $$StockWastageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityWasted => $composableBuilder(
      column: $table.quantityWasted, builder: (column) => column);

  GeneratedColumn<double> get wastageCost => $composableBuilder(
      column: $table.wastageCost, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$RawItemsTableAnnotationComposer get rawItemId {
    final $$RawItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rawItemId,
        referencedTable: $db.rawItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RawItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.rawItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockWastageTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockWastageTable,
    StockWastageData,
    $$StockWastageTableFilterComposer,
    $$StockWastageTableOrderingComposer,
    $$StockWastageTableAnnotationComposer,
    $$StockWastageTableCreateCompanionBuilder,
    $$StockWastageTableUpdateCompanionBuilder,
    (StockWastageData, $$StockWastageTableReferences),
    StockWastageData,
    PrefetchHooks Function({bool rawItemId})> {
  $$StockWastageTableTableManager(_$AppDatabase db, $StockWastageTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockWastageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockWastageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockWastageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> rawItemId = const Value.absent(),
            Value<double> quantityWasted = const Value.absent(),
            Value<double> wastageCost = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              StockWastageCompanion(
            id: id,
            rawItemId: rawItemId,
            quantityWasted: quantityWasted,
            wastageCost: wastageCost,
            reason: reason,
            date: date,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int rawItemId,
            required double quantityWasted,
            required double wastageCost,
            Value<String> reason = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              StockWastageCompanion.insert(
            id: id,
            rawItemId: rawItemId,
            quantityWasted: quantityWasted,
            wastageCost: wastageCost,
            reason: reason,
            date: date,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockWastageTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({rawItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (rawItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rawItemId,
                    referencedTable:
                        $$StockWastageTableReferences._rawItemIdTable(db),
                    referencedColumn:
                        $$StockWastageTableReferences._rawItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockWastageTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockWastageTable,
    StockWastageData,
    $$StockWastageTableFilterComposer,
    $$StockWastageTableOrderingComposer,
    $$StockWastageTableAnnotationComposer,
    $$StockWastageTableCreateCompanionBuilder,
    $$StockWastageTableUpdateCompanionBuilder,
    (StockWastageData, $$StockWastageTableReferences),
    StockWastageData,
    PrefetchHooks Function({bool rawItemId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ZonesTableTableManager get zones =>
      $$ZonesTableTableManager(_db, _db.zones);
  $$RestaurantTablesTableTableManager get restaurantTables =>
      $$RestaurantTablesTableTableManager(_db, _db.restaurantTables);
  $$MenuCategoriesTableTableManager get menuCategories =>
      $$MenuCategoriesTableTableManager(_db, _db.menuCategories);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$KotRecordsTableTableManager get kotRecords =>
      $$KotRecordsTableTableManager(_db, _db.kotRecords);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$PrinterConfigsTableTableManager get printerConfigs =>
      $$PrinterConfigsTableTableManager(_db, _db.printerConfigs);
  $$QueueEntriesTableTableManager get queueEntries =>
      $$QueueEntriesTableTableManager(_db, _db.queueEntries);
  $$StaffCategoriesTableTableManager get staffCategories =>
      $$StaffCategoriesTableTableManager(_db, _db.staffCategories);
  $$StaffTableTableManager get staff =>
      $$StaffTableTableManager(_db, _db.staff);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
  $$SalaryPaymentsTableTableManager get salaryPayments =>
      $$SalaryPaymentsTableTableManager(_db, _db.salaryPayments);
  $$RawItemsTableTableManager get rawItems =>
      $$RawItemsTableTableManager(_db, _db.rawItems);
  $$StockBatchesTableTableManager get stockBatches =>
      $$StockBatchesTableTableManager(_db, _db.stockBatches);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$ItemSopsTableTableManager get itemSops =>
      $$ItemSopsTableTableManager(_db, _db.itemSops);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$CustomCategoriesTableTableManager get customCategories =>
      $$CustomCategoriesTableTableManager(_db, _db.customCategories);
  $$EditedBillsTableTableManager get editedBills =>
      $$EditedBillsTableTableManager(_db, _db.editedBills);
  $$EditedBillItemsTableTableManager get editedBillItems =>
      $$EditedBillItemsTableTableManager(_db, _db.editedBillItems);
  $$StockWastageTableTableManager get stockWastage =>
      $$StockWastageTableTableManager(_db, _db.stockWastage);
}
