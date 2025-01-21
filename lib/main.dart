import 'package:flutter/material.dart';
import 'package:gestor_de_gastos/screens/home_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gastos App",
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Colors.deepPurpleAccent)
      ),
        home: const HomeScreen(),
    );
  }
}
