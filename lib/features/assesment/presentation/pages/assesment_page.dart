import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/assesment/domain/entities/assesment_form_entity.dart';
import 'package:skinsight/features/assesment/presentation/bloc/assesment_bloc.dart';

import '../../../../core/ui/circle_loading.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../../core/ui/shared_method.dart';
import '../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'age_picker.dart';
import 'gender_selector.dart';
import 'skin_type_selector.dart';

class AssesmentPage extends StatefulWidget {
  const AssesmentPage({super.key});

  @override
  State<AssesmentPage> createState() => _AssesmentPageState();
}

class _AssesmentPageState extends State<AssesmentPage> {
  final PageController _controller = PageController(initialPage: 0);
  double maxPage = 3;
  late double currentValue;

  String? selectedGender;
  int? selectedAge;
  String? selectedSkinType;

  @override
  void initState() {
    currentValue = 1 / maxPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AssesmentBloc, AssesmentState>(
        listener: (context, state) {
          if (state is AssesmentLoading) {
            showLoadingDialog(context);
          } else if (state is AssesmentFailed) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (mounted) {
                if (state.message.contains('internet')) {
                  Navigator.pushNamed(context, AppRoute.noConnectionPage);
                } else {
                  showCustomSnackbar(
                      context, state.message);
                }
              }
            });
          } else if (state is AssesmentLoaded) {
            context.read<BottomNavigationBarCubit>().change(0);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoute.assesmentSuccessPage,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 93,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LinearProgressIndicator(
                      color: Colors.black,
                      backgroundColor: greyColor,
                      value: currentValue,
                      minHeight: 3,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            "${(currentValue * maxPage).toStringAsFixed(0)}/${maxPage.toInt()}",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: regular)),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentValue = (index + 1) / maxPage;
                    });
                  },
                  children: [
                    buildGender(context),
                    buildAge(context),
                    buildSkinType(context)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildGender(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
        ),
        Text(
          'What’s your gender?',
          style: blackRobotoTextStyle.copyWith(
              fontSize: 32, fontWeight: bold, color: blackColor),
        ),
        SizedBox(
          height: 27,
        ),
        GenderSelector(
          onSelected: (gender) {
            setState(() {
              selectedGender = gender;
            });
          },
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButtonItems(
            title: 'Continue',
            onPressed: () {
              if (selectedGender == null) {
                showCustomSnackbar(context, "Please select your gender");
                return;
              }
              context.read<AssesmentBloc>().add(
                  UpdateFormEvent(AssesmentFormEntity(gender: selectedGender)));
              _controller.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  buildAge(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
        ),
        Text(
          'How old are you?',
          style: blackRobotoTextStyle.copyWith(
              fontSize: 32, fontWeight: bold, color: blackColor),
        ),
        SizedBox(
          height: 27,
        ),
        AgePickerWheel(
          onAgeSelected: (age) {
            setState(() {
              selectedAge = age;
            });
          },
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButtonItems(
            title: 'Continue',
            onPressed: () {
              if (selectedAge == null) {
                showCustomSnackbar(context, "Please select your age");
                return;
              }
              context
                  .read<AssesmentBloc>()
                  .add(UpdateFormEvent(AssesmentFormEntity(age: selectedAge)));
              _controller.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  buildSkinType(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
        ),
        Text(
          'What’s your skin type?',
          style: blackRobotoTextStyle.copyWith(
              fontSize: 32, fontWeight: bold, color: blackColor),
        ),
        SizedBox(
          height: 27,
        ),
        SkinTypeSelector(
          onSelected: (skin) {
            setState(() {
              selectedSkinType = skin;
            });
          },
        ),
        Spacer(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.scanSkinTypePage);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(
                  color: blackColor.withValues(alpha: 0.5),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                foregroundColor: blackColor.withValues(alpha: 0.5),
              ),
              child: Text(
                'Or Scan Your Face Using AI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButtonItems(
              title: 'Continue',
              onPressed: () {
                if (selectedSkinType == null) {
                  showCustomSnackbar(context, "Please select your skin type");
                  return;
                }
                context.read<AssesmentBloc>().add(UpdateFormEvent(
                    AssesmentFormEntity(skinType: selectedSkinType), resetScanImage: true));
                context.read<AssesmentBloc>().add(SubmitFormEvent());
              }),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
