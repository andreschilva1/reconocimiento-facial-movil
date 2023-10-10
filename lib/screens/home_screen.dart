import 'package:flutter/material.dart';
import 'package:sw2_parcial1_movil/services/image_picker_service.dart' as ImagePickerService;
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: 
      ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const CustomCard(imageUrl: 'https://aws-sw1.s3.amazonaws.com/retrato-de-joven-sonriente-a-hombre-guapo-en-camiseta-polo-azul-aislado-sobre-fondo-gris-de.jpg', name: 'se perdio mi primo',),
          const SizedBox(height: 20),
          FloatingActionButton(
            child: const Icon(Icons.image),
            onPressed: () async => await ImagePickerService.pickImageFromGallery(),  
          ),
          
        ],
      ),
      
    );
  }
}