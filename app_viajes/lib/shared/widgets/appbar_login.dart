import 'package:flutter/material.dart';

class AppViajesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const AppViajesAppBar({super.key, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/aa.png', height: 40),
          const SizedBox(width: 8),
          if (title != null)
            Text(title!, style: const TextStyle(color: Colors.black)),
        ],
      ),
      actions: actions,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
