import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/scan_type_skin/domain/entities/scan_image_entity.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/ui/custom_button.dart';


class ScanImagePage extends StatefulWidget {
  const ScanImagePage({super.key});

  @override
  State<ScanImagePage> createState() => _ScanImagePageState();
}

class _ScanImagePageState extends State<ScanImagePage> {
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Scan your face',
          style: blackRobotoTextStyle.copyWith(
              color: Colors.black, fontSize: 20, fontWeight: semiBold),
        ),
      ),
      body:  ListView(
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
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction1.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Do not wear face coverings'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction2.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text('No other objects in the frame'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction3.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Sit in a good lighting'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon_scan_intruction4.png',
                            width: 26,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Relax your face.'),
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
                 Navigator.pushNamed(context, AppRoute.cameraScanImagePage);
                },
              ),
              SizedBox(
                height: 40,
              ),
//               Image.asset(
//   'assets/loading.gif',
//   fit: BoxFit.cover,
// )
            ],
          )
    );
  }
}


class ScanImageResultArgument {
  final ScanImageEntity scanImage;
  final File? file;

  ScanImageResultArgument({required this.scanImage, required this.file});
}
