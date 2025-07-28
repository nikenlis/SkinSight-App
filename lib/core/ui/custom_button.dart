import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';

class FilledButtonItems extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final double radius;

  const FilledButtonItems({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 56,
    this.radius = 28,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: onPressed == null
              ? WidgetStateProperty.all(
                  const Color.fromARGB(255, 209, 214, 185))
              : WidgetStateProperty.all(mainColor),
          overlayColor: WidgetStateProperty.all(
            whiteColor.withValues(alpha: 0.2),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                  color: whiteColor,
                ),
          ),
        ),
      ),
    );
  }
}

class OutlineButtonItems extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final double radius;
  final Color color;

  const OutlineButtonItems({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 56,
    this.radius = 28,
    this.color = mainColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(
            whiteColor.withValues(alpha: 0.2),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                  color: color,
                ),
          ),
        ),
      ),
    );
  }
}
