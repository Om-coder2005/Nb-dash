import 'package:flutter/material.dart';
import 'package:nextbills/app/theme.dart';
import 'package:google_fonts/google_fonts.dart';

enum NbToastType { success, error, info, warning }

class NbToast {
  static void show(
    BuildContext context,
    String message, {
    NbToastType type = NbToastType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color iconColor;
    IconData defaultIcon;

    switch (type) {
      case NbToastType.success:
        bgColor = isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
        iconColor = AppColors.success;
        defaultIcon = Icons.check_circle;
        break;
      case NbToastType.error:
        bgColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        iconColor = AppColors.error;
        defaultIcon = Icons.error;
        break;
      case NbToastType.warning:
        bgColor = isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);
        iconColor = AppColors.warning;
        defaultIcon = Icons.warning;
        break;
      case NbToastType.info:
      default:
        bgColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
        iconColor = AppColors.info;
        defaultIcon = Icons.info;
        break;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (context) => _NbToastWidget(
        message: message,
        bgColor: bgColor,
        iconColor: iconColor,
        icon: icon ?? defaultIcon,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _NbToastWidget extends StatefulWidget {
  final String message;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  const _NbToastWidget({
    required this.message,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_NbToastWidget> createState() => _NbToastWidgetState();
}

class _NbToastWidgetState extends State<_NbToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.normal);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    
    Future.delayed(widget.duration - AppDurations.normal, () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: AppRadius.lgBorder,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: widget.iconColor, size: 20),
                      const SizedBox(width: AppSpacing.md),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white 
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
