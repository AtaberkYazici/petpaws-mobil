import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpaws/Animal_Page.dart';
import 'package:petpaws/Login.dart';
import 'package:petpaws/Main_Page.dart';
import 'package:petpaws/My_Animals.dart';
import 'package:petpaws/My_Saved_Animals.dart';
import 'package:petpaws/Profile_Edit.dart';
import 'package:petpaws/api/RemoteService.dart';
import 'package:petpaws/api/UserModel.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({
    super.key,
  });

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  UserModel? user;
  var isLoaded = false;
  //final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getUser();
  }

  void getUser() async {
    print(FirebaseAuth.instance.currentUser!.email!);
    user = await RemoteService()
        .getUser(FirebaseAuth.instance.currentUser!.email!);
        if (user != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return isLoaded ? Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user!.imagePath)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      user!.username,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail),
                        Text(
                          user!.email,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone),
                        Text(
                          user!.phone,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: const Text(' My Animals '),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyAnimalsWidget()));
            },
          ),
          ListTile(
            leading: Icon(Icons.video_label),
            title: const Text(' Saved Animals '),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MySavedAnimalsWidget()));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfileWidget(userId: user!.userId)));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => new Login()),
                    (route) => false);
              });
            },
          ),
        ],
      ),
    ):CircularProgressIndicator();
  }
}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(100),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: const Text(
                  "PetPaws",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 70,
            height: 70,
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWi1E-4SEL6sKB8Tg4Rb-IfIV4QCJ2ywYFWMkXUJnq6ygmpaKm0HdLhaXzGGWWuRD_hTc&usqp=CAU"),
            ),
          ),
        ],
      ),
    );
  }
}