

import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../vendor_home_page/models/vendor_view_model.dart';

class VendorProfilePageRepository {
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

}