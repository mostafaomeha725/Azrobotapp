import 'dart:math';

import 'package:azrobot/core/api/Api.dart';
import 'package:azrobot/core/api/end_ponits.dart';
import 'package:azrobot/core/errors/exceptions.dart';
import 'package:azrobot/core/helper/shared_preferences/shared_preferences.dart';
import 'package:azrobot/features/auth/data/model/sign_in_model.dart';
import 'package:azrobot/features/auth/data/model/sign_up_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio = Dio(); // Initialize Dio for sending requests
Future<Either<Failure, SignUpModel>> signUpUser({
  required String name,
  required String email,
  required String password,
  required String confirmpassword,
  required String cityId,
  required String specialtyId,
  required String mobile,
}) async {
  try {
    final response = await dio.post(
      '${EndPoint.baseUrl}register',
      data: {
        "name": name,
        "email": email,
        "password": password,
        "mobile": mobile,
        "password_confirmation": confirmpassword,
        "city_id": cityId,
        "specialty_id": specialtyId,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    if (response.statusCode == 200) {
      return Right(SignUpModel.fromJson(response.data));
    } else {
      final errorMsg = response.data['message'] ?? 'حدث خطأ غير متوقع';
      return Left(Failure(errorMsg));
    }
  } catch (e) {
    String errorMessage;

    // تحقق من وجود نوع الخطأ المحدد
    if (e.toString().contains("type 'String' is not a subtype of type 'int'")) {
      errorMessage = " Email or Mobile already exist";
    } else {
      errorMessage = 'حدث خطأ في الاتصال: ${e.toString()}';
    }

    return Left(Failure(errorMessage));
  }
}

 Future<Either<Failure, SignInModel>> signInUser({
  required String email,
  required String password,
}) async {
  final result = await Api().post(
    name: "login",
    body: {
      "email": email,
      "password": password,
    },
    errMessage: "Failed to login",
  );

  return result.fold(
    (failure) => Left(failure),
    (data) async {
      final token = data['data']['token'];
      final userId = data['data']['user']['id'].toString();
      final point = data['data']['user']['points'];
      final email = data['data']['user']['email'];
      print(point);

      // حفظ البيانات في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      await prefs.setString("userId", userId);
      await prefs.setString("point", point);
      await prefs.setString("email", email);

      return Right(SignInModel.fromJson(data));
    },
  );
}


  Future<Either<Failure, String>> otpVerify({
    required String email,
    required String otp,
  }) async {
    final result = await Api().post(
      name: "verify-otp",
      body: {
        "email": email,
        "otp": otp,
      },
      errMessage: "OTP verification failed",
    );

    return result.fold(
      (failure) => Left(failure),
      (data) {
        final message = data['message'] ?? 'OTP verified successfully';
        return Right(message);
      },
    );
  }

  Future<Either<Failure, String>> resetOtp({
    required String email,
  }) async {
    final result = await Api().post(
      name: "resend-otp",
      body: {"email": email},
      errMessage: "Failed to resend OTP",
    );

    return result.fold(
      (failure) => Left(failure),
      (data) {
        // Check if there's a message indicating the old OTP was invalidated
        final message = data['message'] ?? 'OTP resent successfully';

        // If the old OTP is invalidated, return a message about it and the new OTP.
        if (data['old_otp_invalidated'] == true) {
          return Right('Old OTP has been invalidated. $message');
        }

        // If no invalidation happened, return the normal success message
        return Right(message);
      },
    );
  }

  Future<Either<Failure, String>> logOutUser() async {
    final result = await Api().post(
      name: "logout",
      withAuth: true,
      errMessage: "Failed to logout",
    );

    return result.fold(
      (failure) => Left(failure),
      (_) => Right("Successfully logged out"),
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getProfileData() async {
    final result = await Api().get(
      name: "profile",
      errMessage: "Failed to get profile data",
      withAuth: true,
    );

    // حفظ البيانات إذا نجح الطلب
    result.fold(
      (failure) => null,
      (data) async => await SharedPreference().saveProfileData(data),
    );

    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllSpecialties() async {
    final result = await Api().get(
      name: "specialties",
      errMessage: "Failed to get specialties",
    );

    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllCity() async {
    final response = await Api().get(
      name: "cities",
      errMessage: "Failed to get city",
    );

    return response; // Already Either<Failure, Map<String, dynamic>>
  }

  Future<Either<Failure, Map<String, dynamic>>> getCategory() async {
    final result = await Api().get(
      name: "categories",
      errMessage: "Failed to get categories",
    );

    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> getContentByCategory(
      int categoryId) async {
    final result = await Api().get(
      name: 'categories/$categoryId/contents',
      errMessage: 'Failed to get content by category',
    );
    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> getSpecificCategory(
      int id) async {
    final result = await Api().get(
      name: 'categories/$id',
      errMessage: 'Failed to get specific category',
    );
    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> getAllContents() async {
    final result = await Api().get(
      name: 'contents',
      errMessage: 'Failed to get All category',
    );
    return result;
  }
//getallvoucher
    Future<Either<Failure, Map<String, dynamic>>> getAllVoucher() async {
      final result = await Api().get(
        name: 'vouchers',
        errMessage: 'Failed to get All voucher',
        withAuth: true
      );
      
      return result;
    }     
Future<Either<Failure, Map<String, dynamic>>> getUserVouchers(String userId) async {
  final result = await Api().get(
    name: 'users/$userId/vouchers',
    errMessage: 'Failed to get user vouchers',
    withAuth: true,
  );

  return result;
}


Future<Either<Failure, Map<String, dynamic>>> purchaseVoucher(int voucherId) async {
  final response = await Api().post(
    name: 'vouchers/purchase?voucher_id=$voucherId',
    withAuth: true,
    errMessage: 'Failed to purchase voucher',
  );

  return response.fold(
    (failure) => Left(failure),
    (data) {
      final voucherData = data['data'] as Map<String, dynamic>;
      return Right(voucherData);
    },
  );
}

Future<Either<Failure, Map<String, dynamic>>> addGamePoint(int gameId) async {
  final response = await Api().post(
    name: 'games/add-points',
    withAuth: true,
    body: {'game_id': gameId},
    errMessage: 'Failed to add points',
  );

  return response.fold(
    (failure) => Left(failure),
    (data) {
      final responseData = data ;
      return Right(responseData);
    },
  );
}

Future<Either<Failure, Map<String, dynamic>>> viewSpecificContent(int contentId) async {
  final response = await Api().post(
    name: 'content/view?content_id=$contentId',
    withAuth: true,
    errMessage: 'فشل في عرض المحتوى',
  );

  return response.fold(
    (failure) => Left(failure),
    (data) {
      final contentData = data['data'] as Map<String, dynamic>;
      return Right(contentData);
    },
  );
}


Future<Either<Failure, List<dynamic>>> getGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ServerFailure('Token غير موجود'));
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
        return Right(response.data);
      } else {
        return Left(ServerFailure('خطأ في تحميل البيانات'));
      }
    } catch (e) {
      return Left(ServerFailure('حدث خطأ أثناء الاتصال بالخادم'));
    }
  }
  


}
