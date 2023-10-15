import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/models/persona_desaparecida.dart';
import 'package:sw2_parcial1_movil/screens/personas_desaparecidas/create_desaparecido_screen.dart';
import 'package:sw2_parcial1_movil/services/persona_desaparecida_service.dart';
import 'package:sw2_parcial1_movil/utils/show_alert.dart';
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class MiDesaparecidoScreen extends StatelessWidget {
  const MiDesaparecidoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final personasDesaparecidasService =
        Provider.of<PersonaDesaparecidaService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Center(
            child: Text('Mis Personas Desaparecidas'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_to_photos),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDesaparecidoScreen(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FutureBuilder(
          future: personasDesaparecidasService.getMispersonasDesaparecidas(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  PersonaDesaparecida personaDesaparecida = snapshot.data[index];
                  return Column(children: [
                    CardPersona(
                      imageUrl: personaDesaparecida.fotos[0]['url'],
                      name: personaDesaparecida.nombre,
                      edad: personaDesaparecida.edad,
                      sexo: personaDesaparecida.sexo,
                      description: personaDesaparecida.descripcion,
                      buttoDelete: _buildDeleteButton(context, personaDesaparecida, personasDesaparecidasService),
                      buttonEdit: _buildEditButton(),
                    ),
                  ]);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
} 

Widget _buildDeleteButton(BuildContext context, PersonaDesaparecida personaDesaparecida, PersonaDesaparecidaService personasDesaparecidasService) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
      ),
      onPressed: () async {
        if (await showAlertDelete(context)) {
          personasDesaparecidasService.deletePersonaDesaparecida(personaDesaparecida.id.toString());
          personasDesaparecidasService.notifyListeners();
        }
      },
      child: const Icon(
        Icons.delete_forever_outlined,
        color: Colors.black,
        size: 40,
      ),
    );
}

  Widget _buildEditButton() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
      ),
      onPressed: () {},
      child: const Icon(
        Icons.edit_outlined,
        color: Colors.black,
        size: 40,
      ),
    );
  }
