import 'package:flutter/material.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/models/user_model.dart';
import 'package:flutter_app_sale/pages/cart/cart_page.dart';
import 'package:flutter_app_sale/pages/home/home_page.dart';
import 'package:flutter_app_sale/pages/login/login_page.dart';
import 'package:flutter_app_sale/pages/order_detail/order_detail_page.dart';
import 'package:flutter_app_sale/pages/order_history/order_history_page.dart';
import 'package:flutter_app_sale/pages/product_detail/product_detail_page.dart';
import 'package:flutter_app_sale/pages/sign_up/sign_up_page.dart';

class RouteName {
  static const String login = '/login';
  static const String home = '/home';
  static const String signUp = '/sign_up';
  static const String productDetail = '/product_detail';
  static const String cart = '/cart';
  static const String orderHistory = '/order_history';
  static const String orderDetail = '/order_detail';
}

final Map<String, WidgetBuilder> routes = {
  RouteName.login: (context) => LoginPage(),
  RouteName.home: (context) => HomePage(),
  RouteName.signUp: (context) => const SignUpPage(),
  RouteName.cart: (context) => const CartPage(),
  RouteName.orderHistory: (context) => const OrderHistoryPage(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.productDetail:
      final ProductModel model = (settings.arguments as ProductModel);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => ProductDetailPage(
          productModel: model,
        ),
      );
    case RouteName.orderDetail:
      final CartModel model = (settings.arguments as CartModel);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => OrderDetailPage(
          cartModel: model,
        ),
      );

    default:
      return null;
  }
}
