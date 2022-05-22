List<UserModel> usersFromJson(dynamic str) =>
    List<UserModel>.from((str).map((x) => UserModel.fromJson(x)));

class UserModel {
  late int? id;
  late String? email;
  late String? login;
  late String? nome;
  late String? roles;

  UserModel({this.id, this.email, this.login, this.nome, this.roles});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    login = json['login'];
    nome = json['nome'];
    roles = json['roles'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['login'] = login;
    _data['nome'] = nome;
    _data['roles'] = roles;
    return _data;
  }
}
