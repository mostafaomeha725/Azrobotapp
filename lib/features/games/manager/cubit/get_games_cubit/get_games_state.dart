part of 'get_games_cubit.dart';

abstract class GetGamesState extends Equatable {
  const GetGamesState();

  @override
  List<Object> get props => [];
}

class GetGamesInitial extends GetGamesState {}

class GetGamesLoading extends GetGamesState {}

class GetGamesSuccess extends GetGamesState {
  final List<dynamic> games;

  const GetGamesSuccess(this.games);

  @override
  List<Object> get props => [games];
}

class GetGamesFailure extends GetGamesState {
  final String errorMessage;

  const GetGamesFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}