import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;


class LoginPageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, String>> checkUserValidate({required String email,required String passWord,required int user}) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?email=$email&passWord=$passWord&userType=$user");
    final responseOrException =
    await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);

      if (responseData.isNotEmpty) {
        return const Right('user found');
      } else {
        return const Left('use not found');
      }
    } else {
      return const Left('Failed to check password ');
    }
  }

  Future<Either<String, String>> checkVendorValidate({required String email,required String passWord,required int user}) async {
    final url = Uri.parse("http://10.0.2.2:3000/vendors?email=$email&passWord=$passWord&userType=$user");
    final responseOrException =
    await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);

      if (responseData.isNotEmpty) {
        return const Right('user found');
      } else {
        return const Left('use not found');
      }
    } else {
      return const Left('Failed to check password ');
    }
  }



}