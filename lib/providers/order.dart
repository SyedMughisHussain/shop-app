import 'package:flutter/material.dart';

import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.products,
      required this.amount,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  // Future<void> fetchAndSetOrders() async {
  //   final url = Uri.parse(
  //       'https://test-data-3a842-default-rtdb.asia-southeast1.firebasedatabase.app//orders.json');
  //   final response = await http.get(url);
  //   List<OrderItem> loadedOrders = [];
  //   final extraxtedOrders = json.decode(response.body) as Map<String, dynamic>;
  //   if (extraxtedOrders == null || extraxtedOrders.isEmpty) {
  //     return;
  //   }
  //   extraxtedOrders.forEach((orderId, orderData) {
  //     loadedOrders.add(OrderItem(
  //         id: orderId,
  //         products: (orderData['products'] as List<dynamic>)
  //             .map((item) => CartItem(
  //                 id: item['id'],
  //                 title: item['title'],
  //                 quantity: item['quantity'],
  //                 price: item['price']))
  //             .toList(),
  //         amount: orderData['amount'],
  //         dateTime: DateTime.parse(orderData['dateTime'])));
  //   });
  //   _orders = loadedOrders.reversed.toList();
  //   notifyListeners();
  // }
  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://test-data-3a842-default-rtdb.asia-southeast1.firebasedatabase.app//orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];

    if (response.statusCode != 200) {
      return;
    }

    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    final extractedOrders = Map<String, dynamic>.from(extractedData);

    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://test-data-3a842-default-rtdb.asia-southeast1.firebasedatabase.app//orders/$userId.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            amount: total,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
