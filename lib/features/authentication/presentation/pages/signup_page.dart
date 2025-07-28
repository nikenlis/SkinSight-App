import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/ui/circle_loading.dart';
import '../../../../core/ui/custom_button.dart';
import '../../../../core/ui/shared_method.dart';
import '../widgets/form_items.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? emailError;
  String? nameError;
  String? passwordError;
  String? confirmPasswordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  onTapRegister() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.signInPage, (route) => false);
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
                showCustomSnackbar(context, state.message);
              }
            });
          } else if (state is AuthenticationLoaded) {
            context.read<AuthenticationBloc>().add(AuthReset());
            await Navigator.pushNamed(
              context,
              AppRoute.otpPage,
              arguments: emailController.text,
            );
            
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            children: [
              Text(
                "Let's Create your account",
                style: blackRobotoTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                    color: blackColor.withValues(alpha: 0.8)),
              ),
              SizedBox(
                height: 32,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(16)
                  ),
                  child: Column(
                    children: [
                      //FULL NAME
                      FormItems(
                          title: 'Full Name',
                          controller: nameController,
                          errorText: nameError,
                          obsecureText: false,
                          isShowTitle: true,
                          isShowHint: true,
                          hintTitle: "Jhon Doe",
                          iconVisibility: false,
                          readOnly: false,
                          textInputFormatter: [],
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.name,
                          onFieldSubmitted: (value) {
                            setState(() {
                              if (value.trim().isEmpty) {
                                nameError = 'Name is required';
                              } else {
                                nameError = null;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16,
                      ),
                  
                      //EMAIL
                      FormItems(
                        title: 'Email',
                        controller: emailController,
                        errorText: emailError,
                        obsecureText: false,
                        isShowTitle: true,
                        isShowHint: true,
                        hintTitle: "Example@gmail.com",
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
                  
                      //PASSWORD
                      FormItems(
                        title: 'Create a password',
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
                        textInputAction: TextInputAction.next,
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
                        height: 16,
                      ),
                  
                      //CONFIRM PASSWORD
                      FormItems(
                        title: 'Confirm password',
                        controller: confirmPasswordController,
                        errorText: confirmPasswordError,
                        obsecureText: true,
                        isShowTitle: true,
                        isShowHint: true,
                        hintTitle: "Confirm your password",
                        iconVisibility: true,
                        readOnly: false,
                        textInputFormatter: [],
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              confirmPasswordError =
                                  'Confirm password is required';
                            } else if (value != passwordController.text) {
                              confirmPasswordError =
                                  'Confirm passwords do not match';
                            } else {
                              confirmPasswordError = null;
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Confirm passwords do not match';
                          }
                          return null;
                        },
                      ),
                       SizedBox(
                height: 38,
              ),
              FilledButtonItems(
                  title: 'Sign Up',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(GetSignupEvent(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text));
                    }
                  }),
                    ],
                  ),
                ),
              ),
             
              SizedBox(
                height: 30,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        fontWeight: regular,
                        color: blackColor.withValues(alpha: 0.7)),
                    children: [
                      TextSpan(
                          text: 'Sign In',
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
