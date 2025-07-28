import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

class SplashPage2 extends StatefulWidget {
  const SplashPage2({super.key});

  @override
  State<SplashPage2> createState() => _SplashPage2State();
}

class _SplashPage2State extends State<SplashPage2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _navigated = false;
  double _loadingProgress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _startLoadingProgress();
  }

  void _startLoadingProgress() {
    const totalSteps = 100;
    const stepDuration = Duration(milliseconds: 30);
    _progressTimer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        if (_loadingProgress < 1.0) {
          _loadingProgress += 1 / totalSteps;
        } else {
          _progressTimer?.cancel();
        }
      });
    });
  }

  void _navigateBasedOnState(AuthenticationState state) async{
    if (_navigated || _loadingProgress < 1.0) return;

    _navigated = true;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // Trigger navigasi jika animasi dan progress selesai
          if (_loadingProgress >= 1.0) {
            // _navigateBasedOnState(state);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateBasedOnState(state);
            });
          }
        },
        builder: (context, state) {
          // Jika state berubah sebelum progress selesai, tunggu progress
          if (_loadingProgress >= 1.0) {
            // _navigateBasedOnState(state);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateBasedOnState(state);
            });
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, mainColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: -100, right: -100, child: _circle(250)),
                Positioned(bottom: -50, left: -50, child: _circle(200)),
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Center(child: Image.asset('assets/icon_skinsight.png', width: 64,)),
                                )
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'SkinSight',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: whiteColor,
                                      fontSize: 30,
                                      fontWeight: bold,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'AI-Powered Insights for Healthier Skin',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: bold,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const SizedBox(height: 48),
                              SizedBox(
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: _loadingProgress,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: whiteColor.withOpacity(0.05),
        ),
      );
}
