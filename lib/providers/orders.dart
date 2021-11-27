import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
      final response = await http.get(url);
      final List<OrderItem> list = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      extractedData.forEach((id, v) {
        list.add(
          OrderItem(
            id: id,
            dateTime: DateTime.parse(v['dateTime']),
            amount: v['amount'],
            products: (v['products'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'].toDouble(),
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = list.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
      final timeSp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'products': cartProducts,
            'dateTime': timeSp.toIso8601String(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeSp,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
