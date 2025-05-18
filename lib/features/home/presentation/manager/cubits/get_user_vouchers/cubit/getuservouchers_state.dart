part of 'getuservouchers_cubit.dart';


abstract class GetUserVoucherState extends Equatable {
  const GetUserVoucherState();

  @override
  List<Object?> get props => [];
}

class GetUserVoucherInitial extends GetUserVoucherState {}

class GetUserVoucherLoading extends GetUserVoucherState {}

class GetUserVoucherFailure extends GetUserVoucherState {
  final String errMessage;

  const GetUserVoucherFailure(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}

class GetUserVoucherSuccess extends GetUserVoucherState {
  final List<Map<String, dynamic>> vouchers;

  const GetUserVoucherSuccess({required this.vouchers});

  @override
  List<Object?> get props => [vouchers];
}
