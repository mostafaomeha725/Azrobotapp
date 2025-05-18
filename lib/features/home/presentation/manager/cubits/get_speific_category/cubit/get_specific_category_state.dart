part of 'get_specific_category_cubit.dart';

sealed class GetSpecificCategoryState extends Equatable {
  const GetSpecificCategoryState();

  @override
  List<Object> get props => [];
}

class GetSpecificCategoryInitial extends GetSpecificCategoryState {}

class GetSpecificCategoryLoading extends GetSpecificCategoryState {}

class GetSpecificCategorySuccess extends GetSpecificCategoryState {
  final Map<String, dynamic> category;

  const GetSpecificCategorySuccess({required this.category});

  @override
  List<Object> get props => [category];
}

class GetSpecificCategoryFailure extends GetSpecificCategoryState {
  final String errMessage;

  const GetSpecificCategoryFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
