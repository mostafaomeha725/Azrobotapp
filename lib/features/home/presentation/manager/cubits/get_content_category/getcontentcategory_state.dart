// getcontentcategory_state.dart
part of 'getcontentcategory_cubit.dart';

abstract class GetContentByCategoryState extends Equatable {
  const GetContentByCategoryState();

  @override
  List<Object> get props => [];
}

class GetContentByCategoryInitial extends GetContentByCategoryState {}

class GetContentByCategoryLoading extends GetContentByCategoryState {}

class GetContentByCategorySuccess extends GetContentByCategoryState {
  final Map<String, dynamic> data;
  final bool isUpdated;
  final bool fromCache;
  final bool isLoading;
  final String? error;

  const GetContentByCategorySuccess({
    required this.data,
    this.isUpdated = false,
    this.fromCache = false,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object> get props =>
      [data, isUpdated, fromCache, isLoading, error ?? ''];
}

class GetContentByCategoryFailure extends GetContentByCategoryState {
  final String errMessage;

  const GetContentByCategoryFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
