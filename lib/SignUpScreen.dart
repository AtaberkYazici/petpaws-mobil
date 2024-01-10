import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpaws/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpaws/Utilities.dart';
import 'package:petpaws/api/RemoteService.dart';
import 'package:petpaws/api/UserModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? imageUrl;
      String? modifiedUrl;
  UserModel userModel =
      UserModel(username: "", email: "", phone: "", imagePath: '');

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * (0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        IconButton(
                            onPressed: () {
                              _uploadPictures();
                            },
                            icon: Icon(Icons.camera_alt)),
                       Text("Upload picture"),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userModel.username = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userModel.email = value!;
                      },
                    ),
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
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * (0.1),
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => new Login()),
                                (route) => false);
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Error: ${error.toString()}')));
                          });
                          _submitForm();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      userModel.imagePath = modifiedUrl!;
      userModel.password = "a";
      userModel.userId = 0;
      print(userModel);
      await RemoteService().createUser(userModel);
      print('Form submitted with data: $userModel');
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
}
