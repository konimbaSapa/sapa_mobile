import 'package:flutter/material.dart';
import 'package:koon/Utils/sessionManager.dart';
//import 'package:koon/Screens/Components/maNavDrawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String prenom = SessionManager.username;

    return Scaffold(
      appBar: AppBar(title: Text('Accueil'), backgroundColor: Colors.blue),
      //drawer: const MyNavDrawer(),
      body: Center(
        child: Text(
          'Bienvenue $prenom !',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
