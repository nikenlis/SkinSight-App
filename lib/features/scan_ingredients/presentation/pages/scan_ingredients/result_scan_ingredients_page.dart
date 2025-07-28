import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/api/api_config.dart';
import '../../../../../core/common/app_route.dart';
import '../../../../../core/theme/app_color.dart';


class ResultScanIngredientsPage extends StatefulWidget {
  const ResultScanIngredientsPage({super.key, required this.data});
  final ScanIngredientsEntity data;
  

  @override
  State<ResultScanIngredientsPage> createState() =>
      _ResultScanIngredientsPageState();
}

class _ResultScanIngredientsPageState extends State<ResultScanIngredientsPage> {
  bool showAll = false;
  bool showAllHarmful = false;

  Future<void> _launcherUrl(BuildContext context) async {
    !await launchUrl(Uri.parse('https://wa.link/7mcrno'),
        mode: LaunchMode.externalApplication);
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
        appBar: AppBar(
          title: Text(
            'Scan Result',
            style: blackRobotoTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          centerTitle: false,
        ),
        body: ListView(
          children: [
            header(context),
            const SizedBox(height: 10),
            ingredientsInfo(context),
            const SizedBox(height: 10),
            ingredients(context),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            widget.data.productName,
            style: TextStyle(fontSize: 18, fontWeight: medium),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ExtendedImage.network(
                '${ApiConfig.imageBaseUrl}${widget.data.scanImage}',
                width: double.infinity,
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
                fit: BoxFit.contain,
                handleLoadingProgress: true,
                cache: true, loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.failed) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: mainColor.withValues(alpha: 0.2),
                    child: Icon(
                      size: 53,
                      Icons.broken_image,
                      color: mainColor.withValues(alpha: 0.4),
                    ),
                  ),
                );
              }
              if (state.extendedImageLoadState == LoadState.loading) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteColor,
                  ),
                );
              }
              return null;
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget ingredientsInfo(BuildContext context) {
    final harmful = widget.data.harmfulIngredientsFound;
    final visibleCount = 2;
    final showToggle = harmful.length > visibleCount;
    final visibleHarmful =
        showAllHarmful ? harmful : harmful.take(visibleCount).toList();

    return widget.data.isSafe
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No harmful ingredients for your skin type found in this product. Safe to use!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Harmful Ingredients',
                      style: blackRobotoTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'This product contains ingredients that may cause problems for your skin type.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),

                // tampilkan harmful ingredient (maks 3 atau semua)
                ...visibleHarmful.map((e) => Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.reason,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )),

                // tombol show more/less
                if (showToggle)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          showAllHarmful = !showAllHarmful;
                        });
                      },
                      icon: Icon(
                        showAllHarmful
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: blackColor,
                      ),
                      label: Text(
                        showAllHarmful ? 'Show less' : 'Show more',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
  }

  Widget ingredients(BuildContext context) {
    final extractedIngredients = widget.data.extractedIngredients;
    final visibleCount = 5;
    final hiddenCount = extractedIngredients.length - visibleCount;
    final visibleIngredients = showAll
        ? extractedIngredients
        : extractedIngredients.take(visibleCount).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: blackRobotoTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 10),
          ...visibleIngredients.asMap().entries.map((entry) {
            final index = entry.key;
            final ingredient = entry.value;
            final isLast = index == visibleIngredients.length - 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: mainColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ingredient,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// TOMBOL REPORT A MISTAKE
                if (showAll && isLast)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        _launcherUrl(context);
                      },
                      child: const Text(
                        'Report a mistake',
                        style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),

          /// TOMBOL EXPAND/COLLAPSE
          if (hiddenCount > 0)
            Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                icon: Icon(
                  showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: blackColor,
                ),
                label: Text(
                  showAll
                      ? 'Show less'
                      : '$hiddenCount more ingredient${hiddenCount > 1 ? "s" : ""}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: mainColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

     
}
