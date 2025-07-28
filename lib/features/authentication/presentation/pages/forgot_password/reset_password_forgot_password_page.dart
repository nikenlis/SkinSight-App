import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/ui/circle_loading.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/features/authentication/presentation/widgets/form_items.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/ui/custom_button.dart';
import '../../../../bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';

class ResetPasswordForgotPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordForgotPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordForgotPasswordPage> createState() =>
      _ResetPasswordForgotPasswordPageState();
}

class _ResetPasswordForgotPasswordPageState
    extends State<ResetPasswordForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? newPasswordError;
  String? confirmPasswordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          context.read<ForgotPasswordBloc>().add(ForgotPasswordResetEvent());
          if (Navigator.canPop(context)) {
            Future.delayed(Duration.zero, () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.resetPasswordForgotPasswordPage,
                (route) => false,
              );
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) async {
            if (state is ForgotPasswordLoading) {
              showLoadingDialog(context);
            } else if (state is ForgotPasswordFailed) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
      
              Future.microtask(() {
                if (mounted) {
                  showCustomSnackbar(context, state.message);
                }
              });
            } else if (state is ResetPasswordForgotPasswordLoaded) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
      
              await Future.delayed(Duration(milliseconds: 300));
      
              Future.microtask(() {
                if (mounted) {
                  alertCustomSnackbar(context, '${state.data} Please log in using your new password.');
                }
              });
              Future.delayed(Duration(seconds: 1), () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.signInPage, (route) => false);
              });
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 56),
              children: [
                Text(
                  'Create a New Password',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        color: kMainTextColor,
                        fontWeight: semiBold,
                      ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Your new password must be different from your previous password.',
                  style: blackRobotoTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: regular,
                      color: kSecondaryTextColor),
                ),
                SizedBox(
                  height: 50,
                ),
                //PASSWORD
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormItems(
                        title: 'Create a new password',
                        controller: newPasswordController,
                        errorText: newPasswordError,
                        obsecureText: true,
                        isShowTitle: true,
                        isShowHint: true,
                        hintTitle: "Must be 8 characters",
                        iconVisibility: true,
                        readOnly: false,
                        textInputFormatter: [],
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              newPasswordError = 'Password is required';
                            } else if (value.length < 8) {
                              newPasswordError =
                                  'Password must be at least 8 characters';
                            } else {
                              newPasswordError = null;
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
                  height: 22,
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
                        confirmPasswordError = 'Confirm password is required';
                      } else if (value != confirmPasswordController.text) {
                        confirmPasswordError = 'Confirm passwords do not match';
                      } else {
                        confirmPasswordError = null;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != confirmPasswordController.text) {
                      return 'Confirm passwords do not match';
                    }
                    return null;
                  },
                ),
                    ],
                  ),
                ),
                
                SizedBox(
                  height: 38,
                ),
                FilledButtonItems(
                    title: 'Send code',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                            ResetPasswordForgotPassword(
                                token: widget.token,
                                newPassword: newPasswordController.text,
                                confirmPassword: confirmPasswordController.text));
                      }
                    }),
              ],
            );
          },
        ),
      ),
    );
  }
}
