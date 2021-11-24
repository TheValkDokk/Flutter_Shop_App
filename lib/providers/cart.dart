import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'quantity': this.quantity,
      'price': this.price,
    };
  }

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double totalPrice = 0;
    _items.forEach((_, p) => totalPrice += p.price * p.quantity);
    return totalPrice;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (prod) => CartItem(
          id: prod.id,
          title: title,
          quantity: prod.quantity + 1,
          price: price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (pro) => CartItem(
          id: pro.id,
          title: pro.title,
          quantity: pro.quantity - 1,
          price: pro.price,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
