import 'package:flutter/material.dart';
// import 'package:shop_app/providers/product.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourites;
  ProductGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavourites ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      /* Here we are using ChangeNotifierProvider value constructer 
      because we want to change the data which is present in the 
      form of list or grid view so we use the ChangeNotifierProvider.value approch
      otherwise we use the builder method. */
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            // products[index].id,
            // products[index].title,
            // products[index].imageUrl,
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //mainAxisExtent: 200,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
    );
  }
}
