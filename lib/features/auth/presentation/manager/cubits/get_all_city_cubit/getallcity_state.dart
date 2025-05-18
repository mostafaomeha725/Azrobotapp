part of 'getallcity_cubit.dart';

abstract class GetallcityState extends Equatable {
  const GetallcityState();

  @override
  List<Object> get props => [];
}

class CityInitial extends GetallcityState {}

class CityLoading extends GetallcityState {}

class CitySuccess extends GetallcityState {
  final List<dynamic> citys;

  const CitySuccess({required this.citys});

  @override
  List<Object> get props => [citys];
}

class CityFailure extends GetallcityState {
  final String errMessage;

  const CityFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
