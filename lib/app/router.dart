import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nextbills/core/layout/app_shell.dart';
import 'package:nextbills/features/auth/pin_screen.dart';
import 'package:nextbills/features/auth/activation_screen.dart';
import 'package:nextbills/features/staff/staff_screen.dart';
import 'package:nextbills/features/inventory/inventory_screen.dart';
import 'package:nextbills/features/expenses/expenses_screen.dart';
import 'package:nextbills/features/pos/pos_screen.dart';
import 'package:nextbills/features/order/order_screen.dart';
import 'package:nextbills/features/menu/menu_screen.dart';
import 'package:nextbills/features/tables/table_management_screen.dart';
import 'package:nextbills/features/reports/reports_screen.dart';
import 'package:nextbills/features/printer/printer_setup_screen.dart';
import 'package:nextbills/features/settings/settings_screen.dart';
import 'package:nextbills/features/billing/billing_screen.dart';
import 'package:nextbills/features/queue/screens/queue_screen.dart';
import 'package:nextbills/features/auth/intro_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/intro',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/intro',
        name: 'intro',
        pageBuilder: (c, s) => _buildPage(c, s, const IntroScreen()),
      ),
      GoRoute(
        path: '/pin',
        name: 'pin',
        pageBuilder: (c, s) => _buildPage(c, s, const PinScreen()),
      ),
      GoRoute(
        path: '/activation',
        name: 'activation',
        pageBuilder: (c, s) => _buildPage(c, s, const ActivationScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/pos',
            name: 'pos',
            pageBuilder: (c, s) => _buildPage(c, s, const PosScreen()),
          ),
          GoRoute(
            path: '/order/:tableId/:orderId',
            name: 'order',
            pageBuilder: (c, s) => _buildPage(
              c, s,
              OrderScreen(
                tableId: int.parse(s.pathParameters['tableId']!),
                orderId: int.parse(s.pathParameters['orderId']!),
              ),
            ),
          ),
          GoRoute(
            path: '/billing/:orderId',
            name: 'billing',
            pageBuilder: (c, s) => _buildPage(
              c, s,
              BillingScreen(orderId: int.parse(s.pathParameters['orderId']!)),
            ),
          ),
          GoRoute(
            path: '/menu',
            name: 'menu',
            pageBuilder: (c, s) => _buildPage(c, s, const MenuScreen()),
          ),
          GoRoute(
            path: '/tables',
            name: 'tables',
            pageBuilder: (c, s) {
              final zoneIdStr = s.uri.queryParameters['zoneId'];
              final zoneId = zoneIdStr != null ? int.tryParse(zoneIdStr) : null;
              return _buildPage(c, s, TableManagementScreen(zoneId: zoneId));
            },
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            pageBuilder: (c, s) => _buildPage(c, s, const ReportsScreen()),
          ),
          GoRoute(
            path: '/printer',
            name: 'printer',
            pageBuilder: (c, s) => _buildPage(c, s, const PrinterSetupScreen()),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (c, s) => _buildPage(c, s, const SettingsScreen()),
          ),
          GoRoute(
            path: '/queue',
            name: 'queue',
            pageBuilder: (c, s) => _buildPage(c, s, const QueueScreen()),
          ),
          GoRoute(
            path: '/staff',
            name: 'staff',
            pageBuilder: (c, s) => _buildPage(c, s, const StaffScreen()),
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            pageBuilder: (c, s) => _buildPage(c, s, const InventoryScreen()),
          ),
          GoRoute(
            path: '/expenses',
            name: 'expenses',
            pageBuilder: (c, s) => _buildPage(c, s, const ExpensesScreen()),
          ),
        ],
      ),
    ],
  );
});

Page<void> _buildPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

