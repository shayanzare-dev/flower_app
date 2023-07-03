import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../models/register_user_dto.dart';
import '../models/user_view_model.dart';

class RegisterPageFlowerRepository {
  final httpClient = http.Client();

  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, UserViewModel>> addUser(RegisterUserDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'users');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return Right(
        UserViewModel.fromJson(
          json.decode(responseOrException.body),
        ),
      );
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, bool>> checkEmailUser(String email) async {
    final url = Uri.parse("http://127.0.0.1:3000/users?email=$email");
    final responseOrException =
        await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final responseData = jsonDecode(responseOrException.body);
      if (responseData.isNotEmpty) {
        return Left('Email already exists');
      } else {
        return Right(true);
      }
    } else {
      return const Left('Failed to check email availability');
    }
  }
}
