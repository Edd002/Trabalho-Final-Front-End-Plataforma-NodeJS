import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/pages/login_page.dart';
import 'package:flutter_nodejs_crud_app/services/shared_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter & NodeJS - CRUD Produto'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                SharedService.logout(context);
              },
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: const LoginPage());
  }
}
