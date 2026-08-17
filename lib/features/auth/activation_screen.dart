import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _keyController = TextEditingController();
  final _targetHash = 'f426897f1b73d84bfc9d5c419f2f6deaeb35583e5269ee7b40eb85560d239e0c';
  
  bool _isChecking = false;
  bool _isLockedOut = false;
  int _lockoutSecondsLeft = 0;
  int _failedAttempts = 0;
  Timer? _lockoutTimer;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLockoutStatus();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLockoutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _failedAttempts = prefs.getInt('activation_failed_attempts') ?? 0;
    
    final lockoutUntilStr = prefs.getString('activation_lockout_until');
    if (lockoutUntilStr != null) {
      final lockoutUntil = DateTime.tryParse(lockoutUntilStr);
      if (lockoutUntil != null) {
        final now = DateTime.now();
        if (lockoutUntil.isAfter(now)) {
          final diff = lockoutUntil.difference(now).inSeconds;
          _startLockoutTimer(diff);
        } else {
          setState(() {
            _isLockedOut = false;
          });
        }
      }
    }
  }

  void _startLockoutTimer(int seconds) {
    _lockoutTimer?.cancel();
    setState(() {
      _isLockedOut = true;
      _lockoutSecondsLeft = seconds;
      _errorMessage = 'Too many failed attempts. Locked out.';
    });

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_lockoutSecondsLeft <= 1) {
            _isLockedOut = false;
            _errorMessage = '';
            timer.cancel();
          } else {
            _lockoutSecondsLeft--;
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _activate() async {
    if (_isChecking || _isLockedOut) return;

    final input = _keyController.text.trim();
    if (input.isEmpty) {
      setState(() => _errorMessage = 'Please enter activation key');
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = '';
    });

    // Artificially wait 800ms to mimic secure online/computation verify
    await Future.delayed(const Duration(milliseconds: 800));

    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes).toString().toLowerCase();

    if (hash == _targetHash) {
      // Success
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_activated', true);
      await prefs.setInt('activation_failed_attempts', 0);
      await prefs.remove('activation_lockout_until');
      
      HapticFeedback.mediumImpact();
      if (mounted) {
        context.goNamed('pin');
      }
    } else {
      // Fail
      _failedAttempts++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('activation_failed_attempts', _failedAttempts);

      // Lockout duration = 2^failedAttempts seconds, capped at 5 minutes (300 seconds)
      final durationSeconds = min(pow(2, _failedAttempts).toInt(), 300);
      final lockoutUntil = DateTime.now().add(Duration(seconds: durationSeconds));
      await prefs.setString('activation_lockout_until', lockoutUntil.toIso8601String());

      HapticFeedback.heavyImpact();
      setState(() {
        _isChecking = false;
        _errorMessage = 'Invalid activation key!';
      });
      _startLockoutTimer(durationSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF1E2638), Color(0xFF0F111A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isTablet ? 420 : double.infinity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shield Icon (Lock Indicator)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isLockedOut 
                              ? [AppColors.error, const Color(0xFFC0392B)]
                              : [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isLockedOut ? AppColors.error : AppColors.primary).withOpacity(0.35),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isLockedOut ? Icons.gpp_bad_rounded : Icons.vpn_key_rounded,
                        color: _isLockedOut ? Colors.white : Colors.black,
                        size: 44,
                      ),
                    ),
                    SizedBox(height: 28),

                    // Header Texts
                    Text(
                      'App Activation',
                      style: GoogleFonts.manrope(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please enter your product activation key to license this device offline.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 36),

                    // Key Input Field
                    NbInput(
                      controller: _keyController,
                      hintText: 'NB-XXXX-XXXX-XXXX-XXXX',
                      readOnly: _isChecking || _isLockedOut,
                    ),
                    
                    // Error / Lockout Messages
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.error.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.error, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _isLockedOut 
                                    ? 'Locked out. Try again in ${_lockoutSecondsLeft}s'
                                    : _errorMessage,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 32),

                    // Submit Button
                    NbButton(
                      text: 'Activate Device',
                      isExpanded: true,
                      isLoading: _isChecking,
                      onPressed: (_isChecking || _isLockedOut) ? null : _activate,
                    ),
                    SizedBox(height: 24),
                    
                    // Contact Info
                    Text(
                      'Contact NextBills for licensing support.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textMuted.withOpacity(0.5),
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
}
