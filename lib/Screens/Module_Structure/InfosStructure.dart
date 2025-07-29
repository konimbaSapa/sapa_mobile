import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:koon/Screens/Components/maNavDrawer.dart';
import 'package:koon/Screens/Components/monAppBar.dart';
//import 'package:koon/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:koon/Screens/Module_Structure/structureTable.dart';

class InfosStructure extends StatefulWidget {
  InfosStructure({Key? key}) : super(key: key);

  @override
  _InfosStructureState createState() => _InfosStructureState();
}

class _InfosStructureState extends State<InfosStructure> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegExp _prenomNomRegex = RegExp(
    r"(?:^[A-Z]([a-z]+)$|^(^[A-Z][a-z]+)\-([A-Z]([a-z]+)$)$)",
  );
  final RegExp _adresseRegex = RegExp(r"^[0-9]{1,5}(?: [a-zA-ZÀ-ÿ'\-\.]+)+$");
  final RegExp _codePostalRegex = RegExp(
    r"^(0[1-9]|[1-8][0-9]|9[0-8])[0-9]{3}$",
  );
  //final RegExp _emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  final bool _infoStruct = true;
  final List<String> Territoires = [
    '16 Charente',
    '17 Charente-Maritime',
    '19 Corrèze',
    '23 Creuse',
    '24 Dordogne',
    '33 Gironde',
    '40 Landes',
    '44 Loire-Atlantique',
    '47 Lot-et-Garrone',
    '49 Maine-et-Loire',
    '53 Mayenne',
    '64 Pyrénées Atlantiques',
    '72 Sharte',
    '79 Deux-Sèvres',
    '85 Vendée',
    '86 Vienne',
    '87 Haute-Vienne',
    'Nouvelle-Aquitaine',
    'Pays de la Loire',
  ];

  String? _selectedTerritoire;

  //Type structure
  final List<String> Type_structure = [
    'Centre Evaluateur',
    'Centre PEPS',
    'Maison Sport Sante',
    'Partenaire',
    'Structure Sportive',
  ];

  String? _selectedType;
  String _nom_structure = '';
  String? _code_ONAPS;
  String _adresse = '';
  String? _complement_adresse;
  String _code_postal = '';
  String _ville = '';
  String? _nom_representant;
  String? _prenom_representant;
  String? _tel1;
  String? _tel2;
  String? _mail;

  //statut juridique
  final List<String> statut_juridique = [
    'Association',
    'Collectivité territoriale',
    'Entreprise individuelle (EI)',
    'Entreprise unipersonnelle à responsabilité limitée (EURL)',
    'Exploitation agricole à responsabilité limitée (EARL)',
    'Fondation',
    'Mutuelle',
    'Societé à responsabilité limitée (SARL)',
    'Societé anonyme (SA)',
    'Societé civile de moyens (SCM)',
    'Societé civile immobilière (SCI)',
    'Societé civile professionnelle (SCP)',
    'Societé civile coopérative de production (SCOP)',
    "Societé civile d'intérêt collectif (SCIC)",
    'Societé par actions simplifiée (SAS)',
    'Societé par actions simplifiée unipersonnelle (SASU)',
  ];

  String? _selectedStatut;
  String? _antenne;
  String? _intervenant;
  String? _lien;

  void addStruct() async {
    print('Formulaire soumis');
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Envoie en cours")));
      //Donnees a envoyer
      Map<String, dynamic> dataToSend = {
        'nom_structure': _nom_structure,
        'territoire': _selectedTerritoire,
        'adresse': _adresse,
        'code_postal': _code_postal,
        'code_ONAPS': _code_ONAPS,
        'type_structure': _selectedType,
        'complement_adresse': _complement_adresse,
        'ville': _ville,
        'nom_representant': _nom_representant,
        'prenom_representant': _prenom_representant,
        'mail_representant': _mail,
        'tel1': _tel1,
        'tel2': _tel2,
        'statut_juridique': _selectedStatut,
        'antenne': _antenne,
        'intervenant': _intervenant,
        'lien': _lien,
      };

      //Envoie HTTP POST
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/SAPA_Mobile/structure/insert'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode == 201) {
          print('Structure créée avec succès');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Structure ajoutée avec succès")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StructureTable()),
          );
        } else {
          print('Erreur lors de la creation ${response.body}');
        }
      } catch (e) {
        print('Flutter Exception $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erreur de connexion ")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MonAppBar(myTitle: 'Formulaire'),
        drawer: const MyNavDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            top: 15.0,
            bottom: 15.0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // étire sur tt l'écran
            children: [
              //////////////////////////////////////////////////////////////////
              // Titre /////////////////////////////////////////////////////////
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Informations de la structure".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20.0,
                        ),
                      ),
                    ),

                    const Divider(
                      color: Colors.teal,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 50,
                    ),

                    const SizedBox(height: 15.0),
                  ],
                ),
              ),

              //////Scroll view
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ////formulaire
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'COORDONNEES',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            //Nom structure///////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Nom structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _nom_structure = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty
                                                /*||
                                                    _prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                    */
                                                ? "Entre un nom de structure valide"
                                                : null,
                                    initialValue:
                                        _infoStruct ? _nom_structure : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom structure",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),
                            /////////////////////////Code ONAPS
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Code ONAPS',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _code_ONAPS = value),
                                    initialValue:
                                        _infoStruct ? _code_ONAPS : null,
                                    decoration: InputDecoration(
                                      //hintText: "Code ONAPS",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.0),
                            //Territoire
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Territoire*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  DropdownButtonFormField(
                                    value: _selectedTerritoire,
                                    items:
                                        Territoires.map((String territoire) {
                                          return DropdownMenuItem<String>(
                                            value: territoire,
                                            child: Text(territoire),
                                          );
                                        }).toList(),
                                    onChanged: (String? nouvelleValeur) {
                                      setState(() {
                                        _selectedTerritoire = nouvelleValeur;
                                      });
                                    },
                                    validator:
                                        (value) =>
                                            value == null
                                                ? 'Veuillez choisir une territoire'
                                                : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30.0),

                            //////////Type de structure//////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Type de structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  DropdownButtonFormField(
                                    value: _selectedType,
                                    items:
                                        Type_structure.map((
                                          String tpStructure,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: tpStructure,
                                            child: Text(tpStructure),
                                          );
                                        }).toList(),

                                    onChanged: (String? newVal) {
                                      setState(() {
                                        _selectedType = newVal;
                                      });
                                    },
                                    validator:
                                        (value) =>
                                            value == null
                                                ? "Veuillez choisir un type de structure"
                                                : null,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////// Adresse Structure
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Adresse Structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _adresse = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty
                                                ? "Veuillez entrer un adresse valable"
                                                : null,
                                    initialValue: _infoStruct ? _adresse : null,
                                    decoration: InputDecoration(
                                      //hintText: "Adresse",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30.0),

                            const SizedBox(height: 30.0),
                            ///////Complément adresse de strcucture ////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Complément adresse de structure',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _complement_adresse = value,
                                        ),

                                    initialValue:
                                        _infoStruct
                                            ? _complement_adresse
                                            : null,
                                    decoration: InputDecoration(
                                      //hintText:"Complement adresse de structure",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30.0),

                            ///////code postal ////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Code postal*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _code_postal = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_codePostalRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un code postal valide"
                                                : null,
                                    initialValue:
                                        _infoStruct ? _code_postal : null,
                                    decoration: InputDecoration(
                                      //hintText: "code postal",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            ///////ville////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Ville*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _ville = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty
                                                //||!_villeRegex.hasMatch(value)
                                                ? "Entrez une ville valide"
                                                : null,
                                    initialValue: _infoStruct ? _ville : null,
                                    decoration: InputDecoration(
                                      //hintText: "Ville",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30.0),

                            Text(
                              'Représentant légal'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 30.0),

                            ///////////NOM REPRESENTANT////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Nom', style: TextStyle(fontSize: 18.0)),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _nom_representant = value,
                                        ),
                                    initialValue:
                                        _infoStruct ? _nom_representant : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom representant",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30.0),

                            //////////////PRENOM REPRESENTANT//////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Prenom',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _prenom_representant = value,
                                        ),
                                    initialValue:
                                        _infoStruct
                                            ? _prenom_representant
                                            : null,
                                    decoration: InputDecoration(
                                      //hintText: "Prenom representant",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            ////////////////////TELEPHONE1//////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Telephone 1',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _tel1 = value),
                                    initialValue: _infoStruct ? _tel1 : null,
                                    decoration: InputDecoration(
                                      //hintText: "telephone1 representant",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      suffixIcon: const InkWell(
                                        child: Icon(Icons.phone),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            ///////////////////TELEPHONE2//////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Telephone 2',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _tel2 = value),
                                    initialValue: _infoStruct ? _tel2 : null,
                                    decoration: InputDecoration(
                                      //hintText: "Telephone 2 representant",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      suffixIcon: const InkWell(
                                        child: Icon(Icons.phone),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////MAIL/////////////////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Mail',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _mail = value),
                                    initialValue: _infoStruct ? _mail : null,
                                    decoration: InputDecoration(
                                      //hintText: "Email representant",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      suffixIcon: const InkWell(
                                        child: Icon(Icons.email),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),
                            Text(
                              'Informations complementaires'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),

                            /////////////////STATUT JURIDIQUE////////////////////////////////////////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Statut juridique*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: DropdownButtonFormField(
                                      isExpanded:
                                          true, //Gestion des textes longs
                                      value: _selectedStatut,
                                      items:
                                          statut_juridique.map((String statut) {
                                            return DropdownMenuItem<String>(
                                              value: statut,
                                              child: Text(
                                                statut,
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis, //Eviter le dépassement
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),

                                      onChanged: (String? nwVal) {
                                        setState(() {
                                          _selectedStatut = nwVal;
                                        });
                                      },
                                      validator:
                                          (value) =>
                                              value == null
                                                  ? "Veuillez choisir un statut juridique"
                                                  : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////////////ANTENNE//////////////////////////////////////
                            Text(
                              'ANTENNE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Ajouter une antenne',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _antenne = value),
                                    initialValue: _infoStruct ? _antenne : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom de l'antenne",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////////////INTERVENANT DE LA STRUCTURE//////////////////////////////
                            Text(
                              'INTERVENANT DE LA STRUCTURE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Ajouter un intervenant',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _intervenant = value,
                                        ),
                                    initialValue:
                                        _infoStruct ? _intervenant : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom de l'antenne",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            ////////////////////////////LIEN DE REFERENCEMENT//////////////////////
                            Text(
                              'LIEN DE REFERENCEMENT',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Ajouter un lien',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _lien = value),
                                    initialValue: _infoStruct ? _lien : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom de l'antenne",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            /////////////BOUTON SOUMETTRE/////////////////////////////////////////////////////
                            Row(
                              children: [
                                //mainAxisAlignment: MainAxisAlignment.center
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.white,
                                    elevation: 10.0,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15.0,
                                    ),
                                  ),
                                  child: Text('Annuler'),
                                ),

                                const SizedBox(width: 150.0),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 10.0,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 15.0,
                                    ),
                                  ),
                                  onPressed: addStruct,
                                  child: Text(
                                    'Soumettre'.toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
