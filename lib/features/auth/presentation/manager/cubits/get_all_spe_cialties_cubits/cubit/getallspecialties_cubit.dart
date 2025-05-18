import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'getallspecialties_state.dart';

class GetallspecialtiesCubit extends Cubit<SpecialtiesState> {
  final ApiService apiService;
  final SharedPreference sharedPreference;

  GetallspecialtiesCubit(this.apiService, this.sharedPreference)
      : super(SpecialtiesInitial());

  Future<void> getAllSpecialties() async {
    emit(SpecialtiesLoading());

    // First try to get from cache
    final cachedSpecialties = await sharedPreference.getSpecialtiesData();
    if (cachedSpecialties != null) {
      emit(SpecialtiesSuccess(
          specialties: cachedSpecialties['data']['specialties']));
      return;
    }

    // If not in cache, fetch from API
    final result = await apiService.getAllSpecialties();

    result.fold(
      (failure) => emit(SpecialtiesFailure(errMessage: failure.errMessage)),
      (specialtiesData) async {
        // Save to SharedPreferences for caching
        await sharedPreference.saveSpecialtiesData(specialtiesData);
        emit(SpecialtiesSuccess(
            specialties: specialtiesData['data']['specialties']));
      },
    );
  }

  String? getSpecialNameById(int specialId) {
    if (state is SpecialtiesSuccess) {
      final special = (state as SpecialtiesSuccess).specialties;
      try {
        final specialname = special.firstWhere(
          (city) => city['id'] == specialId,
        );
        return specialname['name'] as String?;
      } catch (e) {
        return null; // City not found
      }
    }
    return null; // Data not loaded yet
  }

  // Future<void> refreshSpecialties() async {
  //   // Force refresh by skipping cache
  //   final result = await apiService.getAllSpecialties();

  //   result.fold(
  //     (failure) => emit(SpecialtiesFailure(errMessage: failure.errMessage)),
  //     (specialtiesData) async {
  //       await sharedPreference.saveSpecialtiesData(specialtiesData);
  //       emit(SpecialtiesSuccess(
  //           specialties: specialtiesData['data']['specialties']));
  //     },
  //   );
  // }
}
