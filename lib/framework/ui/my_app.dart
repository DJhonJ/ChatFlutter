import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/user_controller.dart';
import 'firebase_central.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Get.put(ChatController());
    //Get.put(AuthenticationController());
    //Get.put(UserController());

    Get.lazyPut<AuthenticationController>(() => AuthenticationController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<UserController>(() => UserController());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FirebaseCentral());
  }
}
