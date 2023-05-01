import 'package:dio/dio.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'dio_client.dart';

class ApiRequest {
  late Dio _dio;

  ApiRequest() {
    _dio = DioClient.instance.dio;
  }

  Future signInRequest({required String email, required String password}) {
    return _dio
        .post(ApiURL.login, data: {"email": email, "password": password});
  }

  Future signUpRequest(
      {required String email,
      required String name,
      required String phone,
      required String password,
      required String address}) {
    return _dio.post(ApiURL.signUp, data: {
      "email": email,
      "password": password,
      "phone": phone,
      "name": name,
      "address": address
    });
  }

  Future fetchListProductRequest() {
    return _dio.get(ApiURL.getProducts);
  }

  Future fetchCart() {
    return _dio.get(ApiURL.getCart);
  }

  Future addCart({required String idProduct}) {
    return _dio.post(ApiURL.addCart, data: {"id_product": idProduct});
  }

  Future updateCart({required String idProduct, required String idCart, required num quantity}) {
    return _dio.post(ApiURL.updateCart, data: {"id_product": idProduct, "id_cart": idCart, "quantity": quantity});
  }

  Future confirmOrder({required String idCart}) {
    return _dio.post(ApiURL.confirmOrder, data: {"id_cart": idCart});
  }

  Future getOrderHistory() {
    return _dio.post(ApiURL.getOrderHistory);
  }
}
