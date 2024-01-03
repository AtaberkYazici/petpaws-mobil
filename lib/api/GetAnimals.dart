class GetAnimal {
  int? animalId;
  late String name;
  late String type;
  int? age;
  late String extraExplanations;
  late String imagePath;
  int? userId;


  GetAnimal(
      {this.animalId,
      required this.name,
      this.age,
      required this.extraExplanations,
      required this.imagePath,
      required this.type,
      this.userId,
  });

  GetAnimal.fromJson(Map<String, dynamic> json) {
    animalId = json['animalId'];
    name = json['name'];
    type= json['type'];
    age = json['age'];
    extraExplanations = json['extraExplanations'];
    imagePath = json['imagePath'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['animalId'] = this.animalId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['age'] = this.age;
    data['extraExplanations'] = this.extraExplanations;
    data['imagePath'] = this.imagePath;
    data['userId'] = this.userId;
    
    return data;
  }
}