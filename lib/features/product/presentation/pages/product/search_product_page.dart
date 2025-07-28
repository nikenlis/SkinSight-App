import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/product/presentation/widgets/loading/product_list_item_loading.dart';
import '../../../../../core/ui/shared_method.dart';
import '../../../domain/entities/product_entity.dart';
import '../../bloc/search/search_bloc.dart';
import '../../widgets/product_list_item.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({super.key});

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  TextEditingController searchController = TextEditingController();
  List<ProductEntity> filteredData = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: whiteColor,
          backgroundColor: whiteColor,
          toolbarHeight: 70,
          leadingWidth: 30,
          title: CupertinoSearchTextField(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            controller: searchController,
            autofocus: true,
            suffixIcon: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: mainColor,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: kOutlineColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 14, color: kMainTextColor),
            itemColor: kSecondaryTextColor,
            placeholder: 'Search product',
            placeholderStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 14, color: kSecondaryTextColor),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isSearching = true;
                });
                Future.delayed(const Duration(milliseconds: 500), () {
                  context
                      .read<SearchBloc>()
                      .add(GetProductbySearch(query: value));
                });
              } else {
                setState(() {
                  isSearching = false;
                  filteredData = [];
                });
              }
            },
            onSubmitted: (String value) {
              context.read<SearchBloc>().add(GetProductbySearch(query: value));
            },
          ),
        ),
        body: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchLoaded) {
              setState(() {
                filteredData = state.data;
                isSearching = true;
              });
            } else if (state is SearchFailed) {
              showCustomSnackbar(context, state.message);
              setState(() {
                isSearching = false;
              });
            }
          },
          builder: (context, state) {
            if (state is SearchLoading && filteredData.isEmpty) {
              return ListView.builder(
                 padding: const EdgeInsets.only(
                     left: 20, right: 20, top: 24, bottom: 30),
                 itemCount: 20,
                 itemBuilder: (context, index) {
                   return ProductListItemLoading();
                 },
               );
            }

            if (isSearching) {
              if (filteredData.isEmpty) {
                return const Center(child: Text('No results found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 24, bottom: 30),
                controller: context.read<SearchBloc>().scrollController,
                itemCount: context.read<SearchBloc>().isLoadingMore
                    ? filteredData.length + 1
                    : filteredData.length,
                itemBuilder: (context, index) {
                  if (index < filteredData.length) {
                    return ProductListItem(data: filteredData[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }

            return const SizedBox(); // Awal kosong
          },
        ));
  }
}
