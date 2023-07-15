import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../../vendor_home_page/models/edit_flower_dto.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';


class EditFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, FlowerListViewModel>> editFlower(EditFlowerDto dto,int flowerId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'flowerList/$flowerId');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.put(url, body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return Right(
        FlowerListViewModel.fromJson(
          json.decode(responseOrException.body),
        ),
      );
    } else {
      return const Left('error');
    }
  }
}
