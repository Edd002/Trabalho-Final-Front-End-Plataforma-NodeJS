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

  // Cadastrar ou atualizar produto
  static Future<bool> saveProduct(ProductModel model, bool isEditMode) async {
    if (!isEditMode) {
      return insertProduct(model);
    } else {
      return updateProduct(model);
    }
  }

  // Cadastrar produto
  static Future<bool> insertProduct(ProductModel model) async {
    var requestUri = Config.productsAPIuri;
    String token = await generateToken();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String requestBody = json.encode({
      "descricao": model.descricao,
      "valor": model.valor,
      "marca": model.marca
    });

    bool sucess = false;
    await client
        .post(Uri.http(Config.apiURL, requestUri),
            headers: requestHeaders, body: requestBody)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        sucess = true;
      }
    });
    return sucess;
  }

  // Atualizar produto
  static Future<bool> updateProduct(ProductModel model) async {
    var requestUri = Config.productsAPIuri + "/${model.id}";
    String token = await generateToken();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String requestBody = json.encode({
      "descricao": model.descricao,
      "valor": model.valor,
      "marca": model.marca
    });

    bool sucess = false;
    await client
        .put(Uri.http(Config.apiURL, requestUri),
            headers: requestHeaders, body: requestBody)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode == 200) {
        sucess = true;
      }
    });
    return sucess;
  }

  // Excluir um produto
  static Future<bool> deleteProduct(productId) async {
    var requestUri = Config.productsAPIuri + "/$productId";
    String token = await generateToken();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    await client
        .delete(Uri.http(Config.apiURL, requestUri), headers: requestHeaders)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }
}
