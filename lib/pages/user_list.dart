import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/config.dart';
import 'package:flutter_nodejs_crud_app/model/user_model.dart';
import 'package:flutter_nodejs_crud_app/pages/user_item.dart';
import 'package:flutter_nodejs_crud_app/services/api_service.dart';
import 'package:flutter_nodejs_crud_app/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final GlobalKey _globalKey = GlobalKey();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter & NodeJS - CRUD Produto'),
        elevation: 0,
        backgroundColor: HexColor("#283B71"),
      ),
      backgroundColor: HexColor("#283B71"),
      body: ProgressHUD(
        child: loadUsers(),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: _globalKey,
      ),
    );
  }

  Widget loadUsers() {
    return FutureBuilder(
      future: APIService.getUsers(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<UserModel>?> model,
      ) {
        if (model.hasData) {
          return userList(model.data);
        } else if (model.hasError) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      model.error != null
                          ? '${model.error}'
                          : 'Um erro acorreu.',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ))),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                primary: HexColor("283B71"),
                                side: const BorderSide(
                                    width: 1.0, color: Colors.white),
                                minimumSize: const Size(200, 40),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                  context,
                                  '/list-product',
                                );
                              },
                              child: const Text('Voltar'),
                            )))
                  ],
                ),
              ]);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget userList(users) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: HexColor("283B71"),
                  side: const BorderSide(width: 1.0, color: Colors.white),
                  minimumSize: const Size(200, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(
                    context,
                    '/list-product',
                  );
                },
                child: const Text('Listar Produtos'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: HexColor("283B71"),
                  side: const BorderSide(width: 1.0, color: Colors.white),
                  minimumSize: const Size(200, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  SharedService.logout(context);
                  Navigator.popAndPushNamed(
                    context,
                    '/login',
                  );
                },
                child: const Text('Logoff'),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserItem(
                    model: users[index],
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
