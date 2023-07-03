import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../models/register_user_dto.dart';
import '../models/user_view_model.dart';

class RegisterPageFlowerRepository {
  final httpClient = http.Client();


  Map<String, String> customHeaders = {"content-type": "application/json"};
  Future<Either<String, UserViewModel>> addRecords(RegisterUserDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'auction');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url, body: json.encode(jsonDto), headers: customHeaders);
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

  Future<Map<String, dynamic>> uploadImage(File imageFile, String url) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

}