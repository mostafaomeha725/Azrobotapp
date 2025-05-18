import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'getcategory_state.dart';

class GetcategoryCubit extends Cubit<GetcategoryState> {
  GetcategoryCubit(this.apiService, this.sharedPreference)
      : super(GetcategoryInitial());
  final ApiService apiService;
  final SharedPreference sharedPreference;
  Future<void> getAllCity() async {
    emit(GetcategoryLoading());

    // First try to get from cache
    final cachedcategory = await sharedPreference.getCategoryData();
    if (cachedcategory != null) {
      emit(GetcategorySuccess(category: cachedcategory['data']['categories']));
      return;
    }

    // If not in cache, fetch from API
    final result = await apiService.getCategory();

    result.fold(
      (failure) => emit(GetcategoryFailure(errMessage: failure.errMessage)),
      (citydata) async {
        // Save to SharedPreferences for caching
        await sharedPreference.saveCategoryData(citydata);
        emit(GetcategorySuccess(category: citydata['data']['categories']));
      },
    );
  }
}
