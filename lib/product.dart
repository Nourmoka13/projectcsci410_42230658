// ignore_for_file: non_constant_identifier_names

class Product {
  String? pr_name;
  String? pr_img;
  int? pr_price;
  String? pr_cat;

  Product(
      {required this.pr_name,
      required this.pr_cat,
      required this.pr_img,
      required this.pr_price});

  static List<Product> products = [];
}
