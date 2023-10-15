import 'dart:io';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

Future<File?> pickImageFromGallery() async {
  try {
    
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  } catch (error) {
    print('Error al seleccionar la imagen: $error');
    throw 'error ocurrido en ImagePickerService: $error';
  }
}

