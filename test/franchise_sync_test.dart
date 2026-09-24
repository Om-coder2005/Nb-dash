import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/sync/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late AppDatabase db;
  late FranchiseSyncService syncService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    syncService = FranchiseSyncService(db);
  });

  tearDown(() async {
    syncService.dispose();
    await db.close();
  });

  test('FranchiseOutletInfo default values test', () async {
    final info = await syncService.getOutletInfo();
    expect(info.outletId, equals('OUTLET-001'));
    expect(info.isActivated, isFalse);
  });

  test('saveOutletCredentials activates outlet securely', () async {
    final success = await syncService.saveOutletCredentials(
      outletId: 'OUTLET-101',
      outletName: 'Station Franchise',
      franchiseKey: 'KEY-FRANCHISE-999',
      adminKey: 'admin123',
    );

    expect(success, isTrue);

    final info = await syncService.getOutletInfo();
    expect(info.outletId, equals('OUTLET-101'));
    expect(info.outletName, equals('Station Franchise'));
    expect(info.isActivated, isTrue);
  });
}
