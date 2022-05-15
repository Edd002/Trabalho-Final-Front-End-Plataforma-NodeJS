import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel? model;
  final Function? onDelete;

  const ProductItem({
    Key? key,
    this.model,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: cartItem(context),
      ),
    );
  }

  Widget cartItem(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.775,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Descrição: " + model!.descricao!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7.5,
                  ),
                  Row(children: [
                    Text(
                      "Marca: ${model!.marca}",
                      style: const TextStyle(color: Colors.black),
                    )
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Text(
                      "Valor: R\$${NumberFormat.currency(locale: 'en_US').parse(model!.valor.toString()).toString()}",
                      style: const TextStyle(color: Colors.black),
                    )
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.125,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.edit),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/edit-product',
                        arguments: {
                          'model': model,
                        },
                      );
                    },
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      onDelete!(model);
                    },
                  ),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
