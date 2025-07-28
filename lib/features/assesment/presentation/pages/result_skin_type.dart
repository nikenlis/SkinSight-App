import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/custom_button.dart';

import '../../../../core/common/app_route.dart';
import 'scan_skin_type_page.dart';

class ResultSkinType extends StatelessWidget {
  final SkinTypeResultArgument data;
  const ResultSkinType({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ExtendedImage.file(
        data.file,
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
                data.assesment.predictedLabel!, 
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
              ...buildConcernItem("Dry", data.assesment.dry.toString()),
              ...buildConcernItem("Normal", data.assesment.normal.toString()),
              ...buildConcernItem("Oily", data.assesment.oily.toString()),
              const SizedBox(height: 30),

              // Button
              FilledButtonItems(title: 'Continue', onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context,
                        AppRoute.assesmentSuccessPage, (route) => false);
              },), 
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
