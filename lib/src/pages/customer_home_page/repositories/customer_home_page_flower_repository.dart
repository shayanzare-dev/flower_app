import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/base_url.dart';
import '../models/add_cart_order_dto.dart';
import '../models/cart_order_view_model.dart';
import '../models/edit_flower_dto.dart';
import '../models/edit_order_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';

class CustomerHomePageFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<UserViewModel>>> getCustomerUser(
      String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/users?email=$email");
    final responseOrException =
        await httpClient.get(url, headers: customHeaders);

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

  Future<Either<String, List<CartOrderViewModel>>> getCustomerUserOrders(
      String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/orderList?user.email=$email");
    final responseOrException =
        await httpClient.get(url, headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<CartOrderViewModel> customerUserOrders = [];
      for (final record in json.decode(responseOrException.body)) {
        customerUserOrders.add(CartOrderViewModel.fromJson(record));
      }
      return Right(customerUserOrders);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, List<CartOrderViewModel>>> getCartOrders(
      String email) async {
    final url = Uri.parse("http://10.0.2.2:3000/cartOrder?user.email=$email");
    final responseOrException =
        await httpClient.get(url, headers: customHeaders);

    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      final List<CartOrderViewModel> getCartOrders = [];
      for (final record in json.decode(responseOrException.body)) {
        getCartOrders.add(CartOrderViewModel.fromJson(record));
      }
      return Right(getCartOrders);
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> addCartOrderToOrderList(
      AddCartOrderDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'orderList');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> addCartOrder(AddCartOrderDto dto) async {
    final url = Uri.http(BaseUrl.baseUrl, 'cartOrder');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.post(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> deleteCartOrder(int cartId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'cartOrder/$cartId');
    final responseOrException = await httpClient.delete(url);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> updateCartOrder(
      EditCartOrderDto dto, int cartId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'cartOrder/$cartId');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.patch(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
    } else {
      return const Left('error');
    }
  }

  Future<Either<String, String>> editFlower(
      EditFlowerDto dto, int flowerId) async {
    final url = Uri.http(BaseUrl.baseUrl, 'flowerList/$flowerId');
    final jsonDto = dto.toJson();
    final responseOrException = await httpClient.put(url,
        body: json.encode(jsonDto), headers: customHeaders);
    if (responseOrException.statusCode >= 200 &&
        responseOrException.statusCode <= 400) {
      return const Right('Success');
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
