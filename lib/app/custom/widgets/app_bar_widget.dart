import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWidget({super.key, required this.title, this.action});
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.of(context)
            .regular32
            .copyWith(color: AppColors.of(context).neutralColor12),
      ),
      centerTitle: true,
      actions: [action ?? Container()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
