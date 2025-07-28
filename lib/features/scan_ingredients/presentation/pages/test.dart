import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';

import '../../../../core/ui/custom_button.dart';

class CropImageIngredientsPage extends StatefulWidget {
  final File imageFile;
  const CropImageIngredientsPage({super.key, required this.imageFile});

  @override
  State<CropImageIngredientsPage> createState() =>
      _CropImageIngredientsPageState();
}

Future<Size> _getImageSize(File imageFile) async {
  final completer = Completer<Size>();
  final image = Image.file(imageFile);
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      ));
    }),
  );
  return completer.future;
}

class _CropImageIngredientsPageState extends State<CropImageIngredientsPage> {
  final _cropController = CropController();
  Uint8List? _croppedImageBytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Grid background
          Positioned.fill(
            child: CustomPaint(
              painter: UniformGridPainter(
                color: kOutlineColor.withOpacity(0.6),
                interval: 38,
              ),
            ),
          ),

          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      mainColor.withOpacity(0.0),
                      mainColor.withOpacity(0.1),
                      mainColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fake AppBar di dalam body
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 10,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: kMainTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit photo',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kMainTextColor,
                      ),
                ),
              ],
            ),
          ),

          // Image + Hint text di tengah
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<Size>(
                    future: _getImageSize(widget.imageFile),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final imageSize = snapshot.data!;
                      final screenWidth = MediaQuery.of(context).size.width;

                      final aspectRatio = imageSize.width / imageSize.height;

                      final maxWidth = screenWidth * 0.85;
                      final maxHeight =
                          MediaQuery.of(context).size.height * 0.67;

                      double cropWidth = maxWidth;
                      double cropHeight = cropWidth / aspectRatio;

                      if (cropHeight > maxHeight) {
                        cropHeight = maxHeight;
                        cropWidth = cropHeight * aspectRatio;
                      }

                      return Container(
                        width: cropWidth,
                        height: cropHeight,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Crop(
                          image: widget.imageFile.readAsBytesSync(),
                          controller: _cropController,
                          onCropped: (croppedData) {
                            setState(() {
                              _croppedImageBytes = croppedData;
                            });
                          },
                          withCircleUi: false,
                          baseColor: Colors.transparent,
                          maskColor: Colors.black.withOpacity(0.3),
                          cornerDotBuilder: (size, index) => const DotControl(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withOpacity(0.2),
                          mainColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Crop to leave the front of the ingredient only',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kMainTextColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue button di bawah
          Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(28),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        _cropController.crop();
                      },
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.crop,
                          color: whiteColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  FilledButtonItems(
                    title: 'Continue',
                    width: 160,
                    onPressed: () {},
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class UniformGridPainter extends CustomPainter {
  final Color color;
  final double interval;

  UniformGridPainter({required this.color, this.interval = 38});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += interval) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += interval) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}