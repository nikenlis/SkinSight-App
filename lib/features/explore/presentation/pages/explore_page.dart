import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/explore/domain/entities/education_entity.dart';
import 'package:skinsight/features/explore/presentation/bloc/education/education_bloc.dart';
import 'package:skinsight/features/explore/presentation/bloc/news/news_bloc.dart';
import 'package:skinsight/features/explore/presentation/widgets/education_list_item.dart';
import 'package:skinsight/features/explore/presentation/widgets/loading_item.dart/news_item_loading.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/news_item.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ScrollController _newsScrollController = ScrollController();
  final ScrollController _educationScrollController = ScrollController();
  bool _isNewsFetching = false;
  bool _isEducationFetching = false;

  @override
  void initState() {
    super.initState();
    _newsScrollController.addListener(_onNewsScroll);
    _educationScrollController.addListener(_onEducationScroll);
  }

  @override
  void dispose() {
    _newsScrollController.dispose();
    _educationScrollController.dispose();
    super.dispose();
  }

  void _onNewsScroll() {
    if (!_newsScrollController.hasClients) return;

    final maxScroll = _newsScrollController.position.maxScrollExtent;
    final currentScroll = _newsScrollController.position.pixels;

    if (currentScroll >= maxScroll) {
      final state = context.read<NewsBloc>().state;
      if (state is NewsLoaded && !_isNewsFetching && !state.hasReachedMax) {
        _isNewsFetching = true;
        context.read<NewsBloc>().add(GetAllNews());
      }
    }
  }

  void _onEducationScroll() {
    if (!_educationScrollController.hasClients) return;

    final maxScroll = _educationScrollController.position.maxScrollExtent;
    final currentScroll = _educationScrollController.position.pixels;

    if (currentScroll >= maxScroll) {
      final state = context.read<EducationBloc>().state;
      if (state is EducationLoaded &&
          !_isEducationFetching &&
          !state.hasReachedMax) {
        _isEducationFetching = true;
        context.read<EducationBloc>().add(GetAllEducation());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<NewsBloc>().add(GetAllNews(isRefresh: true));
    context.read<EducationBloc>().add(GetAllEducation(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      backgroundColor: whiteColor,
      color: mainColor,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  section1(context, innerBoxIsScrolled),
                ],
            body: BlocConsumer<EducationBloc, EducationState>(
              listener: (context, state) {
                if (state is EducationFailed) {
                  _isEducationFetching = false;
                  showCustomSnackbar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is EducationLoading) {
                  return ListView.builder(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                            enabled: true,
                            child: EducationListItem(
                              data: EducationEntity(
                                  title: 'Ini data dummy hahahahahahhh apa yang dicariii adakaha yanga menarikkkk buset hoak banget',
                                  link: '',
                                  image: '',
                                  snippet:
                                      '',
                                  date: '2023-02-27',
                                  category: 'csdvv'),
                              isLoading: true,
                            ));
                      });
                } else if (state is EducationLoaded) {
                  _isEducationFetching = false;
                  if (state.data.isEmpty) {
                    return Center(
                      child: Text(
                        'Data is Empty',
                        style: TextStyle(
                          color: greyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                    child: ListView.builder(
                        controller: _educationScrollController,
                         padding:
                                  const EdgeInsets.only(bottom: 100),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return EducationListItem(data: state.data[index]);
                        }),
                  );
                }
                return TextFailure();
              },
            )),
      ),
    );
  }

  section1(BuildContext context, bool isScrolled) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: lightBackgroundColor,
      surfaceTintColor: lightBackgroundColor,
      elevation: 1,
      toolbarHeight: 86,
      automaticallyImplyLeading: false,
      leadingWidth: 50,
      title: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Text(
          'Explore',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 20,
                color: kMainTextColor,
                fontWeight: extraBlack,
              ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Material(
          color: lightBackgroundColor,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Educations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.educationPage);
                  },
                  child: Text(
                    'View all',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                          color: kSecondaryTextColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: newsSection(context),
      ),
    );
  }

  Widget newsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 104, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'News',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.newsPage);
                  },
                  child: Text(
                    'View all',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                          color: kSecondaryTextColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // News Section
          BlocConsumer<NewsBloc, NewsState>(
            listener: (context, state) {
              if (state is NewsFailed) {
                _isNewsFetching = false;
                showCustomSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is NewsLoading) {
                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    controller: _newsScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 0,
                            right: index == 3 - 1 ? 20 : 12,
                          ),
                          width: 209,
                          decoration: BoxDecoration(
                              // color: whiteColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Skeletonizer(
                              enabled: true, child: NewsItemLoading()));
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 2),
                  ),
                );
              } else if (state is NewsLoaded) {
                _isNewsFetching = false;

                if (state.data.isEmpty) {
                  return Center(
                    child: Text(
                      'Data is Empty',
                      style: TextStyle(
                        color: greyColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    controller: _newsScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 0,
                            right: index == state.data.length - 1 ? 20 : 12,
                          ),
                          width: 209,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: NewsItem(data: state.data[index]));
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 2),
                  ),
                );
              }
              return const TextFailure();
            },
          ),
        ],
      ),
    );
  }
}