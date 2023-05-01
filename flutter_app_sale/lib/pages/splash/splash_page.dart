import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sale/common/constants/share_preference_key.dart';
import 'package:flutter_app_sale/common/helpers/app_share_prefs.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 2), () {
      String token = AppSharePreferences.getString(SharePreferenceKey.token);
      if (token.isNotEmpty) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.home, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RouteName.login, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Container(
        color: Colors.blueGrey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset('assets/animations/animation_splash.json',
                animate: true, repeat: true),
            const Text("Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white))
          ],
        ));
  }
}
