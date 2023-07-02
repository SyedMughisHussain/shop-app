import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

//import 'package:shop_app/screens/Product_Overview_Screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import 'providers/products.dart';
import './screens/cart_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './providers/order.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

import './providers/cart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final produts = Products('', []);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(
            '',
            '',
            [],
          ),
          update: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.red,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDeatailScreen.routeArgs: (context) => ProductDeatailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
