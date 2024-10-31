import 'package:flutter/material.dart';
import 'package:flutter_base_setup/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return IconButton(
      icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
            themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      },
    );
  }
}
