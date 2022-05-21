import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel(
      {required this.id,
      required this.nome,
      required this.login,
      required this.roles,
      required this.token,
      required this.message});
  late final int? id;
  late final String? nome;
  late final String? login;
  late final String? roles;
  late final String? token;
  late final String? message;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    login = json['login'];
    roles = json['roles'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nome'] = nome;
    _data['login'] = login;
    _data['roles'] = roles;
    _data['token'] = token;
    _data['message'] = message;
    return _data;
  }
}
