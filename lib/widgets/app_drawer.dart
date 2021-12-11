import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop App'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Management'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LogOut'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Spacer(
            flex: 2,
          ),
          Text(
            "Logged as : ${Provider.of<Auth>(context).userMail}",
            style: TextStyle(fontSize: 20, overflow: TextOverflow.clip),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          )
        ],
      ),
    );
  }
}
