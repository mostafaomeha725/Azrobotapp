import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'add_game_point_state.dart';

class AddGamePointCubit extends Cubit<AddGamePointState> {
  final Dio dio;
  int? currentGameId; // 👈 أضف هذا السطر
  AddGamePointCubit({required this.dio}) : super(AddGamePointInitial());

  Future<void> addGamePoint(int gameId) async {
        currentGameId = gameId; // 👈 حفظ الـ id الحال
    emit(AddGamePointLoading());
    
    try {
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(AddGamePointFailure('Token غير موجود'));
        return;
      }

      final response = await dio.post(
        'https://tempweb90.com/azrobot/public/api/games/add-points',
        data: {'game_id': gameId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        emit(AddGamePointSuccess(
          message: data['message'],
          totalPoints: data['total_points'],
        ));
      } else {
        emit(AddGamePointFailure('خطأ في إضافة النقاط'));
      }
    } on DioException catch (e) {
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        emit(AddGamePointFailure(e.response!.data['message']));
      } else {
        emit(AddGamePointFailure('حدث خطأ أثناء إضافة النقاط'));
      }
    } catch (e) {
      emit(AddGamePointFailure('حدث خطأ غير متوقع'));
    }
  }
}