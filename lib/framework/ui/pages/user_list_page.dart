import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:f_chat_template/domain/app_user.dart';
import 'package:f_chat_template/framework/ui/controllers/chat_controller.dart';
import 'package:f_chat_template/framework/ui/controllers/authentication_controller.dart';
import 'package:f_chat_template/framework/ui/controllers/user_controller.dart';
import '../themes/app_theme.dart';
import 'chat_page.dart';

// Widget donde se presentan los usuarios con los que se puede comenzar un chat
class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // obtenemos la instancia de los controladores
  AuthenticationController authenticationController = Get.find();
  ChatController chatController = Get.find();
  UserController userController = Get.find();

  @override
  void initState() {
    // le decimos al userController que se suscriba a los streams
    userController.start();
    super.initState();
  }

  @override
  void dispose() {
    // le decimos al userController que se cierre los streams
    userController.stop();
    super.dispose();
  }

  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  Widget _item(AppUser element) {
    // Widget usado en la lista de los usuarios  mostramos el correo y uid
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
          onTap: () {
            Get.to(() => const ChatPage(), arguments: [
              element.uid,
              element.email,
            ]);
          },
          title: Text(element.email),
          subtitle: Text(element.uid)
      ),
    );
  }

  Widget _list(String currentEmail) {
    // Un widget con La lista de los usuarios con una validación para cuándo la misma este vacia
    // la lista de usuarios la obtenemos del userController
    return GetX<UserController>(builder: (controller) {
      List<AppUser> users = controller.getUsers(currentEmail);

      if (users.isEmpty) {
        return const Center(
          child: Text('No hay usuarios.'),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          var element = users[index];
          return _item(element);
        },
        //separatorBuilder: (context, index) => const Divider(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorGrey,
      appBar: AppBar(
        title: const Text("Chat App"),
        elevation: 0,
        actions: [
          // botón para crear unos chats para arrancar el demo
          IconButton(
              onPressed: () {
                chatController.initializeChats();
              },
              icon: const Icon(Icons.play_circle_outlined)),
          // botón para cerrar la sesión con el usuario
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _logout();
              }),
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 16.0, bottom: 20.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Hola, ${authenticationController.userEmail()}",
                          style: const TextStyle(fontSize: 20)))
              ),
              Flexible(
                flex: 1,
                child: Container(
                    //padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: Colors.white,
                    child: _list(authenticationController.userEmail())
                ),
              )
            ],
          )),
    );
  }
}
