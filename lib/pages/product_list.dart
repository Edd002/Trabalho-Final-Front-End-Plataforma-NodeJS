import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/config.dart';
import 'package:flutter_nodejs_crud_app/model/login_response_model.dart';
import 'package:flutter_nodejs_crud_app/model/product_model.dart';
import 'package:flutter_nodejs_crud_app/pages/product_item.dart';
import 'package:flutter_nodejs_crud_app/services/api_service.dart';
import 'package:flutter_nodejs_crud_app/services/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final GlobalKey _globalKey = GlobalKey();
  bool isApiCallProcess = false;
  LoginResponseModel? loginDetails;

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
        child: loadProducts(),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        key: _globalKey,
      ),
    );
  }

  Future<void> getLoggedUser() async {
    loginDetails = await SharedService.loginDetails();
  }

  Widget loadProducts() {
    return FutureBuilder(
      future: APIService.getProducts(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ProductModel>?> model,
      ) {
        getLoggedUser();
        if (model.hasData) {
          return productList(model.data);
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
                                SharedService.logout(context);
                                Navigator.popAndPushNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: const Text('Tentar Novamente'),
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

  Widget productList(products) {
    String? userRoles = loginDetails?.roles;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              userRoles != null && userRoles.contains('ADMIN')
                  ? ElevatedButton(
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
                          '/list-user',
                        );
                      },
                      child: const Text('Listar Usu??rios'),
                    )
                  : Container(),
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
                  Navigator.pushNamed(
                    context,
                    '/add-product',
                  );
                },
                child: const Text('Adicionar Produto'),
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductItem(
                    model: products[index],
                    onDelete: (ProductModel model) {
                      setState(() {
                        isApiCallProcess = true;
                      });

                      APIService.deleteProduct(model.id).then(
                        (response) {
                          if (response.isNotEmpty) {
                            FormHelper.showSimpleAlertDialog(
                              _globalKey.currentContext!,
                              Config.appName,
                              "Um erro ocorreu.\n$response",
                              "OK",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          }

                          setState(() {
                            isApiCallProcess = false;
                          });
                        },
                      );
                    },
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
