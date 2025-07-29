import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:intl/intl.dart';
//import 'package:koon/Screens/Module_Users/userModel.dart';
import 'package:koon/Screens/Module_Users/userTable.dart';

import 'package:koon/Screens/Components/maNavDrawer.dart';
import 'package:koon/Screens/Components/monAppBar.dart';

class InfoPersoForm extends StatefulWidget {
  InfoPersoForm({Key? key}) : super(key: key);

  @override
  _InfoPersoFormState createState() => _InfoPersoFormState();
}

class _InfoPersoFormState extends State<InfoPersoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Les roles possibles
  final Map<String, bool> roles = {
    'super admin': false,
    'Coordinateur': false,
    'Intervenant sportif': false,
    'Référent': false,
    'Évaluateur PEPS': false,
    'Responsable Structure': false,
    'Superviseur PEPS': false,
    'Secrétaire': false,
  };

  final bool _infoP = true;
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

  String _ConfirmPswd = '';
  bool _isVisibleConfirmPswd = true;
  String _pswd = '';
  bool _isVisiblePswd = true;
  String _prenom = "";
  String _nom = "";
  // String _date = "07/12/2009";
  String _email = "";
  String _tel = "";
  bool _estCoordonnateurPeps = false;

  //final TextEditingController _dateinput = TextEditingController();

  String _nomStructure = "";
  String _typeStructure = "";
  String _adresseStructure = "";
  String _complementAdresseStructure = "";
  String _codePostal = "";
  String _ville = "";

  final RegExp _prenomNomRegex = RegExp(
    r"(?:^[A-Z]([a-z]+)$|^(^[A-Z][a-z]+)\-([A-Z]([a-z]+)$)$)",
  );
  //final RegExp _dateRegex = RegExp(r"^([0-2][1-9]|3[0-1])\/(0[1-9]|1[0-2])\/(19|20)[0-9]{2}$",);
  final RegExp _emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");
  final RegExp _telRegex = RegExp(
    r"^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$",
  );

  final RegExp _villeRegex = RegExp(r"^[A-Za-zÀ-ÿ' -]{2,40}$");

  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~._-]).{8,}$',
  );

  final RegExp _adresseRegex = RegExp(r"^[0-9]{1,5}(?: [a-zA-ZÀ-ÿ'\-\.]+)+$");
  final RegExp _codePostalRegex = RegExp(
    r"^(0[1-9]|[1-8][0-9]|9[0-8])[0-9]{3}$",
  );

  void submitForm() async {
    print('Formulaire soumis');
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Envoie en cours")));
      // Construire l'objet userModel avec les données du formulaire
      // Construis les données à envoyer
      Map<String, dynamic> dataToSend = {
        "identifiant": _email,
        "pswd": _pswd,
        "est_coordonnateur_peps": _estCoordonnateurPeps,
        "roles": roles.entries.where((e) => e.value).map((e) => e.key).toList(),
        "territoire": _selectedTerritoire,
        "nomUser": _nom,
        "prenomUser": _prenom,
        "telephone": _tel,
        "nomStructure": _nomStructure,
        "typeStructure": _typeStructure,
        "codePostal": _codePostal,
        "ville": _ville,
        "adresseComplementaire": _complementAdresseStructure,
        "compteur": 0,
      };

      // Envoie HTTP POST
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/SAPA-Mobile/users/Create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataToSend),
      );

      if (response.statusCode == 201) {
        // Succès, tu peux naviguer ou afficher un message
        print("Utilisateur créé avec succès !");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur ajouté avec succès")),
        );
      } else {
        print("Erreur lors de la création : ${response.body}");
      }
    }
  }

  void insert() async {
    print('Formulaire soumis');
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Envoie en cours")));
      // Construire l'objet userModel avec les données du formulaire
      // Construis les données à envoyer
      Map<String, dynamic> dataToSend = {
        "identifiant": _email,
        "pswd": _pswd,
        "est_coordonnateur_peps": _estCoordonnateurPeps,
        "roles": roles.entries.where((e) => e.value).map((e) => e.key).toList(),
        "territoire": _selectedTerritoire,
        "nomUser": _nom,
        "prenomUser": _prenom,
        "telephone": _tel,
        "nomStructure": _nomStructure,
        "typeStructure": _typeStructure,
        "codePostal": _codePostal,
        "ville": _ville,
        "adresseComplementaire": _complementAdresseStructure,
        "compteur": 0,
      };
      int nbRolesCoches = roles.entries.where((e) => e.value).length;
      if (nbRolesCoches > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur : pas plus deux roles ")),
        );
      }

      try {
        // Envoie HTTP POST
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/SAPA-Mobile/users/insert'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(dataToSend),
        );

        if (response.statusCode == 201) {
          // Succès
          print("Utilisateur créé avec succès !");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Utilisateur ajouté avec succès")),
          );

          //Recharger la page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UsersTable()),
          );
        } else {
          print("Erreur lors de la création : ${response.body}");
        }
      } catch (e) {
        print('Exception flutter : $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erreur de connexion ")));
      }
    }
  }

  void verifCoordo() {
    _estCoordonnateurPeps = roles["Coordonnateur"] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //////////////////////////////////////////////////////////////////////
        // App bar ///////////////////////////////////////////////////////////
        appBar: MonAppBar(myTitle: 'Formulaire'),
        drawer: const MyNavDrawer(),

        // leading: IconButton(
        //   icon: Icon(Icons.menu_rounded),
        //   color: Theme.of(context).scaffoldBackgroundColor,
        //   onPressed: () => widget.onChangedStep(0), // TODO
        // ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.power_settings_new_rounded),
        //     color: Colors.teal,
        //     onPressed: () => {}, // TODO
        //   ),
        // ]
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
                        text: "Informations Personnelles".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 26.0,
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

              //////////////////////////////////////////////////////////////////
              // Scroll view ///////////////////////////////////////////////////
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///////////////////////////////////////////////////
                      // Formulaire /////////////////////////////////////
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'COORDONNEES',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 26.0,
                              ),
                            ),

                            /////////////////////////////////////
                            // Prénom ///////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Prénom*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _prenom = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un prénom valide"
                                                : null,
                                    initialValue: _infoP ? _prenom : null,
                                    decoration: InputDecoration(
                                      //hintText: "Prénom",
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

                            /////////////////////////////////////
                            // Nom //////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Nom*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(() => _nom = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un nom valide"
                                                : null,
                                    initialValue: _infoP ? _nom : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom",
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

                            /////////////////////////////////////
                            // Date de naissance ////////////////
                            /* Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Date de Naissance',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _dateinput.text = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_dateRegex.hasMatch(value)
                                                ? "Please enter a valid date"
                                                : null,
                                    // initialValue:
                                    //   _infoP
                                    //     ? _dateinput.text
                                    //     : null,
                                    controller: _dateinput,
                                    decoration: InputDecoration(
                                      hintText: "jj/mm/aaaa",
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
                                        child: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime?
                                      pickedDate = await showDatePicker(
                                        context: context,
                                        locale: const Locale("fr", "FR"),
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                          1900,
                                        ), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(pickedDate);
                                        //you can implement different kind of Date Format here according to your requirement

                                        setState(() {
                                          _dateinput.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                      } else {
                                        print("Date non sélectionnée");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          

                            const SizedBox(height: 30.0),
                            */

                            /////////////////////////////////////
                            // Email ////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Email*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) =>
                                            setState(() => _email = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_emailRegex.hasMatch(value)
                                                ? "Entrez un email valide"
                                                : null,
                                    initialValue: _infoP ? _email : null,
                                    decoration: InputDecoration(
                                      //hintText: "Email",
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
                                        child: Icon(Icons.email_rounded),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////////////MOT DE PASSE ///////////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Mot de passe*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    initialValue: _infoP ? _pswd : null,
                                    decoration: InputDecoration(
                                      //labelText: 'Mot de passe',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isVisiblePswd
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isVisiblePswd = !_isVisiblePswd;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText:
                                        !_isVisiblePswd, // Mot de passe visible par défaut
                                    onChanged: (value) {
                                      setState(() {
                                        _pswd = value;
                                      });
                                    },

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer un mot de passe';
                                      } else if (value.length < 8) {
                                        return 'Le mot de passe doit contenir au moins 8 caractères';
                                      } else if (!_passwordRegex.hasMatch(
                                        value,
                                      )) {
                                        return "8 caracteres minimum : une minuscule une majuscule, un chiffre et une caractere speciale ";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////////////////////CONFIRMER MOT DE PASSE///////////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Confirmer MDP*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    initialValue: _infoP ? _ConfirmPswd : null,
                                    decoration: InputDecoration(
                                      //labelText: 'Mot de passe',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isVisibleConfirmPswd
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isVisibleConfirmPswd =
                                                !_isVisibleConfirmPswd;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText:
                                        !_isVisibleConfirmPswd, // Mot de passe visible par défaut
                                    onChanged: (value) {
                                      setState(() {
                                        _ConfirmPswd = value;
                                      });
                                    },

                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !_passwordRegex.hasMatch(value)) {
                                        return 'Veuillez entrer une confirmation de mot de passe valide';
                                      } else if (_ConfirmPswd != _pswd) {
                                        return 'Ces deux mot de passe ne sont pas identitiques';
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            ////////////////CHOIX DE LA TERRITOIRE/////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: [
                                  const Text(
                                    "La territoire*",
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  DropdownButtonFormField<String>(
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

                            /////////////////////////////////////
                            // Téléphone ////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Téléphone*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(() => _tel = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty
                                                //||!_telRegex.hasMatch(value)
                                                ? "Entrez un numéro de téléphone valide"
                                                : null,
                                    initialValue: _infoP ? _tel : null,
                                    decoration: InputDecoration(
                                      //hintText: "Téléphone",
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

                            const SizedBox(height: 15.0),
                            /////////////////////LE CHOIX DES ROLES ////////////////////////////////////////////////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Role(s)*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  const SizedBox(height: 10.0),

                                  ...roles.keys.map((role) {
                                    return CheckboxListTile(
                                      title: Text(role),
                                      value: roles[role],
                                      onChanged: (value) {
                                        setState(() {
                                          roles[role] = value ?? false;

                                          verifCoordo();
                                        });
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15.0),

                            ////////STRUCTURE//////////////
                            const Text(
                              'STRUCTURE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 26.0,
                              ),
                            ),

                            const SizedBox(height: 30.0),

                            //////nom de la structure //////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Nom de la structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _nomStructure = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un nom de structure valide"
                                                : null,
                                    initialValue: _infoP ? _nomStructure : null,
                                    decoration: InputDecoration(
                                      //hintText: "Nom de la structure",
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

                            ///////Type de strcucture ////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Type de structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _typeStructure = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un type de structure valide"
                                                : null,
                                    initialValue:
                                        _infoP ? _typeStructure : null,
                                    decoration: InputDecoration(
                                      //hintText: "Type de structure",
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

                            ///////Adresse de strcucture ////////
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Adresse de structure*',
                                    style: TextStyle(fontSize: 18.0),
                                  ),

                                  const SizedBox(height: 10.0),

                                  TextFormField(
                                    onChanged:
                                        (value) => setState(
                                          () => _adresseStructure = value,
                                        ),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_adresseRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un adresse valide"
                                                : null,
                                    initialValue:
                                        _infoP ? _adresseStructure : null,
                                    decoration: InputDecoration(
                                      //hintText: "Adresse de structure",
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
                                          () => _adresseStructure = value,
                                        ),

                                    /*validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_prenomNomRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un adresse valide"
                                                : null,
                                                */
                                    initialValue:
                                        _infoP
                                            ? _complementAdresseStructure
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

                            const SizedBox(height: 30.0),

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
                                        (value) =>
                                            setState(() => _codePostal = value),
                                    validator:
                                        (value) =>
                                            value!.isEmpty ||
                                                    !_codePostalRegex.hasMatch(
                                                      value,
                                                    )
                                                ? "Entrez un code postal valide"
                                                : null,
                                    initialValue: _infoP ? _codePostal : null,
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
                                    initialValue: _infoP ? _ville : null,
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

                            /////////////////////////////////////////////
                            // Bouton sauvegarder ///////////////////////
                            Row(
                              children: [
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
                                  onPressed: /*if ( nbRolesCoches > 2){
                                            print('Pas plus de 2 roles ');
                                          };
                                          */
                                      insert,

                                  /*
                                  !_prenomNomRegex.hasMatch(_prenom)
                                          //||!_prenomNomRegex.hasMatch(_nomStructure,)
                                          ||
                                          !_prenomNomRegex.hasMatch(_nom) ||
                                          !_emailRegex.hasMatch(_email) ||
                                          //(_dateinput.text).isEmpty ||
                                          //!_emailRegex.hasMatch(_email) ||
                                          //!_telRegex.hasMatch(_tel) ||
                                          //!_villeRegex.hasMatch(_ville) ||
                                          //!_codePostalRegex.hasMatch(_codePostal,) ||
                                          //!_prenomNomRegex.hasMatch(  _typeStructure,) ||
                                          !_passwordRegex.hasMatch(_pswd)
                                      ? submitForm
                                      : null,
                                      */
                                  child: Text(
                                    'SOUMETTRE'.toUpperCase(),
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

        /*  bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Container (
            padding: EdgeInsets.all(10.0),
            child: Row(
              children:[
                Expanded(
                  child:
                ),
              ]
            ),
          )
        ),*/
      ),
    );
  }
}




/*
  DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Choisissez une option',
                  border: OutlineInputBorder(),
                ),
                value: _selectedValue,
                items: ['Option 1', 'Option 2', 'Option 3']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner une option' : null,
              ),
 */

/*? null
                                      : () => {
                                        if (_formKey.currentState!.validate())
                                          {},
                                      },
                                      */