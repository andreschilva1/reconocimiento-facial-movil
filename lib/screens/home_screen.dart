import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/models/persona_desaparecida.dart';
import 'package:sw2_parcial1_movil/screens/personas_desaparecidas/create_desaparecido_screen.dart';
import 'package:sw2_parcial1_movil/services/persona_desaparecida_service.dart';
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final personasDesaparecidasService =
        Provider.of<PersonaDesaparecidaService>(context);

    return Scaffold(
      drawer: const SidebarDrawer(),
      appBar: AppBar(
        title: const Center(
          child: Center(
            child: Text('Personas Desaparecidas'),
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
          future: personasDesaparecidasService.getpersonasDesaparecidas(),
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
