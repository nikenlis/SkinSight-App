import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/product/domain/entities/product_filter_entity.dart';
import 'package:skinsight/features/product/presentation/bloc/product_filter/product_filter_bloc.dart';
import 'package:skinsight/features/product/presentation/widgets/brand_item.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All brand'),
      ),
      body: BlocConsumer<ProductFilterBloc, ProductFilterState>(
        listener: (context, state) {
          if (state is ProductFilterFailed) {
            showCustomSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductFilterLoading) {
            return GridView.builder(
                    itemCount: 12,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 80,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 10),
                    itemBuilder: (_, index) {
                       final rowIndex = index ~/ 2; 
                      return AnimationConfiguration.staggeredGrid(
                        position: rowIndex,
                        columnCount: 2,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: SlideAnimation(
                            delay: Duration(milliseconds: 275),
                            child: BrandItem(
                              enableSkeleton: true,
                              data: BrandEntity(name: 'dummy', image: '', total: 20),
                            ),
                          ),
                        ),
                      );
                    });
          } else if (state is ProductFilterLoaded) {
            return AnimationLimiter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GridView.builder(
                    itemCount: state.brands.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 80,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 10),
                    itemBuilder: (_, index) {
                       final rowIndex = index ~/ 2; 
                      return AnimationConfiguration.staggeredGrid(
                        position: rowIndex,
                        columnCount: 2,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: SlideAnimation(
                            delay: Duration(milliseconds: 275),
                            child: BrandItem(
                              data: state.brands[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          }
          return TextFailure();
        },
      ),
    );
  }
}
