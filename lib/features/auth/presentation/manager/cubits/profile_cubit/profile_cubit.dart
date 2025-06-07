import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiService apiService;
  final SharedPreference sharedPreference;

  ProfileCubit(this.apiService, this.sharedPreference)
      : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final profileData = await sharedPreference.getProfileData();

    if (profileData != null) {
      emit(ProfileSuccess(profileData: profileData));
    } else {
      final result = await apiService.getProfileData();

      result.fold(
        (failure) => emit(ProfileFailure(errMessage: failure.errMessage)),
        (profileData) async {
          await sharedPreference.saveProfileData(profileData);
          emit(ProfileSuccess(profileData: profileData));
        },
      );
    }
  }
}
