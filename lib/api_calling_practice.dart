import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';

void main(){
  runApp(
      const GetMaterialApp(
        home: HomeSc(),
      )

  );
}

class HomeSc extends StatefulWidget {
  const HomeSc({super.key});

  @override
  State<HomeSc> createState() => _HomeScState();
}

class _HomeScState extends State<HomeSc> {



  File? _imageFile;

  final uNameController = TextEditingController();

  final fNameController = TextEditingController();

  final lNameController = TextEditingController();

  final passController = TextEditingController();

  final emailController = TextEditingController();

  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       // _initializeVideoPlayer();
  //     });
  //   }
  // }

  Future<void> _pickImage(ImageSource source) async{
    final pickedFile = await ImagePicker().pickImage(source: source);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  Future<dynamic> getApiCalling(String uName,String fName,String lName,String email,String pass,File? img) async{

    var request = http.MultipartRequest('POST', Uri.parse("https://fluttersv.pythonanywhere.com/api/register"));
    //http.MultipartRequest: This class represents a multipart/form-data request. It is part of the http package in Dart.
    // 'POST': Specifies that this request is a POST request.


    // Add text fields (such as title and user)
    request.fields['first_name'] = fName;
    request.fields['last_name'] = lName;
    request.fields['username'] = uName;
    request.fields['password'] = pass;
    request.fields['email'] = email;

    // Add image file
    if (img != null) {
      var imageStream = http.ByteStream(img!.openRead());//The openRead() method returns a stream of bytes representing the content of the file.
      var imageLength = await img!.length();
      var imageMultipartFile = http.MultipartFile('proPic', imageStream, imageLength,
          contentType: MediaType("image", "*"),//* for all type
          filename: img!.path.split('/').last);
      request.files.add(imageMultipartFile);
    }

    var streamedResponse = await request.send();


    // Get response
    var response = await http.Response.fromStream(streamedResponse);

    // Decode JSON response
    var jsonData = jsonDecode(response.body);
    return jsonData;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(),
        body:   SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                      onTap: (){
                        dialogBox();
                      },

                      child: _imageFile!=null?CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_imageFile!),):
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/images/blue1.jpg"),)
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: uNameController,
                  decoration: const InputDecoration(
                      labelText: "usernamme",
                      border: OutlineInputBorder()

                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: fNameController,
                  decoration: const InputDecoration(
                      labelText: "fName",
                      border: OutlineInputBorder()

                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: lNameController,
                  decoration: const InputDecoration(
                      labelText: "last name",
                      border: OutlineInputBorder()

                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "email",
                      border: OutlineInputBorder()

                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: passController,
                  decoration: const InputDecoration(
                      labelText: "password",
                      border: OutlineInputBorder()

                  ),
                ),
                const SizedBox(height: 10,),

                ElevatedButton(onPressed: (){
                  getApiCalling(uNameController.text, fNameController.text, lNameController.text, emailController.text, passController.text, _imageFile)
                      .then((value){
                    print("response .............${value}");
                  });

                }, child: const Text("Create user"))

              ],
            ),
          ),
        )

    );
  }

  void dialogBox(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick Image"),
          actions: [
            TextButton(onPressed: (){
              _pickImage(ImageSource.gallery);
              Navigator.pop(context);
            }, child: const Text("Select from gallery")),
            TextButton(onPressed: (){
              _pickImage(ImageSource.camera);
              Navigator.pop(context);
            }, child: const Text("take from Camera"))
          ],
        );
      },);
  }

}
