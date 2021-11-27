import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  Future<void> fetchPro([bool filterUser = false]) async {
    try {
      final filterString =
          filterUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      var url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken&$filterString');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print('Filter $filterUser');
      url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');

      final favorite = await http.get(url);
      final favoriteData = json.decode(favorite.body);
      final List<Product> loadPro = [];
      extractedData.forEach((id, p) {
        loadPro.add(Product(
          id: id,
          title: p['title'],
          description: p['description'],
          price: p['price'],
          imageUrl: p['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[id] ?? false,
        ));
      });
      _items = loadPro;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<Product> get items {
    // if (_showFavorite) {
    //   return _items.where((e) => e.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product p) async {
    try {
      final url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'price': p.price,
            'creatorId': userId,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: p.title,
        description: p.description,
        imageUrl: p.imageUrl,
        price: p.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (er) {
      throw er;
    }
  }

  Product findbyId(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  void removeProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken');
    http.delete(url);
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product p) async {
    final pp = _items.indexWhere((e) => e.id == id);
    if (pp >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-62017-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'price': p.price,
            'isFavorite': p.isFavorite,
          }));
      _items[pp] = p;
      notifyListeners();
    }
  }
}
