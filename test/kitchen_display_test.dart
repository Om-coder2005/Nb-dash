import 'package:flutter_test/flutter_test.dart';
import 'package:nextbills/features/kitchen/kitchen_display_state.dart';

void main() {
  test('kitchen display statuses are defined and ordered for workflow', () {
    expect(KitchenKotStatus.values.map((status) => status.value), [
      'new',
      'preparing',
      'ready',
      'completed',
    ]);
  });
}
