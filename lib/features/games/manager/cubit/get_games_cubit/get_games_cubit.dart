import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

part 'get_games_state.dart';

class GetGamesCubit extends Cubit<GetGamesState> {
  final Dio dio;

  GetGamesCubit({required this.dio}) : super(GetGamesInitial());

  Future<void> getGames() async {
    emit(GetGamesLoading());
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(GetGamesFailure('Token غير موجود'));
        return;
      }

      final response = await dio.get(
        'https://tempweb90.com/azrobot/public/api/games',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        // Filter games where visibility is "show"
        final visibleGames = (response.data as List).where((game) {
          return game['visibility'] == 'show'; // Assuming API returns visibility field
        }).toList();
        
        emit(GetGamesSuccess(visibleGames));
      } else {
        emit(GetGamesFailure('خطأ في تحميل البيانات'));
      }
    } catch (e) {
      emit(GetGamesFailure('حدث خطأ أثناء الاتصال بالخادم'));
    }
  }
}