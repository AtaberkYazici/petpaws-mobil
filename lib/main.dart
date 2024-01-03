import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petpaws/Animal_Page.dart';
import 'package:petpaws/Create_Announcement.dart';
import 'package:petpaws/Edit_Announcement.dart';
import 'package:petpaws/Main_Page.dart';
import 'package:petpaws/My_Animals.dart';
import 'package:petpaws/My_Saved_Animals.dart';
import 'package:petpaws/login.dart';
import 'package:petpaws/Profile_Edit.dart';


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides{
@override
HttpClient createHttpClient(SecurityContext? context){
return super.createHttpClient(context)
..badCertificateCallback = ((X509Certificate cert, String host, int port) {
final isValidHost = ["172.20.10.3","192.168.1.24","10.116.72.242","192.168.1.101","192.168.1.100","localhost"]. contains(host); // <-- allow only hosts bilgisayardan bilgisayara değişir
return isValidHost;
});
}}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle:true, backgroundColor: Colors.white70
         ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}





