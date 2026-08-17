import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nextbills/app/theme.dart';

class NbAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const NbAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      titleSpacing: showBack ? 0 : 20,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => context.go('/pos'),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        if (actions != null) ...actions!,
      ],
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: bottom!.preferredSize,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: bottom!,
              ),
            )
          : null,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
