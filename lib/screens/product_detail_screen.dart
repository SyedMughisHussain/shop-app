import 'package:flutter/material.dart';

import '../providers/products.dart';

import 'package:provider/provider.dart';

class ProductDeatailScreen extends StatelessWidget {
  static const routeArgs = './products_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title.toString()),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title.toString()),
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    '\$${loadedProduct.price}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child:
                    Text(loadedProduct.description.toString(), softWrap: true),
              ),
              const SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
