import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'getuservouchers_state.dart';

class GetUserVoucherCubit extends Cubit<GetUserVoucherState> {
  final ApiService apiService;

  GetUserVoucherCubit(this.apiService) : super(GetUserVoucherInitial());

  Future<void> getUserVouchers(String userId) async {
    emit(GetUserVoucherLoading());

    final result = await apiService.getUserVouchers(userId);

    result.fold(
      (failure) {
        emit(GetUserVoucherFailure(failure.errMessage));
      },
      (apiData) {
        try {
          final data = apiData['data'];
          final vouchers = List<Map<String, dynamic>>.from(data['vouchers'] ?? []);
          emit(GetUserVoucherSuccess(vouchers: vouchers));
        } catch (e) {
          emit(GetUserVoucherFailure('فشل في قراءة بيانات قسائم المستخدم'));
        }
      },
    );
  }
}
