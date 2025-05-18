part of 'sign_in_cubit.dart';


@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final String token;
  final int? userId; // Add user ID to success state

  SignInSuccess({required this.token, this.userId});
}

final class SignInFailure extends SignInState {
  final String errMessage;

  SignInFailure({required this.errMessage});
}
//class SignInUnverifiedUser extends SignInState {}
