import 'package:flutter/material.dart';
import 'package:sw2_parcial1_movil/models/ruta.dart';
import 'package:sw2_parcial1_movil/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'checkAuth';

  static final routes = <Ruta>[
    Ruta(name: 'Home', icon: Icons.home, route: 'home', screen: const HomeScreen()),
    Ruta(name: 'Personas Desaparecidas', icon: Icons.person, route: 'desaparecidos', screen: const HomeScreen()),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'checkAuth': (context) => const CheckAuthScreen()});
    appRoutes.addAll({'login': (context) =>  LoginScreen()});
    for (var element in routes) {
      appRoutes.addAll({element.route: (context) => element.screen});
    }
    return appRoutes;
  }
}
