import 'package:dio/dio.dart';
import 'package:petpaws/api/GetAnimalById.dart';
import 'package:petpaws/api/GetAnimals.dart';
import 'package:petpaws/api/UserModel.dart';

class RemoteService {
  final String baseUrl = "localhost";
  final dio = Dio();
  Future<List<GetAnimal>?> getPost() async {
    try {
      var response = await dio.get("https://$baseUrl:7293/api/Animal");
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        List<GetAnimal> animals =
            jsonList.map((json) => GetAnimal.fromJson(json)).toList();

        return animals;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<GetAnimal>?> getMyPost(String email) async {
    try {
      print("$email");
      var response =
          await dio.get("https://$baseUrl:7293/api/Animal/myanimal/$email");
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        print(jsonList);
        List<GetAnimal> animals =
            jsonList.map((json) => GetAnimal.fromJson(json)).toList();

        return animals;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<GetAnimal>?> getMySavedPost(String email) async {
    try {
      var response =
          await dio.get("https://$baseUrl:7293/api/Animal/saved/$email");
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        print(jsonList);
        List<GetAnimal> animals =
            jsonList.map((json) => GetAnimal.fromJson(json)).toList();

        return animals;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<GetAnimalById?> getAnimalbyId(int? id) async {
    try {
      var id1 = id.toString();
      var response = await dio.get("https://$baseUrl:7293/api/Animal/$id1");
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        dynamic json = response.data;
        print(json);
        GetAnimalById animal = GetAnimalById.fromJson(json);
        print("oldu");

        return animal;
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }
    Future<List<GetAnimal>?>getAnimalbyFilter(String filter) async {
    try {
      var response = await dio.get("https://$baseUrl:7293/api/Animal/filter/$filter");
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        List<dynamic> jsonList = response.data;
        List<GetAnimal> animals =
            jsonList.map((json) => GetAnimal.fromJson(json)).toList();


        print("oldu");

        return animals;
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUser(String email) async {
    try {
      print("$email");
      var response = await dio.get("https://$baseUrl:7293/api/User/$email");
      if (response.statusCode == 200) {
        dynamic json = response.data;
        UserModel user = UserModel.fromJson(json);
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future createAnimal(GetAnimalById animalModel) async {
    try {
      dynamic json = animalModel.toJson();
      print(json);
      var response =
          await dio.post("https://$baseUrl:7293/api/Animal", data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }

  Future putAnimal(GetAnimalById animalModel, int? animalId) async {
    try {
      dynamic json = animalModel.toJson();
      print(json);
      var response = await dio.put("https://$baseUrl:7293/api/Animal/$animalId",
          data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }

  Future createUser(UserModel userModel) async {
    try {
      dynamic json = userModel.toJson();
      print(json);
      var response =
          await dio.post("https://$baseUrl:7293/api/User", data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }

  Future putUser(UserModel userModel, int? userId) async {
    try {
      dynamic json = userModel.toJson();
      print("json: $json");
      var response =
          await dio.put("https://$baseUrl:7293/api/User/$userId", data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteSaving(String userEmail, int animalId) async {
    try {
      UserModel userModel =
          UserModel(username: "username", email: userEmail, phone: "phone", imagePath: '');
          userModel.userId=1;
      userModel.imagePath = "";
      userModel.password="";
      dynamic json = userModel.toJson();
      print(json);
      var response = await dio.delete(
          "https://$baseUrl:7293/api/User/deletesaving/$animalId",
          data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }
  Future animalSaving(String userEmail, int animalId) async {
    try {
      UserModel userModel =
          UserModel(username: "username", email: userEmail, phone: "phone", imagePath: '');
          userModel.userId=1;
        userModel.imagePath = "a";
        userModel.password="a";
      dynamic json = userModel.toJson();
      print(json);
      var response = await dio.post(
          "https://$baseUrl:7293/api/User/saveanimal/$animalId",
          data: json);
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }
    Future deleteAnimal(GetAnimal animalModel) async {
    try {
      var animalId= animalModel.animalId;

      var response =
          await dio.delete("https://$baseUrl:7293/api/Animal/$animalId");
      print(response.data);
      if (response.statusCode == 200) {
        print("oldu");
        return "ok";
      } else {
        print("olmadı");
      }
    } catch (e) {
      print(e);
    }
  }
}
