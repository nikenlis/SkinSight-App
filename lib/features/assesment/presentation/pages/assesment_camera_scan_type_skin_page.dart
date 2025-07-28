import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/circle_loading.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../scan_ingredients/presentation/pages/scan_ingredients/crop_image_ingredients_page.dart';
import '../../domain/entities/assesment_form_entity.dart';
import '../bloc/assesment_bloc.dart';
import 'scan_skin_type_page.dart';

class AssesmentCameraScanTypeSkinPage extends StatefulWidget {
  const AssesmentCameraScanTypeSkinPage({super.key});

  @override
  State<AssesmentCameraScanTypeSkinPage> createState() =>
      _AssesmentCameraScanTypeSkinPageState();
}

class _AssesmentCameraScanTypeSkinPageState
    extends State<AssesmentCameraScanTypeSkinPage> {
  File? _capturedImage;
  File? selectedImage;

  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      imageResolution: ImageResolution.high,
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
      },
      onFaceDetected: (Face? face) {
        //Do something
      },
    );
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AssesmentBloc, AssesmentState>(
      listener: (context, state) {
        if (state is AssesmentWithScanImageLoading) {
          showLoadingDialog(context);
        } else if (state is AssesmentWithScanImageFailed) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          Future.microtask(() async {
            if (mounted) {
              if (state.message
                  .toLowerCase()
                  .contains('face detection failed')) {
                await controller.stopImageStream();
                showFaceNotDetectedDialog(context);
              } else if (state.message.toLowerCase().contains('internet')) {
                Navigator.pushNamed(context, AppRoute.noConnectionPage);
              } else {
                showCustomSnackbar(context, state.message);
              }
            }
          });
        } else if (state is AssesmentWithScanImageLoaded) {
          Future.microtask(() {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.resultSkinTypePage,
                (route) => false,
                arguments: SkinTypeResultArgument(
                  assesment: state.data,
                  file:  _capturedImage!,
                ),
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Builder(builder: (context) {
          if (_capturedImage != null) {
            return body(context);
          }
          return SmartFaceCamera(
            controller: controller,
            autoDisableCaptureControl: false,
            messageBuilder: (context, face) {
              if (face == null) {
                return _message('Place your face in the camera');
              }
              if (!face.wellPositioned) {
                return _message('Center your face in the square');
              }
              return const SizedBox.shrink();
            },

            /// ---CAMERA
            captureControlBuilder: (context, face) {
              return CircleAvatar(
                radius: 35,
                backgroundColor: Colors.black12,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                ),
              );
            },
            flashControlBuilder: (context, flashMode) {
              IconData icon;
              switch (flashMode) {
                case CameraFlashMode.always:
                  icon = Icons.flash_on;
                  break;
                case CameraFlashMode.off:
                  icon = Icons.flash_off;
                  break;
                default:
                  icon = Icons.flash_auto;
              }

              return CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black12,
                child: Icon(icon, color: Colors.white),
              );
            },

            lensControlIcon: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black12,
              child: const Icon(Icons.switch_camera, color: Colors.white),
            ),
            indicatorShape: IndicatorShape.square,
          );
        });
      },
    ));
  }

  body(BuildContext context) {
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
                  future: _getImageSize(
                    _capturedImage!,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final imageSize = snapshot.data!;
                    final screenWidth = MediaQuery.of(context).size.width;

                    final aspectRatio = imageSize.width / imageSize.height;

                    final maxWidth = screenWidth * 0.85;
                    final maxHeight = MediaQuery.of(context).size.height * 0.65;

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
                          _capturedImage!,
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
                    'Crop to leave your face only',
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
                    onTap: () async {
                      try {
                        final croppedFile = await ImageCropper().cropImage(
                          sourcePath: _capturedImage!.path,
                          compressFormat: ImageCompressFormat.jpg,
                          compressQuality: 100,
                          uiSettings: [
                            AndroidUiSettings(
                              toolbarTitle: 'Crop Image',
                              toolbarColor: mainColor,
                              toolbarWidgetColor: Colors.white,
                              activeControlsWidgetColor: mainColor,
                              statusBarColor: mainColor,
                              initAspectRatio: CropAspectRatioPreset.original,
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
                              _capturedImage = File(compressedXFile.path);
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
                      onTap: () async {
                        await controller.startImageStream();
                        setState(() => _capturedImage = null);
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
                    if (_capturedImage == null ||
                        !_capturedImage!.existsSync()) {
                      showCustomSnackbar(context, 'No picture');
                      return;
                    }

                    context.read<AssesmentBloc>().add(UpdateFormEvent(
                        AssesmentFormEntity(scanImage: _capturedImage)));
                    context
                        .read<AssesmentBloc>()
                        .add(SubmitFormWithScanImageEvent());
                  },
                )
              ],
            )),
      ],
    );
  }

  Widget _message(String msg) => Container(
        margin: EdgeInsets.only(
            top: 60,
            bottom: MediaQuery.of(context).size.height / 1.38,
            left: 40,
            right: 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mainColor.withOpacity(0.2),
              mainColor.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            msg,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: whiteColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
