import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:f_chat_template/domain/app_user.dart';
import 'authentication_controller.dart';
import 'user_controller.dart';
import 'package:f_chat_template/domain/message.dart';

// En este controlador manejamos los mensajes entre el usuario logeado y el seleccionado
class ChatController extends GetxController {
  // Lista de los mensajes, está lista es observada por el UI
  var messages = <Message>[].obs;

  // referencia a la base de datos
  final databaseReference = FirebaseDatabase.instance.ref('messages');

  // stream de nuevas entradas
  late StreamSubscription<DatabaseEvent> newEntryStreamSubscription;

  // stream de actualizaciones
  late StreamSubscription<DatabaseEvent> updateEntryStreamSubscription;

  int _autoIdMessage = 0;

  var _currentSnapshotMessage;

  // método en el que nos suscribimos  a los dos streams
  void subscribeToUpdated(uidUser) {
    messages.clear();

    // obtenemos la instancia del AuthenticationController
    AuthenticationController authenticationController = Get.find();
    String chatKey = getChatKey(authenticationController.getUid(), uidUser);

    // OK TODO
    // newEntryStreamSubscription = databaseReference - child msg - child chatKey - listen
    newEntryStreamSubscription = databaseReference.child(chatKey).onValue.listen((event) {
      _onEntryAdded(event);
    });

    // OK TODO
    //  updateEntryStreamSubscription = databaseReference - child msg - child chatKey - listen

    updateEntryStreamSubscription = databaseReference.child(chatKey).onValue.listen((event) {
      _onEntryChanged(event);
    });
  }

  // método en el que cerramos los streams
  void unsubscribe() {
    //OK. TODO
    // cancelar las subscripciones a los streams
    updateEntryStreamSubscription.cancel();
    newEntryStreamSubscription.cancel();
  }

  // este método es llamado cuando se tiene una nueva entrada
  _onEntryAdded(DatabaseEvent event) {
    if (messages.isEmpty) {
      for (var element in event.snapshot.children) {
        messages.add(Message.fromJson2(element.key, element.value as Map<dynamic, dynamic>));
      }
    } else {
      DataSnapshot lastMessage = event.snapshot.children.last;
      if (messages.where((message) => message.key == lastMessage.key).isEmpty) {
        messages.add(Message.fromJson2(lastMessage.key, lastMessage.value as Map<dynamic, dynamic>));
      }
    }
  }

  // este método es llamado cuando hay un cambio es un mensaje
  _onEntryChanged(DatabaseEvent event) {
    var oldEntry = messages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    final json = event.snapshot.value as Map<dynamic, dynamic>;
    messages[messages.indexOf(oldEntry)] = Message.fromJson(event.snapshot, json);
  }

  // este método nos da la llave con la que localizamos la "tabla" de mensajes
  // entre los dos usuarios
  String getChatKey(uidUser1, uidUser2) {
    List<String> uidList = [uidUser1, uidUser2];
    uidList.sort();
    return uidList[0] + "--" + uidList[1];
  }

  // creamos la "tabla" de mensajes entre dos usuarios
  Future<void> createChat(uidUser1, uidUser2, senderUid, msg) async {
    String key = getChatKey(uidUser1, uidUser2);
    try {
      databaseReference
          .child(key)
          //.child(_autoIdMessage.toString())
          .push()
          .set({'senderUid': senderUid, 'msg': msg, 'date': DateTime.now().toString()});

      _autoIdMessage += 1;
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  // Este método es usado para agregar una nueva entrada en la "tabla" entre los
  // dos usuarios
  Future<void> sendChat(remoteUserUid, msg) async {
    AuthenticationController authenticationController = Get.find();
    String key = getChatKey(authenticationController.getUid(), remoteUserUid);
    String senderUid = authenticationController.getUid();

    try {
      // OK TODO
      // databaseReference - child('msg') - child(key) - push() - set({'senderUid': senderUid, 'msg': msg})
      await databaseReference.child(key).push().set({'senderUid': senderUid, 'msg': msg, 'date': DateTime.now().toString()});

      //await databaseReference.child(key).push().child(_autoIdMessage.toString()).set({'senderUid': senderUid, 'msg': msg, 'date': DateTime.now().toString()});
      //await databaseReference.child('msg').child(key).push().set({'senderUid': senderUid, 'msg': msg});
      //_autoIdMessage += 1;
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  // en esté método creamos chats inicialies con los que podemos probar la lectura
  // de mensajes
  void initializeChats() {
    UserController userController = Get.find();
    List<AppUser> users = userController.allUsers;

    createChat(users[0].uid, users[1].uid, users[0].uid, "Hola B, soy A");
    createChat(users[1].uid, users[0].uid, users[1].uid, "Hola A, cómo estás?");

    createChat(users[0].uid, users[2].uid, users[0].uid, "Hola C, soy A");
    createChat(users[0].uid, users[2].uid, users[2].uid, "Hola A, Cómo estás?");

    createChat(users[1].uid, users[2].uid, users[1].uid, "Hola C, soy B");
    createChat(users[2].uid, users[1].uid, users[2].uid, "Todo bien B");
  }
}
