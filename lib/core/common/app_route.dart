import 'package:flutter/material.dart';
import 'package:skinsight/core/ui/detail_profile.dart';
import 'package:skinsight/features/assesment/presentation/pages/assesment_camera_scan_type_skin_page.dart';
import 'package:skinsight/features/authentication/presentation/pages/forgot_password/generate_otp_forgot_password_page.dart';
import 'package:skinsight/features/authentication/presentation/pages/forgot_password/reset_password_forgot_password_page.dart';
import 'package:skinsight/features/authentication/presentation/pages/forgot_password/verify_otp_forgot_password_page.dart';
import 'package:skinsight/features/authentication/presentation/pages/otp_page.dart';
import 'package:skinsight/features/authentication/presentation/pages/signin_page.dart';
import 'package:skinsight/features/assesment/presentation/pages/assesment_page.dart';
import 'package:skinsight/features/assesment/presentation/pages/assesment_success_page.dart';
import 'package:skinsight/features/chatbot/presentation/pages/chat_bot_page.dart';
import 'package:skinsight/features/explore/presentation/pages/detail_education_page.dart';
import 'package:skinsight/features/explore/presentation/pages/news_page.dart';
import 'package:skinsight/features/no_connection_page.dart';
import 'package:skinsight/features/product/domain/entities/product_entity.dart';
import 'package:skinsight/features/product/domain/entities/product_filter_entity.dart';
import 'package:skinsight/features/product/presentation/pages/brand/brand_page.dart';
import 'package:skinsight/features/product/presentation/pages/brand/search_product_by_brand_page.dart';
import 'package:skinsight/features/profile/domain/entities/profile_entity.dart';
import 'package:skinsight/features/profile/presentation/pages/change_password_profile_page.dart';
import 'package:skinsight/features/profile/presentation/pages/detail_profile_page.dart';
import 'package:skinsight/features/profile/presentation/pages/update_data_profile.dart';
import 'package:skinsight/features/recomendation_product/domain/entities/recommendation_product_entity.dart';
import 'package:skinsight/features/scan_ingredients/domain/entities/scan_ingredients_entity.dart';
import 'package:skinsight/features/scan_ingredients/presentation/pages/history_ingredients/history_scan_ingredients_page.dart';
import 'package:skinsight/features/scan_ingredients/presentation/pages/scan_ingredients/crop_image_ingredients_page.dart';
import 'package:skinsight/features/scan_ingredients/presentation/pages/scan_ingredients/result_scan_ingredients_page.dart';
import 'package:skinsight/features/scan_type_skin/presentation/pages/camera_scan_type_skin_page.dart';
import 'package:skinsight/features/scan_type_skin/presentation/pages/scan_image_page.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import '../../features/authentication/presentation/pages/signup_page.dart';
import '../../features/bottom_navigation_bar/pages/bottom_nav_bar.dart';
import '../../features/assesment/presentation/pages/result_skin_type.dart';
import '../../features/assesment/presentation/pages/scan_skin_type_page.dart';
import '../../features/explore/presentation/pages/detail_news_page.dart';
import '../../features/explore/presentation/pages/education_page.dart';
import '../../features/product/presentation/pages/brand/all_product_by_category_brand_page.dart';
import '../../features/scan_ingredients/presentation/pages/history_ingredients/detail_history_scan_ingredients_page.dart';
import '../../features/scan_ingredients/presentation/pages/scan_ingredients/camera_scan_ingredient_page.dart';
import '../../features/splash/test.dart';
import '../../features/uv_index/presentation/pages/uv_page.dart';
import '../../features/product/presentation/pages/brand/detail_brand_page.dart';
import '../../features/product/presentation/pages/product/detail_product_page.dart';
import '../../features/product/presentation/pages/product/search_product_page.dart';
import '../../features/recomendation_product/presentation/pages/detail_recomendation_product_page.dart';
import '../../features/scan_type_skin/presentation/pages/result_scan_image_page.dart';
import '../../features/splash/splash_page.dart';

class AppRoute {
  static const splashPage = '/splash';
  static const signUpPage = '/sign-up';
  static const signInPage = '/sign-in';
  static const generateOtpForgotPasswordPage = '/confirm-email-forgot-password';
  static const verifyOtpForgotPasswordPage = '/verify-otp-forgot-password';
  static const resetPasswordForgotPasswordPage =
      '/reset-password-forgot-password';
  static const otpPage = '/otp';
  static const assesmentPage = '/assesment';
  static const scanSkinTypePage = '/scan-skin-type';
  static const assesmentCameraSkinTypePage = '/assement-camera-skin-type';
  static const resultSkinTypePage = '/result-skin-type';
  static const assesmentSuccessPage = '/setup-profile-success';
  static const bottomNavBar = '/bottom-nav-bar';
  static const scanImagePage = '/scan-image-skin-type-home';
  static const cameraScanImagePage = '/camera-scan-image';
  static const resultScanImagePage = '/result-scan-image-skin-type-home';
  static const cameraScanIngredientPage = '/camera-scan-ingredient';
  static const cropImageIngredientsPage = '/cropImageIngredientsPage';
  static const resultScanIngredientsPage = '/result-scan-ingredients';
  static const historyScanIngredientsPage = '/history-scan-ingredient';
  static const detailHistoryScanIngredientsPage =
      '/detail-history-scan-ingredient';
  static const recomendationProductPage = '/recomendation-product';
  static const detailEducationPage = '/detail-education';
  static const detailProductPage = '/detail-product';
  static const brandPage = '/brand';
  static const detailBrandPage = '/detail-brand';
  static const allProductByCategoryBrandPage = '/all-product-by-category';
  static const searchProductBrandPage = '/serach-product-brand';
  static const searchProductPage = '/search-product';
  static const newsPage = '/news';
  static const educationPage = '/educations';
  static const detailNewsPage = '/detail-page';
  static const changePasswordProfilePage = '/change-password-profile';
  static const detailProfilePage = '/detail-profile-page';
  static const updateDataProfile = '/update-data-profile';
  static const detailPhotoProfile = '/detail-photo-profile';
  static const uvPage = '/uv';

  static const chatbotPage = '/chat-bot';
  //static const searchDestination = '/sign-in';
  //static const searchDestination = '/sign-in';
  //static const searchDestination = '/sign-in';
  static const noConnectionPage = '/offline';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPage:
        return MaterialPageRoute(builder: (context) => const SplashPage2());
      case signUpPage:
        return MaterialPageRoute(builder: (context) => const SignupPage());
      case signInPage:
        return MaterialPageRoute(builder: (context) => const SigninPage());
      case generateOtpForgotPasswordPage:
        return MaterialPageRoute(
            builder: (context) => const GenerateOtpForgotPasswordPage());
      case verifyOtpForgotPasswordPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => VerifyOtpForgotPasswordPage(
                  email: result,
                ));
      case resetPasswordForgotPasswordPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => ResetPasswordForgotPasswordPage(
                  token: result,
                ));
      case otpPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => OtpPage(
                  email: result,
                ));
      case assesmentPage:
        return MaterialPageRoute(builder: (context) => const AssesmentPage());
      case scanSkinTypePage:
        return MaterialPageRoute(
            builder: (context) => const ScanSkinTypePage());
      case assesmentCameraSkinTypePage:
        return MaterialPageRoute(
            builder: (context) => AssesmentCameraScanTypeSkinPage());
      case resultSkinTypePage:
        final result = settings.arguments as SkinTypeResultArgument;
        return MaterialPageRoute(
            builder: (context) => ResultSkinType(data: result));
      case assesmentSuccessPage:
        return MaterialPageRoute(
            builder: (context) => const AssesmentSuccessPage());
      case bottomNavBar:
        return MaterialPageRoute(builder: (context) => const BottomNavBar());
      case resultScanImagePage:
        final result = settings.arguments as ScanImageResultArgument;
        return MaterialPageRoute(
            builder: (context) => ResultScanImagePage(
                  data: result,
                ));
      case scanImagePage:
        return MaterialPageRoute(builder: (context) => const ScanImagePage());
      case cameraScanImagePage:
        return MaterialPageRoute(
            builder: (context) => const CameraScanTypeSkinPage());
      case cameraScanIngredientPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => CameraScanIngredientPage(
                  namaProduct: result,
                ));
      case cropImageIngredientsPage:
        final result = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => CropImageIngredientsPage(
                  data: result,
                ));
      case resultScanIngredientsPage:
        final result = settings.arguments as ScanIngredientsEntity;
        return MaterialPageRoute(
            builder: (context) => ResultScanIngredientsPage(data: result));
      case historyScanIngredientsPage:
        return MaterialPageRoute(
            builder: (context) => HistoryScanIngredientsPage());
      case detailHistoryScanIngredientsPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => DetailHistoryScanIngredientsPage(
                  data: result,
                ));
      case recomendationProductPage:
        return MaterialPageRoute(
            builder: (context) => RecomendationProductPage());
      case detailProductPage:
        final result = settings.arguments as ProductEntity;
        return MaterialPageRoute(
            builder: (context) => DetailProductPage(
                  data: result,
                ));
      case brandPage:
        return MaterialPageRoute(builder: (context) => BrandPage());
      case detailBrandPage:
        final result = settings.arguments as BrandEntity;
        return MaterialPageRoute(
            builder: (context) => DetailBrandPage(
                  data: result,
                ));
      case allProductByCategoryBrandPage:
        final result = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
            builder: (context) => AllProductByCategoryBrandPage(
                  data: result,
                ));
      case searchProductBrandPage:
        final result = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => SearchProductByBrandPage(
                  data: result,
                ));
      case searchProductPage:
        return MaterialPageRoute(builder: (context) => SearchProductPage());
      case newsPage:
        return MaterialPageRoute(builder: (context) => NewsPage());
      case educationPage:
        return MaterialPageRoute(builder: (context) => EducationPage());
      case detailNewsPage:
        final result = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => DetailNewsPage(
                  data: result,
                ));
      case detailEducationPage:
        final result = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DetailEducationPage(data: result),
        );
      case detailProfilePage:
        return MaterialPageRoute(builder: (context) => DetailProfilePage());
      case changePasswordProfilePage:
        final result = settings.arguments as bool;
        return MaterialPageRoute(
            builder: (context) => ChangePasswordProfilePage(hasPassword: result,));
      case updateDataProfile:
        return MaterialPageRoute(builder: (context) => UpdateDataProfile());
       case detailPhotoProfile:
        final result = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => DetailPhotoProfile(imgProfile: result,));
      case uvPage:
        final result = settings.arguments as UviDataEntity;
        return MaterialPageRoute(
            builder: (context) => UvPage(
                  data: result,
                ));
      case chatbotPage:
        return MaterialPageRoute(builder: (context) => ChatBotPage());
      // case educationPage:
      //   return MaterialPageRoute(builder: (context) => EducationPage());
      // case educationPage:
      //   return MaterialPageRoute(builder: (context) => EducationPage());
      // case educationPage:
      //   return MaterialPageRoute(builder: (context) => EducationPage());
      case noConnectionPage:
        return MaterialPageRoute(
            builder: (context) => const NoConnectionPage());
      default:
        return _notFoundPage;
    }
  }

  static MaterialPageRoute get _notFoundPage => MaterialPageRoute(
      builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ));
}
