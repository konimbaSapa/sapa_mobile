import 'package:flutter/material.dart';
import 'dart:async';
import 'userService.dart';
import 'userModel.dart';
import 'package:koon/Screens/Components/maNavDrawer.dart';
import 'package:koon/Screens/Components/monAppBar.dart';
import 'package:koon/Old/Module_Profil/profil/screens/formulaires/InfoPersoForm.dart';

class UsersTable extends StatefulWidget {
  @override
  _UsersTableState createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  late Future<List<userModel>> futureUsers;
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    //futureUsers = userService.fetchUsers();

    //VERIFICATION
    futureUsers = userService.fetchUserDetails().then((value) {
      setState(() {
        futureUsers = Future.value(value);
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final int startIndex = _currentPage * _itemsPerPage;
    //final int endIndex = (_currentPage + 1) * _itemsPerPage;

    return Scaffold(
      appBar: MonAppBar(myTitle: 'Liste des utilisateurs'),
      drawer: const MyNavDrawer(),

      body: FutureBuilder<List<userModel>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé.'));
          }

          final users = snapshot.data!;

          return Column(
            children: [
              //SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(''),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoPersoForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 10.0,
                ),
                child: Text('Ajouter un utilisateur'),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('NOM')),
                    DataColumn(label: Text('PRENOM')),

                    //VERIFICATION
                    DataColumn(label: Text('Territoire')),
                    DataColumn(label: Text('id territoire')),
                    //DataColumn(label: Text('Fonction')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Telephone P')),
                    DataColumn(label: Text('Telephone F')),
                    DataColumn(label: Text('Nom structure')),
                    //DataColumn(label: Text('Type structure')),
                    DataColumn(label: Text('id structure')),
                    //DataColumn(label: Text('Details')),
                  ],

                  rows:
                      users
                          .skip(_currentPage * _itemsPerPage)
                          .take(_itemsPerPage)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final isEven = index % 2 == 0;

                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>((
                                Set<MaterialState> states,
                              ) {
                                return isEven ? Colors.grey[200] : Colors.white;
                              }),
                              cells: [
                                DataCell(Text(item.nom_user)),
                                DataCell(Text(item.prenom_user)),
                                DataCell(Text(item.nom_territoire)),
                                DataCell(Text(item.id_territoire.toString())),
                                DataCell(Text(item.mail_user)),
                                DataCell(Text(item.tel_user)),
                                DataCell(Text(item.tel_f_user)),
                                DataCell(Text(item.nom_structure)),
                                DataCell(Text(item.id_structure.toString())),
                              ],
                            );
                          })
                          .toList(),

                  /*
                  rows: List.generate(users.length, (index) {
                    final item = users[index];
                    final isEven = index % 2 == 0;

                    users
                        .skip(_currentPage * _itemsPerPage)
                        .take(_itemsPerPage)
                        .map((user) {
                          String Nom = '', Prenom = '';

                          //VERIFICATION
                          String territoire = '',
                                  //role = '',
                                  //fonction =  '',
                                  //type_structure = '',
                                  nom_structure =
                                  '',
                              mail_user = '',
                              tel_f_user = '',
                              tel_user = '';
                          int id_territoire, id_structure;

                          Nom = user.nom_user;
                          Prenom = user.prenom_user;
                          territoire = user.nom_territoire;
                          id_territoire = user.id_territoire;
                          nom_structure = user.nom_structure;
                          id_structure = user.id_structure;
                          tel_user = user.tel_user;
                          tel_f_user = user.tel_f_user;
                          mail_user = user.mail_user;
                          //fonction = user.fonction;
                          //type_structure = user.type_structure;

                          //DISSOCIER LE MAIL POUR AVOIR LE NOM ET LE PRENOM
                          /*
                            final id = user.identifiant.split('@');
                            if (id.isNotEmpty) {
                              final NameId = id[0].split('.');
                              if (NameId.length == 2) {
                                Nom = NameId[0];
                                Prenom = NameId[1];
                              } else {
                                Nom = id[0].toUpperCase();
                                Prenom = id[0].toLowerCase();
                              }
                            }
                            */

                          return DataRow(

                            color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return isEven ? Colors.grey[200] : Colors.white;
                          },
                        ),

                            cells: [
                              DataCell(Text(item.nom_user)),
                              DataCell(Text(item.prenom_user)),
                              DataCell(Text(item.nom_territoire)),
                              DataCell(Text(item.id_territoire.toString())),
                              //DataCell(Text(fonction)),
                              DataCell(Text(item.mail_user)),
                              DataCell(Text(item.tel_user)),
                              DataCell(Text(item.tel_f_user)),
                              DataCell(Text(item.nom_structure)),
                              //DataCell(Text(type_structure)),
                              DataCell(Text(item.id_structure.toString())),
                            ],
                          );
                        })
                        .toList();
                  }),

*/
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        _currentPage > 0
                            ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 10.0,
                    ),
                    child: Text('Précédent'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed:
                        (_currentPage + 1) * _itemsPerPage < users.length
                            ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 10.0,
                    ),
                    child: Text('Suivant'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
