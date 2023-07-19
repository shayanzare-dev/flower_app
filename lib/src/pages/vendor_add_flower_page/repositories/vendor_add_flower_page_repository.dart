import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../infrastructure/commons/base_url.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import 'package:http/http.dart' as http;


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