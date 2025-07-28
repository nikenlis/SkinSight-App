import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/history_scan_ingredient_entity.dart';

import '../../bloc/history_ingredients/history_ingredients_bloc.dart';
import '../../widgets/history_scan_ingredients_item.dart';

class HistoryScanIngredientsPage extends StatefulWidget {
  const HistoryScanIngredientsPage({super.key});

  @override
  State<HistoryScanIngredientsPage> createState() =>
      _HistoryScanIngredientsPageState();
}

class _HistoryScanIngredientsPageState
    extends State<HistoryScanIngredientsPage> {
        @override
  void initState() {
    super.initState();
    context.read<HistoryIngredientsBloc>().add(GetHistoryIngredients());
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: BlocConsumer<HistoryIngredientsBloc, HistoryIngredientsState>(
          listener: (context, state) {
            if (state is HistoryIngredientsFailed) {
              showCustomSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is HistoryIngredientsLoading) {
              return ListView.builder(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                        enabled: true,
                        child: HistoryScanIngredientsItem(
                          data: HistoryScanIngredientEntity(
                              id: '',
                              productName: 'ddvcsdbvcbdvdfbvfvdfvfvfv',
                              scanImage: '',
                              isSafe: false,
                              totalHarmfulIngredients: 4,
                              createdAt: DateTime.now()),
                          isLoading: true,
                        ));
                  });
            } else if (state is HistoryIngredientsLoaded) {
              if(state.data.isEmpty) {
                return Center(
                  child: TextFailure(message: 'Data is empty',)
                );
              } else {
                return ListView.builder(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 30),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return HistoryScanIngredientsItem(
                      data: state.data[index],
                      isLoading: false,
                    );
                  });
              }
              
            }
            return TextFailure();
          },
        ));
  }
}
