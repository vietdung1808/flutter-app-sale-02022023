import 'package:flutter_app_sale/common/base/base_bloc.dart';
import 'package:flutter_app_sale/common/base/base_event.dart';
import 'package:flutter_app_sale/data/repositories/authentication_repository.dart';
import 'package:flutter_app_sale/pages/sign_up/sign_up_event.dart';

class SignUpBloc extends BaseBloc {
  AuthenticationRepository? _authenticationRepository;

  void setAuthenticationRepo(AuthenticationRepository repository) {
    _authenticationRepository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        _handleSignUp(event as SignUpEvent);
        break;
    }
  }

  void _handleSignUp(SignUpEvent event) async {
    loadingSink.add(true);
    _authenticationRepository
        ?.sigUp(
            email: event.email,
            password: event.password,
            name: event.name,
            phone: event.phone,
            address: event.address)
        .then((userDto) {
      progressSink.add(SignUpSuccessEvent(
          email: event.email,
          password: event.password,
          message: "Congratulation Register success"));
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }
}
