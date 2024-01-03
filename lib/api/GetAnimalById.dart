class GetAnimalById {
  int? animalId;
  late String name;
  late String type;
  int? age;
  late String extraExplanations;
  late String imagePath;
  late String userName;
  String? userPhone;
  late List<AnimalVaccines> animalVaccines;

  GetAnimalById(
      {this.animalId,
      required this.name,
      required this.type,
      this.age,
      required this.extraExplanations,
      required this.imagePath,
      required this.userName,
      this.userPhone,
      required this.animalVaccines});

  GetAnimalById.fromJson(Map<String, dynamic> json) {
    animalId = json['animalId'];
    name = json['name'];
    type = json['type'];
    age = json['age'];
    extraExplanations = json['extraExplanations'];
    imagePath = json['imagePath'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    if (json['animalVaccines'] != null) {
      animalVaccines = <AnimalVaccines>[];
      json['animalVaccines'].forEach((v) {
        animalVaccines!.add(new AnimalVaccines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['animalId'] = this.animalId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['age'] = this.age;
    data['extraExplanations'] = this.extraExplanations;
    data['imagePath'] = this.imagePath;
    data['userName'] = this.userName;
    data['userPhone'] = this.userPhone;
    if (this.animalVaccines != null) {
      data['animalVaccines'] =
          this.animalVaccines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnimalVaccines {
  late String name;

  AnimalVaccines({required this.name});

  AnimalVaccines.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}