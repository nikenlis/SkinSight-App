import 'package:extended_image/extended_image.dart';
import 'package:extended_markdown_viewer/extended_markdown_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/api/api_config.dart';
import '../../../../../core/theme/app_color.dart';

class DetailProductPage extends StatefulWidget {
  final ProductEntity data;
  const DetailProductPage({super.key, required this.data});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) setState(() => _isFabVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) setState(() => _isFabVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          imageProductsection(context),
          productDetailSection(context),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(color: whiteColor),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () async {
                      final url = widget.data.link;
                      SharePlus.instance
                          .share(ShareParams(text: 'this product \n\n$url'));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                            border: Border.all(color: mainColor, width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icon_share.svg',
                              width: 30,
                              height: 30,
                              color: mainColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Share',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: semiBold,
                                      color: mainColor),
                            ),
                          ],
                        )),
                  ),
                )),
            SizedBox(
              width: 8,
            ),
            Flexible(
                flex: 1,
                child: Material(
                  color: mainColor,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      _launcherUrl(context, widget.data.link);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Text(
                          'Buy Now',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                  color: whiteColor),
                        ))),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  imageProductsection(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width - 25,
      backgroundColor: lightBackgroundColor,
      surfaceTintColor: mainColor,
      elevation: 0.0,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: true,
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth; // width available
            return SizedBox(
              width: size,
              height: size, // supaya persegi
              child: ExtendedImage.network(
                widget.data.imageUrl,
                fit: BoxFit.contain,
                cache: true,
                width: size,
                height: size,
                handleLoadingProgress: true,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.failed) {
                    return Container(
                      width: size,
                      height: size,
                      color: mainColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.broken_image,
                        size: 32,
                        color: mainColor.withValues(alpha: 0.4),
                      ),
                    );
                  }
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return Container(
                      width: size,
                      height: size,
                      color: whiteColor,
                    );
                  }
                  return null;
                },
              ),
            );
          },
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
    );
  }

  productDetailSection(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      priceTitleBrandSetion(context),
      SizedBox(
        height: 10,
      ),
      detailProductSection(context),
    ]));
  }

  priceTitleBrandSetion(context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rp ${widget.data.price}',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kMainTextColor),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Rp ${widget.data.price}',
          //       style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w600,
          //           color: kMainTextColor),
          //     ),
          //     Material(
          //       color: Colors.transparent,
          //       shape: const CircleBorder(),
          //       clipBehavior:
          //           Clip.antiAlias, // untuk membatasi splash ke lingkaran
          //       child: InkWell(
          //         onTap: () {
          //           // aksi share
          //         },
          //         customBorder: const CircleBorder(),
          //         child: Container(
          //           width: 38,
          //           height: 38,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: mainColor.withAlpha(50), // atau withOpacity(0.2)
          //           ),
          //           child: Icon(
          //             Icons.share,
          //             color: kMainTextColor
          //                 .withAlpha(150), // atau withOpacity(0.6)
          //             size: 20,
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.data.title,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: kMainTextColor),
            maxLines: 3,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.data.type,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 16, fontWeight: FontWeight.bold, color: mainColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                ///--Icon
                Container(
                  width: 42,
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipOval(
                    child: ExtendedImage.network(
                      '${ApiConfig.imageBaseUrl}${widget.data.brandImageUrl}',
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      cache: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mainColor.withAlpha(50), // alpha 0.2
                            ),
                            child: Icon(
                              Icons.broken_image,
                              color: mainColor.withAlpha(100), // alpha 0.4
                              size: 15,
                            ),
                          );
                        }
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                            ),
                          );
                        }
                        return null; 
                      },
                    ),
                  ),
                ),

                /// -- Text
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.data.brand,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  detailProductSection(context) {
    return Container(
      color: whiteColor,
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 8,
          ),
          ExtendedMarkDownViewer(
            markdownText: widget.data.description,
            maxCollapsedLength: 200,
            readMoreTextColor: mainColor,
            readLessTextColor: mainColor,
            expandedTextColor: kMainTextColor,
            collapsedTextColor: kMainTextColor,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 8,
          ),
          ExtendedMarkDownViewer(
            markdownText: widget.data.ingredients,
            maxCollapsedLength: 200,
            readMoreTextColor: mainColor,
            readLessTextColor: mainColor,
            expandedTextColor: kMainTextColor,
            collapsedTextColor: kMainTextColor,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Future<void> _launcherUrl(BuildContext context, String link) async {
  !await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
}
