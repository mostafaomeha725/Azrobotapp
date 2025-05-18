part of 'purchase_vouchers_cubit.dart';
abstract class VoucherPurchaseState {}

class VoucherPurchaseInitial extends VoucherPurchaseState {}

class VoucherPurchaseLoading extends VoucherPurchaseState {}

class VoucherPurchaseSuccess extends VoucherPurchaseState {
  final Map<String, dynamic> voucherData;
  VoucherPurchaseSuccess(this.voucherData);
}

class VoucherPurchaseFailure extends VoucherPurchaseState {
  final String message;
  VoucherPurchaseFailure(this.message);
}
