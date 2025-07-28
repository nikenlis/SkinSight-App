import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/features/product/domain/entities/product_filter_entity.dart';

import '../../../../core/api/api_config.dart';
import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';

class BrandItem extends StatelessWidget {
  final BrandEntity data;
  final bool enableSkeleton;
  const BrandItem({super.key, required this.data, this.enableSkeleton = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.detailBrandPage, arguments: data);
      },
      child: Skeletonizer.sliver(
        enabled: enableSkeleton,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              ///--Icon
              Flexible(
                child: Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ExtendedImage.network(
                      '${ApiConfig.imageBaseUrl}${data.image}',
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      cache: true, loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return Material(
                        borderRadius: BorderRadius.circular(8),
                        color: mainColor.withValues(alpha: 0.2),
                        child: Icon(
                          size: 20,
                          Icons.broken_image,
                          color: mainColor.withValues(alpha: 0.4),
                        ),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: whiteColor,
                        ),
                      );
                    }
                    return null;
                  }),
                ),
              ),

              /// -- Text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kMainTextColor),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.verified,
                          color: mainColor,
                          size: 12,
                        )
                      ],
                    ),
                    Text(
                      '${data.total} products',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withValues(alpha: 0.5)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
