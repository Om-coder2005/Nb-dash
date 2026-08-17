import 'package:flutter/material.dart';
import 'package:nextbills/app/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/core/utils/keyboard_helper.dart';

enum NbInputType { text, search, number, password }

class NbInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final NbInputType type;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final bool autofocus;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;

  const NbInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.type = NbInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
  });

  @override
  State<NbInput> createState() => _NbInputState();
}

class _NbInputState extends State<NbInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == NbInputType.password;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_focusNode.hasFocus && widget.type == NbInputType.search) {
        launchWindowsVirtualKeyboard();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? actualSuffixIcon = widget.suffixIcon;
    if (widget.type == NbInputType.password) {
      actualSuffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted, size: 20),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8, // 0.05em
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        AnimatedContainer(
          duration: AppDurations.fast,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: AppRadius.pillBorder, // 999px
            border: _isFocused 
                ? Border.all(color: AppColors.primary, width: 1.5) 
                : Border.all(color: AppColors.border, width: 1.0),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            obscureText: _obscureText,
            keyboardType: widget.type == NbInputType.number ? TextInputType.number : TextInputType.text,
            maxLength: widget.maxLength,
            maxLines: widget.type == NbInputType.password ? 1 : widget.maxLines,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            onChanged: widget.onChanged,
            onSubmitted: (_) => widget.onSubmitted?.call(),
            onTap: () {
              if (widget.type == NbInputType.search) {
                launchWindowsVirtualKeyboard();
              }
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: GoogleFonts.manrope(color: AppColors.textMuted, fontSize: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? AppSpacing.xs : AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 4.0),
                      child: Icon(widget.prefixIcon, color: _isFocused ? AppColors.primary : AppColors.textMuted, size: 18),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: actualSuffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
