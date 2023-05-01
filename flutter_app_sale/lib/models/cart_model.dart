import 'package:flutter_app_sale/models/product_model.dart';

class CartModel {
  String? id;
  List<ProductModel>? products;
  num? price;
  DateTime? createDate;

  CartModel({this.id, this.products, this.price, this.createDate});

  CartModel.fromJson(dynamic json) {
    id = json['_id'];

    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductModel.fromJson(v));
      });
    }
    price = json['price'];
    createDate = DateTime.parse(json['date_created']);
  }

  static List<CartModel> convertJson(dynamic json) {
    return (json as List).map((e) => CartModel.fromJson(e)).toList();
  }
}
