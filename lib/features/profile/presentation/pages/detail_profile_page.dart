import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/api/api_config.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';

import '../../../../core/theme/app_color.dart';
import '../bloc/profile_bloc.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key});

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  File? _imageFile;

  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      context.read<ProfileBloc>().add(UpdateProfileEvent(
          fullName: null, profilePicture: File(pickedFile.path)));
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      backgroundColor: whiteColor,
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: mainColor,
                ),
                title: const Text('Take a photo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: mainColor,
                ),
                title: const Text('Choose from gallery',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profile'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailed) {
            showCustomSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Skeletonizer(
              enabled: true,
              containersColor: Color(0xFFE0E0E0),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: whiteColor),
                    ),

                    const SizedBox(height: 16),

                    // Skeleton for "Change Profile Picture" text
                    Container(
                        height: 14, width: 140, color: Colors.grey.shade300),

                    const SizedBox(height: 32),

                    // Skeleton for Profile Info Fields
                    ListView.separated(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 14,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 14,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    ///--- IMAGE PROFILE
                    imageProfileSection(context, state),

                    /// --- DETAIL SECTION
                    detailSection(context, state)
                  ],
                ),
              ),
            );
          }
          return TextFailure();
        },
      ),
    );
  }

  imageProfileSection(BuildContext context, ProfileLoaded state) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoute.detailPhotoProfile,
                arguments: state.data.profilePicture,
              );
            },
            child: Hero(
              tag: 'detail-profile',
              child: SizedBox(
                height: 80,
                width: 80,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child: ExtendedImage.network(
                      '${ApiConfig.imageBaseUrl}${state.data.profilePicture}',
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      cache: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor.withValues(alpha: 0.9),
                            ),
                            child: Icon(
                              Icons.broken_image,
                              color: mainColor.withValues(alpha: 0.6),
                              size: 24,
                            ),
                          );
                        }
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _showImageSourceActionSheet();
              },
              child: Text(
                'Change Profile Picture',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: kMainTextColor,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  detailSection(BuildContext context, ProfileLoaded state) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          Divider(),
          SizedBox(
            height: 16,
          ),
          Text(
            'Profile Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          SizedBox(
            height: 32,
          ),

          ///--NAME
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoute.updateDataProfile,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Full Name',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kSecondaryTextColor,
                          fontSize: 14,
                          fontWeight: medium),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      // widget.data!.fullName,
                      state.data.fullName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kMainTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Iconsax.arrow_right_34,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
          ),

          ///--- EMAIL
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kSecondaryTextColor,
                        fontSize: 14,
                        fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    state.data.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(
            height: 16,
          ),
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          SizedBox(
            height: 32,
          ),

          ///--- GENDER
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Gender',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kSecondaryTextColor,
                        fontSize: 14,
                        fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    state.data.gender.toString().capitalizeFirst(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          ///--- AGE
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Age',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kSecondaryTextColor,
                        fontSize: 14,
                        fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    state.data.age.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          ///--- SKINTYPE
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Skintype',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kSecondaryTextColor,
                        fontSize: 14,
                        fontWeight: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    state.data.skinType.toString().capitalizeFirst(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kMainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),

          Center(
            child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
                child: Text(
                  'Closed Account',
                  style: TextStyle(color: Colors.red),
                )),
          )
        ],
      ),
    );
  }
}
