import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/badge.dart';
import '../providers/products.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

import '../widgets/product_grid.dart';
//import '../widgets/badge.dart';

enum FilterOptions {
// ignore: constant_identifier_names
  Favourites,
// ignore: constant_identifier_names
  All
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // 1) Approach
    // Future.delayed(Duration.zero).then((_) =>
    // Provider.of<Products>(context).getAndSetProducts()
    // );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                  value: FilterOptions.Favourites,
                  child: Text(
                    'Only Favourites',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text(
                    'Show All',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => BadgeClass(
              value: cart.itemCount.toString(),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavourites),
    );
  }
}
