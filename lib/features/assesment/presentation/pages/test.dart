import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/circle_loading.dart';
import 'package:skinsight/core/ui/custom_button.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/ui/shared_method.dart';
import '../../domain/entities/assesment_form_entity.dart';
import '../bloc/assesment_bloc.dart';
import '../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';

class ScanSkinTypePage extends StatefulWidget {
  const ScanSkinTypePage({super.key});

  @override
  State<ScanSkinTypePage> createState() => _ScanSkinTypePageState();
}

class _ScanSkinTypePageState extends State<ScanSkinTypePage> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan your face',
        ),
      ),
      body: BlocConsumer<AssesmentBloc, AssesmentState>(
        listener: (context, state) {
          if (state is AssesmentWithScanImageLoading) {
            showLoadingDialog(context);
          } else if (state is AssesmentWithScanImageFailed) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (mounted) {
                if (state.message.toLowerCase().contains('face detection failed')) {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, 
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          Image.asset('assets/Icon_face_scan.png'),
                          SizedBox(width: 8),
                          Text(
                            'Face Not Detected',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        'We couldn’t detect any human face in the photo you just took.\n\n'
                        'Please make sure your face is clearly visible, well-lit, and directly facing the camera.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: mainColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          } ,
                          child: const Text('0k'),
                        ),
                      ],
                    ),
                  );
                } else if (state.message.toLowerCase().contains('internet')) {
                  Navigator.pushNamed(context, AppRoute.noConnectionPage);
                } else {
                  showCustomSnackbar(
                      context, state.message);
                }
              }
            });
          } else if (state is AssesmentWithScanImageLoaded) {
            Future.microtask(() {
              if (mounted) {
                context.read<BottomNavigationBarCubit>().change(0);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.resultSkinTypePage,
                  (route) => false,
                  arguments: SkinTypeResultArgument(
                    assesment: state.data,
                    file: selectedImage,
                  ),
                );
              }
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(
                height: 61,
              ),
              Text(
                'One click away from personalized skincare insights',
                style: blackRobotoTextStyle.copyWith(
                    color: Colors.black, fontSize: 20, fontWeight: regular),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 33,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 29, bottom: 49, left: 40, right: 40),
                  child: Column(
                    children: [
                      Text(
                        'Snap, Scan, Transform!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontSize: 18,
                                fontWeight: medium,
                                color: blackColor),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction1.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text('Do not wear face coverings')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction2.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text('No other objects in the frame')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction3.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text('Sit in a good lighting')),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction4.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text('Relax your face.')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              FilledButtonItems(
                title: 'Get started',
                onPressed: () async {
                  // final pickedFile = await ImagePicker().pickImage(
                  //   source: ImageSource.camera,
                  //   preferredCameraDevice: CameraDevice.front,
                  // );
                  // if (pickedFile != null) {
                  //   setState(() {
                  //     selectedImage = File(pickedFile.path);
                  //   });
                  //   context.read<AssesmentBloc>().add(UpdateFormEvent(
                  //       AssesmentFormEntity(scanImage: selectedImage)));
                  //   context.read<AssesmentBloc>().add(SubmitFormWithScanImageEvent());
                  // }

                  Navigator.pushNamed(context, AppRoute.cameraScanImagePage);
                  
                },
              )
            ],
          );
        },
      ),
    );
  }
}

class SkinTypeResultArgument {
  final AssesmentEntity assesment;
  final File? file;

  SkinTypeResultArgument({required this.assesment, required this.file});
}