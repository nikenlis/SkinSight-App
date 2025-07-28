import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skinsight/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:skinsight/features/profile/domain/usecases/update_profile_usecase.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/change_password_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final ChangePasswordProfileUsecase _changePasswordProfileUsecase;

  ProfileEntity? _cachedProfile;

  ProfileEntity? get cachedProfile => _cachedProfile;


  ProfileBloc(this._getProfileUsecase, this._updateProfileUsecase, this._changePasswordProfileUsecase) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await _getProfileUsecase.execute();
      result.fold(
        (failure) {
          emit(ProfileFailed(message: failure.message));
        },
        (data) {
           _cachedProfile = data;
          emit(ProfileLoaded(data: data));
        },
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileUpdating());
      final result = await _updateProfileUsecase.execute(fullName: event.fullName, profilePicture: event.profilePicture);
      result.fold(
        (failure) {
          emit(ProfileFailed(message: failure.message));
        },
        (data) {
           _cachedProfile = data; 
          emit(ProfileLoaded(data: data));
          emit(ProfileUpdated(data: data));
          add(GetProfileEvent());
        },
      );
    });


    on<ChangePasswordProfileEvent>((event, emit) async {
      emit(ProfileUpdating());
      final result = await _changePasswordProfileUsecase.execute(currentPassword: event.currentPassword, newPassword: event.newPassword, confirmPassword: event.confirmPassword);
      // print('🔥🔥🔥  => current : ${event.currentPassword} new : ${event.newPassword} current : ${event.confirmPassword}');
      result.fold(
        (failure) {
          emit(ProfileFailed(message: failure.message));
        },
        (data) {
          emit(ChangePasswordProfileLoaded(data: data));
        },
      );
    });
  }
}
