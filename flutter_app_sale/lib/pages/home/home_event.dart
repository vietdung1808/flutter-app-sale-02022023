import 'package:flutter_app_sale/common/base/base_event.dart';

class FetchProductsEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class FetchCartEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

class AddCartEvent extends BaseEvent {
  String idProduct;

  AddCartEvent({required this.idProduct});

  @override
  List<Object?> get props => [];
}
