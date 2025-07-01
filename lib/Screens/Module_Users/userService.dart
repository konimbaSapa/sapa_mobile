import 'package:http/http.dart' as http;
import 'userModel.dart';
import 'dart:convert';

class userService {
  static String hostAdress = '10.0.2.2:8000';

  static Future<List<userModel>> fetchUsers() async {
    var url = Uri.parse('http://$hostAdress/SAPA-Mobile/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => userModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des utilisateurs');
    }
  }

  //VERIFICATION
  static Future<List<userModel>> fetchUserDetails() async {
    var url = Uri.parse('http://$hostAdress/SAPA-Mobile/users/select');

    try {
      var response = await http.get(url);

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((json) => userModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur de chargement des utilisateurs (code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des utilisateurs : $e');
    }
  }

  /// Nouvelle méthode pour créer un utilisateur
  static Future<bool> createUser(userModel user) async {
    var url = Uri.parse(
      'http://$hostAdress/SAPA-Mobile/users',
    ); // à adapter si besoin
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Utilisateur créé avec succès');
      return true;
    } else {
      print('Erreur lors de la création : ${response.statusCode}');
      print(response.body);
      return false;
    }
  }
}
