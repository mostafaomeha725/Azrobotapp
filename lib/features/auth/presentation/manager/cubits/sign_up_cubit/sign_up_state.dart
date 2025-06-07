// sign_up_state.dart

part of 'sign_up_cubit.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String email;
  final String password;

  const SignUpSuccess({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpFailure extends SignUpState {
  final String errMessage;

  const SignUpFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
