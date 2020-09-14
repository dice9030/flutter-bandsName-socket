import 'dart:io';

import 'package:app_flutter_avance/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final  socketService = Provider.of<SocketServices>(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Mensaje: ${socketService.serverStatus} '),
          ],
        ),
      ) ,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
          socketService.emit('emitir-mensaje',
          {'nombre':'Diego','mensaje':'mensaje y mensaje'});
        },
      ),
      
    );
  }
}