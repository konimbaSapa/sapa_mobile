import 'package:http/http.dart' as http;
import 'structureModel.dart';
import 'dart:convert';

class structureService {
  //static String hostAdress = '10.0.2.2:8000';
  //static String hostAdress = '127.0.0.1:43703';

  static String hostAdress = '5.196.225.227';

  static Future<List<structureModel>> fetchStructure() async {
    var url = Uri.parse('http://$hostAdress/SAPA_Mobile/structure/select');
    var response = await http.get(url);

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => structureModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des structures');
    }
  }
}
