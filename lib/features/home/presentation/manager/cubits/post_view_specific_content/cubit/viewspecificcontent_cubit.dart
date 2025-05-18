import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'viewspecificcontent_state.dart';

class ViewspecificcontentCubit extends Cubit<ViewspecificcontentState> {
  ViewspecificcontentCubit() : super(ViewspecificcontentInitial());
  final ApiService apiService = ApiService();
  Future<void> fetchContent(int contentId) async {
    emit(ViewspecificcontentLoading());

    final result = await apiService.viewSpecificContent(contentId);

    result.fold(
      (failure) => emit(ViewspecificcontentFailure(failure.errMessage)),
      (content) => emit(ViewspecificcontentSuccess(content)),
    );
  }
}
