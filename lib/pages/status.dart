import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('Server Status:p ${socketService.serverStatus}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit('nuevo-mensaje', 'Hola desde Flutter');
        },
        elevation: 5,
        child: const Icon(Icons.add),

      ),
    );
  }
}
