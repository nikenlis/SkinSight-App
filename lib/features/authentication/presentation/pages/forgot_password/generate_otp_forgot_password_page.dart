import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/features/authentication/presentation/bloc/forgot_password/forgot_password_bloc.dart';

import '../../../../../core/common/app_route.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/ui/circle_loading.dart';
import '../../../../../core/ui/custom_button.dart';
import '../../../../../core/ui/shared_method.dart';
import '../../widgets/form_items.dart';

class GenerateOtpForgotPasswordPage extends StatefulWidget {
  const GenerateOtpForgotPasswordPage({super.key});

  @override
  State<GenerateOtpForgotPasswordPage> createState() =>
      _GenerateOtpForgotPasswordPageState();
}

class _GenerateOtpForgotPasswordPageState
    extends State<GenerateOtpForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController emailController = TextEditingController();
  String? emailError;
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          } else if (state is GenerateOtpForgotPasswordLoaded) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            await Future.delayed(Duration(milliseconds: 300));

            Future.microtask(() {
              if (mounted) {
                alertCustomSnackbar(context, state.data);
              }
            });
            Future.delayed(Duration(seconds: 1), () async {
              Navigator.pushNamed(
                  context, AppRoute.verifyOtpForgotPasswordPage, arguments: emailController.text);
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 56),
            children: [
              Text(
                'Forgot password',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      color: kMainTextColor,
                      fontWeight: semiBold,
                    ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Don’t worry! It happens. Please enter the \nemail associated with your account.',
                style: blackRobotoTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: regular,
                    color: kSecondaryTextColor),
              ),
              SizedBox(
                height: 36,
              ),
              Form(
                key: _formKey,
                child: FormItems(
                  title: 'Email',
                  controller: emailController,
                  errorText: emailError,
                  obsecureText: false,
                  isShowTitle: true,
                  isShowHint: true,
                  hintTitle: "Enter your email address",
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
              ),
              SizedBox(
                height: 38,
              ),
              FilledButtonItems(
                  title: 'Send',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ForgotPasswordBloc>().add(
                          GenerateOtpForgotPassword(
                              email: emailController.text));
                    }
                  }),
            ],
          );
        },
      ),
    );
  }
}
