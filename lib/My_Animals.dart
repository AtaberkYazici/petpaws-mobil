import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpaws/Animal_Page.dart';
import 'package:petpaws/Edit_Announcement.dart';
import 'package:petpaws/api/GetAnimalById.dart';
import 'package:petpaws/api/GetAnimals.dart';
import 'package:petpaws/api/RemoteService.dart';

import 'Utilities.dart';

class MyAnimalsWidget extends StatefulWidget {
  const MyAnimalsWidget({super.key});

  @override
  State<MyAnimalsWidget> createState() => _MyAnimalsWidgetState();
}

class _MyAnimalsWidgetState extends State<MyAnimalsWidget> {
  List<GetAnimal>? posts;

  var isLoaded = false;
  //final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async {
    posts = await RemoteService()
        .getMyPost(FirebaseAuth.instance.currentUser!.email!);
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
          isLoaded //post listesi yüklenmeden burası çalışmaması için alınmış bir önlem
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {}, child: Text("Dog")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {}, child: Text("Cat")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {}, child: Text("Bird")),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: posts?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnimalPage(
                                          animalId: posts?[index].animalId)));
                            },
                            child: Card(
                                child: SizedBox(
                              height: 110,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              posts![index].imagePath))),
                                  Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                        Container(
                                            height: 20,
                                            alignment: Alignment.bottomLeft,
                                            child: Text(posts![index].name)),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditAnnouncementWidget(
                                                                  animalId: posts?[
                                                                          index]
                                                                      .animalId)));
                                                },
                                                child: Text("Edit Animal")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  _deleteAnimal(posts![index]);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyAnimalsWidget()));
                                                },
                                                child: Text("Delete Animal"))
                                          ],
                                        )
                                      ]))
                                ]),
                              ),
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
      drawer: const NavigationDrawerWidget(),
    );
  }

  void _deleteAnimal(GetAnimal animal) async {
    RemoteService().deleteAnimal(animal);
  }
}
