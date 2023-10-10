import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


//esto es de prueba no me cuestionen XD

final picker = ImagePicker();

// Función para seleccionar una imagen desde la galería
Future<void> pickImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // Subir la imagen al endpoint
    await uploadImageToServer(File(pickedFile.path));
  } else {
    print('No se seleccionó ninguna imagen.');
  }
}

Future<void> uploadImageToServer(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://10.0.2.2:3000/api/subir-imagen'), // Cambia a tu URL
  );
  request.files.add(await http.MultipartFile.fromPath('imagen', imageFile.path));
  //agregar en el body el nombre y edad sexo
  request.fields['nombre'] = 'Juan';
  request.fields['descripcion'] = 'es mi primo perdido';
  request.fields['edad'] = '20';
  request.fields['sexo'] = 'M'; 

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print('Error al subir la imagen. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
  }
}