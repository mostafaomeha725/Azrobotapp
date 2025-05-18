import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this.apiService) : super(VerifyOtpInitial());
  final ApiService apiService;
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    emit(VerifyOtpLoading());

    final result = await apiService.otpVerify(
      email: email,
      otp: otp,
    );

    result.fold(
      (failure) {
        emit(VerifyOtpFailure(errMessage: failure.errMessage));
      },
      (message) {
        emit(VerifyOtpSuccess());
      },
    );
  }
}
