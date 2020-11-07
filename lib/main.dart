import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:delgroce/screens/Cart.dart';
import 'package:delgroce/check.dart';
import 'package:delgroce/screens/PurchaseHistory.dart';
import 'package:delgroce/screens/signup.dart';
import 'package:delgroce/screens/splashscreen.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routes = <String, WidgetBuilder>{
    '/check': (BuildContext context) => new Check(),
    '/homepage': (BuildContext context) => new HomePage(),
    '/loginpage': (BuildContext context) => new LoginPage(),
    '/signup': (BuildContext context) => new Signup(),
    '/cartpage': (BuildContext context) => new Cart(),
    '/purchasehistory': (BuildContext context) => new PurchaseHistory(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'delgroceApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SplashScreen(),
      routes: routes,
    );
  }
}
