import 'package:flutter_app_sale/common/base/base_event.dart';
class UpdateCartEvent extends BaseEvent {
  String idProduct;
  String idCart;
  num quantity;

  UpdateCartEvent({required this.idProduct, required this.idCart, required this.quantity});

  @override
  List<Object?> get props => [];
}

class ConfirmOrderEvent extends BaseEvent {
  String idCart;

  ConfirmOrderEvent({required this.idCart});

  @override
  List<Object?> get props => [];
}

class ConfirmOrderSuccessEvent extends BaseEvent {
  String message;
  ConfirmOrderSuccessEvent({required this.message});

  @override
  List<Object?> get props => [];
}

class GetOrderHistoryEvent extends BaseEvent {
  GetOrderHistoryEvent();

  @override
  List<Object?> get props => [];
}