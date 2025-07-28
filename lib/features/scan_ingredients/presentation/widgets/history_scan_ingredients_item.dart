import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/api/api_config.dart';
import 'package:skinsight/core/theme/app_color.dart';

import '../../../../core/common/app_route.dart';
import '../../domain/entities/history_scan_ingredient_entity.dart';

class HistoryScanIngredientsItem extends StatelessWidget {
  final HistoryScanIngredientEntity data;
  final bool isLoading;
  const HistoryScanIngredientsItem(
      {super.key, required this.data, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.detailHistoryScanIngredientsPage,
             arguments: data.id );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              //   boxShadow: [
              //   BoxShadow(
              //       color: kMainTextColor.withValues(alpha: 0.1),
              //       blurRadius: 4,
              //       spreadRadius: 1,
              //       offset: const Offset(0, 4))
              // ],
              borderRadius: BorderRadius.circular(8),
              color: whiteColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isLoading
                    ? Container(
                        width: 109,
                        height: 109,
                        color: Colors.amber,
                      )
                    : ExtendedImage.network(
                        '${ApiConfig.imageBaseUrl}${data.scanImage}',
                        width: 109,
                        height: 109,
                        borderRadius: BorderRadius.circular(8),
                        shape: BoxShape.rectangle,
                        fit: BoxFit.cover,
                        cache: true, loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: mainColor.withValues(alpha: 0.2),
                              child: Icon(
                                size: 32,
                                Icons.broken_image,
                                color: mainColor.withValues(alpha: 0.4),
                              ),
                            ),
                          );
                        } else if (state.extendedImageLoadState ==
                            LoadState.loading) {
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
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: SizedBox(
                  height: 109,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontSize: 14,
                                    fontWeight: semiBold,
                                    color: kMainTextColor,
                                  ),
                        ),
                        SizedBox(
                          height: 12,
                        ),

                        isLoading
    ? Container(
        width: 50,
        height: 20,
        color: Colors.amber,
      )
    : data.isSafe
        ? Container(
            width: 75,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 223, 227, 198),
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                'Safe',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total harmful ingredient : ${data.totalHarmfulIngredients}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 10,
                    fontWeight: medium,
                    color: kSecondaryTextColor),
              ),
              const SizedBox(height: 8),
              Container(
                width: 75,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                ),
                child: Center(
                  child: Text(
                    'Harmful',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              )
            ],
          )

                        
                    //     data.isSafe
                    //         ? isLoading
                    // ? Container(
                    //     width: 50,
                    //     height: 20,
                    //     color: Colors.amber,
                    //   ): Container(
                    //     width: 75,
                    //             padding: EdgeInsets.symmetric(
                    //                 horizontal: 8, vertical: 4),
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(8),
                    //                 color: const Color.fromARGB(
                    //                     255, 223, 227, 198),
                    //                 border: Border.all(color: mainColor)),
                    //             child: Center(
                    //               child: Text(
                    //                 'Safe',
                    //                 style: Theme.of(context)
                    //                     .textTheme
                    //                     .labelLarge
                    //                     ?.copyWith(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: mainColor),
                    //               ),
                    //             ),
                    //           )
                    //         : Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 'Total harmful ingredient : ${data.totalHarmfulIngredients}',
                    //                 style: Theme.of(context)
                    //                     .textTheme
                    //                     .labelLarge
                    //                     ?.copyWith(
                    //                         fontSize: 10,
                    //                         fontWeight: medium,
                    //                         color: kSecondaryTextColor),
                    //               ),
                    //               SizedBox(
                    //                 height: 8,
                    //               ), isLoading
                    // ? Container(
                    //     width: 50,
                    //     height: 20,
                    //     color: Colors.amber,
                    //   ):
                    //               Container(
                    //                 width: 75,
                    //                 padding: EdgeInsets.symmetric(
                    //                     horizontal: 12, vertical: 4),
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(8),
                    //                     color: Colors.red.shade50,
                    //                     border: Border.all(color: Colors.red)),
                    //                 child: Center(
                    //                   child: Text(
                    //                     'Harmfull',
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .labelLarge
                    //                         ?.copyWith(
                    //                             fontSize: 10,
                    //                             fontWeight: FontWeight.bold,
                    //                             color: Colors.red),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
