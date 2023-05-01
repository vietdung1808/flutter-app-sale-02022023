import 'dart:async';

import 'package:flutter_app_sale/common/base/base_bloc.dart';
import 'package:flutter_app_sale/common/base/base_event.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/data/repositories/product_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/pages/home/home_event.dart';

class HomeBloc extends BaseBloc {
  final StreamController<List<ProductModel>> _listProductsController =
      StreamController();
  final StreamController<CartModel> _cartController = StreamController();
  ProductRepository? _productRepository;
  CartRepository? _cartRepository;

  void setProductRepo(ProductRepository repository) {
    _productRepository = repository;
  }

  void setCartRepo(CartRepository repository) {
    _cartRepository = repository;
  }

  Stream<List<ProductModel>> get listProductsStream =>
      _listProductsController.stream;
  Stream<CartModel> get cartStream => _cartController.stream;

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case FetchProductsEvent:
        executeFetchProducts();
        break;
      case FetchCartEvent:
        executeFetchCart();
        break;
      case AddCartEvent:
        executeAddCart(event as AddCartEvent);
        break;
    }
  }

  void executeFetchProducts() {
    loadingSink.add(true);
    _productRepository?.fetchProducts().then((listProductDto) {
      if (listProductDto.isEmpty) return;
      var listProduct = List<ProductModel>.empty(growable: true);
      listProductDto.forEach((product) {
        listProduct.add(ProductModel(
            id: product.id ?? "",
            name: product.name ?? "",
            address: product.address ?? "",
            price: product.price ?? -1,
            img: product.img ?? "",
            quantity: product.quantity ?? -1,
            gallery: product.gallery ?? List.empty()));
      });
      _listProductsController.sink.add(listProduct);
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }

  void executeFetchCart() {
    loadingSink.add(true);
    _cartRepository?.fetchCart().then((cartDto) {
      var listProduct = List<ProductModel>.empty(growable: true);
      cartDto.products?.forEach((product) {
        listProduct.add(ProductModel(
            id: product.id ?? "",
            name: product.name ?? "",
            address: product.address ?? "",
            price: product.price ?? -1,
            img: product.img ?? "",
            quantity: product.quantity ?? -1,
            gallery: product.gallery ?? List.empty()));
      });
      var resultCart = CartModel(
          id: cartDto.id ?? "",
          products: listProduct,
          price: cartDto.price ?? 0);
      _cartController.sink.add(resultCart);
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }

  void executeAddCart(AddCartEvent event) {
    loadingSink.add(true);
    _cartRepository?.addCart(event.idProduct).then((cartDto) {
      var listProduct = List<ProductModel>.empty(growable: true);
      cartDto.products?.forEach((product) {
        listProduct.add(ProductModel(
            id: product.id ?? "",
            name: product.name ?? "",
            address: product.address ?? "",
            price: product.price ?? -1,
            img: product.img ?? "",
            quantity: product.quantity ?? -1,
            gallery: product.gallery ?? List.empty()));
      });
      var resultCart = CartModel(
          id: cartDto.id ?? "",
          products: listProduct,
          price: cartDto.price ?? 0);
      _cartController.sink.add(resultCart);
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }
}
