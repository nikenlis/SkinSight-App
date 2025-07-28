import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../core/common/app_route.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  void navigateAfterDelay(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateAfterDelay(context);
    });
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          Future.delayed(const Duration(seconds: 2), () async {
            if (!ModalRoute.of(context)!.isCurrent) return;
            if (state is AuthenticationCheckCredentialLoaded) {
              final prefs = await SharedPreferences.getInstance();
              final verifyOtpStatus = prefs.getBool('verifyOtpStatus');
              final assesmentStatus = prefs.getBool('assesmentStatus');
              if (verifyOtpStatus!) {
                if (assesmentStatus!) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.bottomNavBar, (route) => false);
                } else {
                   Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.assesmentPage, arguments: '', (route) => false);
                }
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.otpPage, arguments: '', (route) => false);
              }
            } else if (state is AuthenticationFailed) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.signInPage, (route) => false);
            }
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              Image.asset(
                "assets/img_splash.png",
                width: media.width,
                height: media.height,
                fit: BoxFit.cover,
              ),
            ],
          );
        },
      ),
    );
  }
}
