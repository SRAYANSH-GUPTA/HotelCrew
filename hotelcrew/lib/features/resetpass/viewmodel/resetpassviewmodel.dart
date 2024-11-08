import 'package:dio/dio.dart';
import '../models/resetpassemailmode.dart';

class ForgetPasswordViewModel {
  final Dio _dio = Dio();

  Future<dynamic> sendForgetPasswordRequest(String email) async {
    final requestModel = ForgetPasswordRequest(email: email);

    try {
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/forget-password/',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: requestModel.toJson(),
      );

      // Check for successful response or handle errors
      if (response.statusCode == 200 && response.data.containsKey('message')) {
        print('###########');
        print(ForgetPasswordSuccessResponse.fromJson(response.data));
        return ForgetPasswordSuccessResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        // Handle 400 or 500 errors gracefully here if needed
        print("Handled 400 or 500 error: ${response.statusCode}");
        return ForgetPasswordErrorResponse(errors: ["Error: User Does Not Exist"]);
      }
      else if (response.statusCode == 500) {
        // Handle 400 or 500 errors gracefully here if needed
        print("Handled 500 error: ${response.statusCode}");
        return ForgetPasswordErrorResponse(errors: ["Error: Server Error"]);
      }
       else if (response.data.containsKey('error')) {
        print("###############");
        return ForgetPasswordErrorResponse.fromJson(response.data);
      } else {
        return ForgetPasswordErrorResponse(errors: ["User does not exist"]);
      }
    } on DioException catch (e) {
      print("Request error: ${e.response?.statusCode}");
      print(e.requestOptions);
      print(e.message);

      // Handle unexpected error responses here
      return ForgetPasswordErrorResponse(
        errors: ["Network error: Server Error"],
      );
    }
  }
}
