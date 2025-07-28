import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsight/core/common/network_info.dart';
import 'package:skinsight/features/authentication/domain/repositories/auth_repository.dart';
import 'package:skinsight/features/authentication/domain/usecases/check_credential_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/fogot_password/generate_otp_forgot_password_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/get_signin_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/get_verify_otp_usecase.dart';
import 'package:skinsight/features/authentication/domain/usecases/request_new_otp_usecase.dart';
import 'package:skinsight/features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:skinsight/features/authentication/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:skinsight/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:skinsight/features/explore/domain/repositories/explore_repository.dart';
import 'package:skinsight/features/explore/domain/usecases/get_all_news_usecase.dart';
import 'package:skinsight/features/explore/presentation/bloc/education/education_bloc.dart';
import 'package:skinsight/features/explore/presentation/bloc/news/news_bloc.dart';
import 'package:skinsight/features/product/domain/usecases/category_brand_usecase.dart';
import 'package:skinsight/features/product/domain/usecases/product_by_category_brand_usecase.dart';
import 'package:skinsight/features/product/domain/usecases/product_usecase.dart';
import 'package:skinsight/features/product/presentation/bloc/brand/brand_bloc.dart';
import 'package:skinsight/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:skinsight/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:skinsight/features/profile/domain/usecases/change_password_profile_usecase.dart';
import 'package:skinsight/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:skinsight/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:skinsight/features/recomendation_product/domain/repositories/recomendation_product_repository.dart';
import 'package:skinsight/features/recomendation_product/presentation/bloc/recomendation_product_bloc.dart';
import 'package:skinsight/features/scan_ingredients/domain/usecases/get_detail_history_scan_ingredients_usecase.dart';
import 'package:skinsight/features/scan_ingredients/domain/usecases/get_history_scan_ingredients_usecase.dart';
import 'package:skinsight/features/scan_type_skin/data/repositories/scan_image_repository_impl.dart';
import 'package:skinsight/features/scan_type_skin/presentation/bloc/scan_image_bloc.dart';
import 'package:skinsight/features/uv_index/data/datasources/uv_remote_datasource.dart';
import 'package:skinsight/features/uv_index/data/repositories/uv_repository_impl.dart';
import 'package:skinsight/features/uv_index/domain/repositories/uv_repository.dart';
import 'core/api/api_client.dart';
import 'features/assesment/data/datasources/assesment_remote_datasource.dart';
import 'features/assesment/data/repositories/assesment_repository_impl.dart';
import 'features/assesment/domain/repositories/assesment_repository.dart';
import 'features/assesment/domain/usecases/get_assesment_usecase.dart';
import 'features/assesment/presentation/bloc/assesment_bloc.dart';
import 'features/authentication/data/datasources/auth_local_datasource.dart';
import 'features/authentication/data/datasources/auth_remote_datasource.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/usecases/fogot_password/request_new_otp_forgot_password_usecase.dart';
import 'features/authentication/domain/usecases/fogot_password/reset_password_forgot_password_usecase.dart';
import 'features/authentication/domain/usecases/fogot_password/verify_otp_forgot_password_usecase.dart';
import 'features/authentication/domain/usecases/get_signup_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'features/chatbot/domain/repositories/chatbot_repository.dart';
import 'features/chatbot/domain/usecases/get_output_chatbot_usecase.dart';
import 'features/explore/data/datasources/explore_remote_datasource.dart';
import 'features/explore/data/repositories/explore_repository_impl.dart';
import 'features/explore/domain/usecases/get_all_education_usecase.dart';
import 'features/explore/domain/usecases/get_detail_education_usecase.dart';
import 'features/explore/domain/usecases/get_detail_news_usecase.dart';
import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/product_filter_usecase.dart';
import 'features/product/presentation/bloc/category_brand/category_brand_bloc.dart';
import 'features/product/presentation/bloc/product_filter/product_filter_bloc.dart';
import 'features/product/presentation/bloc/search/search_bloc.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/recomendation_product/data/datasources/recomendation_product_remote_datasource.dart';
import 'features/recomendation_product/data/repositories/recomendation_product_repositories_impl.dart';
import 'features/recomendation_product/domain/usecases/recomendation_product_usecase.dart';
import 'features/scan_ingredients/data/datasources/scan_ingredients_remote_datasource.dart';
import 'features/scan_ingredients/data/repositories/scan_ingredients_repository_impl.dart';
import 'features/scan_ingredients/domain/repositories/scan_ingredients_repository.dart';
import 'features/scan_ingredients/domain/usecases/scan_ingredients_usecase.dart';
import 'features/scan_ingredients/presentation/bloc/history_ingredients/history_ingredients_bloc.dart';
import 'features/scan_ingredients/presentation/bloc/scan_ingredients/scan_ingredients_bloc.dart';
import 'features/scan_type_skin/data/datasources/scan_image_remote_datasource.dart';
import 'features/scan_type_skin/domain/repositories/scan_image_repository.dart';
import 'features/scan_type_skin/domain/usecases/get_scan_image_usecase.dart';
import 'features/uv_index/domain/usecases/get_data_uv_usecase.dart';
import 'features/uv_index/presentation/bloc/uv_index_bloc.dart';

final locator = GetIt.instance;
Future<void> initLocator() async {
  //external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => pref);
  locator.registerLazySingleton(() => Connectivity());

  //platform
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: locator()));
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  //AUTHENTICATION
  //bloc
  locator.registerFactory(
      () => AuthenticationBloc(locator(), locator(), locator(), locator(), locator(), locator()));
  locator.registerFactory(
      () => ForgotPasswordBloc(locator(), locator(), locator(), locator()));

  //usecase
  locator.registerLazySingleton(() => GetSignupUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetSigninUsecase(repository: locator()));
  locator.registerLazySingleton(
      () => CheckCredentialUsecase(repository: locator()));
      locator.registerLazySingleton(
      () => GetVerifyOtpUsecase(repository: locator()));
      locator.registerLazySingleton(
      () => RequestNewOtpUsecase(repository: locator()));
  locator.registerLazySingleton(() => GenerateOtpForgotPasswordUsecase(repository: locator()));
  locator.registerLazySingleton(() => VerifyOtpForgotPasswordUsecase(repository: locator()));
  locator.registerLazySingleton(() => RequestNewOtpForgotPasswordUsecase(repository: locator()));
  locator.registerLazySingleton(() => ResetPasswordForgotPasswordUsecase(repository: locator()));
  locator.registerLazySingleton(() => LogoutUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      networkInfo: locator(),
      localDatasource: locator(),
      remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(pref: locator()));
  locator.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(apiClient: locator()));

  //ASSESMENT
  //bloc
  locator.registerFactory(() => AssesmentBloc(locator()));

  //usecase
  locator
      .registerLazySingleton(() => GetAssesmentUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<AssesmentRepository>(() =>
      AssesmentRepositoryImpl(
          networkInfo: locator(),
          remoteDatasource: locator(),
          localDatasource: locator()));

  //datasource
  locator.registerLazySingleton<AssesmentRemoteDatasource>(
      () => AssesmentRemoteDatasourceImpl());

  //SCAN IMAGE
  //bloc
  locator.registerFactory(() => ScanImageBloc(locator()));

  //usecase
  locator
      .registerLazySingleton(() => GetScanImageUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<ScanImageRepository>(() =>
      ScanImageRepositoryImpl(
          networkInfo: locator(),
          remoteDatasource: locator(),
          localDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ScanImageRemoteDatasource>(
      () => ScanImageRemoteDatasourceImpl());

  //SCAN INGREDIENT
  //bloc
  locator.registerFactory(() => ScanIngredientsBloc(locator()));
  locator.registerFactory(() => HistoryIngredientsBloc(locator(), locator()));

  //usecase
  locator.registerLazySingleton(
      () => ScanIngredientsUsecase(repository: locator()));
   locator.registerLazySingleton(
      () => GetHistoryScanIngredientsUsecase(repository: locator()));
    locator.registerLazySingleton(
      () => GetDetailHistoryScanIngredientsUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<ScanIngredientsRepository>(() =>
      ScanIngredientsRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ScanIngredientsRemoteDatasource>(
      () => ScanIngredientsRemoteDatasourceImpl());

  //RECOMENDATION PRODUCT
  //bloc
  locator.registerFactory(() => RecomendationProductBloc(locator()));

  //usecase
  locator.registerLazySingleton(
      () => RecomendationProductUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<RecomendationProductRepository>(() =>
      RecomendationProductRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<RecomendationProductRemoteDatasource>(
      () => RecomendationProductRemoteDatasourceImpl());


  //PRODUCT
  //bloc
  locator.registerFactory(() => ProductBloc(locator()));
  locator.registerFactory(() => ProductFilterBloc(locator()));
  locator.registerFactory(() => BrandBloc(locator()));
  locator.registerFactory(() => CategoryBrandBloc(locator(), locator()));
  locator.registerFactory(() => SearchBloc(locator()));

  //usecase
  locator.registerLazySingleton(() => ProductUsecase(repository: locator()));
  locator.registerLazySingleton(() => ProductFilterUsecase(repository: locator()));
  locator.registerLazySingleton(() => CategoryBrandUsecase(repository: locator()));
  locator.registerLazySingleton(() => ProductByCategoryBrandUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<ProductRepository>(() =>
      ProductRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImpl());





  //EXPLORE
  //bloc
  locator.registerFactory(() => NewsBloc(locator(), locator()));
  locator.registerFactory(() => EducationBloc(locator(), locator()));

  //usecase
  locator.registerLazySingleton(() => GetAllNewsUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetAllEducationUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetDetailNewsUsecase(repository: locator()));
  locator.registerLazySingleton(() => GetDetailEducationUsecase(repository: locator()));

  //repository
  locator.registerLazySingleton<ExploreRepository>(() =>
      ExploreRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ExploreRemoteDatasource>(
      () => ExploreRemoteDatasourceImpl());
  

  //PROFILE
  //bloc
  locator.registerFactory(() => ProfileBloc(locator(), locator(), locator()));

  //usecase
  locator.registerLazySingleton(() => GetProfileUsecase(repository: locator()));
  locator.registerLazySingleton(() => UpdateProfileUsecase(repository: locator()));
  locator.registerLazySingleton(() => ChangePasswordProfileUsecase(repository: locator()));


  //repository
  locator.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ProfileRemoteDatasource>(
      () => ProfileRemoteDatasourceImpl());


      

  //UV INDEX
  //bloc
  locator.registerFactory(() => UvIndexBloc(locator()));

  //usecase
  locator.registerLazySingleton(() => GetDataUvUsecase(repository: locator()));
  //repository
  locator.registerLazySingleton<UvRepository>(() =>
      UvRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<UvRemoteDatasource>(
      () => UvRemoteDatasourceImpl());

  
  //CHATBOT
    //bloc
  locator.registerFactory(() => ChatbotBloc(locator()));

  //usecase
  locator.registerLazySingleton(() => GetOutputChatbotUsecase(repository: locator()));
  //repository
  locator.registerLazySingleton<ChatbotRepository>(() =>
      ChatbotRepositoryImpl(
          networkInfo: locator(), remoteDatasource: locator()));

  //datasource
  locator.registerLazySingleton<ChatbotRemoteDatasource>(
      () => ChatbotRemoteDatasourceImpl());
  

}
