import 'package:azrobot/core/api_services/api_service.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'getcontentcategory_state.dart';

class GetContentByCategoryCubit extends Cubit<GetContentByCategoryState> {
  GetContentByCategoryCubit(this.apiService, this.sharedPreference)
      : super(GetContentByCategoryInitial());

  final ApiService apiService;
  final SharedPreference sharedPreference;

  Future<void> getContentByCategory(int categoryId,
      {bool forceRefresh = false}) async {
    // إظهار حالة التحميل فقط إذا كان التحديث إجباري أو لا يوجد بيانات مخزنة
    if (forceRefresh || state is! GetContentByCategorySuccess) {
      emit(GetContentByCategoryLoading());
    }

    try {
      Map<String, dynamic>? cachedData;

      // الخطوة 1: جلب البيانات المخزنة إذا لم يكن التحديث إجباري
      if (!forceRefresh) {
        final cachedContent =
            await sharedPreference.getCategoryContentData(categoryId);
        cachedData = cachedContent?['data'] as Map<String, dynamic>?;

        if (cachedData != null) {
          emit(GetContentByCategorySuccess(
            data: cachedData,
            fromCache: true,
            isLoading: true, // إظهار مؤشر التحميل مع البيانات المخزنة
          ));
        }
      }

      // الخطوة 2: جلب البيانات من API
      final result = await apiService.getContentByCategory(categoryId);

      await result.fold(
        (failure) async {
          // في حالة فشل API، استخدام البيانات المخزنة إذا كانت متاحة
          if (cachedData != null) {
            emit(GetContentByCategorySuccess(
              data: cachedData,
              fromCache: true,
              error: failure.errMessage,
            ));
          } else {
            emit(GetContentByCategoryFailure(errMessage: failure.errMessage));
          }
        },
        (apiData) async {
          final newData = apiData['data'] as Map<String, dynamic>;
          final hasChanged =
              cachedData == null || _hasDataChanged(cachedData, newData);

          // الخطوة 3: حفظ البيانات الجديدة إذا اختلفت
          if (hasChanged) {
            await sharedPreference.saveCategoryContentData(categoryId, apiData);
          }

          emit(GetContentByCategorySuccess(
            data: newData,
            isUpdated: hasChanged,
            isLoading: false, // إخفاء مؤشر التحميل بعد التحديث
          ));
        },
      );
    } catch (e) {
      emit(GetContentByCategoryFailure(
        errMessage: 'حدث خطأ غير متوقع: ${e.toString()}',
      ));
    }
  }

  bool _hasDataChanged(
      Map<String, dynamic> oldData, Map<String, dynamic> newData) {
    // مقارنة تاريخ التحديث إذا كان متاحاً
    if (oldData['contents'] != null && newData['contents'] != null) {
      final oldUpdated = _getLatestUpdateTime(oldData['contents']['contents']);
      final newUpdated = _getLatestUpdateTime(newData['contents']['contents']);
      return oldUpdated != newUpdated;
    }
    return oldData.toString() != newData.toString();
  }

  String _getLatestUpdateTime(List<dynamic> contents) {
    String latest = '';
    for (final item in contents.cast<Map<String, dynamic>>()) {
      if (item['updated_at'] != null &&
          item['updated_at'].compareTo(latest) > 0) {
        latest = item['updated_at'];
      }
    }
    return latest;
  }

  Future<void> refreshContent(int categoryId) async {
    // إظهار حالة التحميل عند التحديث اليدوي
    emit(GetContentByCategoryLoading());
    await getContentByCategory(categoryId, forceRefresh: true);
  }
}
