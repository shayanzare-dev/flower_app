import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../models/register_user_dto.dart';
import '../models/register_vendor_dto.dart';


class RegisterPageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, String>> addUser({required RegisterUserDto dto}) async {
    final url = Uri.http(BaseUrl.baseUrl, 'users');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, bool>> checkEmailUser({required String email}) async {
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

  Future<Either<String, String>> addVendor({required RegisterVendorDto dto}) async {
    final url = Uri.http(BaseUrl.baseUrl, 'vendors');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, bool>> checkEmailVendor({required String email}) async {
    final url = Uri.parse("http://10.0.2.2:3000/vendors?email=$email");
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
}
