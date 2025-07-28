import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/scan_ingredients/presentation/bloc/scan_ingredients/scan_ingredients_bloc.dart';

import '../../../../../core/common/app_route.dart';
import '../../../../../core/ui/circle_loading.dart';
import '../../../../../core/ui/custom_button.dart';
import '../../../../../core/ui/shared_method.dart';
import '../../../domain/entities/scan_ingredients_entity.dart';

// ignore: must_be_immutable
class CropImageIngredientsPage extends StatefulWidget {
  Map<String, dynamic> data;
  // File imageFile;
  CropImageIngredientsPage({super.key, required this.data});

  @override
  State<CropImageIngredientsPage> createState() =>
      _CropImageIngredientsPageState();
}

class _CropImageIngredientsPageState extends State<CropImageIngredientsPage> {
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          Future.microtask(() {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.bottomNavBar,
              (route) => false,
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ScanIngredientsBloc, ScanIngredientsState>(
          listener: (context, state) {
            if (state is ScanIngredientsLoading) {
              showLoadingDialog(context);
            } else if (state is ScanIngredientsFailed) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Future.microtask(() {
                if (mounted) {
                  if (state.message
                      .toLowerCase()
                      .trim()
                      .contains('no ingredients found')) {
                    showIngredientsNotDetectedDialog(context);
                  } else if (state.message.toLowerCase().contains('internet')) {
                    Navigator.pushNamed(context, AppRoute.noConnectionPage);
                  } else {
                    showCustomSnackbar(context, state.message);
                  }
                }
              });
            } else if (state is ScanIngredientsLoaded) {
              Future.microtask(() {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                if (mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoute.resultScanIngredientsPage,
                    arguments: ScanIngredientsEntity(
                      extractedIngredients: state.data.extractedIngredients,
                      harmfulIngredientsFound:
                          state.data.harmfulIngredientsFound,
                      isSafe: state.data.isSafe,
                      totalHarmfulIngredients:
                          state.data.totalHarmfulIngredients,
                      scanImage: state.data.scanImage,
                      productName: state.data.productName,
                      id: state.data.id,
                    ),
                  ).then((_) {
                    // Reset state setelah kembali dari halaman hasil
                    context
                        .read<ScanIngredientsBloc>()
                        .add(ResetScanIngredientsEvent());
                  });
                }
              });
            }
          },
          builder: (context, state) {
            return Stack(
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
                        'Preview Photo',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
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
                          future: _getImageSize(widget.data['imageFile']),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator(
                                color: mainColor,
                              );
                            }

                            final imageSize = snapshot.data!;
                            final screenWidth =
                                MediaQuery.of(context).size.width;

                            final aspectRatio =
                                imageSize.width / imageSize.height;

                            final maxWidth = screenWidth * 0.85;
                            final maxHeight =
                                MediaQuery.of(context).size.height * 0.65;

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
                                child: Image.file(
                                  widget.data['imageFile'],
                                  fit: BoxFit.contain,
                                ));
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
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
                            onTap: () async {
                              try {
                                final croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: widget.data['imageFile'].path,
                                  compressFormat: ImageCompressFormat.jpg,
                                  compressQuality: 100,
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Crop Image',
                                      toolbarColor: mainColor,
                                      toolbarWidgetColor: whiteColor,
                                      activeControlsWidgetColor: mainColor,
                                      statusBarColor: Colors.transparent,
                                      showCropGrid: false,
                                      initAspectRatio:
                                          CropAspectRatioPreset.original,
                                      lockAspectRatio: false,
                                      
                                    ),
                                    IOSUiSettings(
                                      title: 'Crop Image',
                                    ),
                                  ],
                                );

                                if (croppedFile != null) {
                                  XFile croppedXFile = XFile(croppedFile.path);
                                  final compressedXFile =
                                      await compressImage(croppedXFile);
                                  if (compressedXFile != null) {
                                    setState(() {
                                      widget.data['imageFile'] =
                                          File(compressedXFile.path);
                                    });
                                  }
                                }
                              } catch (e) {
                                showCustomSnackbar(context, e.toString());
                              }
                            },
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.crop,
                                color: whiteColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor, width: 2),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Material(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(28),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoute.cameraScanIngredientPage, (route) => false,
                                    arguments: widget.data["namaProduct"]);
                              },
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: mainColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        FilledButtonItems(
                          title: 'Continue',
                          width: 160,
                          onPressed: () {
                            context.read<ScanIngredientsBloc>().add(
                                  GetScanIngredientsEvent(
                                    image: widget.data['imageFile'],
                                    name: widget.data['namaProduct'],
                                  ),
                                );
                          },
                        )
                      ],
                    )),
              ],
            );
          },
        ),
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
