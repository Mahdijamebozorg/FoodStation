class APIConsts {
  static const String baseUrl = 'http://188.121.98.1:8080/api';

  static const String phoneCheck = '$baseUrl/user/exists';

  static const String phoneReg = '$baseUrl/phone/registration/send';
  static const String phoneRegVerify = '$baseUrl/phone/registration/verify';

  static const String pwdReset = '$baseUrl/user/forgetPassword/send';
  static const String pwdResetVerify = '$baseUrl/user/forgetPassword/verify';
  static const String pwdResetChange =
      '$baseUrl/user/forgetPassword/changePassword';

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';

  static const String allCats = '$baseUrl/category';
  static const String showCat = '$baseUrl/category/1';
  static const String updateCat = '$baseUrl/category/1';
  static const String deleteCat = '$baseUrl/category/2';
  static const String noramlCats = '$baseUrl/category/type/normal';
  static const String placeCats = '$baseUrl/category/type/place';
  static const String addCat = '$baseUrl/category';

  static const String getUserFoods = baseUrl;
  static const String getRecommnededFoods = baseUrl;
}
