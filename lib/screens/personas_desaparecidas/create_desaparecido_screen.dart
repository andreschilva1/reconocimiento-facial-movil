import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/services/services.dart';
import 'package:sw2_parcial1_movil/utils/utils.dart';
import 'package:sw2_parcial1_movil/widgets/card_container.dart';

class CreateDesaparecidoScreen extends StatefulWidget {
  const CreateDesaparecidoScreen({Key? key}) : super(key: key);

  @override
  State<CreateDesaparecidoScreen> createState() =>
      _CreateDesaparecidoScreenState();
}

class _CreateDesaparecidoScreenState extends State<CreateDesaparecidoScreen> {
  File? foto;
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController edad = TextEditingController();
  String? sexoValue;

  @override
  Widget build(BuildContext context) {
    PersonaDesaparecidaService personaDesaparecidaService =
        Provider.of<PersonaDesaparecidaService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('Agregar persona desaparecida'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre',
                        labelText: 'Nombre del desaparecido',
                        prefixIcon: Icons.person_4_outlined,
                      ),
                      controller: name,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'descripcion',
                        labelText: 'descripcion del desaparecido',
                        prefixIcon: Icons.description_outlined,
                      ),
                      controller: descripcion,
                      onChanged: (value) => value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la descripcion';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Edad',
                        labelText: 'Edad del desaparecido',
                        prefixIcon: Icons.timer_outlined,
                      ),
                      controller: edad,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la edad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    DropdownButtonFormField<String>(
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'sexo',
                        labelText: 'sexo del desaparecido',
                        prefixIcon: sexoValue == null
                            ? Icons
                                .fiber_manual_record_outlined // Valor por defecto
                            : sexoValue == 'masculino'
                                ? Icons.male
                                : Icons.female,
                      ),
                      value: sexoValue,
                      onChanged: (value) {
                        setState(() {
                          sexoValue = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el sexo';
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'masculino',
                          child: Text('Masculino'),
                        ),
                        DropdownMenuItem(
                          value: 'femenino',
                          child: Text('Femenino'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (foto != null)
                      Container(
                        alignment: Alignment.center,
                        child: Image.file(
                          foto!,
                        ),
                      ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            try {
                              foto = await pickImageFromGallery();
                              setState(() {});
                            } catch (e) {
                              if (mounted) {
                                showBottomAlert(
                                context: context,
                                message: 'Error al subir la foto',
                              );
                              }
                            }
                          },
                          child: const Icon(Icons.add_a_photo_outlined)),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey,
                          elevation: 0,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          onPressed: personaDesaparecidaService.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    if (foto == null) {
                                      // Si no se ha seleccionado una foto, mostrar un mensaje de error
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Seleccione una foto'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      // Si se ha seleccionado una foto, proceder con la creación
                                      try {
                                        await personaDesaparecidaService
                                            .crearPesonaDesaparecida(
                                                imageFile: foto!,
                                                nombre: name.text,
                                                descripcion: descripcion.text,
                                                edad: edad.text,
                                                sexo: sexoValue!);
                                        //navegar a la pantalla de home
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          displayDialog(
                                              context,
                                              'Error al crear la persona desaparecida',
                                              e.toString(),
                                              Icons.error,
                                              Colors.red);
                                        }
                                      }
                                    }
                                  }
                                },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 15),
                              child: personaDesaparecidaService.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Agregar',
                                      style: TextStyle(color: Colors.white)))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
