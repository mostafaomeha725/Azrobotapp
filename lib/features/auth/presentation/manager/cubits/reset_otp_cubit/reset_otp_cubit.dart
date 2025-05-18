import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'reset_otp_state.dart';

class ResetOtpCubit extends Cubit<ResetOtpState> {
  ResetOtpCubit(this.apiService) : super(ResetOtpInitial());
  final ApiService apiService;
  Future<void> resetOtp({
    required String email,
    required BuildContext context,
  }) async {
    emit(ResetOtpLoading()); // Emit loading state

    final result = await apiService.resetOtp(
      email: email,
    );

    result.fold(
      (failure) {
        emit(ResetOtpFailure(
            errMessage:
                failure.errMessage)); // Emit failure state if the request fails
      },
      (message) {
        emit(
            ResetOtpSuccess()); // Emit success state if the OTP reset is successful
      },
    );
  }
}
