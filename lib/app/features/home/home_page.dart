import 'package:flutter/material.dart';
import 'package:puc_minas/app/core/constants/app_routes.dart';
import 'package:puc_minas/app/core/models/product_model.dart';
import 'package:puc_minas/app/features/home/home_controler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductModel> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [
          IconButton(
              onPressed: () async {
                var loggedout = await HomeControler.logout();
                if (loggedout) {
                  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                }
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var product = await Navigator.of(context).pushNamed(AppRoutes.add);

          if (product != null) {
            products.add(product as ProductModel);
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(),
    );
  }
}
