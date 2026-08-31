import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CountdownOverlay extends StatelessWidget {
  final int count;

  const CountdownOverlay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
            key: ValueKey<int>(count),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryAccent.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.secondaryAccent.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.black,
                    offset: Offset(4.0, 4.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
