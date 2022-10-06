import 'package:f_chat_template/framework/ui/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

// una interfaz muy sencilla en la que podemos crear los tres usuarios (signup)
// y después logearse (login) con cualquiera de las tres

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({Key? key}) : super(key: key);
  final AuthenticationController authenticationController = Get.find();
  final UserController userController = Get.find();

  void signUp() async {
    // aquí creamos los tres usuarios
    await authenticationController.signup('a@a.com', '123456');
    await authenticationController.signup('b@b.com', '123456');
    await authenticationController.signup('c@c.com', '123456');

    //userController.start();
  }

  void login(String user) {
    // método usado para login
    authenticationController.login(user, '123456');
  }

  Widget _loadUsers() {
    return GridView.builder(
        //itemCount: userController.allUsers.length,
        itemCount: userController.allUsers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.9,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0),
        itemBuilder: (_, index) {
          final user = userController.allUsers[index];

          return GestureDetector(
            onTap: () => login(user.email),
            child: Card(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ingresar como"),
                    Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //userController.start();

    return Scaffold(
      appBar: AppBar(title: const Text("Chat App"), elevation: 0),
      body: SafeArea(

        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: signUp,
                        child: const Text("Crear los tres usuarios"),
                      )
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Listado de usuarios", style: TextStyle(fontSize: 16)),
                ),
                Flexible(flex: 1, child: _loadUsers()),
                /*Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () => login('a@a.com'),
                                child: const Text("Ingresar con usuario A")),
                            ElevatedButton(
                                onPressed: () => login('b@b.com'),
                                child: const Text("Ingresar con usuario B")),
                            ElevatedButton(
                                onPressed: () => login('c@c.com'),
                                child: const Text("Ingresar con usuario C")),
                          ]),
                    ),
                  ),
                )*/
              ]),
        ),
      ),
    );
  }
}
