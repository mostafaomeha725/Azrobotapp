import 'package:dio/dio.dart';

class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectionTimeout:
        return ServerFailure('انتهت مهلة الاتصال بالخادم');
      case DioErrorType.sendTimeout:
        return ServerFailure('انتهت مهلة إرسال البيانات');
      case DioErrorType.receiveTimeout:
        return ServerFailure('انتهت مهلة استقبال البيانات');
      case DioErrorType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response?.statusCode, dioError.response?.data);
      case DioErrorType.cancel:
        return ServerFailure('تم إلغاء الطلب');
      case DioErrorType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          return ServerFailure('لا يوجد اتصال بالإنترنت');
        }
        return ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى');
      default:
        return ServerFailure('حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['message'] ?? 'طلب غير مصرح به');
    } else if (statusCode == 404) {
      return ServerFailure('لم يتم العثور على الصفحة المطلوبة');
    } else if (statusCode == 422) {
      return ServerFailure(response['message'] ?? 'بيانات غير صالحة');
    } else if (statusCode == 500) {
      return ServerFailure(response['message'] ?? 'خطأ في الخادم الداخلي');
    } else {
      return ServerFailure('حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }
}
