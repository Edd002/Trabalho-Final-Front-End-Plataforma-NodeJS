import 'dart:convert';

import 'package:flutter_nodejs_crud_app/model/login_request_model.dart';
import 'package:flutter_nodejs_crud_app/model/login_response_model.dart';
import 'package:flutter_nodejs_crud_app/model/product_model.dart';
import 'package:flutter_nodejs_crud_app/model/register_request_model.dart';
import 'package:flutter_nodejs_crud_app/model/register_response_model.dart';
import 'package:flutter_nodejs_crud_app/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class APIService {
  static var client = http.Client();

  // Buscar todos os produtos
  static Future<List<ProductModel>?> getProducts() async {
    LoginResponseModel? loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails?.token}'
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
  static Future<String> saveProduct(ProductModel model, bool isEditMode) async {
    if (!isEditMode) {
      return insertProduct(model);
    } else {
      return updateProduct(model);
    }
  }

  // Cadastrar produto
  static Future<String> insertProduct(ProductModel model) async {
    var requestUri = Config.productsAPIuri;
    LoginResponseModel? loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails?.token}'
    };
    String requestBody = json.encode({
      "descricao": model.descricao,
      "valor": model.valor,
      "marca": model.marca
    });

    String responseMessage = "";
    await client
        .post(Uri.http(Config.apiURL, requestUri),
            headers: requestHeaders, body: requestBody)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        responseMessage = jsonDecode(response.body)['message'];
      }
    });
    return responseMessage;
  }

  // Atualizar produto
  static Future<String> updateProduct(ProductModel model) async {
    var requestUri = Config.productsAPIuri + "/${model.id}";
    LoginResponseModel? loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails?.token}'
    };
    String requestBody = json.encode({
      "descricao": model.descricao,
      "valor": model.valor,
      "marca": model.marca
    });

    String responseMessage = "";
    await client
        .put(Uri.http(Config.apiURL, requestUri),
            headers: requestHeaders, body: requestBody)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode != 200) {
        responseMessage = jsonDecode(response.body)['message'];
      }
    });
    return responseMessage;
  }

  // Excluir um produto
  static Future<String> deleteProduct(productId) async {
    var requestUri = Config.productsAPIuri + "/$productId";
    LoginResponseModel? loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails?.token}'
    };

    String responseMessage = "";
    await client
        .delete(Uri.http(Config.apiURL, requestUri), headers: requestHeaders)
        .catchError((e) {
      print('Erro: $e');
    }).then((response) {
      if (response.statusCode != 200) {
        responseMessage = jsonDecode(response.body)['message'];
      }
    });
    return responseMessage;
  }

  // Login
  static Future<LoginResponseModel?> login(LoginRequestModel model) async {
    await client
        .post(Uri.http(Config.apiURL, Config.securityLoginAPIuri),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(model.toJson()))
        .catchError((e) {
      print('Erro: $e');
    }).then((response) async {
      if (response.statusCode == 200) {
        await SharedService.setLoginDetails(loginResponseJson(response.body));
        return loginResponseJson(response.body);
      }
    });
    return null;
  }

  // Registro
  static Future<RegisterResponseModel?> register(RegisterRequestModel model) async {
    return await client
        .post(Uri.http(Config.apiURL, Config.securityResgisterAPIuri),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(model.toJson()))
        .catchError((e) {
      print('Erro: $e');
    }).then((response) async {
      if (response.statusCode == 200) {
        return registerResponseJson(response.body);
      }
      return null;
    });
  }
}
