import 'dart:convert';

RegisterResponseModel registerResponseJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.login,
    required this.roles,
    required this.message
  });
  late final int? id;
  late final String? nome;
  late final String? email;
  late final String? login;
  late final String? roles;
  late final String? message;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    login = json['login'];
    roles = json['roles'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nome'] = nome;
    _data['email'] = email;
    _data['login'] = login;
    _data['roles'] = roles;
    _data['message'] = message;
    return _data;
  }
}
