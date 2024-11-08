class ListEtudiants {
  final int id;
  final int codClass;
  late final String nom;
  late final String prenom;
  late final String datNais;

  ListEtudiants(this.id, this.codClass, this.nom, this.prenom, this.datNais);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codClass': codClass,
      'nom': nom,
      'prenom': prenom,
      'datNais': datNais,
    };
  }
}
