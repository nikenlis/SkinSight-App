import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/core/common/app_route.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';

class AssesmentSuccessPage extends StatelessWidget {
  const AssesmentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You’re All Set!',
              style: blackRobotoTextStyle.copyWith(
                fontSize: 32, fontWeight: bold, color: blackColor
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 26,
            ),
            Text(
              'You can check your skin\n factors in profile section!',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButtonItems(
              width: 183,
              title: 'Get Started',
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('assesmentStatus', true);
                 context.read<BottomNavigationBarCubit>().change(0);
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.bottomNavBar, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}