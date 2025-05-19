part of 'getuserpoint_cubit.dart';


abstract class GetUserPointState extends Equatable {
  const GetUserPointState();

  @override
  List<Object> get props => [];
}

class GetUserPointInitial extends GetUserPointState {}

class GetUserPointLoading extends GetUserPointState {}

class GetUserPointSuccess extends GetUserPointState {
  final int points;

  const GetUserPointSuccess({required this.points});

  @override
  List<Object> get props => [points];
}

class GetUserPointFailure extends GetUserPointState {
  final String error;

  const GetUserPointFailure(this.error);

  @override
  List<Object> get props => [error];
}