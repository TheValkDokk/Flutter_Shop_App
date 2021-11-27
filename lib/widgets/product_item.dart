import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context);
    return Consumer<Product>(
      builder: (_, product, __) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              color: Colors.deepOrange,
              onPressed: () => product.switchFavorite(authData.token),
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            trailing: IconButton(
              color: Colors.deepOrange,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      onPressed: () => cart.removeSingleItem(product.id),
                      label: 'Undo',
                    ),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
