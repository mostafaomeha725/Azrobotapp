part of 'get_voucher_cubits_cubit.dart';

abstract class GetVoucherState extends Equatable {
  const GetVoucherState();

  @override
  List<Object?> get props => [];
}

class GetVoucherInitial extends GetVoucherState {}

class GetVoucherLoading extends GetVoucherState {}

class GetVoucherFailure extends GetVoucherState {
  final String errMessage;

  const GetVoucherFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}

class GetVoucherSuccess extends GetVoucherState {
  final List<Map<String, dynamic>> vouchers;
  final bool fromCache;
  final bool isUpdated;
  final bool isLoading;
  final String? error;

  const GetVoucherSuccess({
    required this.vouchers,
    this.fromCache = false,
    this.isUpdated = false,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [vouchers, fromCache, isUpdated, isLoading, error];
}
