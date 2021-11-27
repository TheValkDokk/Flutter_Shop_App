import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> switchFavorite(String authToken) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken');
      await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
