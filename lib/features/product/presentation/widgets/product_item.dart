import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/app_route.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity data;
  const ProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.detailProductPage,
            arguments: data);
      },
      child: Container(
        width: 180,
        height: 270,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: kMainTextColor.withValues(alpha: 0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 4))
          ],
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -- GAMBAR
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: ExtendedImage.network(
                  data.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  handleLoadingProgress: true,
                  cache: true,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          color: mainColor.withValues(alpha: 0.2),
                          child: Icon(
                            size: 32,
                            Icons.broken_image,
                            color: mainColor.withValues(alpha: 0.4),
                          ),
                        ),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          color: whiteColor,
                        ),
                      );
                    }
                    return state.completedWidget;
                  },
                ),
              ),
            ),

           

            /// --- Detail
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        height: 34,
                        child: Text(
                          data.title,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: kMainTextColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Spacer(),
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Rp. ${data.price}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: bold, fontSize: 15),
                          ),
                        ),
                        Material(
                          color: mainColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            onTap: () {
                               _launcherUrl(context, data.link);
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icon_shop.svg',
                                  width: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _launcherUrl(BuildContext context, String link) async {
    !await launchUrl(Uri.parse(link),
        mode: LaunchMode.externalApplication);
  }