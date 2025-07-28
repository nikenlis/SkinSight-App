import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/core/ui/circle_loading.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../../core/ui/shared_method.dart';
import '../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../widgets/form_items.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  onTapRegister() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.signUpPage, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationLoading) {
            showLoadingDialog(context);
          } else if (state is AuthenticationFailed) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (mounted) {
                if (state.message.toLowerCase().contains('Internet')) {
                  Navigator.pushNamed(context, AppRoute.noConnectionPage);
                } else {
                  showCustomSnackbar(context, state.message);
                }
              }
            });
          } else if (state is AuthenticationLoaded) {
            final prefs = await SharedPreferences.getInstance();
            final assesmentStatus = prefs.getBool('assesmentStatus');
            if (assesmentStatus!) {
              context.read<BottomNavigationBarCubit>().change(0);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.bottomNavBar, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.assesmentPage, (route) => false);
            }
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 200),
            children: [
              Text(
                'Sign In',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: kMainTextColor,
                    fontWeight: semiBold,
                  ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //EMAIL
                      FormItems(
                        title: 'Email',
                        controller: emailController,
                        errorText: emailError,
                        obsecureText: false,
                        isShowTitle: true,
                        isShowHint: true,
                        hintTitle: "Enter email",
                        iconVisibility: false,
                        readOnly: false,
                        textInputFormatter: [],
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) {
                          setState(() {
                            final trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              emailError = 'Email is required';
                            } else if (!trimmedValue.contains('@')) {
                              emailError = 'Please enter a valid email address';
                            } else {
                              emailError = null;
                            }
                          });
                        },
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Email is required';
                          if (!email.contains('@'))
                            return 'Please enter a valid email address';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FormItems(
                        title: 'Enter password',
                        controller: passwordController,
                        errorText: passwordError,
                        obsecureText: true,
                        isShowTitle: true,
                        isShowHint: true,
                        hintTitle: "Must be at least 8 characters",
                        iconVisibility: true,
                        readOnly: false,
                        textInputFormatter: [],
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              passwordError = 'Password is required';
                            } else if (value.length < 8) {
                              passwordError =
                                  'Password must be at least 8 characters';
                            } else {
                              passwordError = null;
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoute.generateOtpForgotPasswordPage);
                        },
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: regular,
                              color: blackColor.withValues(alpha: 0.7)),
                        ),
                      ),
                      SizedBox(
                height: 38,
              ),
              FilledButtonItems(
                  title: 'Sign In',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(GetSigninEvent(
                          email: emailController.text,
                          password: passwordController.text));
                    }
                  }),
                    ],
                  ),
                ),
              ),
              
              // SizedBox(
              //   height: 16,
              // ),
              // OutlineButtonItems(
              //     title: 'Create Account',
              //     onPressed: () {
              //       Navigator.pushNamed(
              //           context, AppRoute.signUpPage);
              //     }),
              SizedBox(
                height: 30,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have account? ",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        fontWeight: regular,
                        color: kSecondaryTextColor),
                    children: [
                      TextSpan(
                          text: 'Sign Up',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: semiBold,
                                  color: kMainTextColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = onTapRegister),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 55,
              ),
            ],
          );
        },
      ),
    );
  }
}
