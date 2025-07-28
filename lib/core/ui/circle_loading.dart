
import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';


class CircleLoading extends StatelessWidget {
  const CircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dialog tidak bisa ditutup dengan klik di luar
    builder: (context) {
      return Center( 
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          ),
        ),
      );
    },
  );
}