import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/models/app_response.dart';
import 'package:flutter_app_sale/models/user_model.dart';

class AuthenticationRepository {
  ApiRequest? _apiRequest;

  void setApiRequest(ApiRequest apiRequest) {
    _apiRequest = apiRequest;
  }

  Future<UserModel> signIn(
      {required String email, required String password}) async {
    Completer<UserModel> completerUserDto = Completer();
    try {
      Response response =
          await _apiRequest?.signInRequest(email: email, password: password);
      AppResponse<UserModel> appResponse =
          AppResponse.fromJson(response.data, UserModel.fromJson);
      completerUserDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerUserDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerUserDto.completeError(e);
    }
    return completerUserDto.future;
  }

  Future<UserModel> sigUp(
      {required String email,
      required String name,
      required String phone,
      required String password,
      required String address}) async {
    Completer<UserModel> completerUserDto = Completer();
    try {
      Response response = await _apiRequest?.signUpRequest(
          email: email,
          password: password,
          address: address,
          name: name,
          phone: phone);
      AppResponse<UserModel> appResponse =
          AppResponse.fromJson(response.data, UserModel.fromJson);
      completerUserDto.complete(appResponse.data);
    } on DioError catch (e) {
      completerUserDto.completeError(e.response?.data["message"]);
    } catch (e) {
      completerUserDto.completeError(e);
    }
    return completerUserDto.future;
  }
}
