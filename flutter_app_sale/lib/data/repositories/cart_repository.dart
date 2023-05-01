import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/models/app_response.dart';
import 'package:flutter_app_sale/models/cart_model.dart';

class CartRepository {
  ApiRequest? _apiRequest;

  void setApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<CartModel> fetchCart() async {
    Completer<CartModel> completerCartDto = Completer();
    try {
      Response response = await _apiRequest?.fetchCart();
      AppResponse<CartModel> appResponse =
          AppResponse.fromJson(response.data, CartModel.fromJson);
      completerCartDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerCartDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerCartDto.completeError(e);
    }
    return completerCartDto.future;
  }

  Future<CartModel> addCart(String idProduct) async {
    Completer<CartModel> completerCartDto = Completer();
    try {
      Response response = await _apiRequest?.addCart(idProduct: idProduct);
      AppResponse<CartModel> appResponse =
          AppResponse.fromJson(response.data, CartModel.fromJson);
      completerCartDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerCartDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerCartDto.completeError(e);
    }
    return completerCartDto.future;
  }

  Future<CartModel> updateCart(
      String idProduct, String idCart, num quantity) async {
    Completer<CartModel> completerCartDto = Completer();
    try {
      Response response = await _apiRequest?.updateCart(
          idProduct: idProduct, idCart: idCart, quantity: quantity);
      AppResponse<CartModel> appResponse =
          AppResponse.fromJson(response.data, CartModel.fromJson);
      print(appResponse.data);
      completerCartDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerCartDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerCartDto.completeError(e);
    }
    return completerCartDto.future;
  }

  Future<String> confirmOrder(String idCart) async {
    Completer<String> completerCartDto = Completer();
    try {
      Response response = await _apiRequest?.confirmOrder(idCart: idCart);
      AppResponse<String> appResponse =
          AppResponse(data: response.data["data"].toString());
      completerCartDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerCartDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerCartDto.completeError(e);
    }
    return completerCartDto.future;
  }

  Future<List<CartModel>> getOrderHistory() async {
    Completer<List<CartModel>> completerUserDto = Completer();
    try {
      Response response = await _apiRequest?.getOrderHistory();
      AppResponse<List<CartModel>> appResponse =
      AppResponse.fromJson(response.data, CartModel.convertJson);
      completerUserDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerUserDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerUserDto.completeError(e);
    }
    return completerUserDto.future;
  }
}
