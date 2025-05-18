import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_all_contents_state.dart';
class GetAllContentsCubit extends Cubit<GetAllContentsState> {
  GetAllContentsCubit(this.apiService, this.sharedPreference)
      : super(GetAllContentsInitial());

  final ApiService apiService;
  final SharedPreference sharedPreference;

  Future<void> getAllContents() async {
    emit(GetAllContentsLoading());

    try {
      // Try to get cached data first
      final cached = await sharedPreference.getAllContentsData();
      if (cached != null && cached['data'] != null && cached['data']['contents'] != null) {
        emit(GetAllContentsSuccess(contents: List<Map<String, dynamic>>.from(cached['data']['contents'])));
      }

      // Then get fresh data
      final result = await apiService.getAllContents();
      result.fold(
        (failure) => emit(GetAllContentsFailure(errMessage: failure.errMessage)),
        (data) async {
          if (data['data'] == null || data['data']['contents'] == null) {
            throw Exception('Invalid data structure');
          }
          await sharedPreference.saveAllContentsData(data);
          emit(GetAllContentsSuccess(contents: List<Map<String, dynamic>>.from(data['data']['contents'])));
        },
      );
    } catch (e) {
      emit(GetAllContentsFailure(errMessage: e.toString()));
    }
  }
}