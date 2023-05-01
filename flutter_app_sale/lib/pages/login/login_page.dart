import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/widgets/loading_widget.dart';
import 'package:flutter_app_sale/common/widgets/progress_listener_widget.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/authentication_repository.dart';
import 'package:flutter_app_sale/pages/login/login_bloc.dart';
import 'package:flutter_app_sale/pages/login/login_event.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:flutter_app_sale/utils/dimension_utils.dart';
import 'package:flutter_app_sale/utils/message_utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  late String password = '';
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
          update: (_, request, repository) {
            repository ??= AuthenticationRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider<AuthenticationRepository, LoginBloc>(
          create: (context) => LoginBloc(),
          update: (_, repository, bloc) {
            bloc ??= LoginBloc();
            bloc.setAuthenticationRepo(repository);
            return bloc;
          },
        )
      ],
      child: const LoginContainerWidget(),
    );
  }
}

class LoginContainerWidget extends StatefulWidget {
  const LoginContainerWidget({super.key});

  @override
  State<LoginContainerWidget> createState() => _LoginContainerWidgetState();
}

class _LoginContainerWidgetState extends State<LoginContainerWidget> {
  late LoginBloc _bloc;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.messageStream.listen((event) {
        MessageUtils.showMessage(context, "Alert!!", event.toString());
      });

      _bloc.progressStream.listen((event) {
        if (event is LoginSuccessEvent) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.home, (route) => false);
        }
      });
    });
  }

  void onPressSignIn() {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (email.isEmpty || password.isEmpty) return;
    _bloc.executeSignIn(LoginEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: LoadingWidget(
        bloc: _bloc,
        child: SafeArea(
            child: Container(
          constraints: const BoxConstraints.expand(),
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                    child: ProgressListenerWidget<LoginBloc>(
                  callback: (event) {
                    print(event.runtimeType);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          flex: 2,
                          child:
                              Image.asset("assets/images/ic_food_express.png")),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: DimensionUtils
                                        .paddingHeightDivideNumber(context)),
                                child: _buildEmailTextField(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: DimensionUtils
                                        .paddingHeightDivideNumber(context)),
                                child: _buildPasswordTextField(),
                              ),
                              _buildButtonSignIn(onPressSignIn),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: _buildTextSignUp())
                    ],
                  ),
                )),
              ),
            );
          }),
        )),
      ),
    );
  }

  Widget _buildTextSignUp() {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account!"),
            InkWell(
              onTap: () async {
                try {
                  var data = await Navigator.of(context)
                      .pushNamed(RouteName.signUp) as Map;
                  setState(() {
                    emailController.text = data["email"];
                    passwordController.text = data["password"];
                    MessageUtils.showMessage(
                        context, "Alert!!", data["message"]);
                  });
                } catch (e) {
                  MessageUtils.showMessage(context, "Alert!!", e.toString());
                  return;
                }
              },
              child: const Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildEmailTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "Email",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        obscureText: true,
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 0, color: Colors.black12)),
          labelStyle: const TextStyle(color: Colors.blue),
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(Function onPress) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue[500];
                } else if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.blueAccent;
              }),
              elevation: MaterialStateProperty.all(5),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
            )),
            child: ElevatedButton(
              child: const Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => onPress(),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
