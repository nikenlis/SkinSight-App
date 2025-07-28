import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/uv_index/presentation/bloc/uv_index_bloc.dart';
import 'package:skinsight/features/uv_index/presentation/widgets/index_uv_bar.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/api/api_config.dart';
import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';
import '../../../explore/presentation/bloc/education/education_bloc.dart';
import '../../../explore/presentation/widgets/education_item.dart';
import '../../../explore/presentation/widgets/loading_item.dart/news_item_loading.dart';
import '../../../product/presentation/bloc/product/product_bloc.dart';
import '../../../product/presentation/bloc/product/product_state.dart';
import '../../../product/presentation/widgets/loading/product_item_loading.dart';
import '../../../product/presentation/widgets/product_item.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../recomendation_product/presentation/bloc/recomendation_product_bloc.dart';
import '../../../recomendation_product/presentation/widgets/recomendation_product_item.dart';
import '../../../recomendation_product/presentation/widgets/recommendation_product_item_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    context
        .read<RecomendationProductBloc>()
        .add(GetRecomendationProductEvent());
    context.read<EducationBloc>().add(GetAllEducation());
    context.read<ProductBloc>().add(GetProductEvent(type: 'All', page: 1));
    context.read<ProfileBloc>().add(GetProfileEvent());
    _getCurrentLocation().then((position) {
      lat = position.latitude;
      long = position.longitude;
      _liveLocation();
      context
          .read<UvIndexBloc>()
          .add(GetUvIndexEvent(latitude: lat, longitude: long));
    });
    super.initState();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 100);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          header(context),
          scanSection(context),
          uvSection(context),
          recomendationProductSection(context),
          educationSection(context),
          productSection(context)
        ],
      ),
    );
  }

  header(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 85, //90
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailed) {
              showCustomSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Skeletonizer(
                enabled: true,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Profile Picture (Skeleton)
                          ClipOval(
                            child: Bone(
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 12),

                          /// Text (Skeleton)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bone(
                                width: 160,
                                height: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 8),
                              Bone(
                                width: 120,
                                height: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.detailPhotoProfile,
                              arguments: state.data.profilePicture,
                            );
                          },
                          child: Hero(
                              tag: 'detail-profile',
                              child: ClipOval(
                                child: ExtendedImage.network(
                                  '${ApiConfig.imageBaseUrl}${state.data.profilePicture}',
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  cache: true,
                                  loadStateChanged: (state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.loading) {
                                      return AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: whiteColor,
                                        ),
                                      );
                                    }
                                    if (state.extendedImageLoadState ==
                                        LoadState.failed) {
                                      return AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color:
                                              mainColor.withValues(alpha: 0.2),
                                          child: Icon(
                                            size: 24,
                                            Icons.broken_image,
                                            color: mainColor.withValues(
                                                alpha: 0.4),
                                          ),
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to SkinSight!',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: bold,
                                    color: kMainTextColor,
                                  ),
                            ),
                            Text(
                              state.data.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: medium,
                                    color: kMainTextColor,
                                  ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Material(
                          borderOnForeground: true,
                          color: whiteColor,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoute.chatbotPage);
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Image.asset('assets/sizuka.gif'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
            return TextFailure();
          },
        ),
      ),
    );
  }

  scanSection(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Colors.white,
      expandedHeight: 289,
      // pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 100,
            height: 30,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.scanImagePage);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(mainColor),
                overlayColor: WidgetStateProperty.all(
                  whiteColor.withValues(alpha: 0.2),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Scan Now',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        fontWeight: semiBold,
                        color: whiteColor,
                      ),
                ),
              ),
            ),
          ),
        ),
        background: Container(
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/img_home_scan.png'),
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }

  uvSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<UvIndexBloc, UvIndexState>(
        listener: (context, state) {
          if (state is UvIndexFailed) {
            showCustomSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is UvIndexLoading) {
            return Skeletonizer(
              enabled: true,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 24),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'UV Index',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: kMainTextColor),
                        ),
                        Spacer(),
                        Icon(
                          Icons.location_on,
                          color: mainColor,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Kecamatan ngaglik',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: mainColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Kecamatan ngaglik',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: semiBold,
                                    color: mainColor),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 24,
                            child: Stack(
                              children: [
                                // Garis gradasi UV
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  height: 6,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Safe to be outside without sunscreen.',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: regular,
                          color: kSecondaryTextColor),
                      maxLines: 3,
                    )
                  ],
                ),
              ),
            );
          } else if (state is UvIndexLoaded) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.uvPage,
                    arguments: state.data);
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 24),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'UV Index',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: kMainTextColor),
                        ),
                        Spacer(),
                        Icon(
                          Icons.location_on,
                          color: mainColor,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          state.data.now.locality,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: mainColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    UvIndexBar(value: state.data.now.uvi),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      state.data.now.recommendation,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: regular,
                          color: kSecondaryTextColor),
                      maxLines: 3,
                    )
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextFailure(),
          );
        },
      ),
    );
  }

  recomendationProductSection(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            padding:
                const EdgeInsets.only(top: 24, bottom: 16, left: 20, right: 20),
            color: lightBackgroundColor,
            child: Text(
              'Product Recommendation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
            ),
          ),
        ),
        BlocConsumer<RecomendationProductBloc, RecomendationProductState>(
          listener: (context, state) {
            if (state is RecomendationProductFailed) {
              showCustomSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is RecomendationProductLoading) {
              return SizedBox(
                height: 208,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? 20 : 0,
                          right: index == 3 - 1 ? 20 : 12,
                        ),
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: RecomendationProductItemLoading(
                          data: ProductEntity(
                              brandImageUrl: '',
                              id: '',
                              title:
                                  'Asdvchsdvchsvhvvfvbdfvb duvcdvcdcvd ccgcgfg',
                              price: '',
                              description: '',
                              imageUrl: 'dummy',
                              link: '',
                              type: '',
                              brand: '',
                              ingredients: ''),
                        ));
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 2),
                ),
              );
            } else if (state is RecomendationProductLoaded) {
              return SizedBox(
                height: 208,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? 20 : 0,
                          right: index == state.data.length - 1 ? 20 : 12,
                        ),
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: RecomendationProductItem(
                          data: state.data[index],
                        ));
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 2),
                ),
              );
            }
            return TextFailure();
          },
        ),
      ],
    );
  }

  educationSection(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            padding:
                const EdgeInsets.only(top: 24, bottom: 16, left: 20, right: 20),
            color: lightBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SkinSight Article',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: kMainTextColor,
                      fontSize: 18,
                      fontWeight: semiBold),
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
                        color: kSecondaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocConsumer<EducationBloc, EducationState>(
            listener: (context, state) {
              if (state is EducationFailed) {
                showCustomSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is EducationLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 0,
                            right: index == 4 ? 20 : 12,
                          ),
                          width: 209,
                          child: const NewsItemLoading(),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 2),
                    ),
                  ),
                );
              } else if (state is EducationLoaded) {
                return SizedBox(
                  height: 150,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20 : 0,
                            right: index == state.data.length - 1 ? 20 : 12,
                          ),
                          width: 209,
                          decoration: BoxDecoration(
                              // color: whiteColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: EducationItem(
                            data: state.data[index],
                          ));
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 2),
                  ),
                );
              }
              return TextFailure();
            },
          ),
        )
      ],
    );
  }

  productSection(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            padding:
                const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 16),
            color: lightBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: kMainTextColor,
                      fontSize: 18,
                      fontWeight: semiBold),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomNavigationBarCubit>().change(1);
                  },
                  child: Text(
                    'View all',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                        color: kSecondaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              final tabState = state.getTabState('All');

              /// --- STATE LOADING
              if ((tabState.status == ProductFetchStatus.loading ||
                      tabState.status == ProductFetchStatus.initial) &&
                  tabState.products.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.667,
                      ),
                      itemBuilder: (_, i) =>
                          const ProductItemLoading(isSkeleton: true),
                    ),
                  ),
                );

                /// --- STATE FAILED
              } else if (tabState.status == ProductFetchStatus.failure &&
                  tabState.products.isEmpty) {
                return TextFailure(
                  message: tabState.errorMessage!,
                );

                /// --- STATE DATA KOSONG
              } else if (tabState.products.isEmpty) {
                return const Center(child: Text("Data is Empty"));
              }

              /// --- STATE DATA LOADED
              return Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 120),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.667,
                  ),
                  itemBuilder: (_, i) {
                    return ProductItem(data: tabState.products[i]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
