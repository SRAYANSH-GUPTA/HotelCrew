import 'package:dio/dio.dart';
import '../models/resetpassemailmode.dart';

class ForgetPasswordViewModel {
  final Dio _dio = Dio();

  ForgetPasswordViewModel() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("Requesting: ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("Response: ${response.data}");
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print("Error: ${e.response?.data}");
        return handler.next(e);
      },
    ));
  }

  Future<dynamic> sendForgetPasswordRequest(String email) async {
    final requestModel = ForgetPasswordRequest(email: email);

    try {
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/forgetpassword/',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200 && response.data.containsKey('message')) {
      
        print('###########');
        print(ForgetPasswordSuccessResponse.fromJson(response.data));
        return ForgetPasswordSuccessResponse.fromJson(response.data);
      } else if (response.data.containsKey('error')) {
        
        return ForgetPasswordErrorResponse.fromJson(response.data);
      } else {
      
        return ForgetPasswordErrorResponse(errors: ["Unexpected response"]);
      }
    } on DioException catch (e) {
      print("Request error: ${e.response?.statusCode}");
      print(e.requestOptions);
    print(e.message);      
      return ForgetPasswordErrorResponse(
        errors: ["Network error: ${e.message}"],
      );
    }//overlay
  }
}
