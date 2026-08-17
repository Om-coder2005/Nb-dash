import 'package:flutter/material.dart';
import 'package:nextbills/app/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nb_button.dart';
import 'nb_card.dart';

class NbDialog extends StatelessWidget {
  final String title;
  final Widget customContent;
  final String primaryButtonText;
  final VoidCallback onPrimary;
  final String? secondaryButtonText;
  final VoidCallback? onSecondary;
  final bool isDanger;

  const NbDialog({
    super.key,
    required this.title,
    required this.customContent,
    required this.primaryButtonText,
    required this.onPrimary,
    this.secondaryButtonText,
    this.onSecondary,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: NbCard(
          width: 400,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.border),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: customContent,
              ),
              Divider(height: 1, color: AppColors.border),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (secondaryButtonText != null && onSecondary != null) ...[
                      NbButton(
                        text: secondaryButtonText!,
                        type: NbButtonType.ghost,
                        onPressed: onSecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    NbButton(
                      text: primaryButtonText,
                      type: isDanger ? NbButtonType.danger : NbButtonType.primary,
                      onPressed: onPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => NbDialog(
        title: title,
        customContent: Text(
          message,
          style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textSecondary),
        ),
        primaryButtonText: confirmText,
        onPrimary: () => Navigator.of(ctx).pop(true),
        secondaryButtonText: cancelText,
        onSecondary: () => Navigator.of(ctx).pop(false),
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }
}
