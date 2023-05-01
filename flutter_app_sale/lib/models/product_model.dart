class ProductModel {
  ProductModel(
      {this.id,
      this.name,
      this.address,
      this.price,
      this.img,
      this.quantity,
      this.gallery});

  ProductModel.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'] != null ? json['gallery'].cast<String>() : [];
  }

  String? id;
  String? name;
  String? address;
  num? price;
  String? img;
  num? quantity;
  List<String>? gallery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['price'] = price;
    map['img'] = img;
    map['quantity'] = quantity;
    map['gallery'] = gallery;
    return map;
  }

  static List<ProductModel> convertJson(dynamic json) {
    return (json as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, address: $address, price: $price, imageUrl: $img, quantity: $quantity, gallery: $gallery}';
  }
}
