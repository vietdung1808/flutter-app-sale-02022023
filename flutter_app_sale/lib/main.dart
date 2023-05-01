import 'package:flutter/material.dart';
import 'package:flutter_app_sale/common/helpers/app_share_prefs.dart';
import 'package:flutter_app_sale/pages/splash/splash_page.dart';
import 'package:flutter_app_sale/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppSharePreferences.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      onGenerateRoute: generateRoutes,
      home: Scaffold(body: SplashPage()),
    );
  }
}
