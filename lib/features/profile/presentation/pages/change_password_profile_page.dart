import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/ui/custom_button.dart';

import '../../../authentication/presentation/widgets/form_items.dart';
import '../bloc/profile_bloc.dart';

class ChangePasswordProfilePage extends StatefulWidget {
  final bool hasPassword;
  const ChangePasswordProfilePage({super.key, required this.hasPassword});

  @override
  State<ChangePasswordProfilePage> createState() =>
      _ChangePasswordProfilePageState();
}

class _ChangePasswordProfilePageState extends State<ChangePasswordProfilePage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? currentPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateForm() {
    return _formKey.currentState!.validate();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
       canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (didPop) {
          context.read<ProfileBloc>().add(GetProfileEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
           
          },
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Create a strong and secure password to keep your account safe.'),
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      widget.hasPassword ? FormItems(
                        title: 'Current passowrd',
                        controller: currentPasswordController,
                        errorText: currentPasswordError,
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
                              currentPasswordError = 'Password is required';
                            } else if (value.length < 8) {
                              currentPasswordError =
                                  'Password must be at least 8 characters';
                            } else {
                              currentPasswordError = null;
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
                      ) : SizedBox(),
                      SizedBox(
                        height: 22,
                      ),
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
                              confirmPasswordError =
                                  'Confirm password is required';
                            } else if (value != newPasswordController.text) {
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
                          if (value != newPasswordController.text) {
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
                  title: 'Save',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProfileBloc>().add(ChangePasswordProfileEvent(
                          currentPassword: currentPasswordController.text,
                          newPassword: newPasswordController.text,
                          confirmPassword: confirmPasswordController.text));
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
