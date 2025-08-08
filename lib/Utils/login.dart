// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:koon/Screens/Module_Accueil_Intervenant/myHome.dart';
//import 'package:koon/Screens/Module_Accueil/myHome.dart';
import 'package:koon/Utils/sessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Login {
  //static String hostAdress = '127.0.0.1:43703';

  //static String hostAdress = '10.0.2.2:8000';
  static String hostAdress = '5.196.225.227';

  static loginUser(
    BuildContext context,
    String username,
    String password,
  ) async {
    print('[LOGIN] Début de loginUser');

    var url = Uri.parse('http://$hostAdress/SAPA-Mobile/login');
    print('[LOGIN] URL construite : $url');

    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> jsonBody = {"username": username, "password": password};
    String requestBody = json.encode(jsonBody);

    print('[LOGIN] Corps de la requête : $requestBody');

    try {
      print('[LOGIN] Envoi de la requête POST...');
      var response = await http.post(url, headers: headers, body: requestBody);
      print('[LOGIN] Réponse reçue. Code : ${response.statusCode}');

      final jsonResponse = json.decode(response.body);
      print('[LOGIN] Réponse décodée : $jsonResponse');

      if (response.statusCode == 200) {
        print('[LOGIN] Connexion réussie. Mise à jour de la session...');

        SessionManager.username = jsonResponse['identifiant'];
        SessionManager.password = password;
        SessionManager.isConnected = true;
        SessionManager.id_user = jsonResponse['id_user'];
        SessionManager.roles = jsonResponse['roles'];
        SessionManager.est_coordinateur_peps =
            jsonResponse['est_coordinateur_peps'];
        SessionManager.compteur = jsonResponse['compteur'];

        if (jsonResponse.containsKey('fonction') &&
            jsonResponse['fonction'] != null) {
          SessionManager.fonction = jsonResponse['fonction'];
          print('[LOGIN] Fonction : ${SessionManager.fonction}');
        }

        //Navigation en fonction du role de l'utilisateur
        /*print("Navigation en fonctionn des roles");
        if (SessionManager.roles.contains("super admin")) {
          print("L'intervenant est un super admin");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else if (SessionManager.roles.contains("Intervenant sportif")) {
          print("L'utilisateur est un intervenant");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePageIntervenant(),
            ),
          );
        }
        */

        /*for (var role in SessionManager.roles) {
          if (role == 'super admin') {
            print("L'intervenant est un super admin");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
            return;
          } else if (role == 'Intervenant sportif') {
            print("L'utilisateur est un intervenant");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePageIntervenant(),
              ),
            );
            return;
          }
        }
        */

        print('[LOGIN] Navigation vers MyHomePage');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePageIntervenant(),
          ),
        );
      } else {
        print('[LOGIN] Erreur côté serveur : ${jsonResponse['status']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${jsonResponse['status']}'),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } catch (e) {
      print('[LOGIN] Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la connexion. $e'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }
}
