import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/auth/presentation/manager/cubits/profile_cubit/profile_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final ApiService apiService;
  final ProfileCubit profileCubit; // إضافة ProfileCubit
  final SharedPreference sharedPreference;

  SignInCubit(this.apiService, this.profileCubit, this.sharedPreference)
      : super(SignInInitial());
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());

    final result = await apiService.signInUser(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(SignInFailure(errMessage: failure.errMessage)),
      (signInModel) async {
        await sharedPreference.clearProfileCache();
        await sharedPreference.removeToken();
        await sharedPreference.saveToken(signInModel.token);
  

      
          emit(SignInSuccess(token: signInModel.token));
      
      },
    );
  }

  Future<void> logOutUser() async {
    emit(SignInLoading());

    final result = await apiService.logOutUser();

    result
        .fold((failure) => emit(SignInFailure(errMessage: failure.errMessage)),
            (message) async {
      await sharedPreference.clearAllData();
      emit(SignInSuccess(token: ''));
    }

            // Clear token on logout
            );
  }
  
  
}

// point_cubit.dart

class PointCubit extends Cubit<String> {
  PointCubit() : super("0");

  Future<void> loadPoint() async {
    final prefs = await SharedPreferences.getInstance();
    final point = prefs.getString("point") ?? "0";
    emit(point);
  }

  Future<void> updatePoint(String newPoint) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("point", newPoint);
    emit(newPoint);
  }
}
