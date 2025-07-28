import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/product_entity.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity data;
  const ProductListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailProductPage,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: whiteColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ExtendedImage.network(data.imageUrl,
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
                } else if (state.extendedImageLoadState == LoadState.loading) {
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7, right: 8),
          child: Text(
            data.title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: kMainTextColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          'Rp. ${data.price}',
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: bold, fontSize: 14),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Material(
            color: mainColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
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
            ),
          ),
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
