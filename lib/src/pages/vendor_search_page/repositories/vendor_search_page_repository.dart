import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../models/category_list_view_model.dart';
import '../models/color_list_view_model.dart';

class VendorSearchPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<FlowerListViewModel>>> searchTextFieldWithFilters(
      {required String colors,
        required String min,
        required String max,
        required String category,
        required String search,
        required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?name_like=$search&price_gte=$min&price_lte=$max&category_like=$category&vendorUser.email=$email&$colors");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchTextFieldCategoryPrice(
      {required String min,
        required String max,
        required String category,
        required String search,
        required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?name_like=$search&price_gte=$min&price_lte=$max&category_like=$category&vendorUser.email=$email");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchTextFieldColorPrice(
      {required String colors,
        required String search,
        required String min,
        required String max,
        required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?name_like=$search&price_gte=$min&price_lte=$max&vendorUser.email=$email&$colors");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> textFieldSearchWithPriceRange(
      {required String min,
      required String max,
      required String search,
      required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?name_like=$search&price_gte=$min&price_lte=$max&vendorUser.email=$email");
    final responseOrException = await httpClient.get(url);

    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchFilters(
      {required String colors,
      required String min,
      required String max,
      required String category,
      required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&category_like=$category&vendorUser.email=$email&$colors");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategoryPrice(
      {required String min,
      required String max,
      required String category,
      required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&category_like=$category&vendorUser.email=$email");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchFilterColorPrice(
      {required String colors,
      required String min,
      required String max,
      required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&vendorUser.email=$email&$colors");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<FlowerListViewModel>>> searchFilterPriceRange(
      {required String min, required String max, required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&vendorUser.email=$email");
    final responseOrException = await httpClient.get(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<ColorListViewModel>>> getColorList() async {
    final url = Uri.parse("http://10.0.2.2:3000/colorList");
    final responseOrException = await httpClient.get(url);

    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<ColorListViewModel> colorList = [];
      for (final record in json.decode(responseOrException.body)) {
        colorList.add(ColorListViewModel.fromJson(record));
      }
      return Right(colorList);
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

  Future<Either<String, List<FlowerListViewModel>>> getFlowerList(
      String email) async {
    final url =
        Uri.parse("http://10.0.2.2:3000/flowerList?vendorUser.email=$email");
    final responseOrException = await httpClient.get(url);

    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<FlowerListViewModel> flowerListVendor = [];
      for (final record in json.decode(responseOrException.body)) {
        flowerListVendor.add(FlowerListViewModel.fromJson(record));
      }
      return Right(flowerListVendor);
    } else {
      return const Left('error');
    }
  }
}
