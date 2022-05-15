import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/model/product_model.dart';
import 'package:flutter_nodejs_crud_app/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../config.dart';

class ProductAddEdit extends StatefulWidget {
  const ProductAddEdit({Key? key}) : super(key: key);

  @override
  _ProductAddEditState createState() => _ProductAddEditState();
}

class _ProductAddEditState extends State<ProductAddEdit> {
  ProductModel? productModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter & NodeJS - CRUD Produto'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: productForm(),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productModel = ProductModel();

    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productModel = arguments['model'];
        isEditMode = true;
        setState(() {});
      }
    });
  }

  Widget productForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              const Icon(Icons.person),
              "ProductDescription",
              "Descrição do Produto",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'A descrição do produto não pode ser vazia.';
                }
                return null;
              },
              (onSavedVal) => {
                productModel!.descricao = onSavedVal,
              },
              initialValue: productModel!.descricao ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              const Icon(Icons.person),
              "ProductBrand",
              "Marca do Produto",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'A marca do produto não pode ser vazia.';
                }
                return null;
              },
              (onSavedVal) => {
                productModel!.marca = onSavedVal,
              },
              initialValue: productModel!.marca ?? "",
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
            ),
            child: FormHelper.inputFieldWidget(
              context,
              const Icon(Icons.person),
              "ProductPrice",
              "Preço do Produto",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'O preço do produto não pode ser vazio.';
                } else if (double.tryParse(onValidateVal.toString().replaceAll(",", ".")) == null) {
                  return 'O preço do produto deve ser numérico (ex.: 2.99).';
                }
                return null;
              },
              (onSavedVal) => {
                productModel!.valor = onSavedVal,
              },
              initialValue: productModel!.valor == null
                  ? ""
                  : productModel!.valor.toString(),
              obscureText: false,
              borderFocusColor: Colors.black,
              borderColor: Colors.black,
              textColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.7),
              borderRadius: 10,
              showPrefixIcon: false,
              suffixIcon: const Icon(Icons.monetization_on),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Salvar",
              () {
                if (validateAndSave()) {
                  print(productModel!.toJson());

                  setState(() {
                    isApiCallProcess = true;
                  });

                  APIService.saveProduct(productModel!, isEditMode).then(
                    (response) {
                      setState(() {
                        isApiCallProcess = false;
                      });

                      if (response) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          Config.appName,
                          "Um erro ocorreu.",
                          "OK",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                  );
                }
              },
              btnColor: HexColor("283B71"),
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  isValidURL(url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
}
