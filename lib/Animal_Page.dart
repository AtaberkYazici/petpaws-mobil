import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpaws/api/GetAnimalById.dart';
import 'package:petpaws/api/GetAnimals.dart';
import 'package:petpaws/api/RemoteService.dart';
import 'package:petpaws/api/UserModel.dart';

import 'Utilities.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key, this.animalId});
  final int? animalId;

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final double top = 175;
  late int? localAnimalId;
  var isLoaded = false;
  UserModel? user;
  GetAnimalById? animal;

  @override
  void initState() {
    localAnimalId = widget.animalId;
    print(localAnimalId);
    super.initState();
    //fetch data from API
    getData(localAnimalId);
  }

  getData(int? id) async {
    animal = await RemoteService().getAnimalbyId(id);
    user = await RemoteService()
        .getUser(FirebaseAuth.instance.currentUser!.email!);
    if (animal != null && user != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoaded
          ? Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    AnimalImageBuilder(animal!.imagePath),
                    Positioned(
                        top: top,
                        child: BuildAnimalName(animalName: animal!.name))
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.deepPurple[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Text(animal!.age.toString()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.deepPurple[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Text("Ankara"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 60,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.deepPurple[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (AnimalVaccines myObject
                                          in animal!.animalVaccines)
                                        ListTile(
                                          title: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(myObject.name),
                                          ),
                                        ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.deepPurple[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 125,
                                      height: 125,
                                      child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user!.imagePath)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(animal!.userName,
                                        style: TextStyle(fontSize: 15)),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 350,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text(animal!.extraExplanations, maxLines: 5),
                      ),
                    ),
                  ],
                )
              ],
            )
          : CircularProgressIndicator(),
      drawer: const NavigationDrawerWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveAnimal(animal!.animalId!);
        },
        label: Text("Sahiplen"),
      ),
    );
  }

  void _saveAnimal(int animalIndex) async {
    RemoteService()
        .animalSaving(FirebaseAuth.instance.currentUser!.email!, animalIndex);
  }
}

class BuildAnimalName extends StatelessWidget {
  final String animalName;
  BuildAnimalName({super.key, required this.animalName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Text(animalName,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
    );
  }
}

class AnimalImageBuilder extends StatelessWidget {
  AnimalImageBuilder(
    this.imagePath, {
    super.key,
  });
  final String imagePath;
  final double coverHeight = 200;
  final double coverwidth = 400;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        child: Image.network(imagePath,
            fit: BoxFit.cover, height: coverHeight, width: coverwidth));
  }
}
