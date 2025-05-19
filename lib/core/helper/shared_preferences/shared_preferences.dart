import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  Future<String?> getpoint(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

  // Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'user_token', token); // Save the token with the key 'user_token'
  }

  // Get token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        'user_token'); // Retrieve the token using the 'user_token' key
  }

  // Remove token from SharedPreferences
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('user_token'); // Remove the token with the key 'user_token'
  }

  Future<void> clearProfileCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
  }

  Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonProfile =
        jsonEncode(profileData); // Convert profile data to JSON string
    await prefs.setString('user_profile',
        jsonProfile); // Save profile data with the key 'user_profile'
  }

  // Get profile data from SharedPreferences
  Future<Map<String, dynamic>?> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonProfile =
        prefs.getString('user_profile'); // Retrieve profile data as JSON string
    if (jsonProfile != null) {
      return jsonDecode(jsonProfile); // Convert JSON string back to Map
    }
    return null; // Return null if profile data is not found
  }

  Future<void> saveSpecialtiesData(Map<String, dynamic> specialtiesData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('specialties_data', json.encode(specialtiesData));
  }

  Future<Map<String, dynamic>?> getSpecialtiesData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('specialties_data');
    return data != null ? json.decode(data) : null;
  }

  Future<void> clearSpecialtiesCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('specialties_data');
  }

  Future<void> saveCityData(Map<String, dynamic> cityData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city_data', json.encode(cityData));
  }

  Future<Map<String, dynamic>?> getCityData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('city_data');
    return data != null ? json.decode(data) : null;
  }

  Future<void> clearCityDataCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('city_data');
  }

  Future<Map<String, dynamic>?> getCategoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('category_data');
    return data != null ? json.decode(data) : null;
  }

  Future<void> saveCategoryData(Map<String, dynamic> categoryData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('category_data', json.encode(categoryData));
  }

  Future<void> saveCategoryContentData(
      int categoryId, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString('category_content_$categoryId', jsonString);
  }

  Future<Map<String, dynamic>?> getCategoryContentData(int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('category_content_$categoryId');

    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<void> saveSpecificCategoryData(
      int id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('specific_category_$id', jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getSpecificCategoryData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('specific_category_$id');
    if (json != null) {
      return jsonDecode(json);
    }
    return null;
  }

// حفظ بيانات كل المحتويات
  Future<void> saveAllContentsData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('all_contents', jsonEncode(data));
  }

// جلب بيانات كل المحتويات من الكاش
  Future<Map<String, dynamic>?> getAllContentsData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('all_contents');
    if (json != null) {
      return jsonDecode(json);
    }
    return null;
  }

Future<void> saveVoucherData(Map<String, dynamic> data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString('voucher_data', jsonEncode(data));
    print('Voucher data saved: $success');
  } catch (e) {
    print('Error saving voucher data: $e');
  }
}


  Future<Map<String, dynamic>?> getVoucherData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('voucher_data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  Future<void> removeVoucherData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('voucher_data');
}

  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح جميع البيانات
  }
   // ignore: unused_field
   static const String _userIdKey = 'user_id';


 Future<void> saveUserId(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
}
