import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.compact = false, this.showLabel = true});

  final bool compact;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = compact ? 32.0 : 48.0;
    final iconSize = compact ? 16.0 : 22.0;

    final label = Text(
      'NovaCart',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
        color: showLabel ? colorScheme.onSurface : Colors.transparent,
      ),
    );

    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.shopping_bag_rounded, color: Colors.white, size: iconSize),
          Positioned(
            right: size * 0.16,
            top: size * 0.14,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );

    if (!showLabel) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [mark, const SizedBox(width: 12), label],
    );
  }
}
