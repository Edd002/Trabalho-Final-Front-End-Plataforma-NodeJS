List<ProductModel> productsFromJson(dynamic str) =>
    List<ProductModel>.from((str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  late int? id;
  late String? descricao;
  late String? valor;
  late String? marca;

  ProductModel({this.id, this.descricao, this.valor, this.marca});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = json['valor'];
    marca = json['marca'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['descricao'] = descricao;
    _data['valor'] = valor;
    _data['marca'] = marca;
    return _data;
  }
}
