import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';

import '../../../../core/common/app_route.dart';

class RecomendationProductItem extends StatelessWidget {
  final ProductEntity data;
  const RecomendationProductItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.pushNamed(context, AppRoute.detailProductPage,
            arguments: data);
      },
      child: Container(
        width: 100,
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
                child:  ExtendedImage.network(
                  data.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  handleLoadingProgress: true,
                  cache: true,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: whiteColor,
                        ),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.failed) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Material(
                          color: mainColor.withValues(alpha: 0.2),
                          child: Icon(
                            size: 24,
                            Icons.broken_image,
                            color: mainColor.withValues(alpha: 0.6),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ) 
              ),
            ),
    
            /// --- Detail
            Padding(
              padding: EdgeInsets.all(8),
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
            )
          ],
        ),
      ),
    );
  }
}
