import 'package:flutter/material.dart';
import '../screens/user_products_edit_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/user_products_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refeshProduct(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchPro(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context).items;
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
      body: FutureBuilder(
        future: _refeshProduct(context),
        builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refeshProduct(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productData.items.length,
                      itemBuilder: (ctx, i) => UserProductItem(
                        productData.items[i].id,
                        productData.items[i].title,
                        productData.items[i].imageUrl,
                        productData.items[i].price,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
