import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrder(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapShot.error != null) {
              //....
              //ERROR HANDLING
              return Center(
                child: Text('Error occurred!!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) => ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (ctx, i) => ord.OrderItem(ordersData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
