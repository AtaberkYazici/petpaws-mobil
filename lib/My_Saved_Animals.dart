import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpaws/api/GetAnimals.dart';
import 'package:petpaws/api/RemoteService.dart';

import 'Utilities.dart';

class MySavedAnimalsWidget extends StatefulWidget {
  const MySavedAnimalsWidget({super.key});

  @override
  State<MySavedAnimalsWidget> createState() => _MyAnimalsSavedState();
}

class _MyAnimalsSavedState extends State<MySavedAnimalsWidget> {
  List<GetAnimal>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async {
    posts = await RemoteService()
        .getMySavedPost(FirebaseAuth.instance.currentUser!.email!);
    print(posts);
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
      body: isLoaded
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: posts?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
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
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(posts![index].name,
                                              textAlign: TextAlign.center)),
                                      Container(
                                          height: 30,
                                          width: 200,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                _deleteSaving(
                                                    posts![index].animalId!);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MySavedAnimalsWidget()));
                                              },
                                              child: const Row(
                                                children: [
                                                  Icon(Icons
                                                      .heart_broken_rounded),
                                                  Text("delete from saved")
                                                ],
                                              )))
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          )),
                        ),
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

  void _deleteSaving(int animalIndex) {
    RemoteService()
        .deleteSaving(FirebaseAuth.instance.currentUser!.email!, animalIndex);
  }
}
