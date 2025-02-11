import 'package:socket_io_client/socket_io_client.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/services/token_service.dart';

class SocketService {
  late Socket _socket;
  bool _isConnected = false;
 
 Future<void> initializeSocket() async{
 final token = await TokenService.instance.getToken();
      _socket = io(
        imageBaseUrl,
        OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setExtraHeaders({'cookie' : token!.accessToken})
        .build()
      );
      _socket.on("connected",(_){
        _isConnected = true;
        print("Connected to webSockets");
      });
      _socket.on("disconnect",(e){
        _isConnected = false;
        print('Conection failed to webSockets : ${e.toString()}');
      });
      
      _socket.connect();
 }

 Socket get socket => _socket;

 void on(String event, Function(dynamic) handler){
  _socket.on(event, handler);
 }

 void emit(String event, dynamic data){
  if (_isConnected) {
    _socket.emit(event, data);
  } else {
    print("Cannot emit, socket disconnected");
  }
 }

 void off(String event){
  _socket.off(event);
 }
}
