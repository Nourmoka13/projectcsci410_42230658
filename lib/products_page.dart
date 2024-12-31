// ignore_for_file: non_constant_identifier_names
import 'package:candles/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:candles/categories_page.dart';
import 'package:flutter/material.dart';

List<Product> products = Product.products;

class ProductsPage extends StatefulWidget {
  final String? cat_name;
  const ProductsPage({super.key, required this.cat_name});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool loaded = false;
  void fetchProducts() async {
    loaded = false;
    getProducts(widget.cat_name as String);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  void initState() {
    fetchProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' ${widget.cat_name} Products'),
          centerTitle: true,
          backgroundColor: Colors.purple[100],
          actions: [
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () async {
                  fetchProducts();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: loaded
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2.4 / 4,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/${products[index].pr_img}'), // Replace with the actual product image URL
                              height: 150,
                              width: 150,
                              fit: BoxFit.fitWidth,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              (loadingProgress
                                                      .expectedTotalBytes ??
                                                  1)
                                          : null, // Show progress if available
                                    ),
                                  );
                                }
                              },
                              // errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              children: [
                                Text(
                                  products[index].pr_name as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${products[index].pr_price.toString()} \$',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: products.length, // Number of products per category
              )
            : const Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}

void getProducts(String cat) async {
  final url = Uri.http(baseUrl, 'getProducts.php', {'cat': cat});
  final response = await http.get(url);
  if (response.statusCode == 200) {
    products.clear();
    final jsonResponse = convert.jsonDecode(response.body);
    for (var row in jsonResponse) {
      Product p = Product(
          pr_name: row['pr_name'],
          pr_cat: row['cat_name'],
          pr_img: row['pr_img'],
          pr_price: row['pr_price']);
      products.add(p);
    }
  }
}
