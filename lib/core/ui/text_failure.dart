import 'package:flutter/material.dart';

import '../theme/app_color.dart';
class TextFailure extends StatelessWidget {
  final String message;
  const TextFailure({super.key, this.message = 'Failed to load data'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message, style: const TextStyle(color: greyColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}