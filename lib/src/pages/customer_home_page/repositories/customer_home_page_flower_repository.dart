import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/base_url.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';


class CustomerHomePageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<UserViewModel>>> getCustomerUser(String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?email=$email");
    final responseOrException = await httpClient.get(url,headers: customHeaders);

    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<UserViewModel> customerUser = [];
      for (final record in json.decode(responseOrException.body)) {
        customerUser.add(UserViewModel.fromJson(record));
      }
      return Right(customerUser);
    } else {
      return const Left('error');
    }
  }

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

}