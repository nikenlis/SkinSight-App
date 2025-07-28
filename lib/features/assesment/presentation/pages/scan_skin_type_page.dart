import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/custom_button.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_entity.dart';

import '../../../../core/common/app_route.dart';


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
      body: ListView(
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

                  Navigator.pushNamed(context, AppRoute.assesmentCameraSkinTypePage);
                  
                },
              )
            ],
          ),
    );
  }
}

class SkinTypeResultArgument {
  final AssesmentEntity assesment;
  final File file;

  SkinTypeResultArgument({required this.assesment, required this.file});
}