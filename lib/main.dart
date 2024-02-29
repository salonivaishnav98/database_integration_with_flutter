import 'package:db_practice/db_controller.dart';
import 'package:db_practice/splash.dart';
import 'package:db_practice/statemanagement.dart';
import 'package:db_practice/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'splash.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nothing',
      home: SplashSc(),
    );
  }
}

class HomeSc extends StatefulWidget {
  final String? username;
  const HomeSc({super.key, this.username});

  @override
  State<HomeSc> createState() => _HomeScState();
}

class _HomeScState extends State<HomeSc> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white12,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
          Text('Welcome to Dashboard ${widget.username}'),

            // ElevatedButton(onPressed: (){
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn(),));
            // }, child: const Text('Login')),
      ]
      ),
    );
  }
}




class SignUp extends StatelessWidget {
  SignUp({super.key});

  final fNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final rePassController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TextField(
            controller: fNameController,
            style: const TextStyle(color: Colors.blue),
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.account_circle_sharp),

            ),
          ),
          TextField(
            controller: usernameController,
            style: const TextStyle(color: Colors.blue),
            decoration: const InputDecoration(
              labelText: 'username',
              prefixIcon: Icon(Icons.account_circle_sharp),

            ),
          ),
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.blue),
            decoration: const InputDecoration(
              labelText: 'email',
              prefixIcon: Icon(Icons.account_circle_sharp),

            ),
          ),
          TextField(
            controller: passController,
            style: const TextStyle(color: Colors.blue),
            decoration: const InputDecoration(
              labelText: 'password',
              prefixIcon: Icon(Icons.account_circle_sharp),

            ),
          ),
          TextField(
            controller: rePassController,
            style: const TextStyle(color: Colors.blue),
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.account_circle_sharp),

            ),
          ),

          ElevatedButton(onPressed: (){

            if(fNameController.text.isEmpty || usernameController.text.isEmpty || emailController.text.isEmpty || passController.text.isEmpty || rePassController.text.isEmpty){
              FlutterToast().toastMsg("Please fill all the fields", Colors.redAccent);

            }else{
              DatabaseHelper.checkUserExistance(usernameController.text).then((username){
                if(!username){
                  DatabaseHelper.checkEmailExistance(emailController.text).then((email){
                    if(!email){
                      if(passController.text != rePassController.text){
                        FlutterToast().toastMsg("Both password should be match!", Colors.redAccent);
                      }
                      else{
                        DatabaseHelper.createItems(fNameController.text, usernameController.text, emailController.text, passController.text, const Uuid().v4()).then((value){
                          FlutterToast().toastMsg('Account created', Colors.blue);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  LogIn(),));
                        });

                      }
                    }else{
                      FlutterToast().toastMsg('Email exist', Colors.redAccent);
                    }
                  });
                }
                else{
                  FlutterToast().toastMsg("user already exist", Colors.redAccent);
                }

              });

            }
            //Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn(),));
          }, child: const Text("SignUp"))

        ],
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();

}


class _LogInState extends State<LogIn> {

  final usernameController = TextEditingController();
  final passController = TextEditingController();

  final userAuthentication = Get.put(UserAuth());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.blue),
              decoration: const InputDecoration(
                labelText: 'user',
                prefixIcon: Icon(Icons.account_circle_sharp),

              ),
            ),
            Obx(()=>
                TextField(
                  controller: passController,
                  style: const TextStyle(color: Colors.blue),
                  obscureText: !userAuthentication.passVisibility.value,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(

                      labelText: 'password',
                      prefixIcon: const Icon(Icons.account_circle_sharp),
                      suffixIcon: IconButton(onPressed: (){
                        userAuthentication.passAuth();
                      },icon: Icon(userAuthentication.passVisibility.value? Icons.visibility_off:Icons.visibility),)
                  ),
                ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp(),));
            }, child: const Text("Signup")),

            ElevatedButton(onPressed: (){
              if(usernameController.text.isEmpty || passController.text.isEmpty){
                FlutterToast().toastMsg('Please fill all fields', Colors.red);
              }else{
                DatabaseHelper.authentication(usernameController.text, passController.text).then((value) async{

                  if(value.isNotEmpty){

                    String? unique_Id = value[0]['unique_Id'];
                    String? username = value[0]['username'];

                    SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.setString('unique_Id', unique_Id!);
                    await pref.setString('username', username!);

                    FlutterToast().toastMsg("login success", Colors.blue);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => HomeSc(username: username,),));

                  }else{
                    FlutterToast().toastMsg("Invalid user", Colors.redAccent);
                  }
                });
              }
            }, child: const Text("Login")),
          ],
        )
    );
  }
}




