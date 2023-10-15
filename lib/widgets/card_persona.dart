import 'package:flutter/material.dart';

class CardPersona extends StatelessWidget {
  final String imageUrl;
  final String? name;
  final String? description;
  final String? edad;
  final String? sexo;
  final Widget? buttonEdit;
  final Widget? buttoDelete;

  const CardPersona(
      {required this.imageUrl,
      super.key,
      this.name = '',
      this.description = '',
      this.edad = '',
      this.sexo = '',
      this.buttonEdit,
      this.buttoDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: Column(
        children: [
          Stack(
            children: [
              FadeInImage(
                image: NetworkImage(imageUrl),
                placeholder: const AssetImage('assets/jar-loading.gif'),
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
              Positioned(
                top: 10,
                right: 1,
                child: buttoDelete ?? Container(),
              ),
              Positioned(
                top: 10,
                right: 40,
                child: buttonEdit ?? Container(),

              ),
            ],
          ),
          if (name != null)
            Container(
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text('Nombre: $name')),
          Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text('Edad: $edad')),
          Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text('Sexo: $sexo')),
          if (description != null)
            Container(
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(description ?? 'no description')),
        ],
      ),
    );
  }
}
