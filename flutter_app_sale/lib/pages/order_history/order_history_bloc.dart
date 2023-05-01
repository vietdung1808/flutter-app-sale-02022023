import 'dart:async';

import 'package:flutter_app_sale/common/base/base_bloc.dart';
import 'package:flutter_app_sale/common/base/base_event.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/data/repositories/product_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/pages/cart/cart_event.dart';
import 'package:flutter_app_sale/pages/home/home_event.dart';

class OrderHistoryBloc extends BaseBloc {
  final StreamController<List<CartModel>> _listCartController =
      StreamController();
  CartRepository? _cartRepository;

  void setCartRepo(CartRepository repository) {
    _cartRepository = repository;
  }

  Stream<List<CartModel>> get listCartStream => _listCartController.stream;

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case GetOrderHistoryEvent:
        getHistoryOrder();
        break;
    }
  }

  void getHistoryOrder() {
    loadingSink.add(true);
    _cartRepository?.getOrderHistory().then((listCart) {
      if (listCart.isEmpty) return;
      _listCartController.sink.add(listCart);
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }
}
