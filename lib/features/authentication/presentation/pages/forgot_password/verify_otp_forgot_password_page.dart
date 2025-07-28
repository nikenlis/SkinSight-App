import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/circle_loading.dart';
import 'package:skinsight/core/ui/custom_button.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:skinsight/features/authentication/presentation/bloc/forgot_password/forgot_password_bloc.dart';

import '../../../../../core/ui/shared_method.dart';

class VerifyOtpForgotPasswordPage extends StatefulWidget {
  final String email;
  const VerifyOtpForgotPasswordPage({super.key, required this.email});

  @override
  State<VerifyOtpForgotPasswordPage> createState() =>
      _VerifyOtpForgotPasswordPageState();
}

class _VerifyOtpForgotPasswordPageState
    extends State<VerifyOtpForgotPasswordPage> {
  late final TextEditingController pinController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? error;

  Timer? _timer;
  int _countDown = 60;
  bool canResend = false;

  @override
  void initState() {
    pinController = TextEditingController();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          _timer?.cancel();
          canResend = true;
        }
      });
    });
  }

  void _resendOtp() {
    if (canResend) {
      setState(() {
        _countDown = 60;
        canResend = false;
      });
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 77,
      height: 77,
      textStyle: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontSize: 32, fontWeight: medium, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: blackColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
    );
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          context.read<ForgotPasswordBloc>().add(ForgotPasswordResetEvent());
          if (Navigator.canPop(context)) {
            Future.delayed(Duration.zero, () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.generateOtpForgotPasswordPage,
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
            } else if (state is VerifyOtpForgotPasswordLoading) {
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
            } else if (state is VerifyOtpForgotPasswordLoaded) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await Future.delayed(Duration(milliseconds: 300));
              if (state.data.isValid) {
                  Future.microtask(() {
                if (mounted) {
                  alertCustomSnackbar(context, 'Your OTP has been verified');
                }
              });
              Future.delayed(Duration(seconds: 1), () async {
                Navigator.pushNamed(
                    context, AppRoute.resetPasswordForgotPasswordPage, arguments: state.data.token);
              });
              } else {
                if (mounted) {
                  showCustomSnackbar(context, '${state.data.statusOtp} OTP');
                }
              }
            } else if (state is RequestNewOtpForgotPasswordLoaded) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              if (mounted) {
                alertCustomSnackbar(context, state.data);
              }
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 56),
              children: [
                Text(
                  'Please check your email',
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
                  'We’ve sent a code to your email  ${widget.email}',
                  style: blackRobotoTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: regular,
                      color: kSecondaryTextColor),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                          "Enter your code here",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                  color: kSecondaryTextColor),
                        ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Pinput(
                        controller: pinController,
                        onCompleted: (value) {},
                        length: 4,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        defaultPinTheme: PinTheme(
                          width: 64,
                          height: 64,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 28,
                                  fontWeight: medium,
                                  color: Colors.black),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: blackColor.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        errorBuilder: (errorText, pin) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              errorText ?? "",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          );
                        },
                        errorText: error,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'OTP code is required';
                          } else if (value.length != 4) {
                            return 'OTP code must be exactly 4 digits';
                          }
                          return null;
                        },
                        pinputAutovalidateMode:
                            PinputAutovalidateMode.onSubmit),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '00:${_countDown.toString()}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          fontWeight: regular,
                          color: kSecondaryTextColor),
                    ),
                    Row(
                      children: [
                        Text(
                          "Didn't receive otp? ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                  color: kSecondaryTextColor),
                        ),
                        canResend
                            ? InkWell(
                                onTap: () {
                                  _resendOtp();
                                  context
                                      .read<ForgotPasswordBloc>()
                                      .add(RequestNewOtpForgotPassword(email: widget.email));
                                },
                                child: Text(
                                  "Resend",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: semiBold,
                                          color: mainColor),
                                ),
                              )
                            : Text(
                                "Resend",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: semiBold,
                                        color: kSecondaryTextColor),
                              ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 38,
                ),
                FilledButtonItems(
                    title: 'Verify OTP',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                            VerifyOtpForgotPassword(
                                email: widget.email, otp: pinController.text));
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
