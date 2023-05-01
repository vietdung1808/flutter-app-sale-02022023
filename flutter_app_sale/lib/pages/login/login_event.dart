import 'package:flutter_app_sale/common/base/base_event.dart';

class LoginEvent extends BaseEvent {
  String email;
  String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [];
}

class LoginSuccessEvent extends BaseEvent {
  LoginSuccessEvent();

  @override
  List<Object?> get props => [];
}
