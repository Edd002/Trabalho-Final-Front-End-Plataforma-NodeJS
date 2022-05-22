import 'package:flutter/material.dart';
import 'package:flutter_nodejs_crud_app/model/user_model.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class UserItem extends StatelessWidget {
  final UserModel? model;

  const UserItem({
    Key? key,
    this.model,
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
    return Container(
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(7.0),
        color: HexColor("283B71"),
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
                          "Id: " + model!.id.toString(),
                          style: const TextStyle(
                            color: Colors.white,
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
                        "Email: ${model!.email}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(
                        "Login: ${model!.login}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(
                        "Nome: ${model!.nome}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(
                        "Roles: ${model!.roles != null ? (model!.roles! == 'ADMIN' ? 'Administrador' : (model!.roles! == 'USER' ? 'Usuário' : (model!.roles! == 'USER;ADMIN' ? 'Usuário Administrador' : 'Papel não identificado'))) : 'Papel não identificado'}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ],
        ));
  }
}
