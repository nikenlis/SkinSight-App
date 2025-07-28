import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinsight/features/assesment/presentation/bloc/assesment_bloc.dart';
import 'package:skinsight/features/authentication/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:skinsight/features/explore/presentation/bloc/news/news_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/brand/brand_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/category_brand/category_brand_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/product_filter/product_filter_bloc.dart';
import 'package:skinsight/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:skinsight/features/recomendation_product/presentation/bloc/recomendation_product_bloc.dart';
import 'package:skinsight/features/scan_type_skin/presentation/bloc/scan_image_bloc.dart';
import 'package:skinsight/features/uv_index/presentation/bloc/uv_index_bloc.dart';
import 'package:skinsight/injection.dart';
import 'core/common/app-navigator.dart';
import 'core/common/app_route.dart';
import 'features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'features/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'features/explore/presentation/bloc/education/education_bloc.dart';
import 'features/product/presentation/bloc/search/search_bloc.dart';
import 'features/scan_ingredients/presentation/bloc/history_ingredients/history_ingredients_bloc.dart';
import 'features/scan_ingredients/presentation/bloc/scan_ingredients/scan_ingredients_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FaceCamera.initialize();
  await initLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData kAppThemeData = _buildThemeData(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BottomNavigationBarCubit()),
          BlocProvider(
              create: (_) =>
                  locator<AuthenticationBloc>()..add(AuthCheckCredential())),
          BlocProvider(create: (_) => locator<ForgotPasswordBloc>()),
          BlocProvider(create: (_) => locator<AssesmentBloc>()),
          BlocProvider(create: (_) => locator<ScanImageBloc>()),
          BlocProvider(create: (_) => locator<ScanIngredientsBloc>()),
          BlocProvider(create: (_) => locator<HistoryIngredientsBloc>()),
          BlocProvider(
              create: (_) => locator<RecomendationProductBloc>()
                ..add(GetRecomendationProductEvent())),
          BlocProvider(
              create: (_) =>
                  locator<ProductBloc>()..add(GetProductEvent(page: 1))),
          BlocProvider(
              create: (_) =>
                  locator<ProductFilterBloc>()..add(GetProductFilterEvent())),
          BlocProvider(create: (_) => locator<BrandBloc>()),
          BlocProvider(create: (_) => locator<CategoryBrandBloc>()),
          BlocProvider(create: (_) => locator<SearchBloc>()),
          BlocProvider(
              create: (_) =>
                  locator<NewsBloc>()..add(GetAllNews(isRefresh: true))),
          BlocProvider(
              create: (_) => locator<EducationBloc>()
                ..add(GetAllEducation(isRefresh: true))),
          BlocProvider(
              create: (_) => locator<ProfileBloc>()..add(GetProfileEvent())),
          BlocProvider(create: (_) => locator<UvIndexBloc>()),
          BlocProvider(create: (_) => locator<ChatbotBloc>()),
          // BlocProvider(
          //     create: (_) => locator<ProfileBloc>()),
          // BlocProvider(
          //     create: (_) => locator<ProfileBloc>()),
          // BlocProvider(
          //     create: (_) => locator<ProfileBloc>()),
          // BlocProvider(
          //     create: (_) => locator<ProfileBloc>()),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: kAppThemeData,
          initialRoute: AppRoute.splashPage,
          onGenerateRoute: AppRoute.onGenerateRoute,
        ));
  }

  ThemeData _buildThemeData(BuildContext context) {
    final base = ThemeData.light();
    final baseTextTheme = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: mainColor,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackgroundColor,
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (BuildContext context) {
          return const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kMainTextColor,
          );
        },
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: lightBackgroundColor,
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(fontSize: 20, color: kMainTextColor, fontWeight: medium),
        iconTheme: IconThemeData(
          color: kMainTextColor,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge!.copyWith(
          height: 32.0 / 22.0,
          fontWeight: FontWeight.bold,
          color: kMainTextColor,
          letterSpacing: 0.5,
        ),
        titleMedium: baseTextTheme.titleMedium!.copyWith(
          fontSize: 17.0,
          height: 27.0 / 17.0,
          color: kMainTextColor,
          letterSpacing: 0.5,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: baseTextTheme.titleSmall!.copyWith(
          fontSize: 15.0,
          height: 25.0 / 15.0,
          fontWeight: FontWeight.bold,
          color: kMainTextColor,
          letterSpacing: 0.5,
        ),
        bodyLarge: baseTextTheme.bodyLarge!.copyWith(
          fontSize: 17.0,
          height: 27.0 / 17.0,
          color: kMainTextColor,
          letterSpacing: 0.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium!.copyWith(
          fontSize: 15.0,
          height: 25.0 / 15.0,
          color: kMainTextColor,
          letterSpacing: 0.5,
        ),
        bodySmall: baseTextTheme.bodySmall!.copyWith(
          height: 15.0 / 12.0,
          color: kMainTextColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
