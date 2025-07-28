import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/explore/domain/entities/education_entity.dart';
import 'package:skinsight/features/explore/presentation/widgets/news_item.dart';

class EducationItem extends StatelessWidget {
  final EducationEntity data;
  final bool enableLoading;
  const EducationItem({super.key, required this.data, this.enableLoading = false});

  @override
  Widget build(BuildContext context) {
    final imageKey = GlobalKey();
    return Skeletonizer(
      enabled: enableLoading,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.detailEducationPage,
              arguments: {
                'link' : data.link,
                'category' : data.category,
                'image' : data.image
              });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Builder(builder: (context) {
                  return Flow(
                    delegate: ParallaxHorizontalDelegate(
                        scrollable: Scrollable.of(context),
                        listItemContext: context,
                        backgroundImageKey: imageKey),
                    children: [
                      ExtendedImage.network(
                        data.image,
                        key: imageKey,
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
                                ));
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
                        },
                      ),
                    ],
                  );
                }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black87,
                      Colors.transparent,
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data.category,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}