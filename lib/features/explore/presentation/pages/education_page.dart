import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/shared_method.dart';
import '../../../../core/ui/text_failure.dart';
import '../../domain/entities/education_entity.dart';
import '../bloc/education/education_bloc.dart';
import '../widgets/education_list_item.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final ScrollController _educationScrollController = ScrollController();
  bool _isEducationFetching = false;

  @override
  void initState() {
    super.initState();
    context.read<EducationBloc>().add(GetAllEducation(isRefresh: true));
    _educationScrollController.addListener(_onEducationScroll);
  }

  @override
  void dispose() {
    _educationScrollController.dispose();
    super.dispose();
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
        print('🔥 FETCHING NEXT PAGE');
        context.read<EducationBloc>().add(GetAllEducation());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<EducationBloc>().add(GetAllEducation(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Education'),
      ),
      body: BlocConsumer<EducationBloc, EducationState>(
          listener: (context, state) {
        if (state is EducationFailed) {
          _isEducationFetching = false;
          showCustomSnackbar(context, state.message);
        }
        else if (state is EducationLoaded) {
  _isEducationFetching = false;
}
      }, builder: (context, state) {
        if (state is EducationLoading) {
          return ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Skeletonizer(
                    enabled: true,
                    child: EducationListItem(
                      data: EducationEntity(
                          title: 'Ini data dummy hahahahahahhh apa yang dicariii adakaha yanga menarikkkk buset hoak banget yang duvhdvsdvbdsvbcvbsvhsdvhsdvhsdfvdhsvhdsvhsdvhdsvhds',
                          link: '',
                          image: '',
                          snippet:
                              '',
                          date: '2025-07-07',
                          category: 'csdvv csdvv'),
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
          return RefreshIndicator(
            onRefresh: _onRefresh,
            backgroundColor: whiteColor,
            color: mainColor,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, ),
              child: ListView.builder(
                controller: _educationScrollController,
                padding: const EdgeInsets.only(bottom: 30, top: 16),
                itemCount: state.hasReachedMax
                    ? state.data.length
                    : state.data.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.data.length) {
                    return Skeletonizer(
                      enabled: true,
                      child: EducationListItem(
                        data: EducationEntity(
                            title: 'Ini data dummy hahahahahahhh apa yang dicariii adakaha yanga menarikkkk buset hoak banget yang duvhdvsdvbdsvbcvbsvhsdvhsdvhsdfvdhsvhdsvhsdvhdsvhds',
                            link: '',
                            image: '',
                            snippet:
                                '',
                            date: '2025-07-07',
                            category: 'csdvv bagian'),
                        isLoading: true,
                      ),
                    );
                  }
            
                  return EducationListItem(data: state.data[index]);
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
