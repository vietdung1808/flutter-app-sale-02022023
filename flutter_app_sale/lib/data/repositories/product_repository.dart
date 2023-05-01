import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/models/app_response.dart';
import 'package:flutter_app_sale/models/product_model.dart';

class ProductRepository {
  ApiRequest? _apiRequest;

  void setApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<List<ProductModel>> fetchProducts() async {
    Completer<List<ProductModel>> completerUserDto = Completer();
    try {
      Response response = await _apiRequest?.fetchListProductRequest();
      AppResponse<List<ProductModel>> appResponse =
          AppResponse.fromJson(response.data, ProductModel.convertJson);
      completerUserDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerUserDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerUserDto.completeError(e);
    }
    return completerUserDto.future;
  }
}
