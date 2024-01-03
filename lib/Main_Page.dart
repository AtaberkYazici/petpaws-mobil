import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:petpaws/Animal_Page.dart';
import 'package:petpaws/Create_Announcement.dart';
import 'package:petpaws/Login.dart';
import 'package:petpaws/api/GetAnimals.dart';
import 'package:petpaws/api/RemoteService.dart';

import 'Utilities.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<GetAnimal>? posts;
  List<GetAnimal>? filteredPost;
  var isLoaded = false;
  //final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetch data from API
    searchAnimal("");

  }

  getData() async {
    posts = await RemoteService().getPost();
   
  }

  void searchAnimal(String query) async{
    await getData();
    setState(() {
       if (query.isNotEmpty) {
        // Arama sorgusuna uygun ürünleri filtrele
        print("object");
        filteredPost = posts!
            .where((animal) => animal.type!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        // Arama sorgusu boş ise tüm ürünleri göster
        print("bos");
        filteredPost = posts;
      }
      if (filteredPost != null) {
        print("isloadedtrue");
        isLoaded = true;
    }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoaded
          ? Column(
              //post listesi yüklenmeden burası çalışmaması için alınmış bir önlem
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
                            onPressed: () {
                              searchAnimal("dog");
                              }, child: Text("Dog")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          
                            onPressed: () {
                              searchAnimal("cat");
                              
                            }, child: Text("Cat")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              searchAnimal("bird");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()));
                            }, child: Text("Bird")),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPost?.length,
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
                                          filteredPost![index].imagePath))),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: Text(
                                            filteredPost![index].extraExplanations,
                                            textAlign: TextAlign.center)),
                                    Container(
                                        height: 20,
                                        alignment: Alignment.bottomLeft,
                                        child: Text(filteredPost![index].type)),
                                  ],
                                ),
                              ),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAnnouncement()))
              },
          child: const Icon(Icons.add)),
      drawer: const NavigationDrawerWidget(),
    );
  }
  @override
  void didChangeDependencies() {
     getData();
    print('Page refreshed!');
    super.didChangeDependencies();
  }

}
