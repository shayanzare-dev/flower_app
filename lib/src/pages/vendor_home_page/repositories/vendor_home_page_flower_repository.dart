import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/base_url.dart';
import '../models/edit_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/vendor_view_model.dart';

class VendorHomePageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

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

  Future<Either<String, String>> deleteFlowerItem(final int flowerId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'flowerList/$flowerId');
    final responseOrException = await httpClient.delete(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> deleteColorListItem(
      {required final int colorId}) async {
    final url = Uri.http(BaseUrl.baseUrl, 'colorList/$colorId');
    final responseOrException = await httpClient.delete(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, FlowerListViewModel>> editFlower(
      EditFlowerDto dto, int flowerId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'flowerList/$flowerId');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.put(url,
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
