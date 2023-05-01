import 'package:flutter_app_sale/common/base/base_bloc.dart';
import 'package:flutter_app_sale/common/base/base_event.dart';
import 'package:flutter_app_sale/common/constants/share_preference_key.dart';
import 'package:flutter_app_sale/common/helpers/app_share_prefs.dart';
import 'package:flutter_app_sale/data/repositories/authentication_repository.dart';
import 'package:flutter_app_sale/pages/login/login_event.dart';

class LoginBloc extends BaseBloc {
  AuthenticationRepository? _authenticationRepository;

  void setAuthenticationRepo(AuthenticationRepository repository) {
    _authenticationRepository = repository;
  }

  @override
  void dispatch(BaseEvent event) {
    switch (event.runtimeType) {
      case LoginEvent:
        executeSignIn(event as LoginEvent);
        break;
    }
  }

  void executeSignIn(LoginEvent event) {
    loadingSink.add(true);
    _authenticationRepository
        ?.signIn(email: event.email, password: event.password)
        .then((userDto) {
      AppSharePreferences.setString(
          key: SharePreferenceKey.token, value: userDto.token ?? "");
      // messageSink.add("Login success");
      progressSink.add(LoginSuccessEvent());
    }).catchError((e) {
      messageSink.add(e.toString());
    }).whenComplete(() => loadingSink.add(false));
  }
}
