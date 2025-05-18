import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:azrobot/core/api_services/api_service.dart';

part 'sign_up_state.dart';


class SignUpCubit extends Cubit<SignUpState> {
  final ApiService apiService;

  SignUpCubit({required this.apiService}) : super(SignUpInitial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String confirmPassword,
    required int city,
    required int specialty,
  }) async {
    emit(SignUpLoading());

    try {
      final result = await apiService.signUpUser(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
        confirmpassword: confirmPassword,
        cityId: city.toString(), // Convert to string for API
        specialtyId: specialty.toString(), // Convert to string for API
      );

      result?.fold(
        (failure) => emit(SignUpFailure(errMessage: failure.errMessage)),
        (_) => emit(SignUpSuccess()),
      );
    } catch (e) {
      emit(SignUpFailure(errMessage: "An unexpected error occurred"));
    }
  }
}