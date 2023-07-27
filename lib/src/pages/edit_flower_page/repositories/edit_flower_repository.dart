import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../../vendor_home_page/models/add_category_dto.dart';
import '../../vendor_home_page/models/category_list_view_model.dart';
import '../../vendor_home_page/models/edit_category_dto.dart';
import '../../vendor_home_page/models/edit_flower_dto.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../models/edit_color_dto.dart';


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

  Future<Either<String, FlowerListViewModel>> editColorList(EditColorDto dto,int colorId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'colorList/$colorId');
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


  Future<Either<String, CategoryListViewModel>> addCategory(
      AddCategoryDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'categoryList');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return Right(
        CategoryListViewModel.fromJson(
          json.decode(responseOrException.body),
        ),
      );
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<CategoryListViewModel>>> getCategoryList() async {
    final url = Uri.parse("http://10.0.2.2:3000/categoryList");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<CategoryListViewModel> categoryList = [];
      for (final record in json.decode(responseOrException.body)) {
        categoryList.add(CategoryListViewModel.fromJson(record));
      }
      return Right(categoryList);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, CategoryListViewModel>> editCategoryList(
      EditCategoryDto dto, int categoryId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'categoryList/$categoryId');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.patch(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return Right(
        CategoryListViewModel.fromJson(
          json.decode(responseOrException.body),
        ),
      );
    } else {
      return const Left('error');
    }
  }

}
