import 'package:flutter/material.dart';
import 'package:nextbills/app/theme.dart';

enum NbCardStyle { flat, neumorphic, outlined }

class NbCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final NbCardStyle style;
  final double? width;
  final double? height;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const NbCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.style = NbCardStyle.neumorphic, // Default to neumorphic for Stitch UI
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  @override
  State<NbCard> createState() => _NbCardState();
}

class _NbCardState extends State<NbCard> {
  bool _isHovered = false;

  List<BoxShadow>? _getShadows(BuildContext context, bool isDark) {
    if (widget.style == NbCardStyle.outlined) return null;
    
    if (widget.style == NbCardStyle.neumorphic) {
      if (_isHovered && widget.onTap != null) {
        return AppShadows.ambient(isDark).map((s) => BoxShadow(
          color: s.color,
          offset: s.offset,
          blurRadius: s.blurRadius * 1.5,
          spreadRadius: s.spreadRadius,
        )).toList();
      }
      return AppShadows.ambient(isDark);
    }
    
    // Flat style
    if (_isHovered && widget.onTap != null) {
      return [
        BoxShadow(
          color: isDark ? Colors.black26 : Colors.black12,
          offset: const Offset(0, 4),
          blurRadius: 12,
        )
      ];
    }
    
    return [
      BoxShadow(
        color: isDark ? Colors.black12 : Colors.black.withOpacity(0.04),
        offset: const Offset(0, 2),
        blurRadius: 8,
      )
    ];
  }

  Border? _getBorder(BuildContext context, bool isDark) {
    if (widget.style == NbCardStyle.outlined) {
      return Border.all(color: AppColors.border, width: 1);
    }
    if (widget.style == NbCardStyle.flat) {
      return Border.all(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.03), width: 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget content = AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeOutExpo,
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? EdgeInsets.all(AppSpacing.lg), // 32px
      decoration: BoxDecoration(
        color: widget.style == NbCardStyle.neumorphic ? AppColors.card : AppColors.surface,
        borderRadius: widget.shape == BoxShape.circle ? null : (widget.borderRadius ?? AppRadius.lgBorder), // 24px
        shape: widget.shape,
        border: _getBorder(context, isDark),
        boxShadow: _getShadows(context, isDark),
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: AppDurations.normal,
        curve: Curves.easeOutExpo,
        child: content,
      );
    }

    if (widget.onTap != null) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
