class RegisterRequestModel {
  RegisterRequestModel({
    this.nome,
    this.login,
    this.senha,
    this.email,
  });
  late final String? nome;
  late final String? login;
  late final String? senha;
  late final String? email;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    login = json['login'];
    senha = json['senha'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nome'] = nome;
    _data['login'] = login;
    _data['senha'] = senha;
    _data['email'] = email;
    return _data;
  }
}
