import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/explore/presentation/bloc/news/news_bloc.dart';
import 'package:skinsight/features/explore/presentation/widgets/news_item.dart';
import 'package:skinsight/features/explore/presentation/widgets/loading_item.dart/news_item_loading.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/shared_method.dart';


class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _newsScrollController = ScrollController();
  bool _isNewsFetching = false;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(GetAllNews(isRefresh: true));
    _newsScrollController.addListener(_onNewsScroll);
  }

  @override
  void dispose() {
    _newsScrollController.dispose();
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

  Future<void> _onRefresh() async {
    context.read<NewsBloc>().add(GetAllNews(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All News'),
      ),
      body: BlocConsumer<NewsBloc, NewsState>(listener: (context, state) {
        if (state is NewsFailed) {
          _isNewsFetching = false;
          showCustomSnackbar(context, state.message);
        }
      }, builder: (context, state) {
        if (state is NewsLoading) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (_, i) {
                return Skeletonizer(
                  enabled: true,
                  child: NewsItemLoading());
              },
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

          return RefreshIndicator(
            onRefresh: _onRefresh,
            backgroundColor: whiteColor,
            color: mainColor,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20,),
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 30, top: 16),
                itemCount: state.hasReachedMax
                      ? state.data.length
                      : state.data.length + 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (_, i) {
                  if (i >= state.data.length) {
                    context.read<NewsBloc>().add(GetAllNews());
                      return Skeletonizer(
                        enabled: true,
                        child: NewsItemLoading());
                    }
                  return NewsItem(data: state.data[i]);
                },
              ),
            ),
          );
        }
        return TextFailure();
      }),
    );
  }
}
