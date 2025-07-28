import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';


class RecomendationProductItemLoading extends StatelessWidget {
  final ProductEntity data;
  const RecomendationProductItemLoading({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
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
                child: Bone(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.circular(8),
                ),
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
