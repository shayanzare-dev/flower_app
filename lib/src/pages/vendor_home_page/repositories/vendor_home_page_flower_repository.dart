import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/commons/base_url.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../models/add_category_dto.dart';
import '../models/add_flower_dto.dart';
import '../models/category_list_view_model.dart';
import '../models/edit_category_dto.dart';
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

  Future<Either<String, List<CartOrderViewModel>>>
      getVendorUserOrdersHistory() async {
    final url = Uri.parse("http://10.0.2.2:3000/orderList");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategoryPrice(
      {        required String min,
        required String max,
        required String category,
        required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?price_gte=$min&pri ce_lte=$max&category_like=$category&vendorUser.email=$email");
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

  Future<Either<String, List<FlowerListViewModel>>> searchFilterCategoryColor(
      {required String colors,
        required String category,
        required String email}) async {
    final url = Uri.parse(
        "http://10.0.2.2:3000/flowerList?category=$category&vendorUser.email=$email&$colors");
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
        "http://10.0.2.2:3000/flowerList?name_like=$search&vendorUser.email=$email");
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
