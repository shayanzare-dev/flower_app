import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import 'package:http/http.dart' as http;

class VendorHistoryPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

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
}