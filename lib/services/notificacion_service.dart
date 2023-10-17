import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:sw2_parcial1_movil/models/models.dart';
import 'package:sw2_parcial1_movil/services/api_service.dart';
import 'package:sw2_parcial1_movil/services/services.dart';


AuthService authService = AuthService();

final socket = socket_io.io(baseUrl, <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false,
});

conectarseAlSocket() async {
  try {
    User user = await authService.readUser();
    
    socket.connect();
    //emitiendo un evento
    socket.emit('autenticar', user.id);
  } catch (e) {
    print(e);
  }
  
}
