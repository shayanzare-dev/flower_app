import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';

class LoginPageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};



  Future<Either<String, bool>> checkEmailUser(String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?email=$email");
    final responseOrException =
    await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);
      if (responseData.isNotEmpty) {
        return const Left('Email already exists');
      } else {
        return const Right(true);
      }
    } else {
      return const Left('Failed to check email availability');
    }
  }

  Future<Either<String, bool>> checkPassWordUser(String passWord) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?passWord=$passWord");
    final responseOrException =
    await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);
      if (responseData.isNotEmpty) {
        return const Left('passWord already exists');
      } else {
        return const Right(true);
      }
    } else {
      return const Left('Failed to check password ');
    }
  }

  Future<Either<String, String>> checkUserValidate({required String email,required String passWord,required int user}) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?email=$email&passWord=$passWord&userType=$user");
    final responseOrException =
    await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);

      if (responseData.isNotEmpty) {
        return const Left('user found');
      } else {
        return const Right('use not found');
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
        return const Left('user found');
      } else {
        return const Right('use not found');
      }
    } else {
      return const Left('Failed to check password ');
    }
  }



}