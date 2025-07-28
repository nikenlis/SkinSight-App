import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/theme/app_color.dart';

class ProductListItemLoading extends StatelessWidget {
  const ProductListItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: whiteColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 109,
                height: 109,
                color: Colors.amber,
              ),
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
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Text(
                        'vdasvdacvhsdcvsdhcvdhscvhdsvchdsvchdsvdshvdhsvdhsvhscvhdvcdsvcsahgvcgdsvcdsgcwegdywqgdyuwgds',
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
                      'Rp. 57575768',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: bold, fontSize: 14),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Skeleton.keep(
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
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
