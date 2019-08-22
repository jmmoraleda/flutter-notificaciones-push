import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io';
import 'dart:async';

//  Clase para manejar todas las notificaciones
class PushNotificationProvider {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;


  initNotifications() {

    _firebaseMessaging.requestNotificationPermissions(); // Pedimos permiso al usuario para usar notificaciones


    _firebaseMessaging.getToken().then( (token) { //  Obtenemos el token del dispositivo


      print('===== FCM Token =====');
      print( token );

    });


    _firebaseMessaging.configure(

      onMessage: ( info ) { //  Se dispara cuando nuestra aplicación está abierta

        print('======= On Message ========');
        print( info );

        String argumento = 'no-data';
        if ( Platform.isAndroid  ) {  
          argumento = info['data']['comida'] ?? 'no-data';
        } else {
          argumento = info['comida'] ?? 'no-data-ios';
        }

        _mensajesStreamController.sink.add(argumento);

      },
      onLaunch: ( info ) { // Se dispara cuando la aplicación está en segundo plano

        print('======= On Launch ========');
        print( info );

        

      },

      onResume: ( info ) {  // Se dispara cuando la aplicación está cerrada

        print('======= On Resume ========');
        print( info );


        String argumento = 'no-data';

        if ( Platform.isAndroid  ) {  
          argumento = info['data']['comida'] ?? 'no-data';
        } else {
          argumento = info['comida'] ?? 'no-data-ios';
        }
        
        _mensajesStreamController.sink.add(argumento);

      }


    );


  }


  dispose() {
    _mensajesStreamController?.close();
  }

}

