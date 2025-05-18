import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_specific_category_state.dart';

class GetSpecificCategoryCubit extends Cubit<GetSpecificCategoryState> {
  GetSpecificCategoryCubit(this.apiService, this.sharedPreference)
      : super(GetSpecificCategoryInitial());

  final ApiService apiService;
  final SharedPreference sharedPreference;

  Future<void> getSpecificCategory(int id) async {
    emit(GetSpecificCategoryLoading());

    // اختيارية: جلب من الكاش
    final cached = await sharedPreference.getSpecificCategoryData(id);
    if (cached != null) {
      emit(GetSpecificCategorySuccess(category: cached['data']));
      return;
    }

    final result = await apiService.getSpecificCategory(id);
    result.fold(
      (failure) =>
          emit(GetSpecificCategoryFailure(errMessage: failure.errMessage)),
      (data) async {
        await sharedPreference.saveSpecificCategoryData(id, data);
        emit(GetSpecificCategorySuccess(category: data['data']));
      },
    );
  }
}
