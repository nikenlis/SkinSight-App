import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/recomendation_product/presentation/bloc/recomendation_product_bloc.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/shared_method.dart';
import '../../../../core/ui/text_failure.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../widgets/recomendation_product_item.dart';
import '../widgets/recommendation_product_item_loading.dart';

class RecomendationProductPage extends StatefulWidget {
  const RecomendationProductPage({super.key});

  @override
  State<RecomendationProductPage> createState() =>
      _RecomendationProductPageState();
}

class _RecomendationProductPageState extends State<RecomendationProductPage> {
    @override
  void initState() {
    super.initState();
       context
        .read<RecomendationProductBloc>()
        .add(GetRecomendationProductEvent());
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Recommendation Product'),
          ),
          body: BlocConsumer<RecomendationProductBloc, RecomendationProductState>(
            listener: (context, state) {
              if (state is RecomendationProductFailed) {
                showCustomSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is RecomendationProductLoading) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.76,
                      ),
                      padding: const EdgeInsets.only(bottom: 30, top: 30),
                      itemBuilder: (_, i) =>
                          const RecomendationProductItemLoading(
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
                        ),
                    ),
                  ),
                );
              } else if (state is RecomendationProductLoaded) {
                // _isFetching = false;
                if (state.data.isEmpty) {
                  return Center(
                      child: Text(
                    'Data is Empty',
                    style: TextStyle(
                        color: greyColor, fontWeight: FontWeight.w600),
                  ));
                }
                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: GridView.builder(
                    itemCount: state.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.76,
                    ),
                    padding: const EdgeInsets.only(bottom: 50, top: 30),
                    itemBuilder: (_, i) {
                      if (i >= state.data.length) {
                        return Skeletonizer(
                          enabled: true,
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
                        ),);
                      }
                      return RecomendationProductItem(
                          data: state.data[i],
                        );
                    },
                  ),
                );
              }

              return TextFailure();
            },
          )),
    );
  }
}
