import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/explore/presentation/bloc/news/news_bloc.dart';
import 'package:skinsight/features/explore/presentation/widgets/markdown.dart';

import '../widgets/loading_item.dart/detail_news_page_loading.dart';
import 'detail_item_header_delegate.dart';

class DetailNewsPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailNewsPage({super.key, required this.data});

  @override
  State<DetailNewsPage> createState() => _DetailExplorePageState();
}

class _DetailExplorePageState extends State<DetailNewsPage> {
  double _borderRadiusMultiplier = 1;
  @override
  void initState() {
    context
        .read<NewsBloc>()
        .add(GetDetailNews(articleLink: widget.data['link']
));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          context.read<NewsBloc>().add(GetAllNews(isRefresh: true));
        }
      },
      child: Scaffold(
        backgroundColor: blackColor,
        body: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state is NewsFailed) {
              showCustomSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is NewsLoading) {
              return DetailNewsPageLoading();
            } else if (state is DetailNewsLoaded) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: maxScreenSizeHeight / 2 + 40,
                    child: ExtendedImage.network(
                      widget.data['image'],
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      cache: true,
                      loadStateChanged: (imageState) {
                        if (imageState.extendedImageLoadState ==
                            LoadState.failed) {
                          return Container(
                            color: mainColor.withAlpha(30),
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 32),
                            ),
                          );
                        }
                        if (imageState.extendedImageLoadState ==
                            LoadState.loading) {
                          return Container(color: whiteColor);
                        }
                        return null;
                      },
                    ),
                  ),

                  // 2. Overlay Gradient Hitam di Atas Gambar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: maxScreenSizeHeight / 2 + 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC000000),
                            Color(0x99000000),
                            Color(0x00000000),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Konten Scrollable
                  CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: DetailItemHeaderDelegate(
                          borderRadiusAnimationValue: (value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _borderRadiusMultiplier = value;
                              });
                            });
                          },
                          title: state.data.title,
                          category: widget.data['category'],
                          date: state.data.date,
                          minExtent: topPadding + 56,
                          maxExtent: maxScreenSizeHeight / 2,
                          topPadding: topPadding,
                        ),
                        pinned: true,
                      ),
                      SliverToBoxAdapter(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.vertical(
                              top:
                                  Radius.circular(40 * _borderRadiusMultiplier),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                state.data.author,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: 20, fontWeight: medium),
                              ),
                              const SizedBox(height: 24),
                              MarkdownViewer(markdownData: state.data.content),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }
            return const TextFailure();
          },
        ),
      ),
    );
  }
}
