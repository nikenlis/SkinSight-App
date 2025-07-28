import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skinsight/core/api/api_config.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/core/ui/text_failure.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:skinsight/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/app_route.dart';
import '../../../../core/ui/circle_loading.dart';
import '../widgets/custum_curves_edges.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool? hasPassword;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///--- HEADER
            headerSection(context),

            ///--- BODY
            bodySection(context, hasPassword ?? false)
          ],
        ),
      ),
    );
  }

  headerSection(BuildContext context) {
    return ClipPath(
      clipper: CustumCurvesEdges(),
      child: Container(
        width: double.infinity,
        color: mainColor,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: Container(
                width: 400,
                height: 400,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(400),
                    color: whiteColor.withValues(alpha: 0.1)),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: Container(
                width: 400,
                height: 400,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(400),
                    color: whiteColor.withValues(alpha: 0.1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileFailed) {
                    showCustomSnackbar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: kToolbarHeight - 20,
                          ),
                          Text(
                            'Profile',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 20,
                                  color: whiteColor,
                                  fontWeight: extraBlack,
                                ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'adcsdcvsfvfvdfvfdvdfvdbgb',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 18,
                                    color: whiteColor,
                                    fontWeight: semiBold,
                                  ),
                            ),
                            subtitle: Text(
                              'adcsdcvsfvfvdfvfdvdfvdbgbvsbvndfvbdfnvfdn',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: whiteColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.detailProfilePage,
                                  );
                                },
                                icon: Icon(
                                  Icons.edit_square,
                                  color: whiteColor,
                                )),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipOval(
                                child: Container(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProfileLoaded) {
                    hasPassword = state.data.hasPassword;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: kToolbarHeight - 20,
                        ),
                        Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 20,
                                color: whiteColor,
                                fontWeight: extraBlack,
                              ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            state.data.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 18,
                                  color: whiteColor,
                                  fontWeight: semiBold,
                                ),
                          ),
                          subtitle: Text(
                            state.data.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.detailProfilePage,
                                );
                              },
                              icon: Icon(
                                Icons.edit_square,
                                color: whiteColor,
                              )),
                          leading: GestureDetector(
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
                                height: 50,
                                width: 50,
                                child: ClipOval(
                                  child: ExtendedImage.network(
                                    '${ApiConfig.imageBaseUrl}${state.data.profilePicture}',
                                    shape: BoxShape.circle,
                                    fit: BoxFit.cover,
                                    handleLoadingProgress: true,
                                    cache: true,
                                    loadStateChanged: (state) {
                                      if (state.extendedImageLoadState ==
                                          LoadState.failed) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                whiteColor.withValues(alpha: 0.9),
                                          ),
                                          child: Icon(
                                            Icons.broken_image,
                                            color:
                                                mainColor.withValues(alpha: 0.6),
                                            size: 24,
                                          ),
                                        );
                                      }
                                      if (state.extendedImageLoadState ==
                                          LoadState.loading) {
                                        return Container(
                                          width: 50,
                                          height: 50,
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
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    );
                  }
                  return TextFailure();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  bodySection(BuildContext context, bool hasPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          SizedBox(
            height: 16,
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.changePasswordProfilePage,
                  arguments: hasPassword);
            },
            leading: Icon(
              Iconsax.lock_1,
              color: mainColor,
              size: 26,
            ),
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    color: kMainTextColor,
                    fontWeight: medium,
                  ),
            ),
            subtitle: Text(
              'Change your current password for security',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    color: kSecondaryTextColor,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          ListTile(
            onTap: () async {
             _launcherUrl(context, 'https://wa.link/7mcrno');
            },
            leading: Icon(
              Iconsax.call,
              color: mainColor,
            ),
            title: Text(
              'Contact Support',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    color: kMainTextColor,
                    fontWeight: medium,
                  ),
            ),
            subtitle: Text(
              'Chat with our support team',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    color: kSecondaryTextColor,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationLogoutLoading) {
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
              } else if (state is AuthenticationLogoutLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.signInPage, (route) => false);
                });
              }
            },
            child: ListTile(
              onTap: () {
                context.read<AuthenticationBloc>().add(AuthLogoutEvent());
              },
              leading: Icon(
                Iconsax.logout_14,
                color: mainColor,
                size: 27,
              ),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      color: kMainTextColor,
                      fontWeight: medium,
                    ),
              ),
              subtitle: Text(
                'Sign out from your account',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 12,
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.historyScanIngredientsPage);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(mainColor),
              overlayColor: WidgetStateProperty.all(
                whiteColor.withValues(alpha: 0.2),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icon_history_scan.svg',
                  width: 32,
                  color: whiteColor,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  'See your scanned ingredients history',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: whiteColor,
                        fontWeight: medium,
                      ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

    Future<void> _launcherUrl(BuildContext context, String link) async {
    !await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
  }
}
