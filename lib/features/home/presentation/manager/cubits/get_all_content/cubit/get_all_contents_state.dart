part of 'get_all_contents_cubit.dart';

sealed class GetAllContentsState extends Equatable {
  const GetAllContentsState();

  @override
  List<Object> get props => [];
}

class GetAllContentsInitial extends GetAllContentsState {}

class GetAllContentsLoading extends GetAllContentsState {}

class GetAllContentsSuccess extends GetAllContentsState {
  final List<dynamic> contents;

  const GetAllContentsSuccess({required this.contents});

  @override
  List<Object> get props => [contents];
}

class GetAllContentsFailure extends GetAllContentsState {
  final String errMessage;

  const GetAllContentsFailure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}
