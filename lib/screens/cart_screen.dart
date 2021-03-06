import 'package:flutter/material.dart';
import '../widgets/cart_items.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  orderBt(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItems(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class orderBt extends StatefulWidget {
  const orderBt({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<orderBt> createState() => _orderBtState();
}

class _orderBtState extends State<orderBt> {
  var _isLoad = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.itemCount <= 0 || _isLoad)
          ? null
          : () async {
              setState(() {
                _isLoad = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoad = false;
              });
              widget.cart.clear();
            },
      child: _isLoad ? CircularProgressIndicator() : Text('ORDER NOW'),
    );
  }
}
