part of 'add_game_point_cubit.dart';


abstract class AddGamePointState extends Equatable {
  const AddGamePointState();

  @override
  List<Object> get props => [];
}

class AddGamePointInitial extends AddGamePointState {}

class AddGamePointLoading extends AddGamePointState {}

class AddGamePointSuccess extends AddGamePointState {
  final String message;
  final int totalPoints;

  const AddGamePointSuccess({required this.message, required this.totalPoints});

  @override
  List<Object> get props => [message, totalPoints];
}

class AddGamePointFailure extends AddGamePointState {
  final String errorMessage;

  const AddGamePointFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}