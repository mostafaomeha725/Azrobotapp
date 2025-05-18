part of 'getcategory_cubit.dart';

sealed class GetcategoryState extends Equatable {
  const GetcategoryState();

  @override
  List<Object> get props => [];
}

final class GetcategoryInitial extends GetcategoryState {}

class GetcategoryLoading extends GetcategoryState {}

class GetcategorySuccess extends GetcategoryState {
  final List<dynamic> category;

  const GetcategorySuccess({required this.category});

  @override
  List<Object> get props => [category];
}

class GetcategoryFailure extends GetcategoryState {
  final String errMessage;

  const GetcategoryFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
