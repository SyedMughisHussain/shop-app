import 'package:flutter/material.dart';

import '../providers/products.dart';
import '../widgets/user_products_item.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';

import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refreshUserProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshUserProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshUserProducts(context),
                  child: Consumer<Products>(
                    builder: (ctx, products, _) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  UserProductItem(
                                    id: products.items[index].id!,
                                    imageUrl: products.items[index].imageUrl,
                                    title: products.items[index].title,
                                  ),
                                  const Divider(),
                                ],
                              )),
                    ),
                  ),
                ),
        ));
  }
}
