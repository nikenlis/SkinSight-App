part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {

}

class UpdateProfileEvent extends ProfileEvent {
final String? fullName;
final File? profilePicture;

  const UpdateProfileEvent({required this.fullName, required this.profilePicture});
}

class ChangePasswordProfileEvent extends ProfileEvent {
final String? currentPassword;
final String newPassword;
final String confirmPassword;

  ChangePasswordProfileEvent({required this.currentPassword, required this.newPassword, required this.confirmPassword});

  
}
