import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loggy/loggy.dart';

import 'framework/config/configuration.dart';
import 'framework/ui/my_app.dart';

Future<void> main() async {
  // this is the key
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  // aquí nos conectamos a los servicios de firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: Configuration.apiKey,
        authDomain: Configuration.authDomain,
        databaseURL: Configuration.databaseURL,
        projectId: Configuration.projectId,
        messagingSenderId: Configuration.messagingSenderId,
        appId: Configuration.appId,
  ));

  runApp(const MyApp());
}
