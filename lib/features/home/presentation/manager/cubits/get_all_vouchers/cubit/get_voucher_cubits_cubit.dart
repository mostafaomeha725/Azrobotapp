import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_voucher_cubits_state.dart';

class GetVoucherCubit extends Cubit<GetVoucherState> {
  GetVoucherCubit(this.apiService) : super(GetVoucherInitial());

  final ApiService apiService;

  Future<void> getAllVouchers() async {
    emit(GetVoucherLoading());

    final result = await apiService.getAllVoucher();

    result.fold(
      (failure) {
        emit(GetVoucherFailure(failure.errMessage));
      },
      (apiData) {
        try {
          final vouchers = List<Map<String, dynamic>>.from(apiData['data']);
          emit(GetVoucherSuccess(vouchers: vouchers));
        } catch (e) {
          emit(GetVoucherFailure('فشل في قراءة بيانات العروض'));
        }
      },
    );
  }
}
