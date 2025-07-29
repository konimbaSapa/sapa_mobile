import 'InfosStructure.dart';
import 'structureService.dart';
import 'structureModel.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:koon/Screens/Components/maNavDrawer.dart';
import 'package:koon/Screens/Components/monAppBar.dart';

class StructureTable extends StatefulWidget {
  @override
  _StructureTableState createState() => _StructureTableState();
}

class _StructureTableState extends State<StructureTable> {
  late Future<List<structureModel>> FuturStructures;
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    FuturStructures = structureService.fetchStructure().then((value) {
      setState(() {
        FuturStructures = Future.value(value);
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MonAppBar(myTitle: 'Liste des structures'),
      drawer: MyNavDrawer(),
      body: FutureBuilder<List<structureModel>>(
        future: FuturStructures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune structure trouvee'));
          }

          final structure = snapshot.data!;
          return Column(
            children: [
              //SizedBox(height: 10.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(''),
                icon: Icon(Icons.arrow_back),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfosStructure()),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 10.0,
                ),
                child: Text('Ajouter une structure'),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nom Structure')),
                    DataColumn(label: Text('Type Structure')),
                    DataColumn(label: Text('Adresse')),
                    DataColumn(label: Text('Territoire')),
                  ],

                  rows:
                      structure
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
                                return isEven ? Colors.grey : Colors.white;
                              }),
                              cells: [
                                DataCell(Text(item.nom_structure)),
                                DataCell(Text(item.nom_statut_structure)),
                                DataCell(Text(item.nom_adresse)),
                                DataCell(Text(item.nom_territoire)),
                              ],
                            );
                          })
                          .toList(),
                ),
              ),

              SizedBox(height: 10.0),

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
                    child: Text('Precedent'),
                  ),

                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed:
                        (_currentPage + 1) * _itemsPerPage < structure.length
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
