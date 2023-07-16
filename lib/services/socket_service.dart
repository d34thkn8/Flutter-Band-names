import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
enum ServerStatus{
  online,
  offline,
  connecting
}
class SocketService with ChangeNotifier{

 ServerStatus _serverStatus=ServerStatus.connecting;
 ServerStatus get serverStatus=>_serverStatus;
 late IO.Socket _socket;
 IO.Socket get socket => _socket;
 Function get emit=> _socket.emit;
 SocketService(){
   _initConfig();
 }
 void _initConfig(){
   _socket = IO.io('http://192.168.0.124:3001',
       IO.OptionBuilder()
       .setTransports(['websocket'])
       .enableAutoConnect()
       .build()
   );
   _socket.on('connect',(_) {
     _serverStatus=ServerStatus.online;
     print('En linea');
     notifyListeners();
   });

   _socket.on('disconnect',(_) {
     _serverStatus=ServerStatus.offline;
     print('Fuera de linea');
     notifyListeners();
   });

   _socket.on('nuevo-mensaje',(_) {
     print(_);
   });
 }
}