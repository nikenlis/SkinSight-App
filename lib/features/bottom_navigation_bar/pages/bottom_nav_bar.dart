import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_color.dart';
import '../bottom_navigation_bar_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<BottomNavigationBarCubit, int>(
  //     builder: (context, currentIndex) {
  //       final cubit = context.read<BottomNavigationBarCubit>();

  //       return Scaffold(
  //         extendBody: true,
  //         backgroundColor: Colors.white,
  //         body: cubit.page,
  //         floatingActionButton: FloatingActionButton(
  //           onPressed: () => cubit.change(2),
  //           backgroundColor: Colors.blue,
  //           elevation: 6,
  //           shape: const CircleBorder(),
  //           child: SvgPicture.asset(
  //             'assets/icon_scan.svg',
  //             width: 24,
  //             height: 24,
  //             colorFilter: const ColorFilter.mode(
  //               Colors.white,
  //               BlendMode.srcIn,
  //             ),
  //           ),
  //         ),
  //         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  //         bottomNavigationBar: BottomAppBar(
  //           shape: const CircularNotchedRectangle(),
  //           notchMargin: 6,
  //           elevation: 8,
  //           color: Colors.white,
  //           clipBehavior: Clip.antiAlias,
  //           child: BottomNavigationBar(
  //             type: BottomNavigationBarType.fixed,
  //             currentIndex: currentIndex,
  //             backgroundColor: Colors.white,
  //             elevation: 0,
  //             selectedItemColor: Colors.blue,
  //             unselectedItemColor: Colors.grey,
  //             selectedLabelStyle: const TextStyle(
  //               fontSize: 10,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             unselectedLabelStyle: const TextStyle(
  //               fontSize: 10,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             onTap: (index) {
  //               if (index != 2) {
  //                 cubit.change(index);
  //               }
  //             },
  //             items: List.generate(
  //               cubit.menuBottomNavigationBarCubit.length,
  //               (i) {
  //                 final isScan = i == 2;
  //                 return BottomNavigationBarItem(
  //                   icon: isScan
  //                       ? const SizedBox.shrink()
  //                       : _buildIcon(
  //                           cubit.menuBottomNavigationBarCubit[i][1],
  //                           i == currentIndex,
  //                         ),
  //                   label: isScan ? '' : cubit.menuBottomNavigationBarCubit[i][0],
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildIcon(String assetPath, bool isActive) {
  //   return SvgPicture.asset(
  //     assetPath,
  //     width: 20,
  //     height: 20,
  //     colorFilter: ColorFilter.mode(
  //       isActive ? Colors.blue : Colors.grey,
  //       BlendMode.srcIn,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBarCubit, int>(
      builder: (context, currentIndex) {
        final cubit = context.read<BottomNavigationBarCubit>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: Colors.white,
          body: cubit.page,
          floatingActionButton: FloatingActionButton(
            onPressed: () => cubit.change(2),
            backgroundColor: mainColor,
            elevation: 6,
            shape: const CircleBorder(),
            splashColor: Colors.transparent,
            highlightElevation: 0,
            child: SvgPicture.asset(
              'assets/icon_scan.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            elevation: 8,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                backgroundColor: Colors.white,
                elevation: 0,
                selectedItemColor: mainColor,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                onTap: (index) {
                  if (index != 2) {
                    cubit.change(index);
                  }
                },
                items: List.generate(
                  cubit.menuBottomNavigationBarCubit.length,
                  (i) {
                    final isScan = i == 2;

                    return BottomNavigationBarItem(
                      icon: isScan
                          ? const SizedBox.shrink()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildIcon(
                                  cubit.menuBottomNavigationBarCubit[i][1],
                                  i == currentIndex,
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                      label: isScan
                          ? ''
                          : cubit.menuBottomNavigationBarCubit[i][0],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(String assetPath, bool isActive) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isActive ? mainColor : Colors.grey,
        BlendMode.srcIn,
      ),
    );
  }
}
