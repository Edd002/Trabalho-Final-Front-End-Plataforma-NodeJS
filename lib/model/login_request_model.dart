class LoginRequestModel {
  LoginRequestModel({
    this.login,
    this.senha,
  });
  late final String? login;
  late final String? senha;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['login'] = login;
    _data['senha'] = senha;
    return _data;
  }
}
