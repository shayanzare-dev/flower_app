import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../customer_home_page/models/flower_list_view_model.dart';

class CustomerSearchPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<FlowerListViewModel>>> getFlowerList() async {
    final url = Uri.parse("http://10.0.2.2:3000/flowerList");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterColor(
      {required String colors}) async {
    final url = Uri.parse("http://10.0.2.2:3000/flowerList?$colors");
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
      {required String min, required String max}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategory(
      {required String category}) async {
    final url =
    Uri.parse("http://10.0.2.2:3000/flowerList?category_like=$category");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilters({
    required String colors,
    required String min,
    required String max,
    required String category,
  }) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&category_like=$category&$colors");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategoryPrice({
    required String min,
    required String max,
    required String category,
  }) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&category_like=$category");
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
      }) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&price_lte=$max&$colors");
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

  Future<Either<String, List<FlowerListViewModel>>> search(
      String search) async {
    final url = Uri.parse("http://10.0.2.2:3000/flowerList?q=$search");
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