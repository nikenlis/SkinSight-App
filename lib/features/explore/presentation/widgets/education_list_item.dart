import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/features/explore/domain/entities/education_entity.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/shared_method.dart';

class EducationListItem extends StatelessWidget {
  final EducationEntity data;
  final bool isLoading;
  const EducationListItem(
      {super.key, required this.data, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoute.detailEducationPage,
            arguments: {
                'link' : data.link,
                'category' : data.category,
                'image' : data.image
              }
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: whiteColor),
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
                    : ExtendedImage.network(data.image,
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
                          data.category,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: kSecondaryTextColor),
                        ),
                        Spacer(),
                        Text(
                          data.title,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kMainTextColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
  
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              formatDate(data.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: medium, fontSize: 12, color: kSecondaryTextColor),
                            ),
                          ],
                        ),
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
