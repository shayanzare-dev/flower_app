import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../vendor_home_page/models/flower_list_view_model.dart';



class VendorSearchPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<FlowerListViewModel>>> searchFilterColor(
      {required String colors, required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?$colors&vendorUser.email=$email");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategory(
      {required String category, required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?category_like=$category&vendorUser.email=$email");
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
      String search, String email) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?q=$search&vendorUser.email=$email");
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