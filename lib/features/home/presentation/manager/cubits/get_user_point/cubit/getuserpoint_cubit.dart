import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'getuserpoint_state.dart';

class GetUserPointCubit extends Cubit<GetUserPointState> {
  final ApiService apiService;

  GetUserPointCubit(this.apiService) : super(GetUserPointInitial());

  Future<void> getUserPoints(String userId) async {
    emit(GetUserPointLoading());

    final result = await apiService.getuserpoint(userId);

    result.fold(
      (failure) {
        emit(GetUserPointFailure(failure.errMessage));
      },
      (apiData) {
        try {
          final data = apiData['data'];
          final points = int.tryParse(data['points'].toString()) ?? 0;
          emit(GetUserPointSuccess(points: points));
        } catch (e) {
          emit(GetUserPointFailure('فشل في قراءة نقاط المستخدم'));
        }
      },
    );
  }
}

