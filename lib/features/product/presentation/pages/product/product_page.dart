import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/product_filter/product_filter_bloc.dart';
import 'package:skinsight/features/product/presentation/widgets/brand_item.dart';
import 'package:skinsight/features/product/presentation/widgets/product_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/common/app_route.dart';
import '../../../../../core/ui/text_failure.dart';
import '../../bloc/product/product_state.dart';
import '../../widgets/loading/product_item_loading.dart';
import '../../widgets/loading/product_page_loading.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  List<ScrollController> _scrollControllers = [];
  late TabController _tabController;
  List<String> _productTypes = [];
  late bool _initialized;
  late bool _isSorted = false;

  @override
  void initState() {
    _initialized = false;
    context.read<ProductFilterBloc>().add(GetProductFilterEvent());
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll(int index) {
    final controller = _scrollControllers[index];
    final type = _productTypes[index];

    if (controller.position.pixels >= controller.position.maxScrollExtent) {
      context.read<ProductBloc>().add(GetProductEvent(type: type));
    }
  }

  Future<void> _onRefresh(String type) async {
    setState(() {
      _isSorted = false;
    });
    context.read<ProductBloc>().add(GetProductEvent(
          type: type,
          isRefresh: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'Product',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 20, color: kMainTextColor, fontWeight: extraBlack),
          ),
        ),
        title: const SizedBox(),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductFilterBloc, ProductFilterState>(
            listener: (context, state) {
              if (state is ProductFilterFailed) {
                showCustomSnackbar(context, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<ProductFilterBloc, ProductFilterState>(
            builder: (context, filterState) {
          if (filterState is ProductFilterLoading) {
            return ProductPageLoading();
          } else if (filterState is ProductFilterLoaded) {
            if (!_initialized) {
              _productTypes = filterState.types;
              _isSorted = false;
              _tabController =
                  TabController(length: _productTypes.length, vsync: this);

              // ⬇️ Tambahkan ini
              _tabController.animation?.addListener(() {
                final newIndex = _tabController.index;

                // Trigger saat perpindahan tab selesai
                if (_tabController.index.toDouble() ==
                    _tabController.animation?.value) {
                  final selectedType = _productTypes[newIndex];

                  final productBloc = context.read<ProductBloc>();
                  final tabState = productBloc.state.getTabState(selectedType);

                  if (tabState.products.isEmpty &&
                      tabState.status != ProductFetchStatus.loading) {
                    productBloc.add(GetProductEvent(
                      type: selectedType,
                      sort: _isSorted ? 'brand' : null,
                    ));
                  }
                }
              });

              _scrollControllers = List.generate(
                _productTypes.length,
                (_) => ScrollController(),
              );

              for (int i = 0; i < _scrollControllers.length; i++) {
                _scrollControllers[i].addListener(() => _onScroll(i));
              }

              // Load awal untuk tab pertama
              context.read<ProductBloc>().add(
                  GetProductEvent(type: _productTypes[0], isRefresh: true));

              _initialized = true;
            }

            return NestedScrollView(
              headerSliverBuilder: (_, innerBoxScrolled) {
                return [
                  /// -- Appbar
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    backgroundColor: lightBackgroundColor,
                    expandedHeight: 420,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.all(20),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoute.searchProductPage);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: kOutlineColor)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          color: kSecondaryTextColor,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'Search product',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontSize: 14,
                                                  color: kSecondaryTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    setState(() {
                                      _isSorted = !_isSorted;
                                    });

                                    for (final type in _productTypes) {
                                      context.read<ProductBloc>().add(
                                            GetProductEvent(
                                              type: type,
                                              sort: _isSorted ? 'brand' : null,
                                              isRefresh: true,
                                            ),
                                          );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: kOutlineColor)),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.sliders,
                                        color: _isSorted == true
                                            ? mainColor
                                            : kSecondaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),

                          /// -- Feature brands
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Brands',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        color: kMainTextColor,
                                        fontSize: 18,
                                        fontWeight: semiBold),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoute.brandPage);
                                },
                                child: Text(
                                  'View all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: semiBold,
                                          color: kSecondaryTextColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),

                          /// -- Brand GRID
                          GridView.builder(
                              itemCount: 4,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 80,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 10),
                              itemBuilder: (_, index) {
                                return BrandItem(
                                  data: filterState.brands[index],
                                );
                              }),
                        ],
                      ),
                    ),

                    /// --TAB
                    bottom: TTbar(
                      allTypes: filterState.types,
                      controller: _tabController,
                    ),
                  )
                ];
              },

              /// --TABVIEW
              body: SafeArea(
                top: false,
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(filterState.types.length, (index) {
                    return BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        final type = filterState.types[index];
                        final tabState = state.getTabState(type);

                        /// --- DATA LOADING
                        if ((tabState.status == ProductFetchStatus.loading ||
                                tabState.status ==
                                    ProductFetchStatus.initial) &&
                            tabState.products.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Skeletonizer(
                              child: GridView.builder(
                                itemCount: 6,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.667,
                                ),
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 30),
                                itemBuilder: (_, i) =>
                                    const ProductItemLoading(isSkeleton: true),
                              ),
                            ),
                          );
                        }

                        if (tabState.status == ProductFetchStatus.failure &&
                            tabState.products.isEmpty) {
                          return TextFailure();
                        }

                        if (tabState.products.isEmpty) {
                          return const Center(
                              child: Text(
                            "Data is Empty",
                            style: TextStyle(
                                color: greyColor, fontWeight: FontWeight.w600),
                          ));
                        }

                        /// --- DATA LOADED
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: RefreshIndicator(
                            onRefresh: () => _onRefresh(type),
                            color: mainColor,
                            backgroundColor: whiteColor,
                            child: GridView.builder(
                              controller: _scrollControllers[index],
                              itemCount: tabState.hasReachedMax
                                  ? tabState.products.length
                                  : tabState.products.length + 2,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.667,
                              ),
                              padding:
                                  const EdgeInsets.only(bottom: 50, top: 30),
                              itemBuilder: (_, i) {
                                if (i >= tabState.products.length) {
                                  return Skeletonizer(
                                      child:
                                          ProductItemLoading(isSkeleton: true));
                                }
                                return ProductItem(data: tabState.products[i]);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            );
          }
          return TextFailure();
        }),
      ),
    );
  }
}

class TTbar extends StatelessWidget implements PreferredSizeWidget {
  const TTbar({
    super.key,
    required this.controller,
    required this.allTypes,
  });
  final TabController controller;
  final List<String> allTypes;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: lightBackgroundColor,
      child: TabBar(
        controller: controller,
        splashFactory: InkRipple.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        padding: EdgeInsets.only(left: 5),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: mainColor,
        unselectedLabelColor: kSecondaryTextColor,
        labelColor: kMainTextColor,
        tabs: allTypes.map((type) => Tab(text: type)).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
