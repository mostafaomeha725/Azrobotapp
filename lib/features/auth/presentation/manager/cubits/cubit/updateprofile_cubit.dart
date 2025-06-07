import 'package:azrobot/core/api_services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'updateprofile_state.dart';

class UpdateprofileCubit extends Cubit<UpdateprofileState> {
  UpdateprofileCubit() : super(UpdateprofileInitial());

  Future<void> updateProfile({
    required String name,
    required String mobile,
    required String mainCity,
    required String specialty,
  }) async {
    emit(UpdateprofileLoading());

    final result = await ApiService().updateProfile(
      name: name,
      mobile: mobile,
      mainCity: mainCity,
      specialty: specialty,
    );

    result.fold(
      (failure) => emit(UpdateprofileFailure(failure.errMessage)),
      (data) => emit(UpdateprofileSuccess(data)),
    );
  }
}
