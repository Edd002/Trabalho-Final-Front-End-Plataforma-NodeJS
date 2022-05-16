import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/pages/login_page.dart';
import 'package:flutter_nodejs_crud_app/pages/product_add_edit.dart';
import 'package:flutter_nodejs_crud_app/pages/product_list.dart';
import 'package:flutter_nodejs_crud_app/pages/register_page.dart';
import 'package:flutter_nodejs_crud_app/services/shared_service.dart';

Widget _defaultHome = const LoginPage();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get result of the login function.
  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    _defaultHome = const LoginPage();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & NodeJS - CRUD Produto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => _defaultHome,
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/list-product':(context) => const ProductsList(),
        '/add-product': (context) => const ProductAddEdit(),
        '/edit-product': (context) => const ProductAddEdit(),
      },
    );
  }
}
