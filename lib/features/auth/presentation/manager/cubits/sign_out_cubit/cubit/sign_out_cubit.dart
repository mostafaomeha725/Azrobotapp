import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_out_state.dart';




class SignOutCubit extends Cubit<SignOutState> {
  final ApiService apiService;
  final SharedPreference sharedPreference;

  SignOutCubit({
    required this.apiService,
    required this.sharedPreference,
  }) : super(SignOutInitial());

  Future<void> logOutUser() async {
    emit(SignOutLoading());

    final result = await apiService.logOutUser();

    result.fold(
      (failure) => emit(SignOutFailure(errMessage: failure.errMessage)),
      (message) async {
        await sharedPreference.clearAllData();
        emit(SignOutSuccess());
      },
    );
  }
}