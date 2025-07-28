import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/ui/circle_loading.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../core/ui/custom_button.dart';
import '../widgets/profile_form_item.dart';

class UpdateDataProfile extends StatefulWidget {
  const UpdateDataProfile({super.key});

  @override
  State<UpdateDataProfile> createState() => _UpdateDataProfileState();
}

class _UpdateDataProfileState extends State<UpdateDataProfile> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? nameError;

  bool validateForm() {
    return _formKey.currentState!.validate();
  }



  @override
  void dispose() {
    nameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Name'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileUpdating) {
            showLoadingDialog(context);
            
          } else if (state is ProfileFailed) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (mounted) {
                showCustomSnackbar(context, state.message);
              }
            });
          } else if (state is ChangePasswordProfileLoaded) {

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

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                
                });
            
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                    'Use real name for easy verification. This name will appear on several pages.'),
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: _formKey,
                  child: ProfileFormItems(
                      controller: nameController,
                      errorText: nameError,
                      obsecureText: false,
                      isShowTitle: false,
                      isShowHint: true,
                      hintTitle: "Name",
                      iconVisibility: false,
                      readOnly: false,
                      textInputFormatter: [],
                      textInputAction: TextInputAction.done,
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
                ),
                SizedBox(
                  height: 24,
                ),
                FilledButtonItems(
                  title: 'Save',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ProfileBloc>().add(UpdateProfileEvent(
                          fullName: nameController.text, profilePicture: null));
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
