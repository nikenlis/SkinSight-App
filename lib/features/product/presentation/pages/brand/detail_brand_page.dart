import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/product/domain/entities/product_filter_entity.dart';
import 'package:skinsight/features/product/presentation/bloc/brand/brand_bloc.dart';

import '../../../../../core/api/api_config.dart';
import '../../../../../core/theme/app_color.dart';
import '../../bloc/category_brand/category_brand_bloc.dart';
import '../../widgets/loading/product_item_loading.dart';
import '../../widgets/product_item.dart';

class DetailBrandPage extends StatefulWidget {
  const DetailBrandPage({super.key, required this.data});
  final BrandEntity data;

  @override
  State<DetailBrandPage> createState() => _DetailBrandPageState();
}

class _DetailBrandPageState extends State<DetailBrandPage> {
  late ScrollController _scrollProductController;
  late ScrollController _scrollCategoryController;
  bool _isFetching = false;
  int? itemCategoryLoading;
  @override
  void initState() {
    context
        .read<BrandBloc>()
        .add(GetProductbyBrand(brand: widget.data.name, isRefresh: true));
    context
        .read<CategoryBrandBloc>()
        .add(GetCategoryBrand(brand: widget.data.name));

    _scrollProductController = ScrollController();
    _scrollCategoryController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollProductController.dispose();
    _scrollCategoryController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<BrandBloc>().add(GetProductbyBrand(
          brand: widget.data.name,
          isRefresh: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            profileBrandSection(context),
          ],
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 300) {
                final state = context.read<BrandBloc>().state;
                if (state is BrandLoaded &&
                    !_isFetching &&
                    !state.hasReachedMax) {
                  _isFetching = true;
                  context
                      .read<BrandBloc>()
                      .add(GetProductbyBrand(brand: widget.data.name));
                }
              }
              return false;
            },
            child: TabBarView(
              children: [
                allProductTab(context, key: const PageStorageKey('AllTab')),
                categoryProductTab(context,
                    key: UniqueKey()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileBrandSection(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1,
      toolbarHeight: 70,
      automaticallyImplyLeading: true,
      leadingWidth: 30,
      title: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.pushNamed(context, AppRoute.searchProductBrandPage, arguments: widget.data.name);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kOutlineColor)),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: kSecondaryTextColor,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Search products by brand',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14, color: kSecondaryTextColor),
                )
              ],
            ),
          ),
        ),
      ),
      bottom: TabBar(
        splashFactory: InkRipple.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        indicatorColor: mainColor,
        unselectedLabelColor: kSecondaryTextColor,
        labelColor: kMainTextColor,
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Category'),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 45, right: 20, bottom: 24),
          child: Row(
            children: [
              ///--Icon
              Container(
                height: 50,
                padding: const EdgeInsets.only(right: 12),
                child: ClipOval(
                  child: ExtendedImage.network(
                    '${ApiConfig.imageBaseUrl}${widget.data.image}',
                    shape: BoxShape.circle,
                    fit: BoxFit.cover,
                    handleLoadingProgress: true,
                    cache: true,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.failed) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: mainColor.withAlpha(50), // alpha 0.2
                          ),
                          child: Icon(
                            Icons.broken_image,
                            color: mainColor.withAlpha(100), // alpha 0.4
                            size: 24,
                          ),
                        );
                      }
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: whiteColor,
                          ),
                        );
                      }
                      return null; // gunakan default dari ExtendedImage
                    },
                  ),
                ),
              ),

              /// -- Text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.data.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kMainTextColor),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.verified,
                          color: mainColor,
                          size: 14,
                        )
                      ],
                    ),
                    Text(
                      '${widget.data.total} products',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withValues(alpha: 0.5)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  allProductTab(BuildContext context, {required Key key}) {
    return BlocConsumer<BrandBloc, BrandState>(
      listener: (context, state) {
        if (state is BrandFailed) {
          _isFetching = false;
          showCustomSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is BrandLoading) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Skeletonizer(
              child: GridView.builder(
                controller: _scrollProductController,
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.667,
                ),
                padding: const EdgeInsets.only(bottom: 30, top: 30),
                itemBuilder: (_, i) =>
                    const ProductItemLoading(isSkeleton: true),
              ),
            ),
          );
        } else if (state is BrandLoaded) {
          _isFetching = false;
          if (state.data.isEmpty) {
            return Center(
                child: Text(
              'Data is Empty',
              style: TextStyle(color: greyColor, fontWeight: FontWeight.w600),
            ));
          }
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: RefreshIndicator(
              onRefresh: () => _onRefresh(),
              color: mainColor,
              backgroundColor: whiteColor,
              child: GridView.builder(
                key: key,
                itemCount: state.hasReachedMax
                    ? state.data.length
                    : state.data.length + 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.667,
                ),
                padding: const EdgeInsets.only(bottom: 50, top: 30),
                itemBuilder: (_, i) {
                  if (i >= state.data.length) {
                    return Skeletonizer(
                        child: ProductItemLoading(isSkeleton: true));
                  }
                  return ProductItem(data: state.data[i]);
                },
              ),
            ),
          );
        }

        return TextFailure();
      },
    );
  }

  categoryProductTab(BuildContext context, {required Key key}) {
    return BlocConsumer<CategoryBrandBloc, CategoryBrandState>(
      listener: (context, state) {
        if (state is CategoryBrandFailed) {
          showCustomSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is CategoryBrandLoading) {
          return Skeletonizer(
            enabled: true,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 0),
              child: ListView.builder(
                key: key,
                controller: _scrollCategoryController,
                itemCount: itemCategoryLoading ?? 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              'vchdsvhcdshcd',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: kMainTextColor,
                                    fontSize: 15,
                                  ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'bjh',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: kSecondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: light,
                                  ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is CategoryBrandLoaded) {
          if (state.data.isEmpty) {
            return Center(
                child: Text(
              'Data is Empty',
              style: TextStyle(color: greyColor, fontWeight: FontWeight.w600),
            ));
          }
          return Padding(
            padding:
                const EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 0),
            child: ListView.builder(
              key: key,
              controller: _scrollCategoryController,
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.pushNamed(context, AppRoute.allProductByCategoryBrandPage, arguments: {
                          'brand' : widget.data.name,
                          'category' : state.data[index].type
                        });
                      },
                      title: Row(
                        children: [
                          Text(
                            state.data[index].type,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: kMainTextColor,
                                  fontSize: 15,
                                ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(${state.data[index].productCount})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: kSecondaryTextColor,
                                  fontSize: 14,
                                  fontWeight: light,
                                ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return TextFailure();
      },
    );
  }
}
