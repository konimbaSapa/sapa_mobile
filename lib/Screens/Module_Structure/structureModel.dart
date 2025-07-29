class structureModel {
  late String nom_structure;
  late String nom_statut_structure;
  late String nom_adresse;
  late String nom_territoire;

  structureModel({
    required this.nom_structure,
    required this.nom_statut_structure,
    required this.nom_adresse,
    required this.nom_territoire,
  });

  factory structureModel.fromJson(Map<String, dynamic> json) {
    return structureModel(
      nom_structure: json['nom_structure'] ?? '',
      nom_statut_structure: json['nom_statut_structure'] ?? '',
      nom_adresse: json['nom_adresse'] ?? '',
      nom_territoire: json['nom_territoire'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom_structure': nom_structure,
      'nom_statut_structure': nom_statut_structure,
      'nom_adresse': nom_adresse,
      'nom_territoire': nom_territoire,
    };
  }
}
