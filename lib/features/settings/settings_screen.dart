import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';


import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _hotelNameController = TextEditingController();
  final _hotelAddressController = TextEditingController();
  final _hotelPhoneController = TextEditingController();
  final _footerController = TextEditingController();
  final _upiIdController = TextEditingController();
  final _soundboxTrController = TextEditingController();
  final _gstinController = TextEditingController();
  final _cgstRateController = TextEditingController();
  final _sgstRateController = TextEditingController();
  String? _logoBase64;
  bool _autoLaunchKeyboard = true;
  bool _enablePrintUpiQr = false;
  bool _enableTableQuickLook = true;
  bool _enableGst = false;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _hotelNameController.dispose();
    _hotelAddressController.dispose();
    _hotelPhoneController.dispose();
    _footerController.dispose();
    _upiIdController.dispose();
    _soundboxTrController.dispose();
    _gstinController.dispose();
    _cgstRateController.dispose();
    _sgstRateController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hotelNameController.text = prefs.getString('hotel_name') ?? 'My Restaurant';
      _hotelAddressController.text = prefs.getString('hotel_address') ?? '';
      _hotelPhoneController.text = prefs.getString('hotel_phone') ?? '';
      _footerController.text = prefs.getString('receipt_footer') ?? 'Thank you! Visit Again..';
      _upiIdController.text = prefs.getString('upi_id') ?? '';
      _soundboxTrController.text = prefs.getString('soundbox_tr') ?? '';
      _gstinController.text = prefs.getString('gstin_number') ?? '';
      _cgstRateController.text = (prefs.getDouble('cgst_rate') ?? 2.5).toString();
      _sgstRateController.text = (prefs.getDouble('sgst_rate') ?? 2.5).toString();
      _enableGst = prefs.getBool('enable_gst') ?? false;
      _logoBase64 = prefs.getString('restaurant_logo_base64');
      _autoLaunchKeyboard = prefs.getBool('auto_launch_keyboard') ?? true;
      _enablePrintUpiQr = prefs.getBool('enable_print_upi_qr') ?? false;
      _enableTableQuickLook = prefs.getBool('enable_table_quick_look') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _pickLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        
        // Decode and resize to 20x20 as requested
        final image = img.decodeImage(bytes);
        if (image != null) {
          // Resize to a higher resolution for better print quality (400px is safe for storage)
          final resized = img.copyResize(image, width: 400, interpolation: img.Interpolation.cubic);
          final pngBytes = img.encodePng(resized);
          final base64 = base64Encode(pngBytes);
          
          setState(() => _logoBase64 = base64);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('restaurant_logo_base64', base64);
        }
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Failed to pick logo: $e', type: NbToastType.error);
      }
    }
  }


  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hotel_name', _hotelNameController.text.trim());
    await prefs.setString('hotel_address', _hotelAddressController.text.trim());
    await prefs.setString('hotel_phone', _hotelPhoneController.text.trim());
    await prefs.setString('receipt_footer', _footerController.text.trim());
    await prefs.setString('upi_id', _upiIdController.text.trim());
    await prefs.setString('soundbox_tr', _soundboxTrController.text.trim());
    await prefs.setString('gstin_number', _gstinController.text.trim().toUpperCase());
    await prefs.setDouble('cgst_rate', double.tryParse(_cgstRateController.text.trim()) ?? 2.5);
    await prefs.setDouble('sgst_rate', double.tryParse(_sgstRateController.text.trim()) ?? 2.5);
    await prefs.setBool('enable_gst', _enableGst);
    await prefs.setBool('enable_print_upi_qr', _enablePrintUpiQr);
    await prefs.setBool('enable_table_quick_look', _enableTableQuickLook);

    if (mounted) {
      NbToast.show(context, 'Settings saved!', type: NbToastType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    if (_isLoading) return Scaffold(backgroundColor: AppColors.bg, body: const Center(child: NbLoadingPulse()));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'Settings',
        showBack: true,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text('Save',
                style: GoogleFonts.manrope(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // ─── Hotel Info
          _SectionHeader('Restaurant Info'),
          SizedBox(height: 12),
          NbInput(
            controller: _hotelNameController,
            hintText: 'Restaurant / Hotel Name (Printed on bills)',
            prefixIcon: Icons.restaurant_rounded,
          ),
          SizedBox(height: 12),
          NbInput(
            controller: _hotelAddressController,
            hintText: 'Address (optional)',
            prefixIcon: Icons.location_on_rounded,
          ),
          SizedBox(height: 12),
          NbInput(
            controller: _hotelPhoneController,
            type: NbInputType.number,
            hintText: 'Phone Number (optional)',
            prefixIcon: Icons.phone_rounded,
          ),
          SizedBox(height: 12),
          NbInput(
            controller: _footerController,
            hintText: 'Receipt Footer Message',
            prefixIcon: Icons.text_fields_rounded,
          ),
          SizedBox(height: 12),
          
          // Logo Upload Tile
          _SettingsTile(
            icon: Icons.image_rounded,
            iconColor: AppColors.info,
            title: 'Restaurant Logo',
            subtitle: _logoBase64 != null ? 'Logo uploaded' : 'Not set (No logo will be printed)',
            trailing: _logoBase64 != null 
              ? Image.memory(base64Decode(_logoBase64!), width: 32, height: 32, fit: BoxFit.contain)
              : null,
            onTap: () {
              if (_logoBase64 != null) {
                showDialog(
                  context: context,
                  builder: (ctx) => NbDialog(
                    title: 'Restaurant Logo',
                    customContent: Text(
                      'Would you like to change or remove the logo printed on bills?',
                      style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
                    ),
                    primaryButtonText: 'Change',
                    onPrimary: () {
                      Navigator.pop(ctx);
                      _pickLogo();
                    },
                    secondaryButtonText: 'Remove',
                    onSecondary: () async {
                      Navigator.pop(ctx);
                      setState(() => _logoBase64 = null);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('restaurant_logo_base64');
                      if (mounted) {
                        NbToast.show(context, 'Logo removed successfully', type: NbToastType.success);
                      }
                    },
                  ),
                );
              } else {
                _pickLogo();
              }
            },
          ),

          SizedBox(height: 28),

          // ─── UPI Payment & Soundbox Settings
          _SectionHeader('UPI Payment & Soundbox QR'),
          SizedBox(height: 12),
          NbInput(
            controller: _upiIdController,
            hintText: 'UPI VPA ID (e.g. merchant@upi / 9876543210@upi)',
            prefixIcon: Icons.qr_code_2_rounded,
          ),
          SizedBox(height: 12),
          NbInput(
            controller: _soundboxTrController,
            hintText: 'Soundbox TR / Payee Name (optional)',
            prefixIcon: Icons.speaker_group_rounded,
          ),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.qr_code_scanner_rounded,
            iconColor: AppColors.primary,
            title: 'Print UPI QR Code on Bill',
            subtitle: 'Prints dynamic QR code with exact bill amount for UPI apps',
            trailing: Switch(
              value: _enablePrintUpiQr,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                setState(() => _enablePrintUpiQr = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('enable_print_upi_qr', val);
              },
            ),
            onTap: () async {
              final val = !_enablePrintUpiQr;
              setState(() => _enablePrintUpiQr = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('enable_print_upi_qr', val);
            },
          ),

          SizedBox(height: 28),

          // ─── GST & Tax Settings
          _SectionHeader('GST & Tax Configuration'),
          SizedBox(height: 12),
          NbInput(
            controller: _gstinController,
            hintText: 'GSTIN Number (e.g. 27AAAAA0000A1Z5)',
            prefixIcon: Icons.receipt_long_rounded,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NbInput(
                  controller: _cgstRateController,
                  type: NbInputType.number,
                  hintText: 'CGST Rate (%)',
                  prefixIcon: Icons.percent_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: NbInput(
                  controller: _sgstRateController,
                  type: NbInputType.number,
                  hintText: 'SGST Rate (%)',
                  prefixIcon: Icons.percent_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.request_quote_rounded,
            iconColor: AppColors.primary,
            title: 'Enable GST / SGST Tax Billing',
            subtitle: 'Automatically calculates and prints CGST & SGST breakdown on bills',
            trailing: Switch(
              value: _enableGst,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                setState(() => _enableGst = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('enable_gst', val);
              },
            ),
            onTap: () async {
              final val = !_enableGst;
              setState(() => _enableGst = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('enable_gst', val);
            },
          ),

          SizedBox(height: 28),

          // ─── Appearance
          _SectionHeader('Appearance'),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            iconColor: AppColors.primary,
            title: 'Dark Mode',
            subtitle: 'Toggle dark mode theme',
            trailing: Switch(
              value: ref.watch(themeModeProvider) == ThemeMode.dark,
              onChanged: (val) {
                ref.read(themeModeProvider.notifier).state =
                    val ? ThemeMode.dark : ThemeMode.light;
              },
              activeColor: AppColors.primary,
            ),
            onTap: () {
              final isDark = ref.read(themeModeProvider) == ThemeMode.dark;
              ref.read(themeModeProvider.notifier).state =
                  !isDark ? ThemeMode.dark : ThemeMode.light;
            },
          ),

          SizedBox(height: 28),

          // ─── Security & Audit Log
          _SectionHeader('Security & Audit Log'),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.history_edu_rounded,
            iconColor: AppColors.error,
            title: 'Edited Bills Audit Log',
            subtitle: 'View history of post-print bill alterations & item removals',
            onTap: () => _showEditedBillsDialog(context, ref),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.lock_rounded,
            iconColor: AppColors.warning,
            title: 'Change PIN',
            subtitle: 'Update your 4-digit unlock PIN',
            onTap: () => _changePinDialog(context),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.admin_panel_settings_rounded,
            iconColor: AppColors.error,
            title: 'Change Admin PIN',
            subtitle: 'Update PIN for Reports & Staff Management',
            onTap: () => _changeAdminPinDialog(context),
          ),

          SizedBox(height: 28),

          // ─── Navigation shortcuts
          _SectionHeader('Management'),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.table_restaurant_rounded,
            iconColor: AppColors.info,
            title: 'Table & Zone Management',
            subtitle: 'Add, edit, reorder tables and zones',
            onTap: () => context.pushNamed('tables'),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.restaurant_menu_rounded,
            iconColor: AppColors.success,
            title: 'Menu Management',
            subtitle: 'Add items, import/export XLSX',
            onTap: () => context.pushNamed('menu'),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.print_rounded,
            iconColor: AppColors.primary,
            title: 'Printer Setup',
            subtitle: 'Connect Bluetooth printer, test print',
            onTap: () => context.pushNamed('printer'),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.preview_rounded,
            iconColor: AppColors.info,
            title: 'Table Quick Look',
            subtitle: 'Display active order summary under occupied table cards',
            trailing: Switch(
              value: _enableTableQuickLook,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                setState(() => _enableTableQuickLook = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('enable_table_quick_look', val);
              },
            ),
            onTap: () async {
              final val = !_enableTableQuickLook;
              setState(() => _enableTableQuickLook = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('enable_table_quick_look', val);
            },
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.people_rounded,
            iconColor: AppColors.primary,
            title: 'Staff Management',
            subtitle: 'Manage attendance, payroll, and category wages',
            onTap: () => _showAdminAccessDialog(context, 'staff'),
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.keyboard_rounded,
            iconColor: AppColors.primary,
            title: 'Auto-launch Keyboard',
            subtitle: 'Automatically open virtual keyboard on search focus',
            trailing: Switch(
              value: _autoLaunchKeyboard,
              activeColor: AppColors.primary,
              onChanged: (val) async {
                setState(() => _autoLaunchKeyboard = val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('auto_launch_keyboard', val);
              },
            ),
            onTap: () async {
              final val = !_autoLaunchKeyboard;
              setState(() => _autoLaunchKeyboard = val);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('auto_launch_keyboard', val);
            },
          ),

          SizedBox(height: 28),

          // ─── Data Management
          _SectionHeader('Data & Backup'),
          SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.backup_rounded,
            iconColor: AppColors.success,
            title: 'Export Backup',
            subtitle: 'Share full database backup as JSON',
            onTap: _exportBackup,
          ),
          SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.restore_rounded,
            iconColor: AppColors.warning,
            title: 'Import Backup',
            subtitle: 'Restore from a JSON backup file',
            onTap: _importBackup,
          ),

          SizedBox(height: 28),

          // ─── About
          _SectionHeader('About'),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'NextBills',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Professional Hotel POS System',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // ─── Logout / Lock
          NbButton(
            text: 'Lock App',
            icon: Icons.lock_rounded,
            type: NbButtonType.secondary,
            onPressed: () => context.goNamed('pin'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAdminAccessDialog(BuildContext context, String targetRoute) async {
    final prefs = await SharedPreferences.getInstance();
    final correctPin = prefs.getString('admin_pin') ?? '9469';
    
    if (!context.mounted) return;

    final tc = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Admin Access',
        customContent: NbInput(
          controller: tc,
          type: NbInputType.number,
          hintText: 'Enter Admin PIN',
        ),
        primaryButtonText: 'Submit',
        onPrimary: () {
          Navigator.pop(ctx);
          if (tc.text == correctPin) {
            context.pushNamed(targetRoute);
          } else {
            NbToast.show(context, 'Incorrect PIN', type: NbToastType.error);
          }
        },
        secondaryButtonText: 'Cancel',
        onSecondary: () => Navigator.pop(ctx),
      ),
    );
  }

  Future<void> _changeAdminPinDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPin = prefs.getString('admin_pin') ?? '9469';

    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Change Admin PIN',
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NbInput(
              controller: currentPinController,
              type: NbInputType.number,
              maxLength: 4,
              hintText: 'Current Admin PIN',
            ),
            SizedBox(height: 12),
            NbInput(
              controller: newPinController,
              type: NbInputType.number,
              maxLength: 4,
              hintText: 'New Admin PIN (4 digits)',
            ),
            SizedBox(height: 12),
            NbInput(
              controller: confirmPinController,
              type: NbInputType.number,
              maxLength: 4,
              hintText: 'Confirm Admin PIN',
            ),
          ],
        ),
        primaryButtonText: 'Save PIN',
        onPrimary: () async {
          if (currentPinController.text != currentPin) {
            NbToast.show(context, 'Incorrect current PIN', type: NbToastType.error);
            return;
          }
          if (newPinController.text.length != 4) {
            NbToast.show(context, 'PIN must be 4 digits', type: NbToastType.error);
            return;
          }
          if (newPinController.text != confirmPinController.text) {
            NbToast.show(context, 'PINs do not match', type: NbToastType.error);
            return;
          }
          await prefs.setString('admin_pin', newPinController.text);
          if (ctx.mounted) {
            Navigator.pop(ctx);
            NbToast.show(context, 'Admin PIN updated!', type: NbToastType.success);
          }
        },
        secondaryButtonText: 'Cancel',
        onSecondary: () => Navigator.pop(ctx),
      ),
    );
  }

  Future<void> _changePinDialog(BuildContext context) async {
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Change PIN',
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NbInput(
              controller: newPinController,
              type: NbInputType.number,
              maxLength: 4,
              hintText: 'New PIN (4 digits)',
            ),
            SizedBox(height: 12),
            NbInput(
              controller: confirmPinController,
              type: NbInputType.number,
              maxLength: 4,
              hintText: 'Confirm PIN',
            ),
          ],
        ),
        primaryButtonText: 'Save PIN',
        onPrimary: () async {
          if (newPinController.text.length != 4) return;
          if (newPinController.text != confirmPinController.text) {
            NbToast.show(context, 'PINs do not match', type: NbToastType.error);
            return;
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('app_pin', newPinController.text);
          if (ctx.mounted) {
            Navigator.pop(ctx);
            NbToast.show(context, 'PIN updated!', type: NbToastType.success);
          }
        },
        secondaryButtonText: 'Cancel',
        onSecondary: () => Navigator.pop(ctx),
      ),
    );
  }

  Future<void> _exportBackup() async {
    try {
      final db = ref.read(databaseProvider);
      final jsonStr = await db.exportFullDatabase();

      if (Platform.isWindows) {
        final outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Backup File',
          fileName: 'nextbills_backup_${DateTime.now().millisecondsSinceEpoch}.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsString(jsonStr);
          if (mounted) {
            NbToast.show(context, 'Backup saved successfully to ${p.basename(outputFile)}!', type: NbToastType.success);
          }
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            '${dir.path}/nextbills_backup_${DateTime.now().millisecondsSinceEpoch}.json');
        await file.writeAsString(jsonStr);

        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/json')],
          subject: 'NextBills Backup',
        );
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Export failed: $e', type: NbToastType.error);
      }
    }
  }

  Future<void> _importBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonStr = await file.readAsString();
        
        final db = ref.read(databaseProvider);
        await db.importFullDatabase(jsonStr);
        
        if (mounted) {
          NbToast.show(context, 'Backup restored successfully!', type: NbToastType.success);
          _loadSettings();
        }
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Import failed: $e', type: NbToastType.error);
      }
    }
  }

  void _showEditedBillsDialog(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);

    showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: '📋 Edited Bills Audit Log',
        customContent: SizedBox(
          width: 550,
          height: 450,
          child: StreamBuilder<List<EditedBill>>(
            stream: db.watchEditedBills(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const NbLoadingPulse();
              final edited = snapshot.data!;
              if (edited.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_rounded, size: 48, color: AppColors.success),
                      const SizedBox(height: 12),
                      Text('No edited bills recorded.', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text('All printed bills remain untampered.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: edited.length,
                itemBuilder: (context, idx) {
                  final log = edited[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: AppColors.surface,
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.error.withOpacity(0.15),
                        child: Icon(Icons.edit_note_rounded, color: AppColors.error, size: 20),
                      ),
                      title: Text(
                        'Bill #${log.billNumber} (${log.tableLabel})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Original: ₹${log.originalTotal.toStringAsFixed(0)} ➔ New: ₹${log.newTotal.toStringAsFixed(0)} • ${DateFormat('dd MMM hh:mm a').format(log.editedAt)}',
                        style: TextStyle(fontSize: 12, color: AppColors.error),
                      ),
                      children: [
                        FutureBuilder<List<EditedBillItem>>(
                          future: db.getEditedBillItems(log.id),
                          builder: (context, itemSnap) {
                            final items = itemSnap.data ?? [];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reason: ${log.reason}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                                  const SizedBox(height: 6),
                                  ...items.map((i) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('• ${i.itemName}', style: const TextStyle(fontSize: 12)),
                                            Text('${i.oldQuantity}x ➔ ${i.newQuantity}x (@ ₹${i.itemPrice})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.error)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        primaryButtonText: 'Close',
        onPrimary: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title,
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary)),
        subtitle: Text(subtitle,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );

  }
}
