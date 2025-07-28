import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/features/scan_type_skin/presentation/pages/scan_image_page.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';

class ResultScanImagePage extends StatelessWidget {
  const ResultScanImagePage({super.key, required this.data});
  final ScanImageResultArgument data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ExtendedImage.file(
        data.file!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState == LoadState.failed) {
            return AspectRatio(
              aspectRatio: 9 / 16,
              child: Material(
                color: mainColor.withValues(alpha: 0.2),
                child: Icon(
                  size: 100,
                  Icons.broken_image,
                  color: mainColor.withValues(alpha: 0.4),
                ),
              ),
            );
          }
          return null;
        },
      ),

      // Blur overlay
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
        ),
      ),

      // Content
      Positioned.fill(
          child: Column(children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Predicted label
              Text(
                'Your Skin Type is',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.scanImage.predictedLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Concerns',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),

              // Concern Items
              ...buildConcernItem("Dry", data.scanImage.dry.toString()),
              ...buildConcernItem("Normal", data.scanImage.normal.toString()),
              ...buildConcernItem("Oily", data.scanImage.oily.toString()),
              const SizedBox(height: 30),

              // Button
              OutlineButtonItems(
                title: 'Back to home',
                color: whiteColor,
                onPressed: () {
                  context.read<BottomNavigationBarCubit>().change(0);
                   Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.bottomNavBar, (route) => false,);
                },
              ),
              const SizedBox(height: 16),
              FilledButtonItems(
                title: 'Recommendation Product',
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoute.recomendationProductPage,);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        )
      ]))
    ]));
  }

  buildConcernItem(String label, String value) {
    return [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      )
    ];
  }
}
