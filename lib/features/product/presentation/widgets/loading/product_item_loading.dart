import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:skinsight/core/theme/app_color.dart';

class ProductItemLoading extends StatelessWidget {
  final bool isSkeleton;

  const ProductItemLoading({
    super.key,
    this.isSkeleton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSkeleton ? null : () {},
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kMainTextColor.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GAMBAR
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: isSkeleton
                    ? Skeleton.replace(
                        width: double.infinity,
                        height: double.infinity,
                        child: Container(color: Colors.grey),
                      )
                    : ExtendedImage.network(
                        '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        handleLoadingProgress: true,
                        cache: true,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState == LoadState.failed) {
                            return AspectRatio(
                              aspectRatio: 1,
                              child: Material(
                                color: mainColor.withOpacity(0.2),
                                child: Icon(
                                  size: 100,
                                  Icons.broken_image,
                                  color: mainColor.withOpacity(0.4),
                                ),
                              ),
                            );
                          }
                          if (state.extendedImageLoadState == LoadState.loading) {
                            return Container(color: whiteColor);
                          }
                          return null;
                        },
                      ),
              ),
            ),

            /// DETAIL
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  SizedBox(
                    height: 34,
                    child: Text(
                      'titleeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kMainTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// HARGA & BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// HARGA
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'HArgannbdhvb',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: bold,
                                fontSize: 15,
                              ),
                        ),
                      ),

                      /// ICON SHOP
                      Skeleton.ignore(
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: const BorderRadius.only(
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
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
