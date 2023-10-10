import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final String imageUrl ;
  final String? name; 

  const CustomCard({required this.imageUrl ,super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
        ),
      elevation: 10,
      child: Column(
        children:   [
          FadeInImage(
            image: NetworkImage(imageUrl),
            placeholder: const AssetImage('assets/jar-loading.gif'),
            width: double.infinity,
            height: 230,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
          
          if(name != null)
          Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.only(right: 20,top: 10,bottom: 10),
            child: Text(name?? 'no title')
            )
        ],
      ),
    );
  }
}