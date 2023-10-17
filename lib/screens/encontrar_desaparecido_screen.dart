import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/models/persona_desaparecida.dart';
import 'package:sw2_parcial1_movil/services/services.dart';
import 'package:sw2_parcial1_movil/utils/utils.dart';
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class EncontrarDesaparecidoScreen extends StatefulWidget {
  const EncontrarDesaparecidoScreen({Key? key}) : super(key: key);

  @override
  State<EncontrarDesaparecidoScreen> createState() =>
      _EncontrarDesaparecidoScreenState();
}

class _EncontrarDesaparecidoScreenState
    extends State<EncontrarDesaparecidoScreen> {
  
  File? foto;
  PersonaDesaparecida? personaDesaparecida;
  final _scrollController = ScrollController();
 

  @override
  Widget build(BuildContext context) {
    ReconocimientoService reeconocimientoService =
        Provider.of<ReconocimientoService>(context);

    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        title: const Center(
          child: Text('Encontrar Desaparecido'),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              'Foto A Buscar',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                elevation: 10,
                shadowColor: Colors.grey,
                child: Column(
                  children: [
                    foto != null
                        ? Container(
                            alignment: Alignment.center,
                            child: Image.file(
                              foto!,
                              width: double.infinity,
                              height: 230,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Agrega una Foto para buscar',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blueAccent)),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
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
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () async{
                            try {
                              foto = await pickImageFromCamera();
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
                          child: const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade800,
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        icon: reeconocimientoService.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.search,
                              ),
                        label: Text(
                          reeconocimientoService.isLoading
                              ? 'Buscando...'
                              : 'Buscar',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: (reeconocimientoService.isLoading || foto == null)
                            ? null
                            : () async {
                                personaDesaparecida = null;
                                personaDesaparecida =
                                    await reeconocimientoService
                                        .reconocerPersona(imageFile: foto!);

                                if (personaDesaparecida != null) {
                                  //esperar 1 segundos antes de hacer scroll
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );

                                  if (mounted) {
                                    showBottomAlert(
                                        context: context,
                                        message: 'Persona Encontrada!',
                                        color: Colors.green.shade600);
                                  }
                                } else {
                                  if (mounted) {
                                    showBottomAlert(
                                      context: context,
                                      message: 'Persona no encontrada',
                                    );
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (personaDesaparecida != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'Persona Encontrada!',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 30,
                      ),
                    ),
                    CardPersona(
                      imageUrl: personaDesaparecida!.fotos[0]['url'],
                      name: personaDesaparecida!.nombre,
                      edad: personaDesaparecida!.edad,
                      sexo: personaDesaparecida!.sexo,
                      description: personaDesaparecida!.descripcion,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade800,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      icon: const Icon(
                        Icons.notification_important,
                      ),
                      label: const Text(
                        'Notificar a la familia',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        socket.emit('notificar-desaparecido', personaDesaparecida!);
                      },
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
