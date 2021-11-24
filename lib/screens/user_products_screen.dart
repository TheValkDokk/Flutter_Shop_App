import 'package:flutter/material.dart';
import '../screens/user_products_edit_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/user_products_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refeshProduct(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchPro();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).items;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProduct.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refeshProduct(context),
        child: ListView.builder(
          itemCount: productData.length,
          itemBuilder: (ctx, i) => UserProductItem(
            productData[i].id,
            productData[i].title,
            productData[i].imageUrl,
            productData[i].price,
          ),
        ),
      ),
    );
  }
}
