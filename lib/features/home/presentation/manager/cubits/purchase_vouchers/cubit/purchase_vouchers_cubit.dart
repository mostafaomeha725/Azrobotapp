import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';

part 'purchase_vouchers_state.dart';

class PurchaseVouchersCubit extends Cubit<VoucherPurchaseState> {
  PurchaseVouchersCubit() : super(VoucherPurchaseInitial());

  final ApiService apiService = ApiService();

  Future<void> purchaseVoucher(int voucherId) async {
    emit(VoucherPurchaseLoading());

    final result = await apiService.purchaseVoucher(voucherId);

    result.fold(
      (failure) => emit(VoucherPurchaseFailure(failure.errMessage)),
      (data) => emit(VoucherPurchaseSuccess(data)), // No need to extract "data['data']" here if already done in ApiService
    );
  }
}
