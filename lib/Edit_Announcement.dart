import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpaws/api/GetAnimalById.dart';
import 'package:petpaws/api/RemoteService.dart';
import 'package:petpaws/api/UserModel.dart';
import 'Main_Page.dart';
import 'Utilities.dart';

class EditAnnouncementWidget extends StatefulWidget {
  const EditAnnouncementWidget({super.key, this.animalId});
  final int? animalId;
  @override
  State<EditAnnouncementWidget> createState() => _EditAnnouncementWidgetState();
}

class _EditAnnouncementWidgetState extends State<EditAnnouncementWidget> {
  final _formKey = GlobalKey<FormState>();
  final GetAnimalById _formData = GetAnimalById(
      name: '',
      type: '',
      extraExplanations: '',
      imagePath: '',
      userName: '',
      animalVaccines: []);

  List<AnimalVaccines> _vaccines = [
    AnimalVaccines(name: "kuduz"),
    AnimalVaccines(name: "hepatit"),
    AnimalVaccines(name: "karma")
  ];
  late int? localAnimalId;
  UserModel? user;
  GetAnimalById? animal;
  var isLoaded = false;
  String? imageUrl;
  String? modifiedUrl;

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
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                IconButton(
                    onPressed: () {
                      _uploadPictures();
                    },
                    icon: Icon(Icons.camera_alt)),
                    Text("Upload Picture"),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter animal name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData.name = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter animal type eg dog or cat';
                    }
                    // You can add additional email validation logic here
                    return null;
                  },
                  onSaved: (value) {
                    _formData.type = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType:
                      TextInputType.number, // Restrict input to numeri
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter animal age';
                    }
                    // You can add additional email validation logic here
                    return null;
                  },
                  onSaved: (value) {
                    _formData.age = int.parse(value!);
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Extra Explanation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Explain';
                    }
                    // You can add additional email validation logic here
                    return null;
                  },
                  onSaved: (value) {
                    _formData.extraExplanations = value!;
                  },
                ),
                SizedBox(height: 16.0),
                for (AnimalVaccines vaccine in _vaccines)
                  CheckboxListTile(
                    title: Text(vaccine.name),
                    value: _formData.animalVaccines.contains(vaccine),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            _formData.animalVaccines.add(vaccine);
                          } else {
                            _formData.animalVaccines.remove(vaccine);
                          }
                        }
                      });
                    },
                  ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Create Announcement"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          onPressed: () => { _submitForm()}),
      drawer: const NavigationDrawerWidget(),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData.imagePath = modifiedUrl!;
      _formData.animalId = widget.animalId;
      _formData.userName = FirebaseAuth.instance.currentUser!.email!;
      _formData.userPhone = "435542";//önemli değil
      print(_formData);
      await RemoteService().putAnimal(_formData, widget.animalId);
      print('Form submitted with data: $_formData');
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
        return ; 
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
    void _deletePicture()async{
    try{
    FirebaseStorage.instance.refFromURL(animal!.imagePath!).delete();
    }catch(e){print(e);}
  }
    String removeTokenFromUrl(String url) {
  // Split the URL based on the '?' character
  List<String> parts = url.split("&");
  
  // Take the part before the '?'
  String baseUrl = parts[0];

  return baseUrl;
  }
}

