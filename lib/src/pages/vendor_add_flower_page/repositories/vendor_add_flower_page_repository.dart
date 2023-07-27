import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flower_app/src/pages/vendor_add_flower_page/models/add_color_dto.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/base_url.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_category_dto.dart';
import '../models/add_flower_dto.dart';
import '../models/category_list_view_model.dart';
import '../models/edit_category_dto.dart';
import '../models/flower_list_view_model.dart';

class VendorAddFlowerPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, FlowerListViewModel>> addFlower(
      AddFlowerDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'flowerList');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
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

  Future<Either<String, String>> addColorList(AddColorDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'colorList');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('success');
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

  Future<Either<String, List<VendorViewModel>>> getVendorUser(
      String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/vendors?email=$email");
    final responseOrException =
        await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<VendorViewModel> vendorUser = [];
      for (final record in json.decode(responseOrException.body)) {
        vendorUser.add(VendorViewModel.fromJson(record));
      }
      return Right(vendorUser);
    } else {
      return const Left('error');
    }
  }
}
