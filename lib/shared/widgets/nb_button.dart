import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';

enum NbButtonType { primary, secondary, danger, ghost, outline, success }

class NbButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final NbButtonType type;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const NbButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = NbButtonType.primary,
    this.isLoading = false,
    this.isExpanded = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<NbButton> createState() => _NbButtonState();
}

class _NbButtonState extends State<NbButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: AppDurations.fast);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    _scaleController.forward();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null || widget.isLoading) return;
    _scaleController.reverse();
    setState(() => _isPressed = false);
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    _scaleController.reverse();
    setState(() => _isPressed = false);
  }

  Color _getBackgroundColor(BuildContext context, bool isDark) {
    if (widget.onPressed == null) return AppColors.border;
    switch (widget.type) {
      case NbButtonType.primary:
        return AppColors.primary;
      case NbButtonType.secondary:
        return AppColors.surface;
      case NbButtonType.danger:
        return AppColors.error;
      case NbButtonType.success:
        return AppColors.success;
      case NbButtonType.ghost:
      case NbButtonType.outline:
        return _isHovered ? (isDark ? Colors.white10 : Colors.black12) : Colors.transparent;
    }
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    if (widget.onPressed == null) return AppColors.textMuted;
    switch (widget.type) {
      case NbButtonType.primary:
        return Colors.white; // As per Stitch design
      case NbButtonType.danger:
      case NbButtonType.success:
        return Colors.white;
      case NbButtonType.secondary:
      case NbButtonType.ghost:
      case NbButtonType.outline:
        return AppColors.textPrimary;
    }
  }

  Border? _getBorder(BuildContext context, bool isDark) {
    if (widget.type == NbButtonType.outline) {
      return Border.all(color: AppColors.border, width: 1);
    }
    if (widget.type == NbButtonType.secondary) {
      return Border.all(color: AppColors.border, width: 1);
    }
    return null;
  }

  List<BoxShadow>? _getShadows(BuildContext context, bool isDark) {
    if (widget.onPressed == null || widget.type == NbButtonType.ghost || widget.type == NbButtonType.outline) return null;
    
    // Normal / Hovered state (Ambient Lift)
    if (widget.type == NbButtonType.primary || widget.type == NbButtonType.danger || widget.type == NbButtonType.secondary || widget.type == NbButtonType.success) {
       if (_isHovered && !_isPressed) {
         return AppShadows.ambient(isDark).map((s) => BoxShadow(
          color: s.color,
          offset: s.offset,
          blurRadius: s.blurRadius * 1.5,
          spreadRadius: s.spreadRadius,
        )).toList();
       }
       return AppShadows.ambient(isDark);
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    Widget content = AnimatedContainer(
      duration: AppDurations.fast,
      width: widget.width ?? (widget.isExpanded ? double.infinity : null),
      height: widget.height ?? 56.0,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context, isDark),
        borderRadius: AppRadius.pillBorder, // 999px

        border: _getBorder(context, isDark),
        boxShadow: _getShadows(context, isDark),
      ),
      child: Row(
        mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isLoading) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(context, isDark)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ] else if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: _getTextColor(context, isDark)),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            widget.text,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8, // 0.05em
              color: _getTextColor(context, isDark),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _isHovered && !isDisabled && !_isPressed ? 1.02 : (_isPressed ? 0.96 : 1.0),
          duration: AppDurations.fast,
          curve: Curves.easeOutExpo,
          child: AnimatedOpacity(
            opacity: _isHovered && !isDisabled ? 0.9 : 1.0,
            duration: AppDurations.fast,
            child: content,
          ),
        ),
      ),
    );
  }
}
