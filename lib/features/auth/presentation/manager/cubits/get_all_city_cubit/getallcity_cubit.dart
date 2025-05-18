import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'getallcity_state.dart';

class GetallcityCubit extends Cubit<GetallcityState> {
  final ApiService apiService;
  final SharedPreference sharedPreference;

  GetallcityCubit(this.apiService, this.sharedPreference)
      : super(CityInitial());

  Future<void> getAllCity() async {
    emit(CityLoading());

    // First try to get from cache
    final cachedCities = await sharedPreference.getCityData();
    if (cachedCities != null) {
      emit(CitySuccess(citys: cachedCities['data']['cities']));
      return;
    }

    // If not in cache, fetch from API
    final result = await apiService.getAllCity();

    result.fold(
      (failure) => emit(CityFailure(errMessage: failure.errMessage)),
      (citydata) async {
        // Save to SharedPreferences for caching
        await sharedPreference.saveCityData(citydata);
        emit(CitySuccess(citys: citydata['data']['cities']));
      },
    );
  }

  // Function to get city name by ID
 String? getCityNameById(int cityId) {
  if (state is CitySuccess) {
    final cities = (state as CitySuccess).citys;
    try {
      final city = cities.firstWhere(
        (city) => city['id'] == cityId,
        orElse: () => {'name': null}, // Return null if city not found
      );
      return city['name'] as String?;
    } catch (e) {
      return null;
    }
  }
  return null;
}

}
