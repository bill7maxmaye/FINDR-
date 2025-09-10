import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile _updateProfile;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required UpdateProfile updateProfile,
    required ProfileRepository profileRepository,
  })  : _updateProfile = updateProfile,
        _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<ProfileLoadUser>(_onLoadUser);
    on<ProfileUpdateProfile>(_onUpdateProfile);
    on<ProfileChangePassword>(_onChangePassword);
    on<ProfileDeleteAccount>(_onDeleteAccount);
    on<ProfileUploadImage>(_onUploadImage);
  }

  Future<void> _onLoadUser(
    ProfileLoadUser event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _profileRepository.getCurrentUser();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    ProfileUpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _updateProfile.call(UpdateProfileParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      ));
      emit(ProfileUpdated(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onChangePassword(
    ProfileChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(ProfilePasswordChanged());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    ProfileDeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.deleteAccount();
      emit(ProfileAccountDeleted());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUploadImage(
    ProfileUploadImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.uploadProfileImage(event.imagePath);
      emit(ProfileImageUploaded());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
