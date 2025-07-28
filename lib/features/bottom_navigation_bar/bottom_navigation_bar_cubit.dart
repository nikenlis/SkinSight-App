import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skinsight/features/explore/presentation/pages/explore_page.dart';
import 'package:skinsight/features/profile/presentation/pages/profile_page.dart';


import '../home/presentation/pages/home_page.dart';
import '../product/presentation/pages/product/product_page.dart';
import '../scan_ingredients/presentation/pages/scan_ingredients/scan_ingredients_page.dart';


class BottomNavigationBarCubit extends Cubit<int> {
  BottomNavigationBarCubit() : super(0);

  void change(int index) => emit(index);
  void resetToHome() => emit(0);

  final List<List<dynamic>> menuBottomNavigationBarCubit = [
    ['Home', 'assets/icon_home.svg', const HomePage()],
    ['Product', 'assets/icon_product.svg', const ProductPage()],
    ['Scan', 'assets/icon_scan.svg', const ScanIngredientsPage()],
    ['Explore', 'assets/icon_explore.svg', ExplorePage()],
    ['Profile', 'assets/icon_profile.svg', const ProfilePage()],
  ];

  Widget get page => menuBottomNavigationBarCubit[state][2];

}
