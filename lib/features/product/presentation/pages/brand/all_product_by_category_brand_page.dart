import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/ui/shared_method.dart';
import '../../../../../core/ui/text_failure.dart';
import '../../bloc/category_brand/category_brand_bloc.dart';
import '../../widgets/loading/product_item_loading.dart';
import '../../widgets/product_item.dart';


class AllProductByCategoryBrandPage extends StatefulWidget {
  final Map<String, String> data;
  const AllProductByCategoryBrandPage({super.key, required this.data});

  @override
  State<AllProductByCategoryBrandPage> createState() => _AllProductByCategoryBrandPageState();
}

class _AllProductByCategoryBrandPageState extends State<AllProductByCategoryBrandPage> {
   final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBrandBloc>().add(GetAllProductByCategoryBrand(brand: widget.data['brand']!, category: widget.data['category']!));
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<CategoryBrandBloc>().add(GetAllProductByCategoryBrand(brand: widget.data['brand']!, category: widget.data['category']!));
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
           context
        .read<CategoryBrandBloc>()
        .add(GetCategoryBrand(brand: widget.data['brand']!));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.data['category']!),),
        body: BlocConsumer<CategoryBrandBloc, CategoryBrandState>(
        listener: (context, state) {
          if (state is CategoryBrandFailed) {
            // _isFetching = false;
            showCustomSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CategoryBrandLoading) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Skeletonizer(
                child: GridView.builder(
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
          } else if (state is AllProductByCategoryBrandLoaded) {
            // _isFetching = false;
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
                  itemCount: state.data.length,
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
            )
      ),
    );
  }
}