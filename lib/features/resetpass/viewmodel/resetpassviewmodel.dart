import 'package:dio/dio.dart';
import '../models/resetpassemailmode.dart';

class ForgetPasswordViewModel {
  final Dio _dio = Dio();

  Future<dynamic> sendForgetPasswordRequest(String email) async {
    final requestModel = ForgetPasswordRequest(email: email);
    try {
      print("&"*100);
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/forget-password/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 600;
          },
        ),
        data: requestModel.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200 && response.data.containsKey('message')) {
        return ForgetPasswordSuccessResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        return ForgetPasswordErrorResponse(errors: ["Error: Invalid otp or expired otp"]);
      }
       else if (response.statusCode == 404) {
        return ForgetPasswordErrorResponse(errors: ["Error: Email not found in the databbase "]);
      }
       else if (response.statusCode == 500) {
        return ForgetPasswordErrorResponse(errors: ["Error: Server Error"]);
      } else if (response.data.containsKey('error')) {
        return ForgetPasswordErrorResponse.fromJson(response.data);
      } else {
        return ForgetPasswordErrorResponse(errors: ["Unexpected error occurred"]);
      }
    } on DioException catch (e) {
      print("Request error: ${e.response?.statusCode}");
      print(e.requestOptions);
      print(e.message);

      String errorMessage = "";
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout, please try again";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Receive timeout, please try again";
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = "Bad response from server";
      } else {
        errorMessage = "Unexpected error occurred";
      }

      return ForgetPasswordErrorResponse(errors: [errorMessage]);
    } catch (e) {
      print("Unexpected error: $e");
      return ForgetPasswordErrorResponse(errors: ["An unexpected error occurred"]);
    }
  }
}