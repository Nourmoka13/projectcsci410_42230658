// ignore_for_file: avoid_print
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'products_page.dart';
import 'cCategory.dart';
import 'package:http/http.dart' as http;

String baseUrl = "noorflutter.atwebpages.com";
List<Ccategory> categories = Ccategory.categories;

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool loaded = false;
  void fetchCategories() {
    loaded = false;
    getCategories();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  void initState() {
    fetchCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () async {
                  fetchCategories();
                  setState(() {});
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          centerTitle: true,
          title: Text('Categories'),
          backgroundColor: Colors.purple[100],
        ),
        body: loaded
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductsPage(cat_name: categories[index].cName),
                        ),
                      );
                    },
                    child: Card(
                      child: Image(
                        image: AssetImage('assets/${categories[index].cImg}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                itemCount: categories.length, // Number of categories
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

void getCategories() async {
  try {
    final url = Uri.http(baseUrl, "getCat.php");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      categories.clear();
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Ccategory c = Ccategory(cName: row['cat_name'], cImg: row['cat_img']);
        categories.add(c);
      }
    } else {
      print(response.statusCode);
    }
  } catch (e) {
    print(e.toString());
  }
}
