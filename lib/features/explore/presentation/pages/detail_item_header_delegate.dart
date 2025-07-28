import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/shared_method.dart';

class DetailItemHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String category;
  final String date;
  final double topPadding;

  final Function(double value) borderRadiusAnimationValue;

  @override
  final double maxExtent;
  @override
  final double minExtent;

  const DetailItemHeaderDelegate({
    required this.borderRadiusAnimationValue,
    required this.title,
    required this.category,
    required this.date,
    required this.maxExtent,
    required this.minExtent,
    required this.topPadding,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final screenWidth = MediaQuery.of(context).size.width;
    const animationDuration = Duration(milliseconds: 200);

    final showCategoryDate = shrinkOffset < 100;

    final calcForTitleAnimations =
        (maxExtent - shrinkOffset - topPadding - 56 - 100) / 100;

    final titleAnimationValue = calcForTitleAnimations > 1.0
        ? 1.0
        : calcForTitleAnimations < 0.0
            ? 0.0
            : calcForTitleAnimations;

    final calcForTopBarAnimations =
        (maxExtent - shrinkOffset - topPadding - 56) / 50;

    final topBarAnimationValue = calcForTopBarAnimations > 1.0
        ? 1.0
        : calcForTopBarAnimations < 0.0
            ? 0.0
            : calcForTopBarAnimations;

    borderRadiusAnimationValue(topBarAnimationValue);

    return Stack(
      fit: StackFit.expand,
      children: [

        Positioned(
          bottom: 0,
          child: AnimatedOpacity(
            opacity: titleAnimationValue,
            duration: animationDuration,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: animationDuration,
                    height: showCategoryDate ? 10 : 0,
                  ),

                  ///-- TITLE
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 24,
                                fontWeight: bold,
                                color: whiteColor,
                              ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: animationDuration,
                    height: showCategoryDate ? 10 : 0,
                  ),

                  ///-- TANGGAL
                  AnimatedSwitcher(
                    duration: animationDuration,
                    child: showCategoryDate
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                category ,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: whiteColor,
                                        fontSize: 15,
                                        fontWeight: medium),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 12, right: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor
                                ),
                              ),
                              Text(
                                formatDate(date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: whiteColor,
                                        fontSize: 14,
                                        fontWeight: medium),
                              )
                          ],
                        )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: AnimatedContainer(
            duration: animationDuration,
            height: 56 + topPadding,
            color: whiteColor.withOpacity(1 - topBarAnimationValue),
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(
                  height: topPadding,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: animationDuration,
                        width: topBarAnimationValue * 10,
                      ),
                      AnimatedCrossFade(
                        duration: animationDuration,
                        crossFadeState: topBarAnimationValue > 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        secondChild: 
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AppRoundedButton(
                            iconData: CupertinoIcons.left_chevron,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        firstChild: AppRoundedButtonBlur(
                          iconData: CupertinoIcons.left_chevron,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AnimatedCrossFade(
                          duration: animationDuration,
                          crossFadeState: topBarAnimationValue > 0
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          secondChild: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    color: kMainTextColor,
                                    fontWeight: medium),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              
                            ],
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: animationDuration,
                        width: topBarAnimationValue * 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}

class AppRoundedButtonBlur extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  const AppRoundedButtonBlur({super.key, this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0x33FFFFFF),
      borderRadius: BorderRadius.circular(56),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(56),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(56),
            onTap: onTap,
            child: SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                iconData,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppRoundedButton extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;
  const AppRoundedButton({super.key, this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF6F5F8),
      borderRadius: BorderRadius.circular(56),
      child: InkWell(
        borderRadius: BorderRadius.circular(56),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            iconData,
          ),
        ),
      ),
    );
  }
}
