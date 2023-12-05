import 'package:flutter/material.dart';
import 'package:iot/home.dart';
import 'package:iot/provider/products.dart';
import 'package:provider/provider.dart';

import 'provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (create) => Providers(),
        ),
        ChangeNotifierProvider(
          create: (create) => Products(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
