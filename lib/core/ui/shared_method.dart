


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:skinsight/core/theme/app_color.dart';

import 'package:lottie/lottie.dart'; // Tambahkan di pubspec.yaml



void showCustomSnackbar(BuildContext context, String message) {
  Flushbar(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    messageColor: Colors.red,
    borderColor: const Color(0xFFF44336),
    icon: Icon(
        Icons.info_outline_rounded,
        color: Colors.red,
      ),
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.red.shade50,
    borderRadius: BorderRadius.circular(16),
    duration: const Duration(seconds: 2),
  ).show(context);
}

void alertCustomSnackbar(BuildContext context, String message) {
  Flushbar(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    messageColor: mainColor,
    borderColor: mainColor,
    icon: Icon(
        Icons.info_outline_rounded,
        color: mainColor,
      ),
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: const Color.fromARGB(255, 223, 227, 198),
    borderRadius: BorderRadius.circular(16),
    duration: const Duration(seconds: 2),
  ).show(context);
}


Future<XFile?> compressImage(XFile imageFile) async {
  final outputPath = "${imageFile.path}_compressed.jpg";
  
  // Kompres gambar
  XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
    imageFile.path,       // Path input gambar
    outputPath,           // Path output gambar
    quality: 70,          // Kualitas kompresi (0-100)
  );
  
  return compressedFile;
}



String formatDate(String rawDate) {
  final DateTime date = DateTime.parse(rawDate);
  return DateFormat('MMM d, y').format(date);
}

extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}



Future<void> showFaceNotDetectedDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Tidak bisa ditutup sembarangan
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Container(
                color: whiteColor,
                height: 120,
                width: 120,
                child:Image.asset('assets/scan.gif')
              ),

              const SizedBox(height: 20),

              
              Text(
                'We couldn’t detect any human face in the photo you just took',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kMainTextColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please make sure your face is clearly visible, well-lit, and directly facing the camera.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: kSecondaryTextColor,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ✅ Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



Future<void> showIngredientsNotDetectedDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Tidak bisa ditutup sembarangan
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Animated GIF or Lottie
              Container(
                color: whiteColor,
                height: 120,
                width: 120,
                child: Image.asset('assets/scan_text.gif')
              ),

              const SizedBox(height: 20),

              // ✅ Texts
              Text(
                'Error',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kMainTextColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'No ingredients found in the scan image',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: kSecondaryTextColor,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ✅ Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



