import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:nextbills/features/printer/sound_service.dart';

final _pinProvider = StateProvider<String>((ref) => '');
final _shakeProvider = StateProvider<bool>((ref) => false);

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoTranslateY;
  late Animation<double> _contentOpacity;
  late Animation<double> _contentTranslateY;
  String _hotelName = 'NextBills';
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _logoTranslateY = Tween<double>(begin: 180.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeInOutCubic),
      ),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _contentTranslateY = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _logoController.forward();
    _loadHotelName();
  }

  Future<void> _loadHotelName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _hotelName = prefs.getString('hotel_name') ?? 'NextBills');
    
    final isActivated = prefs.getBool('is_activated') ?? false;
    if (!isActivated) {
      if (mounted) {
        context.goNamed('activation');
      }
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    final pin = ref.read(_pinProvider);
    if (pin.length < 4) {
      ref.read(_pinProvider.notifier).state = pin + digit;
      HapticFeedback.lightImpact();
      if (ref.read(_pinProvider).length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    final pin = ref.read(_pinProvider);
    if (pin.isNotEmpty) {
      ref.read(_pinProvider.notifier).state = pin.substring(0, pin.length - 1);
      HapticFeedback.lightImpact();
    }
  }

  Future<String> _getCorrectPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_pin') ?? '1234';
  }

  Future<void> _verifyPin() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final entered = ref.read(_pinProvider);
    final correct = await _getCorrectPin();

    if (entered == correct) {
      HapticFeedback.mediumImpact();
      setState(() {
        _failedAttempts = 0;
      });
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final hasPrinter = prefs.containsKey('printer_name');
        if (hasPrinter) {
          context.goNamed('pos');
        } else {
          context.goNamed('printer');
          NbToast.show(context, 'Please select a default printer to continue!', type: NbToastType.info);
        }
      }
    } else {
      HapticFeedback.heavyImpact();
      _shakeController.reset();
      _shakeController.forward();
      ref.read(_pinProvider.notifier).state = '';
      setState(() {
        _failedAttempts++;
      });
    }
  }

  void _showRecoveryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Password',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter recovery code to reset PINs to default (PIN: 1234):',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter recovery code',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF0A0A0F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (controller.text == 'help--@password') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('app_pin', '1234');
                await prefs.setString('admin_pin', '9469');
                setState(() {
                  _failedAttempts = 0;
                });
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  NbToast.show(context, 'PINs reset to default successfully!', type: NbToastType.success);
                }
              } else {
                NbToast.show(ctx, 'Incorrect recovery code', type: NbToastType.error);
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(_pinProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF1C1C2E), Color(0xFF0A0A0F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isTablet ? 400 : double.infinity),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with entrance animation (growing from center, then moving up)
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0.0, _logoTranslateY.value),
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotate.value * 2 * 3.14159,
                              child: Opacity(
                                opacity: _logoOpacity.value,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),

                    // Password window and content that slides up and fades in
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _contentOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0.0, _contentTranslateY.value),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            _hotelName,
                            style: GoogleFonts.manrope(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enter PIN to continue',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // PIN dots
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              final offset = _shakeController.isAnimating
                                  ? ((_shakeAnimation.value * 20) *
                                      ((_shakeAnimation.value * 10).toInt().isEven ? 1 : -1))
                                  : 0.0;
                              return Transform.translate(
                                offset: Offset(offset, 0),
                                child: child,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (i) {
                                final filled = i < pin.length;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  width: filled ? 18 : 16,
                                  height: filled ? 18 : 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filled
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: filled
                                          ? AppColors.primary
                                          : Colors.white24,
                                      width: 2,
                                    ),
                                    boxShadow: filled
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Number pad
                          _buildNumberPad(),

                          if (_failedAttempts >= 10) ...[
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _showRecoveryDialog,
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: buttons.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((digit) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: _NumButton(
                  label: digit,
                  onTap: digit.isEmpty
                      ? null
                      : digit == 'del'
                          ? _onDelete
                          : () => _onDigit(digit),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _NumButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return SizedBox(width: 80, height: 80);

    final isDel = label == 'del';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        splashColor: AppColors.primaryGlow,
        highlightColor: AppColors.primaryGlow,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.card,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Center(
            child: isDel
                ? Icon(Icons.backspace_outlined,
                    color: AppColors.textSecondary, size: 22)
                : Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
