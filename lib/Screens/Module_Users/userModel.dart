class userModel {
  //late int id_user;
  //late String identifiant;

  //VERIFICATION
  late String nom_territoire;
  late String nom_structure;
  late String tel_f_user;
  //late String fonction;
  late String nom_user;
  late String prenom_user;
  late String tel_user;
  late String mail_user;
  late int id_territoire;
  late int id_structure;
  //late String role;
  //late String type_structure;

  userModel({
    //required this.id_user,
    //required this.identifiant,

    //VERIFICATION
    required this.nom_territoire,
    required this.nom_structure,
    //required this.fonction,
    required this.tel_f_user,
    required this.nom_user,
    required this.prenom_user,
    required this.tel_user,
    required this.mail_user,
    required this.id_territoire,
    required this.id_structure,
    //required this.type_structure,
    //required this.role,
  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      //id_user: json['id_user'],
      //identifiant: json['identifiant'],

      //VERIFICATION
      //fonction: json['fonction'],
      tel_f_user: json['tel_f_user'] ?? '',
      nom_territoire: json['nom_territoire'] ?? '',
      nom_user: json['nom_user'] ?? '',
      prenom_user: json['prenom_user'] ?? '',
      tel_user: json['tel_p_user'] ?? '',
      mail_user: json['email_user'] ?? '',
      id_territoire: json['id_territoire'] ?? '',
      id_structure: json['id_structure'] ?? '',
      //type_structure: json['type_structure'],
      nom_structure: json['nom_structure'] ?? '',

      //role:json['']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'identifiant': identifiant,

      //VERIFICATION
      //'fonction': fonction,
      'tel_f_user': tel_f_user,
      'nom_structure': nom_structure,
      'id_structure': id_structure,
      'nom_territoire': nom_territoire,
      'id_territoire': id_territoire,
      //'type_structure': type_structure,
      'mail_user': mail_user,
      'tel_user': tel_user,
      'nom_user': nom_user,
      'prenom_user': prenom_user,
    };
  }
}


/*class userModel {
  late String identifiant;
  late String motDePasse;
  late String nom;
  late String prenom;
  late String email;
  late String tel;
  late String codePostal;
  late String ville;
  late String typeStructure;
  late String nomStructure;

                           
                           
                               
  late List<String> roles;
  late List<String> territoire;

  userModel({
    required this.identifiant,
    required this.motDePasse,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.tel,
    required this.codePostal,
    required this.ville,
    required this.typeStructure,
    required this.nomStructure,
    required this.roles,
    required this.territoire,
  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      identifiant: json['identifiant'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      tel: json['tel'],
      codePostal: json['codePostal'],
      ville: json['ville'],
      typeStructure: json['typeStructure'],
      nomStructure: json['nomStructure'],
      roles: json['roles'],
      territoire: json['territoire'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifiant': identifiant,
      'motDePasse': motDePasse,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'tel': tel,
      'codePostal': codePostal,
      'ville': ville,
      'typeStructure': typeStructure,
      'nomStructure': nomStructure,
      'roles': roles,
      'territoire': territoire,
    };
  }
}
*/