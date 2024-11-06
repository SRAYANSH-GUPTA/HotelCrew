import 'package:dio/dio.dart';
import '../auth_models/loginmodel.dart';

class AuthViewModel {
  final Dio _dio = Dio();

  AuthViewModel() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("Response received: ${response.data}");
        return handler.next(response);
      },
      onError: (DioError error, handler) {
        print("Error: ${error.message}");
        return handler.next(error);
      },
    ));
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://hotelcrew-1.onrender.com/api/auth/login/',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // Parsing the JSON response to LoginResponse model for success response
        return LoginResponse.fromJson(response.data);
      } else {
        // Handle unexpected status codes
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "",
          userData: UserData(fullName: "", email: ""),
          user: null, // Returning null for user if not available
        );
      }
    } on DioError catch (e) {
      
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
  
        final errorData = e.response?.data as Map<String, dynamic>;
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "error",
          userData: UserData(fullName: "", email: ""),
          user: null,
        );
      } else if (e.type == DioErrorType.connectionTimeout) {
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "error",
          userData: UserData(fullName: "", email: ""),
          user: null,
        );
      } else if (e.type == DioErrorType.receiveTimeout) {
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "error",
          userData: UserData(fullName: "", email: ""),
          user: null,
        );
      } else if (e.type == DioErrorType.badResponse) {
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "error",
          userData: UserData(fullName: "", email: ""),
          user: null,
        );
      } else {
        return LoginResponse(
          accessToken: "",
          refreshToken: "",
          role: "error",
          userData: UserData(fullName: "", email: ""),
          user: null,
        );
      }
    } catch (e) {
      // Handling any other exceptions
      return LoginResponse(
        accessToken: "",
        refreshToken: "",
        role: "error",
        userData: UserData(fullName: "", email: ""),
        user: null,
      );
    }
  }
}
