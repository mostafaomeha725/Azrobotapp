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

  // Method to fetch profile data from SharedPreferences or API
  Future<void> getProfile() async {
    emit(ProfileLoading());

    // Try to get the profile data from SharedPreferences
    final profileData = await sharedPreference.getProfileData();

    if (profileData != null) {
      // If profile data is available in SharedPreferences, emit it
      emit(ProfileSuccess(profileData: profileData));
    } else {
      // If no profile data in SharedPreferences, fetch it from the API
      final result = await apiService.getProfileData();

      result.fold(
        (failure) => emit(ProfileFailure(errMessage: failure.errMessage)),
        (profileData) async {
          // Save the profile data to SharedPreferences after fetching from API
          await sharedPreference.saveProfileData(profileData);
          emit(ProfileSuccess(profileData: profileData));
        },
      );
    }
  }
}
