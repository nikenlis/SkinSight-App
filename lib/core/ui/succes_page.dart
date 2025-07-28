
import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/custom_button.dart';

class SuccesPage extends StatelessWidget {
  const SuccesPage({
    super.key,
    required this.title,
    required this.subTitle,
    this.onPressed,
  });
  final String title;
  final String subTitle;
  final VoidCallback? onPressed;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        color: kMainTextColor,
                        fontWeight: semiBold,
                      ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 26,
            ),
            Text(
              subTitle,
              style: blackRobotoTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: regular,
                      color: kSecondaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButtonItems(
              width: 183,
              title: 'Get Started',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
