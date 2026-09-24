import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/features/franchise/screens/franchise_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NextBillsDashboardApp()));
}

class NextBillsDashboardApp extends ConsumerWidget {
  const NextBillsDashboardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'nextbills-dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const FranchiseDashboardScreen(),
    );
  }
}
