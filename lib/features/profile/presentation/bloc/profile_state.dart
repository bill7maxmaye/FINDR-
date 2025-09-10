
import '../../../auth/domain/entities/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});
}

class ProfileUpdated extends ProfileState {
  final User user;

  ProfileUpdated({required this.user});
}

class ProfilePasswordChanged extends ProfileState {}

class ProfileAccountDeleted extends ProfileState {}

class ProfileImageUploaded extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
