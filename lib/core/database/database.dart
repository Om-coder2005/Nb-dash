import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'database.g.dart';

// ─────────────────────────────────────────────
// TABLE DEFINITIONS
// ─────────────────────────────────────────────

class Zones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFF3B82F6))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class RestaurantTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get zoneId => integer().references(Zones, #id)();
  TextColumn get tableNumber => text().withLength(min: 1, max: 10)();
  TextColumn get tableLabel => text().withLength(min: 1, max: 50)();
  IntColumn get capacity => integer().withDefault(const Constant(4))();
  RealColumn get posX => real().withDefault(const Constant(0.0))();
  RealColumn get posY => real().withDefault(const Constant(0.0))();
  TextColumn get shape => text().withDefault(const Constant('square'))(); // square, circle
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class MenuCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFFF59E0B))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class MenuItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(MenuCategories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  BoolColumn get isVeg => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get hasHalfFull => boolean().withDefault(const Constant(false))();
  RealColumn get halfPrice => real().withDefault(const Constant(0.0))();
  TextColumn get defaultSize => text().withDefault(const Constant('full'))();
  TextColumn get image => text().nullable()();
  TextColumn get customVariantsJson => text().withDefault(const Constant('[]'))(); // JSON list of { "name": "8mm", "price": 250 }
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tableId => integer().references(RestaurantTables, #id)();
  TextColumn get status => text().withDefault(const Constant('open'))(); // open, billed, cancelled
  TextColumn get waiterName => text().withDefault(const Constant(''))();
  TextColumn get customerName => text().withDefault(const Constant(''))();
  IntColumn get covers => integer().withDefault(const Constant(1))();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get menuItemId => integer().references(MenuItems, #id)();
  TextColumn get itemName => text()(); // snapshot
  RealColumn get itemPrice => real()(); // snapshot
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get kotSent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();
  TextColumn get itemSize => text().withDefault(const Constant('full'))();
  IntColumn get printedQuantity => integer().withDefault(const Constant(0))();
}

class KotRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get kotNumber => integer()();
  TextColumn get itemsJson => text()(); // JSON snapshot of items
  DateTimeColumn get printedAt => dateTime()();
  TextColumn get kitchenStatus => text().withDefault(const Constant('new'))(); // new, preparing, ready, completed
  DateTimeColumn get kitchenUpdatedAt => dateTime().nullable()();
}

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get tableId => integer()();
  TextColumn get tableLabel => text()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  RealColumn get amountReceived => real().withDefault(const Constant(0.0))();
  RealColumn get change => real().withDefault(const Constant(0.0))();
  RealColumn get splitCash => real().withDefault(const Constant(0.0))();
  RealColumn get splitOnline => real().withDefault(const Constant(0.0))();
  TextColumn get itemsJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get billNumber => integer().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}

class PrinterConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()(); // MAC or IP
  TextColumn get printerType => text().withDefault(const Constant('bluetooth'))(); // bluetooth, tcp
  IntColumn get paperWidth => integer().withDefault(const Constant(80))(); // 58 or 80
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isConnected => boolean().withDefault(const Constant(false))();
}

class QueueEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text().withLength(min: 1, max: 50)();
  TextColumn get customerPhone => text().nullable()();
  IntColumn get requiredSeats => integer().withDefault(const Constant(2))();
  IntColumn get waitingNumber => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('waiting'))(); // waiting, seated, cancelled
}

class StaffCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get defaultDailyRate => real().withDefault(const Constant(0.0))();
  RealColumn get defaultHalfDayRate => real().withDefault(const Constant(0.0))();
}

class Staff extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(StaffCategories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get payType => text().withDefault(const Constant('daily'))(); // daily, monthly
  RealColumn get payRate => real().withDefault(const Constant(0.0))(); // daily rate override
  RealColumn get halfDayRate => real().withDefault(const Constant(0.0))(); // half day rate override
  RealColumn get monthlySalary => real().withDefault(const Constant(0.0))(); // monthly salary
  DateTimeColumn get joiningDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Attendance extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffId => integer().references(Staff, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('present'))(); // present, half_day, absent, holiday
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class SalaryPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get staffId => integer().references(Staff, #id)();
  IntColumn get month => integer()(); // 1-12
  IntColumn get year => integer()();
  IntColumn get presentCount => integer().withDefault(const Constant(0))();
  IntColumn get halfDayCount => integer().withDefault(const Constant(0))();
  IntColumn get absentCount => integer().withDefault(const Constant(0))();
  IntColumn get holidayCount => integer().withDefault(const Constant(0))();
  RealColumn get baseSalary => real().withDefault(const Constant(0.0))();
  RealColumn get calculatedSalary => real().withDefault(const Constant(0.0))();
  RealColumn get bonus => real().withDefault(const Constant(0.0))();
  RealColumn get deductions => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get holidaysUnpaid => boolean().withDefault(const Constant(false))();
}

// ─────────────────────────────────────────────
// NEW TABLES FOR INVENTORY, RECIPES, SOPS, EXPENSES & CUSTOM CATEGORIES
// ─────────────────────────────────────────────

class RawItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get unit => text().withLength(min: 1, max: 20)(); // kg, g, l, ml, pcs, pack, etc.
  RealColumn get minStockAlert => real().withDefault(const Constant(0.0))();
  IntColumn get expiryAlertDays => integer().withDefault(const Constant(7))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class StockBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rawItemId => integer().references(RawItems, #id)();
  RealColumn get initialQty => real()();
  RealColumn get remainingQty => real()();
  RealColumn get costPerUnit => real()(); // cost per unit of measure
  RealColumn get totalBatchCost => real()(); // purchase cost for this batch
  DateTimeColumn get purchaseDate => dateTime()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get batchCode => text().withDefault(const Constant(''))();
  TextColumn get supplier => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class RecipeItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get menuItemId => integer().references(MenuItems, #id)();
  TextColumn get variantName => text().withDefault(const Constant(''))(); // empty for default/full, or custom category option name
  IntColumn get rawItemId => integer().references(RawItems, #id)();
  RealColumn get quantityRequired => real()(); // quantity of rawItem consumed per menu item
  TextColumn get unit => text().withDefault(const Constant(''))();
}

class ItemSops extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get menuItemId => integer().references(MenuItems, #id)();
  TextColumn get variantName => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant('SOP'))();
  IntColumn get prepTimeMins => integer().withDefault(const Constant(0))();
  TextColumn get instructionsJson => text().withDefault(const Constant('[]'))(); // steps list
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().withDefault(const Constant('General'))(); // Electricity, Gas, Rent, Oil, Vegetables, Salary, Misc
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

class CustomCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)(); // e.g. "Pizza Sizes", "Beer Portions"
  TextColumn get optionsJson => text()(); // JSON list of strings, e.g. ["8mm", "10mm", "12mm"]
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class EditedBills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()();
  IntColumn get billNumber => integer()();
  TextColumn get tableLabel => text()();
  RealColumn get originalTotal => real()();
  RealColumn get newTotal => real()();
  TextColumn get editedBy => text().withDefault(const Constant('Staff'))();
  DateTimeColumn get editedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get reason => text().withDefault(const Constant('Quantity reduction after print'))();
}

class EditedBillItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get editedBillId => integer().references(EditedBills, #id)();
  TextColumn get itemName => text()();
  IntColumn get oldQuantity => integer()();
  IntColumn get newQuantity => integer()();
  RealColumn get itemPrice => real()();
}

class StockWastage extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rawItemId => integer().references(RawItems, #id)();
  RealColumn get quantityWasted => real()();
  RealColumn get wastageCost => real()();
  TextColumn get reason => text().withDefault(const Constant('Spoiled / Damaged'))(); // Spoiled, Expired, Spilled, Preparation Error, Other
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

// ─────────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────────

@DriftDatabase(tables: [
  Zones,
  RestaurantTables,
  MenuCategories,
  MenuItems,
  Orders,
  OrderItems,
  KotRecords,
  Bills,
  PrinterConfigs,
  QueueEntries,
  StaffCategories,
  Staff,
  Attendance,
  SalaryPayments,
  RawItems,
  StockBatches,
  RecipeItems,
  ItemSops,
  Expenses,
  CustomCategories,
  EditedBills,
  EditedBillItems,
  StockWastage,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultData();
        },
        onUpgrade: (m, from, to) async {
          await _ensureSchemaIntegrity();
        },
        beforeOpen: (details) async {
          await _ensureSchemaIntegrity();
        },
      );

  Future<void> _ensureSchemaIntegrity() async {
    try {
      // 1. Ensure all columns exist on modified core tables
      await _safeAddColumn('bills', 'bill_number', 'INTEGER');
      await _safeAddColumn('bills', 'is_synced', 'INTEGER NOT NULL DEFAULT 0');
      await _safeAddColumn('bills', 'synced_at', 'TEXT');
      await _safeAddColumn('bills', 'split_cash', 'REAL NOT NULL DEFAULT 0.0');
      await _safeAddColumn('bills', 'split_online', 'REAL NOT NULL DEFAULT 0.0');
      await _safeAddColumn('menu_items', 'has_half_full', 'INTEGER NOT NULL DEFAULT 0');
      await _safeAddColumn('menu_items', 'half_price', 'REAL NOT NULL DEFAULT 0.0');
      await _safeAddColumn('menu_items', 'default_size', 'TEXT NOT NULL DEFAULT \'Full\'');
      await _safeAddColumn('menu_items', 'image', 'TEXT');
      await _safeAddColumn('menu_items', 'custom_variants_json', 'TEXT NOT NULL DEFAULT \'[]\'');
      await _safeAddColumn('order_items', 'item_size', 'TEXT NOT NULL DEFAULT \'Full\'');
      await _safeAddColumn('order_items', 'printed_quantity', 'INTEGER NOT NULL DEFAULT 0');
      await _safeAddColumn('kot_records', 'kitchen_status', 'TEXT NOT NULL DEFAULT \'new\'');
      await _safeAddColumn('kot_records', 'kitchen_updated_at', 'TEXT');

      // 2. Automatically ensure EVERY table registered in AppDatabase exists safely
      for (final table in allTables) {
        await _safeCreateTable(table);
      }
    } catch (_) {}
  }

  Future<void> _safeAddColumn(String tableName, String columnName, String columnDef) async {
    try {
      final columns = await customSelect('PRAGMA table_info("$tableName")').get();
      final exists = columns.any((col) => col.read<String>('name') == columnName);
      if (!exists) {
        await customStatement('ALTER TABLE "$tableName" ADD COLUMN "$columnName" $columnDef');
      }
    } catch (_) {}
  }

  Future<void> _safeCreateTable(TableInfo table) async {
    try {
      await customStatement('CREATE TABLE IF NOT EXISTS "${table.actualTableName}" (${table.$columns.map((c) => c.escapedNameFor(SqlDialect.sqlite)).join(', ')})');
    } catch (_) {
      try {
        await createMigrator().createTable(table);
      } catch (_) {}
    }
  }

  Future<void> _seedDefaultData() async {
    await batch((b) {
      b.insertAll(zones, [
        ZonesCompanion.insert(name: 'Main Hall', colorValue: const Value(0xFF3B82F6), sortOrder: const Value(0)),
        ZonesCompanion.insert(name: 'Terrace', colorValue: const Value(0xFF10B981), sortOrder: const Value(1)),
        ZonesCompanion.insert(name: 'Bar', colorValue: const Value(0xFF8B5CF6), sortOrder: const Value(2)),
        ZonesCompanion.insert(name: 'Private', colorValue: const Value(0xFFEF4444), sortOrder: const Value(3)),
      ]);
    });

    // Get first zone id
    final firstZone = await (select(zones)..limit(1)).getSingle();

    // Default tables
    await batch((b) {
      for (int i = 1; i <= 8; i++) {
        b.insert(restaurantTables, RestaurantTablesCompanion.insert(
          zoneId: firstZone.id,
          tableNumber: 'T$i',
          tableLabel: 'Table $i',
          capacity: const Value(4),
          posX: Value(((i - 1) % 4) * 120.0),
          posY: Value(((i - 1) ~/ 4) * 120.0),
        ));
      }
    });

    // Default categories
    await batch((b) {
      b.insertAll(menuCategories, [
        MenuCategoriesCompanion.insert(name: 'Starters', colorValue: const Value(0xFFEF4444), sortOrder: const Value(0)),
        MenuCategoriesCompanion.insert(name: 'Main Course', colorValue: const Value(0xFFF59E0B), sortOrder: const Value(1)),
        MenuCategoriesCompanion.insert(name: 'Breads', colorValue: const Value(0xFFF97316), sortOrder: const Value(2)),
        MenuCategoriesCompanion.insert(name: 'Rice & Biryani', colorValue: const Value(0xFF8B5CF6), sortOrder: const Value(3)),
        MenuCategoriesCompanion.insert(name: 'Beverages', colorValue: const Value(0xFF3B82F6), sortOrder: const Value(4)),
        MenuCategoriesCompanion.insert(name: 'Desserts', colorValue: const Value(0xFFEC4899), sortOrder: const Value(5)),
      ]);
    });

    // Default menu items
    final cats = await select(menuCategories).get();
    if (cats.isNotEmpty) {
      await batch((b) {
        // Starters
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[0].id, name: 'Paneer Tikka', price: const Value(280), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[0].id, name: 'Chicken Kebab', price: const Value(320), isVeg: const Value(false)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[0].id, name: 'Veg Spring Roll', price: const Value(180), isVeg: const Value(true)));
        // Main Course
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[1].id, name: 'Butter Chicken', price: const Value(380), isVeg: const Value(false)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[1].id, name: 'Dal Makhani', price: const Value(260), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[1].id, name: 'Paneer Butter Masala', price: const Value(320), isVeg: const Value(true)));
        // Breads
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[2].id, name: 'Naan', price: const Value(40), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[2].id, name: 'Roti', price: const Value(25), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[2].id, name: 'Garlic Naan', price: const Value(60), isVeg: const Value(true)));
        // Rice
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[3].id, name: 'Veg Biryani', price: const Value(280), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[3].id, name: 'Chicken Biryani', price: const Value(360), isVeg: const Value(false)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[3].id, name: 'Steamed Rice', price: const Value(120), isVeg: const Value(true)));
        // Beverages
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[4].id, name: 'Mango Lassi', price: const Value(120), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[4].id, name: 'Cold Coffee', price: const Value(140), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[4].id, name: 'Fresh Lime Soda', price: const Value(80), isVeg: const Value(true)));
        // Desserts
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[5].id, name: 'Gulab Jamun', price: const Value(120), isVeg: const Value(true)));
        b.insert(menuItems, MenuItemsCompanion.insert(categoryId: cats[5].id, name: 'Ice Cream', price: const Value(150), isVeg: const Value(true)));
      });
    }
  }

  // ─── ZONE QUERIES ────────────────────────────
  Future<List<Zone>> getAllZones() => select(zones).get();
  Stream<List<Zone>> watchAllZones() => select(zones).watch();

  Future<int> insertZone(ZonesCompanion z) => into(zones).insert(z);
  Future<bool> updateZone(Zone z) => update(zones).replace(z);
  Future<int> deleteZone(int id) async {
    final tablesInZone = await (select(restaurantTables)..where((t) => t.zoneId.equals(id))).get();
    for (final t in tablesInZone) {
      await deleteTable(t.id);
    }
    return (delete(zones)..where((t) => t.id.equals(id))).go();
  }

  // ─── TABLE QUERIES ───────────────────────────
  Stream<List<RestaurantTable>> watchTablesByZone(int zoneId) =>
      (select(restaurantTables)..where((t) => t.zoneId.equals(zoneId) & t.isActive.equals(true))).watch();

  Future<List<RestaurantTable>> getTablesByZone(int zoneId) =>
      (select(restaurantTables)..where((t) => t.zoneId.equals(zoneId))).get();

  Future<List<RestaurantTable>> getAllTables() => select(restaurantTables).get();
  Stream<List<RestaurantTable>> watchAllTables() => select(restaurantTables).watch();

  Future<int> insertTable(RestaurantTablesCompanion t) => into(restaurantTables).insert(t);
  Future<bool> updateTable(RestaurantTable t) => update(restaurantTables).replace(t);
  Future<int> deleteTable(int id) async {
    final relatedOrders = await (select(orders)..where((t) => t.tableId.equals(id))).get();
    for (final o in relatedOrders) {
      await (delete(orderItems)..where((t) => t.orderId.equals(o.id))).go();
      await (delete(kotRecords)..where((t) => t.orderId.equals(o.id))).go();
      await (delete(bills)..where((t) => t.orderId.equals(o.id))).go();
    }
    await (delete(orders)..where((t) => t.tableId.equals(id))).go();
    return (delete(restaurantTables)..where((t) => t.id.equals(id))).go();
  }

  // ─── MENU QUERIES ────────────────────────────
  Stream<List<MenuCategory>> watchAllCategories() =>
      (select(menuCategories)..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).watch();
  Future<List<MenuCategory>> getAllCategories() => select(menuCategories).get();

  Stream<List<MenuItem>> watchItemsByCategory(int catId) =>
      (select(menuItems)..where((t) => t.categoryId.equals(catId))).watch();

  Future<List<MenuItem>> getItemsByCategory(int catId) =>
      (select(menuItems)..where((t) => t.categoryId.equals(catId) & t.isAvailable.equals(true))).get();

  Future<List<MenuItem>> getAllMenuItems() => select(menuItems).get();
  Stream<List<MenuItem>> watchAllMenuItems() => select(menuItems).watch();
  Future<MenuItem?> getMenuItem(int id) async {
    final list = await (select(menuItems)..where((t) => t.id.equals(id))).get();
    return list.isNotEmpty ? list.first : null;
  }

  Future<int> insertCategory(MenuCategoriesCompanion c) => into(menuCategories).insert(c);
  Future<bool> updateCategory(MenuCategory c) => update(menuCategories).replace(c);
  Future<int> deleteCategory(int id) async {
    final items = await (select(menuItems)..where((t) => t.categoryId.equals(id))).get();
    for (final item in items) {
      await deleteMenuItem(item.id);
    }
    return (delete(menuCategories)..where((t) => t.id.equals(id))).go();
  }

  Future<int> insertMenuItem(MenuItemsCompanion m) => into(menuItems).insert(m);
  Future<bool> updateMenuItem(MenuItem m) => update(menuItems).replace(m);
  Future<int> deleteMenuItem(int id) async {
    await (delete(orderItems)..where((t) => t.menuItemId.equals(id))).go();
    return (delete(menuItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> bulkInsertMenuItems(List<MenuItemsCompanion> items) async {
    await batch((b) => b.insertAll(menuItems, items));
  }

  // ─── ORDER QUERIES ────────────────────────────
  Stream<List<Order>> watchOpenOrders() =>
      (select(orders)..where((t) => t.status.equals('open') | t.status.equals('billed'))).watch();

  Stream<Map<int, double>> watchOpenOrderTotals() {
    final query = select(orders).join([
      leftOuterJoin(orderItems, orderItems.orderId.equalsExp(orders.id)),
    ])..where(orders.status.equals('open') | orders.status.equals('billed'));

    return query.watch().map((rows) {
      final Map<int, double> totals = {};
      for (final row in rows) {
        final orderId = row.readTable(orders).id;
        final item = row.readTableOrNull(orderItems);
        final itemTotal = item != null ? (item.itemPrice * item.quantity) : 0.0;
        totals[orderId] = (totals[orderId] ?? 0.0) + itemTotal;
      }
      return totals;
    });
  }

  Future<Order?> getOpenOrderForTable(int tableId) async {
    final results = await (select(orders)
          ..where((t) => t.tableId.equals(tableId) & t.status.equals('open'))
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first;
  }

  Future<int> insertOrder(OrdersCompanion o) => into(orders).insert(o);
  Future<bool> updateOrder(Order o) => update(orders).replace(o);

  // ─── ORDER ITEMS ─────────────────────────────
  Stream<List<OrderItem>> watchOrderItems(int orderId) =>
      (select(orderItems)..where((t) => t.orderId.equals(orderId))).watch();

  Future<List<OrderItem>> getOrderItems(int orderId) =>
      (select(orderItems)..where((t) => t.orderId.equals(orderId))).get();

  Future<int> insertOrderItem(OrderItemsCompanion i) => into(orderItems).insert(i);
  Future<bool> updateOrderItem(OrderItem i) => update(orderItems).replace(i);
  Future<int> deleteOrderItem(int id) => (delete(orderItems)..where((t) => t.id.equals(id))).go();

  Future<void> markKotSent(int orderId) async {
    final items = await getOrderItems(orderId);
    for (final item in items) {
      if (item.quantity > item.printedQuantity) {
        await updateOrderItem(item.copyWith(
          printedQuantity: item.quantity,
          kotSent: true,
        ));
      }
    }
  }

  // ─── KOT RECORDS ─────────────────────────────
  Future<int> insertKotRecord(KotRecordsCompanion k) => into(kotRecords).insert(k);
  Future<List<KotRecord>> getKotsByOrder(int orderId) =>
      (select(kotRecords)..where((t) => t.orderId.equals(orderId))).get();

  Stream<List<KotRecord>> watchKitchenKots() {
    return (select(kotRecords)
          ..orderBy([
            (t) => OrderingTerm.desc(t.kitchenUpdatedAt),
            (t) => OrderingTerm.desc(t.printedAt),
          ]))
        .watch();
  }

  Future<void> updateKotKitchenStatus(int kotId, String status) async {
    final row = await (select(kotRecords)..where((t) => t.id.equals(kotId))).getSingleOrNull();
    if (row == null) return;
    await (update(kotRecords)..where((t) => t.id.equals(kotId))).write(
      KotRecordsCompanion(
        kitchenStatus: Value(status),
        kitchenUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> getNextKotNumber() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    
    final dayKots = await (select(kotRecords)
          ..where((t) =>
              t.printedAt.isBiggerOrEqualValue(start) &
              t.printedAt.isSmallerThanValue(end)))
        .get();

    int maxNum = 0;
    for (final kot in dayKots) {
      if (kot.kotNumber > maxNum) {
        maxNum = kot.kotNumber;
      }
    }
    return maxNum + 1;
  }

  // ─── BILL QUERIES ─────────────────────────────
  Future<int> insertBill(BillsCompanion b) => into(bills).insert(b);
  
  Future<Bill?> getBillForOrder(int orderId) async {
    final results = await (select(bills)
          ..where((t) => t.orderId.equals(orderId))
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first;
  }

  Future<int> getNextDailyBillNumber(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final dayBills = await (select(bills)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end)))
        .get();

    int maxNum = 0;
    for (final bill in dayBills) {
      if (bill.billNumber != null && bill.billNumber! > maxNum) {
        maxNum = bill.billNumber!;
      }
    }
    return maxNum + 1;
  }

  Future<int> upsertBill(BillsCompanion b) async {
    final orderIdVal = b.orderId.value;
    final existing = await (select(bills)
          ..where((t) => t.orderId.equals(orderIdVal))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      final updated = existing.copyWith(
        tableId: b.tableId.value,
        tableLabel: b.tableLabel.value,
        subtotal: b.subtotal.value,
        discount: b.discount.value,
        total: b.total.value,
        paymentMethod: b.paymentMethod.value,
        amountReceived: b.amountReceived.value,
        change: b.change.value,
        splitCash: b.splitCash.present ? b.splitCash.value : existing.splitCash,
        splitOnline: b.splitOnline.present ? b.splitOnline.value : existing.splitOnline,
        itemsJson: b.itemsJson.value,
      );
      await update(bills).replace(updated);
      return existing.billNumber ?? 0;
    } else {
      final billNum = await getNextDailyBillNumber(b.createdAt.value);
      final withBillNum = b.copyWith(billNumber: Value(billNum));
      await into(bills).insert(withBillNum);
      return billNum;
    }
  }

  Future<List<Bill>> getAllBills() => select(bills).get();
  Future<List<Bill>> getBillsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(bills)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end)))
        .get();
  }

  Future<List<Bill>> getBillsForDateRange(DateTime startDate, DateTime endDate) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day).add(const Duration(days: 1));
    return (select(bills)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end)))
        .get();
  }

  Stream<List<Bill>> watchTodayBills() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return (select(bills)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(start) &
              t.createdAt.isSmallerThanValue(end)))
        .watch();
  }

  // ─── PRINTER CONFIGS ──────────────────────────
  Future<List<PrinterConfig>> getAllPrinterConfigs() => select(printerConfigs).get();
  Future<PrinterConfig?> getDefaultPrinter() async {
    final r = await (select(printerConfigs)..where((t) => t.isDefault.equals(true))..limit(1)).get();
    return r.isEmpty ? null : r.first;
  }
  Future<int> insertPrinterConfig(PrinterConfigsCompanion p) => into(printerConfigs).insert(p);
  Future<bool> updatePrinterConfig(PrinterConfig p) => update(printerConfigs).replace(p);
  Future<int> deletePrinterConfig(int id) => (delete(printerConfigs)..where((t) => t.id.equals(id))).go();
  Future<void> setDefaultPrinter(int id) async {
    await (update(printerConfigs)).write(const PrinterConfigsCompanion(isDefault: Value(false)));
    await (update(printerConfigs)..where((t) => t.id.equals(id))).write(const PrinterConfigsCompanion(isDefault: Value(true)));
  }

  // ─── QUEUE QUERIES ────────────────────────────
  Stream<List<QueueEntry>> watchActiveQueue() =>
      (select(queueEntries)
            ..where((t) => t.status.equals('waiting'))
            ..orderBy([(t) => OrderingTerm(expression: t.waitingNumber)]))
          .watch();

  Future<int> getNextWaitingNumber() async {
    final result = await (select(queueEntries)
          ..where((t) => t.status.equals('waiting'))
          ..orderBy([(t) => OrderingTerm(expression: t.waitingNumber, mode: OrderingMode.desc)])
          ..limit(1))
        .get();
    return result.isEmpty ? 1 : result.first.waitingNumber + 1;
  }

  Future<int> addToQueue(QueueEntriesCompanion entry) async {
    final waitingNum = await getNextWaitingNumber();
    return into(queueEntries).insert(entry.copyWith(waitingNumber: Value(waitingNum)));
  }

  Future<void> removeFromQueue(int id) async {
    await transaction(() async {
      // Get the entry being removed
      final entryToRemove = await (select(queueEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (entryToRemove == null) return;
      final removedNumber = entryToRemove.waitingNumber;

      // Update its status
      await (update(queueEntries)..where((t) => t.id.equals(id)))
          .write(const QueueEntriesCompanion(status: Value('cancelled')));

      // Shift all following numbers down
      final followingEntries = await (select(queueEntries)
            ..where((t) => t.status.equals('waiting') & t.waitingNumber.isBiggerThanValue(removedNumber))
            ..orderBy([(t) => OrderingTerm(expression: t.waitingNumber)]))
          .get();

      for (final entry in followingEntries) {
        await (update(queueEntries)..where((t) => t.id.equals(entry.id)))
            .write(QueueEntriesCompanion(waitingNumber: Value(entry.waitingNumber - 1)));
      }
    });
  }

  Future<void> markAsSeated(int id) async {
    await transaction(() async {
      // Get the entry being seated
      final entryToRemove = await (select(queueEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (entryToRemove == null) return;

      // Update its status
      await (update(queueEntries)..where((t) => t.id.equals(id)))
          .write(const QueueEntriesCompanion(status: Value('seated')));

      // Waiting numbers are retained after seating so existing queue history stays intact.
    });
  }

  // ─── STAFF CATEGORIES QUERIES ──────────────────
  Stream<List<StaffCategory>> watchAllStaffCategories() => select(staffCategories).watch();
  Future<List<StaffCategory>> getAllStaffCategories() => select(staffCategories).get();
  Future<int> insertStaffCategory(StaffCategoriesCompanion c) => into(staffCategories).insert(c);
  Future<bool> updateStaffCategory(StaffCategory c) => update(staffCategories).replace(c);
  Future<int> deleteStaffCategory(int id) async {
    await (delete(staff)..where((t) => t.categoryId.equals(id))).go();
    return (delete(staffCategories)..where((t) => t.id.equals(id))).go();
  }

  // ─── STAFF QUERIES ─────────────────────────────
  Stream<List<StaffData>> watchAllStaff() =>
      (select(staff)..where((t) => t.isActive.equals(true))).watch();
  Stream<List<StaffData>> watchAllStaffIncludingInactive() => select(staff).watch();
  Future<List<StaffData>> getAllStaff() => select(staff).get();
  Future<int> insertStaff(StaffCompanion s) => into(staff).insert(s);
  Future<bool> updateStaff(StaffData s) => update(staff).replace(s);
  Future<int> deleteStaff(int id) async {
    await (delete(attendance)..where((t) => t.staffId.equals(id))).go();
    await (delete(salaryPayments)..where((t) => t.staffId.equals(id))).go();
    return (delete(staff)..where((t) => t.id.equals(id))).go();
  }

  // ─── ATTENDANCE QUERIES ────────────────────────
  Stream<List<AttendanceData>> watchAttendanceForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(attendance)
          ..where((t) => t.date.isBiggerOrEqualValue(start) & t.date.isSmallerThanValue(end)))
        .watch();
  }

  Future<List<AttendanceData>> getAttendanceForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(attendance)
          ..where((t) => t.date.isBiggerOrEqualValue(start) & t.date.isSmallerThanValue(end)))
        .get();
  }

  Future<void> upsertAttendance(AttendanceCompanion a) async {
    final staffIdVal = a.staffId.value;
    final dateVal = a.date.value;
    final start = DateTime(dateVal.year, dateVal.month, dateVal.day);
    final end = start.add(const Duration(days: 1));

    final existing = await (select(attendance)
          ..where((t) =>
              t.staffId.equals(staffIdVal) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      final updated = existing.copyWith(
        status: a.status.value,
        notes: a.notes.value,
        date: dateVal,
      );
      await update(attendance).replace(updated);
    } else {
      await into(attendance).insert(a);
    }
  }

  Future<List<AttendanceData>> getStaffAttendanceForMonth(int staffId, int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return (select(attendance)
          ..where((t) =>
              t.staffId.equals(staffId) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .get();
  }

  Stream<List<AttendanceData>> watchStaffAttendanceForMonth(int staffId, int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return (select(attendance)
          ..where((t) =>
              t.staffId.equals(staffId) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end)))
        .watch();
  }

  // ─── PAYROLL / SALARY QUERIES ──────────────────
  Future<SalaryPayment?> getSalaryPayment(int staffId, int month, int year) async {
    final results = await (select(salaryPayments)
          ..where((t) =>
              t.staffId.equals(staffId) &
              t.month.equals(month) &
              t.year.equals(year))
          ..limit(1))
        .get();
    return results.isEmpty ? null : results.first;
  }

  Future<void> upsertSalaryPayment(SalaryPaymentsCompanion s) async {
    final staffIdVal = s.staffId.value;
    final monthVal = s.month.value;
    final yearVal = s.year.value;

    final existing = await (select(salaryPayments)
          ..where((t) =>
              t.staffId.equals(staffIdVal) &
              t.month.equals(monthVal) &
              t.year.equals(yearVal))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      final updated = existing.copyWith(
        baseSalary: s.baseSalary.value,
        calculatedSalary: s.calculatedSalary.value,
        bonus: s.bonus.value,
        deductions: s.deductions.value,
        paidAmount: s.paidAmount.value,
        paidAt: s.paidAt.value,
        notes: s.notes.value,
        holidaysUnpaid: s.holidaysUnpaid.value,
      );
      await update(salaryPayments).replace(updated);
    } else {
      await into(salaryPayments).insert(s);
    }
  }

  Stream<List<SalaryPayment>> watchMonthlyPayments(int month, int year) {
    return (select(salaryPayments)
          ..where((t) => t.month.equals(month) & t.year.equals(year)))
        .watch();
  }

  // ─── BACKUP / RESTORE ──────────────────────────
  Future<String> exportFullDatabase() async {
    final zonesList = await select(zones).get();
    final tablesList = await select(restaurantTables).get();
    final catsList = await select(menuCategories).get();
    final itemsList = await select(menuItems).get();
    final ordersList = await select(orders).get();
    final orderItemsList = await select(orderItems).get();
    final kotRecordsList = await select(kotRecords).get();
    final billsList = await select(bills).get();
    final printersList = await select(printerConfigs).get();
    final staffCatsList = await select(staffCategories).get();
    final staffList = await select(staff).get();
    final attendanceList = await select(attendance).get();
    final paymentsList = await select(salaryPayments).get();

    final backup = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.1.0',
      'zones': zonesList.map((e) => e.toJson()).toList(),
      'restaurantTables': tablesList.map((e) => e.toJson()).toList(),
      'menuCategories': catsList.map((e) => e.toJson()).toList(),
      'menuItems': itemsList.map((e) => e.toJson()).toList(),
      'orders': ordersList.map((e) => e.toJson()).toList(),
      'orderItems': orderItemsList.map((e) => e.toJson()).toList(),
      'kotRecords': kotRecordsList.map((e) => e.toJson()).toList(),
      'bills': billsList.map((e) => e.toJson()).toList(),
      'printerConfigs': printersList.map((e) => e.toJson()).toList(),
      'staffCategories': staffCatsList.map((e) => e.toJson()).toList(),
      'staff': staffList.map((e) => e.toJson()).toList(),
      'attendance': attendanceList.map((e) => e.toJson()).toList(),
      'salaryPayments': paymentsList.map((e) => e.toJson()).toList(),
    };

    // Include Queue if exists
    try {
      final queueList = await select(queueEntries).get();
      backup['queueEntries'] = queueList.map((e) => e.toJson()).toList();
    } catch (_) {}

    // Include Hotel Details from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      backup['hotelDetails'] = {
        'hotel_name': prefs.getString('hotel_name'),
        'hotel_address': prefs.getString('hotel_address'),
        'hotel_phone': prefs.getString('hotel_phone'),
        'receipt_footer': prefs.getString('receipt_footer'),
        'restaurant_logo_base64': prefs.getString('restaurant_logo_base64'),
        'auto_launch_keyboard': prefs.getBool('auto_launch_keyboard'),
      };
    } catch (_) {}

    return jsonEncode(backup);
  }

  Future<void> importFullDatabase(String jsonStr) async {
    final backup = jsonDecode(jsonStr) as Map<String, dynamic>;
    
    await transaction(() async {
      // 1. Wipe existing tables in safe dependency order
      await delete(queueEntries).go();
      await delete(printerConfigs).go();
      await delete(bills).go();
      await delete(kotRecords).go();
      await delete(orderItems).go();
      await delete(orders).go();
      await delete(menuItems).go();
      await delete(menuCategories).go();
      await delete(restaurantTables).go();
      await delete(zones).go();
      await delete(salaryPayments).go();
      await delete(attendance).go();
      await delete(staff).go();
      await delete(staffCategories).go();

      // 2. Insert fresh data ensuring primary keys and auto-increments restore natively
      if (backup['zones'] != null) {
        for (var map in backup['zones']) {
          await into(zones).insert(Zone.fromJson(map));
        }
      }
      if (backup['restaurantTables'] != null) {
        for (var map in backup['restaurantTables']) {
          await into(restaurantTables).insert(RestaurantTable.fromJson(map));
        }
      }
      if (backup['menuCategories'] != null) {
        for (var map in backup['menuCategories']) {
          await into(menuCategories).insert(MenuCategory.fromJson(map));
        }
      }
      if (backup['menuItems'] != null) {
        for (var map in backup['menuItems']) {
          await into(menuItems).insert(MenuItem.fromJson(map));
        }
      }
      if (backup['orders'] != null) {
        for (var map in backup['orders']) {
          await into(orders).insert(Order.fromJson(map));
        }
      }
      if (backup['orderItems'] != null) {
        for (var map in backup['orderItems']) {
          await into(orderItems).insert(OrderItem.fromJson(map));
        }
      }
      if (backup['kotRecords'] != null) {
        for (var map in backup['kotRecords']) {
          await into(kotRecords).insert(KotRecord.fromJson(map));
        }
      }
      if (backup['bills'] != null) {
        for (var map in backup['bills']) {
          await into(bills).insert(Bill.fromJson(map));
        }
      }
      if (backup['printerConfigs'] != null) {
        for (var map in backup['printerConfigs']) {
          await into(printerConfigs).insert(PrinterConfig.fromJson(map));
        }
      }
      if (backup['queueEntries'] != null) {
        for (var map in backup['queueEntries']) {
          await into(queueEntries).insert(QueueEntry.fromJson(map));
        }
      }
      if (backup['staffCategories'] != null) {
        for (var map in backup['staffCategories']) {
          await into(staffCategories).insert(StaffCategory.fromJson(map));
        }
      }
      if (backup['staff'] != null) {
        for (var map in backup['staff']) {
          await into(staff).insert(StaffData.fromJson(map));
        }
      }
      if (backup['attendance'] != null) {
        for (var map in backup['attendance']) {
          await into(attendance).insert(AttendanceData.fromJson(map));
        }
      }
      if (backup['salaryPayments'] != null) {
        for (var map in backup['salaryPayments']) {
          await into(salaryPayments).insert(SalaryPayment.fromJson(map));
        }
      }
      if (backup['rawItems'] != null) {
        for (var map in backup['rawItems']) {
          await into(rawItems).insert(RawItem.fromJson(map));
        }
      }
      if (backup['stockBatches'] != null) {
        for (var map in backup['stockBatches']) {
          await into(stockBatches).insert(StockBatche.fromJson(map));
        }
      }
      if (backup['recipeItems'] != null) {
        for (var map in backup['recipeItems']) {
          await into(recipeItems).insert(RecipeItem.fromJson(map));
        }
      }
      if (backup['itemSops'] != null) {
        for (var map in backup['itemSops']) {
          await into(itemSops).insert(ItemSop.fromJson(map));
        }
      }
      if (backup['expenses'] != null) {
        for (var map in backup['expenses']) {
          await into(expenses).insert(Expense.fromJson(map));
        }
      }
      if (backup['customCategories'] != null) {
        for (var map in backup['customCategories']) {
          await into(customCategories).insert(CustomCategory.fromJson(map));
        }
      }
    });

    // Restore Hotel Details in SharedPreferences
    try {
      if (backup['hotelDetails'] != null) {
        final hotelDetails = backup['hotelDetails'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        if (hotelDetails['hotel_name'] != null) {
          await prefs.setString('hotel_name', hotelDetails['hotel_name'] as String);
        }
        if (hotelDetails['hotel_address'] != null) {
          await prefs.setString('hotel_address', hotelDetails['hotel_address'] as String);
        }
        if (hotelDetails['hotel_phone'] != null) {
          await prefs.setString('hotel_phone', hotelDetails['hotel_phone'] as String);
        }
        if (hotelDetails['receipt_footer'] != null) {
          await prefs.setString('receipt_footer', hotelDetails['receipt_footer'] as String);
        }
        if (hotelDetails['restaurant_logo_base64'] != null) {
          await prefs.setString('restaurant_logo_base64', hotelDetails['restaurant_logo_base64'] as String);
        }
        if (hotelDetails['auto_launch_keyboard'] != null) {
          await prefs.setBool('auto_launch_keyboard', hotelDetails['auto_launch_keyboard'] as bool);
        }
      }
    } catch (_) {}
  }

  // ─────────────────────────────────────────────
  // RAW ITEMS & STOCK BATCHES HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<RawItem>> watchRawItems() => select(rawItems).watch();
  Future<List<RawItem>> getAllRawItems() => select(rawItems).get();
  Future<int> insertRawItem(RawItemsCompanion companion) => into(rawItems).insert(companion);
  Future<bool> updateRawItem(RawItem item) => update(rawItems).replace(item);
  Future<int> deleteRawItem(int id) => (delete(rawItems)..where((tbl) => tbl.id.equals(id))).go();

  Stream<List<StockBatche>> watchStockBatches() => (select(stockBatches)..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)])).watch();
  Future<List<StockBatche>> getBatchesForRawItem(int rawItemId) =>
      (select(stockBatches)..where((t) => t.rawItemId.equals(rawItemId) & t.remainingQty.isBiggerThanValue(0))..orderBy([(t) => OrderingTerm.asc(t.purchaseDate)])).get();

  Future<int> insertStockBatch(StockBatchesCompanion companion) => into(stockBatches).insert(companion);
  Future<bool> updateStockBatch(StockBatche batch) => update(stockBatches).replace(batch);
  Future<int> deleteStockBatch(int id) => (delete(stockBatches)..where((tbl) => tbl.id.equals(id))).go();

  // Deduct inventory using FIFO batch allocation when order items are sold
  Future<List<String>> deductInventoryForOrderItem(int menuItemId, String variantName, int quantity) async {
    final alerts = <String>[];
    final recipes = await (select(recipeItems)
          ..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName)))
        .get();

    for (final recipe in recipes) {
      double remainingToDeduct = recipe.quantityRequired * quantity;
      if (remainingToDeduct <= 0) continue;

      final activeBatches = await getBatchesForRawItem(recipe.rawItemId);

      for (final batch in activeBatches) {
        if (remainingToDeduct <= 0) break;

        if (batch.remainingQty >= remainingToDeduct) {
          final updatedQty = batch.remainingQty - remainingToDeduct;
          await updateStockBatch(batch.copyWith(remainingQty: updatedQty));
          remainingToDeduct = 0;
        } else {
          remainingToDeduct -= batch.remainingQty;
          await updateStockBatch(batch.copyWith(remainingQty: 0));
        }
      }

      // Check remaining total stock for this raw item after deduction
      final allRawItems = await getAllRawItems();
      final rawItem = allRawItems.firstWhere((r) => r.id == recipe.rawItemId, orElse: () => RawItem(id: 0, name: '', unit: '', minStockAlert: 0, expiryAlertDays: 7, category: '', createdAt: DateTime.now()));
      if (rawItem.id != 0) {
        final remainingBatches = await getBatchesForRawItem(rawItem.id);
        final currentTotalQty = remainingBatches.fold<double>(0.0, (s, b) => s + b.remainingQty);
        if (currentTotalQty <= rawItem.minStockAlert) {
          alerts.add('${rawItem.name}: Only ${currentTotalQty.toStringAsFixed(1)} ${rawItem.unit} remaining (Min Alert: ${rawItem.minStockAlert} ${rawItem.unit})');
        }
      }
    }
    return alerts;
  }

  // Restore inventory when an item is removed from an order or canceled
  Future<void> restoreInventoryForOrderItem(int menuItemId, String variantName, int quantity) async {
    final recipes = await (select(recipeItems)
          ..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName)))
        .get();

    for (final recipe in recipes) {
      final qtyToRestore = recipe.quantityRequired * quantity;
      if (qtyToRestore <= 0) continue;

      // Add restored quantity to the latest active stock batch for this raw item, or create a restored batch
      final batches = await (select(stockBatches)
            ..where((t) => t.rawItemId.equals(recipe.rawItemId))
            ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
          .get();

      if (batches.isNotEmpty) {
        final latestBatch = batches.first;
        await updateStockBatch(latestBatch.copyWith(remainingQty: latestBatch.remainingQty + qtyToRestore));
      }
    }
  }

  // Check if stock is sufficient for adding/ordering an item
  Future<String?> checkStockAvailability(int menuItemId, String variantName, int requestedQty) async {
    final recipes = await (select(recipeItems)
          ..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName)))
        .get();

    for (final recipe in recipes) {
      final neededQty = recipe.quantityRequired * requestedQty;
      if (neededQty <= 0) continue;

      final batches = await getBatchesForRawItem(recipe.rawItemId);
      final totalAvailable = batches.fold<double>(0.0, (s, b) => s + b.remainingQty);

      if (totalAvailable < neededQty) {
        final allRawItems = await getAllRawItems();
        final rawItem = allRawItems.firstWhere((r) => r.id == recipe.rawItemId, orElse: () => RawItem(id: 0, name: 'Raw Material', unit: '', minStockAlert: 0, expiryAlertDays: 7, category: '', createdAt: DateTime.now()));
        return '${rawItem.name} stock insufficient! Needed: ${neededQty.toStringAsFixed(1)} ${rawItem.unit}, Available: ${totalAvailable.toStringAsFixed(1)} ${rawItem.unit}';
      }
    }
    return null; // Stock available!
  }

  // Calculate current average/weighted cost price for a raw material
  Future<double> getAverageCostForRawItem(int rawItemId) async {
    final batches = await getBatchesForRawItem(rawItemId);
    if (batches.isEmpty) {
      final allBatches = await (select(stockBatches)..where((t) => t.rawItemId.equals(rawItemId))..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)])..limit(1)).get();
      if (allBatches.isNotEmpty) return allBatches.first.costPerUnit;
      return 0.0;
    }
    double totalQty = 0;
    double totalValue = 0;
    for (final b in batches) {
      totalQty += b.remainingQty;
      totalValue += b.remainingQty * b.costPerUnit;
    }
    return totalQty > 0 ? totalValue / totalQty : batches.first.costPerUnit;
  }

  // Calculate cost price (COGS) for a menu item variant based on recipe & raw material prices
  Future<double> getMenuItemCostPrice(int menuItemId, String variantName) async {
    final recipes = await (select(recipeItems)
          ..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName)))
        .get();

    double totalCost = 0.0;
    for (final r in recipes) {
      final unitCost = await getAverageCostForRawItem(r.rawItemId);
      totalCost += unitCost * r.quantityRequired;
    }
    return totalCost;
  }

  // ─────────────────────────────────────────────
  // RECIPES (BOM) HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<RecipeItem>> watchRecipeItems(int menuItemId, String variantName) =>
      (select(recipeItems)..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName))).watch();

  Future<List<RecipeItem>> getRecipeItems(int menuItemId, String variantName) =>
      (select(recipeItems)..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName))).get();

  Future<int> insertRecipeItem(RecipeItemsCompanion companion) => into(recipeItems).insert(companion);
  Future<bool> updateRecipeItem(RecipeItem recipe) => update(recipeItems).replace(recipe);
  Future<int> deleteRecipeItem(int id) => (delete(recipeItems)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> clearRecipe(int menuItemId, String variantName) =>
      (delete(recipeItems)..where((r) => r.menuItemId.equals(menuItemId) & r.variantName.equals(variantName))).go();

  // Clone/Reference Recipe from another MenuItem
  Future<void> copyRecipeFromExisting({
    required int sourceMenuItemId,
    required String sourceVariant,
    required int targetMenuItemId,
    required String targetVariant,
  }) async {
    final existingRecipes = await getRecipeItems(sourceMenuItemId, sourceVariant);
    await clearRecipe(targetMenuItemId, targetVariant);
    for (final source in existingRecipes) {
      await insertRecipeItem(RecipeItemsCompanion.insert(
        menuItemId: targetMenuItemId,
        variantName: Value(targetVariant),
        rawItemId: source.rawItemId,
        quantityRequired: source.quantityRequired,
        unit: Value(source.unit),
      ));
    }
  }

  // ─────────────────────────────────────────────
  // SOP HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<ItemSop?> watchItemSop(int menuItemId, String variantName) =>
      (select(itemSops)..where((s) => s.menuItemId.equals(menuItemId) & s.variantName.equals(variantName))).watchSingleOrNull();

  Future<ItemSop?> getItemSop(int menuItemId, String variantName) =>
      (select(itemSops)..where((s) => s.menuItemId.equals(menuItemId) & s.variantName.equals(variantName))).getSingleOrNull();

  Future<int> saveItemSop(ItemSopsCompanion companion) async {
    final existing = await getItemSop(companion.menuItemId.value, companion.variantName.value);
    if (existing != null) {
      await (update(itemSops)..where((s) => s.id.equals(existing.id))).write(companion);
      return existing.id;
    } else {
      return into(itemSops).insert(companion);
    }
  }

  // ─────────────────────────────────────────────
  // EXPENSES HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<Expense>> watchExpenses() => (select(expenses)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end) =>
      (select(expenses)..where((e) => e.date.isBetweenValues(start, end))..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Future<int> insertExpense(ExpensesCompanion companion) => into(expenses).insert(companion);
  Future<bool> updateExpense(Expense expense) => update(expenses).replace(expense);
  Future<int> deleteExpense(int id) => (delete(expenses)..where((tbl) => tbl.id.equals(id))).go();

  // ─────────────────────────────────────────────
  // CUSTOM CATEGORIES / VARIANTS HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<CustomCategory>> watchCustomCategories() => select(customCategories).watch();
  Future<List<CustomCategory>> getAllCustomCategories() => select(customCategories).get();
  Future<int> insertCustomCategory(CustomCategoriesCompanion companion) => into(customCategories).insert(companion);
  Future<bool> updateCustomCategory(CustomCategory cat) => update(customCategories).replace(cat);
  Future<int> deleteCustomCategory(int id) => (delete(customCategories)..where((tbl) => tbl.id.equals(id))).go();

  // ─────────────────────────────────────────────
  // EDITED BILLS AUDIT LOG HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<EditedBill>> watchEditedBills() =>
      (select(editedBills)..orderBy([(t) => OrderingTerm.desc(t.editedAt)])).watch();

  Future<List<EditedBillItem>> getEditedBillItems(int editedBillId) =>
      (select(editedBillItems)..where((t) => t.editedBillId.equals(editedBillId))).get();

  Future<int> logEditedBill({
    required int orderId,
    required int billNumber,
    required String tableLabel,
    required double originalTotal,
    required double newTotal,
    required String editedBy,
    required String reason,
    required List<Map<String, dynamic>> editedItemDetails,
  }) async {
    final editedBillId = await into(editedBills).insert(EditedBillsCompanion.insert(
      orderId: orderId,
      billNumber: billNumber,
      tableLabel: tableLabel,
      originalTotal: originalTotal,
      newTotal: newTotal,
      editedBy: Value(editedBy),
      editedAt: Value(DateTime.now()),
      reason: Value(reason),
    ));

    for (final item in editedItemDetails) {
      await into(editedBillItems).insert(EditedBillItemsCompanion.insert(
        editedBillId: editedBillId,
        itemName: item['name'] as String,
        oldQuantity: item['oldQty'] as int,
        newQuantity: item['newQty'] as int,
        itemPrice: (item['price'] as num).toDouble(),
      ));
    }
    return editedBillId;
  }

  // ─────────────────────────────────────────────
  // STOCK WASTAGE HELPER METHODS
  // ─────────────────────────────────────────────

  Stream<List<StockWastageData>> watchStockWastage() =>
      (select(stockWastage)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<int> recordStockWastage({
    required int rawItemId,
    required double quantityWasted,
    required String reason,
    String notes = '',
  }) async {
    final costPerUnit = await getAverageCostForRawItem(rawItemId);
    final wastageCost = quantityWasted * costPerUnit;

    // Deduct stock from active batches
    double remainingToDeduct = quantityWasted;
    final activeBatches = await getBatchesForRawItem(rawItemId);
    for (final batch in activeBatches) {
      if (remainingToDeduct <= 0) break;
      if (batch.remainingQty >= remainingToDeduct) {
        await updateStockBatch(batch.copyWith(remainingQty: batch.remainingQty - remainingToDeduct));
        remainingToDeduct = 0;
      } else {
        remainingToDeduct -= batch.remainingQty;
        await updateStockBatch(batch.copyWith(remainingQty: 0));
      }
    }

    return into(stockWastage).insert(StockWastageCompanion.insert(
      rawItemId: rawItemId,
      quantityWasted: quantityWasted,
      wastageCost: wastageCost,
      reason: Value(reason),
      notes: Value(notes),
      date: Value(DateTime.now()),
    ));
  }

  Future<int> deleteStockWastage(int id) =>
      (delete(stockWastage)..where((tbl) => tbl.id.equals(id))).go();
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'nextbills');
}
