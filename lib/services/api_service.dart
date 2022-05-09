import 'dart:convert';

import 'package:flutter_nodejs_crud_app/model/product_model.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class APIService {
  static var client = http.Client();

  // PASSAR O LOGIN E SENHA TEMPORARIAMENTE PARA CONSEGUIR O TOKEN TODA VEZ QUE SUBIR O APP ATÉ TER O LOGIN IMPLEMENTADO
  static Future<String> generateToken() async {
    var token = '';

    await client
        .post(Uri.http(Config.apiURL, Config.securityAPIuri),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({"login": "admin", "senha": "1234"}))
        .catchError((e) {
      print('Erro: $e');
    }).then((response) => token = json.decode(response.body)['token']);

    return token;
  }

  // Buscar todos os produtos
  static Future<List<ProductModel>?> getProducts() async {
    String token = await generateToken();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.get(
        Uri.http(Config.apiURL, Config.productsAPIuri),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return productsFromJson(data);
    } else {
      return null;
    }
  }

  // CONTINUAR: CONFIGURAR A CHAMADA DOS ENDPOINTS DE CADASTRAR/ALTERAR E EXLCUIR
  // Cadastrar ou atualizar um produto
  static Future<bool> saveProduct(
    ProductModel model,
    bool isEditMode,
    bool isFileSelected,
  ) async {
    String token = await generateToken();
    var productURL = Config.productsAPIuri;

    if (isEditMode) {
      productURL = productURL + "/" + model.id.toString();
    }

    var requestMethod = isEditMode ? "PUT" : "POST";
    var request = http.MultipartRequest(
        requestMethod, Uri.http(Config.apiURL, productURL));

    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields["descricao"] = model.descricao!;
    request.fields["marca"] = 'Marca Teste';//model.marca!;
    request.fields["valor"] = model.valor!.toString();

    /*
    if (model.productImage != null && isFileSelected) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage',
        model.productImage!,
      );

      request.files.add(multipartFile);
    }
    */

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Excluir um produto
  static Future<bool> deleteProduct(productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.productsAPIuri + "/" + productId,
    );

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
