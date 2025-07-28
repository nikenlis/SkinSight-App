import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/common/app_route.dart';

class CameraScanIngredientPage extends StatefulWidget {
  final String namaProduct;
  const CameraScanIngredientPage({super.key, required this.namaProduct});

  @override
  State<CameraScanIngredientPage> createState() =>
      _CameraScanIngredientPageState();
}

class _CameraScanIngredientPageState extends State<CameraScanIngredientPage> {
  File? _lastCapturedPhoto;
  FlashMode _flashMode = FlashMode.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CameraAwesomeBuilder.custom(
      // Important for rebuilding camera
      sensorConfig: SensorConfig.single(
        sensor: Sensor.position(SensorPosition.back),
        flashMode: _flashMode,
        aspectRatio: CameraAspectRatios.ratio_4_3,
        zoom: 0.0,
      ),
      saveConfig: SaveConfig.photo(
        pathBuilder: (sensors) async {
          final Directory extDir = await getTemporaryDirectory();
          final testDir = await Directory('${extDir.path}/camerawesome')
              .create(recursive: true);
          if (sensors.length == 1) {
            return SingleCaptureRequest(
              '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
              sensors.first,
            );
          }
          return MultipleCaptureRequest({
            for (final sensor in sensors)
              sensor:
                  '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : 'back_'}${DateTime.now().millisecondsSinceEpoch}.jpg',
          });
        },
      ),
      builder: (state, preview) {
        final isReady = state is PhotoCameraState;

        if (!isReady) {
          return const Center(child: CircularProgressIndicator(color: Colors.amber,));
        }

        return Stack(
          children: [
            // Toggle Flash Button
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: Icon(
                  _flashMode == FlashMode.on ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () async {
                  final newFlashMode = _flashMode == FlashMode.on
                      ? FlashMode.none
                      : FlashMode.on;

                  state.when(onPhotoMode: (photoState) async {
                    await photoState.sensorConfig.setFlashMode(newFlashMode);
                  });

                  setState(() {
                    _flashMode = newFlashMode;
                  });
                },
              ),
            ),

            // Switch Camera Button
            Positioned(
              bottom: 50,
              right: 20,
              child: AwesomeCameraSwitchButton(
                state: state,
                theme: AwesomeTheme(
                  buttonTheme: AwesomeButtonTheme(
                    foregroundColor: Colors.white,
                    iconSize: 24,
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),

            // Tombol ambil gambar
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () async {
                    state.when(
                      onPhotoMode: (photoState) async {
                        final result = await photoState.takePhoto();
                        final file = result.path;
                        if (file != null) {
                          setState(() {
                            _lastCapturedPhoto = File(file);
                          });

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => CropImageIngredientsPage(
                          //         imageFile: File(file)),
                          //   ),
                          // );

                          Navigator.pushNamed(
                              context, AppRoute.cropImageIngredientsPage,
                              arguments: {
                                "namaProduct": widget.namaProduct,
                                "imageFile": File(file)
                              });
                        }
                      },
                    );
                  },
                  customBorder: const CircleBorder(),
                  splashColor: Colors.white.withAlpha(100),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black12,
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Gallery Picker
            Positioned(
              bottom: 50,
              left: 20,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() {
                        _lastCapturedPhoto = File(picked.path);
                      });

                      Navigator.pushNamed(
                          context, AppRoute.cropImageIngredientsPage,
                          arguments: {
                            "namaProduct": widget.namaProduct,
                            "imageFile": File(picked.path)
                          });
                    }
                  },
                  customBorder: const CircleBorder(),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.photo_library, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
