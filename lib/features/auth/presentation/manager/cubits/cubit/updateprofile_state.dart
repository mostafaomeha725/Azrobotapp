part of 'updateprofile_cubit.dart';


abstract class UpdateprofileState extends Equatable {
  const UpdateprofileState();

  @override
  List<Object?> get props => [];
}

class UpdateprofileInitial extends UpdateprofileState {}

class UpdateprofileLoading extends UpdateprofileState {}

class UpdateprofileSuccess extends UpdateprofileState {
  final Map<String, dynamic> response;

  const UpdateprofileSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class UpdateprofileFailure extends UpdateprofileState {
  final String error;

  const UpdateprofileFailure(this.error);

  @override
  List<Object?> get props => [error];
}
