import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';

part 'queue_provider.g.dart';

@riverpod
class QueueController extends _$QueueController {
  @override
  Stream<List<QueueEntry>> build() {
    final db = ref.watch(databaseProvider);
    return db.watchActiveQueue();
  }

  Future<void> addEntry({
    required String name,
    String? phone,
    required int seats,
  }) async {
    final db = ref.read(databaseProvider);
    await db.addToQueue(QueueEntriesCompanion.insert(
      customerName: name,
      customerPhone: Value(phone),
      requiredSeats: Value(seats),
      waitingNumber: 0, // Placeholder, set by addToQueue
    ));
  }

  Future<void> removeEntry(int id) async {
    final db = ref.read(databaseProvider);
    await db.removeFromQueue(id);
  }

  Future<void> markAsSeated(int id) async {
    final db = ref.read(databaseProvider);
    await db.markAsSeated(id);
  }
}
