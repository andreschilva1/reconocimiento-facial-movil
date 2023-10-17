import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/models/user.dart';
import 'package:sw2_parcial1_movil/screens/screens.dart';
import 'package:sw2_parcial1_movil/services/services.dart';
import 'package:sw2_parcial1_movil/utils/show_alert.dart';


class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
    cargarId();
    // Initialize socket.io
    socket.connect();
    // convertir String a int    
    // Listen to push_notification event
    socket.on('notificar', (data)  {
      if (data!= null) {  
        print(data);
          showNotification(data.toString(),flutterLocalNotificationsPlugin);
      }
      
    });
  }

  Future<void> cargarId() async {
    AuthService authService = AuthService();  
    User? user = await authService.readUser();
     socket.emit('autenticar',user);  
  }

  

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.checkAuth(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                Future.microtask(() async {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  }
                });
                return Container();
              } else {
                return  LoginScreen();
              }
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
