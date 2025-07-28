import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skinsight/core/common/app_route.dart';
import 'package:skinsight/core/common/network_info.dart';
import 'package:skinsight/core/ui/custom_button.dart';
import 'package:skinsight/core/ui/shared_method.dart';
import 'package:skinsight/features/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';

import '../core/theme/app_color.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  

    Future<void> _checkConnection(BuildContext context) async {
  final networkInfo = NetworkInfoImpl(connectivity: Connectivity());

  bool online = await networkInfo.isConnected();

  if (online) {
    context.read<BottomNavigationBarCubit>().change(0);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoute.bottomNavBar,
      (route) => false,
    );
  } else {
    showCustomSnackbar(
      context,
      'No internet connection. Please check your network.',
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.2)
                  ),
                  child: Icon(Icons.wifi_off, size: 60, color: mainColor),
                ),
              ),
              
              SizedBox(height: 24),
              Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kMainTextColor),
              ),
              SizedBox(height: 12),
              Text(
                'Your device is currently offline.\nPlease check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: kSecondaryTextColor),
              ),
              SizedBox(height: 24),
              FilledButtonItems(title: 'Retry', onPressed: (){
                _checkConnection(context);
              },)
            ],
          ),
        ),
      ),
    );
  }
}