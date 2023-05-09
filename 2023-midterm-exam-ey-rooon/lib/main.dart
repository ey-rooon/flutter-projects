import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mad2_quiz1_2023/screen/converter_screen.dart';
import 'package:mad2_quiz1_2023/screen/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FireApp());
}

class FireApp extends StatelessWidget {
  const FireApp({super.key});

  @override
  Widget build(BuildContexMaterialApp) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConverterScreen(),
    );
  }
}
