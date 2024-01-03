import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpaws/api/RemoteService.dart';
import 'package:petpaws/api/UserModel.dart';

import 'Main_Page.dart';
import 'Utilities.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key, this.userId});
  final int? userId;
  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  UserModel? user;
  var isLoaded = false;
  String? imageUrl;
    String? modifiedUrl;
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

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel userModel =
      UserModel(username: '', email: '', phone: '', imagePath: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoaded? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                            IconButton(
                            onPressed: () {
                              _uploadPictures();
                              // _deletePicture();
                            },
                            icon: Icon(Icons.camera_alt)),
                       Text("Upload picture"),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userModel.username = value!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                       
                        return null;
                      },
                      onSaved: (value) {
                        userModel.phone = value!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: passwordControler,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        
                        return null;
                      },
                      onSaved: (value) {
                        userModel.password = value!;
                      },
                    )
                  ]))):CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Change Profile"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          onPressed: () => {
                if (_formKey.currentState!.validate()) {_changeCredentials()}
              }),
      drawer: const NavigationDrawerWidget(),
    );
  }

  void _changeCredentials() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await Firebase.initializeApp();
        var olduser = FirebaseAuth.instance.currentUser;

        // Change password
        await olduser?.updatePassword(passwordControler.text);
        userModel.userId = widget.userId;
        userModel.email = FirebaseAuth.instance.currentUser!.email!;
        userModel.imagePath = modifiedUrl!;
      } catch (e) {
        print(e);
      }
      await RemoteService().putUser(userModel, widget.userId);
    }
  }
  void _uploadPictures() async {
    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resim yüklenemedi')));
        return;
      }
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      await referenceImageToUpload.putFile(File(file.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();
      modifiedUrl = removeTokenFromUrl(imageUrl!);
      print(modifiedUrl);

    } catch (e) {
      print(e);
    }
  }
  String removeTokenFromUrl(String url) {
  // Split the URL based on the '?' character
  List<String> parts = url.split("&");
  
  // Take the part before the '?'
  String baseUrl = parts[0];

  return baseUrl;
  }
  // void _deletePicture()async{
  //   try{
  //   FirebaseStorage.instance.refFromURL(user!.imagePath!).delete();
  //   }catch(e){print(e);}
  // }
}
