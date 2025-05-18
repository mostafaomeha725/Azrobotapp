part of 'viewspecificcontent_cubit.dart';

sealed class ViewspecificcontentState extends Equatable {
  const ViewspecificcontentState();

  @override
  List<Object> get props => [];
}

final class ViewspecificcontentInitial extends ViewspecificcontentState {}


class ViewspecificcontentLoading extends ViewspecificcontentState {}

class ViewspecificcontentSuccess extends ViewspecificcontentState {
  final Map<String, dynamic> content;

  const ViewspecificcontentSuccess(this.content);
}

class ViewspecificcontentFailure extends ViewspecificcontentState {
  final String message;

  const ViewspecificcontentFailure(this.message);
}
