import 'loginForm.dart';
import 'package:flutter/material.dart';
import 'package:cmf/Entities/user.dart';
import 'package:cmf/Database_helper/firebaseHelper.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {



  final TextEditingController _id = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String Gender = "Male";
  String Role = "Blogger";
  final _registerFormKey = GlobalKey<FormState>();


  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child:const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF333c3a)),
              SizedBox(height: 10),
              Text("Processing", style: TextStyle(fontSize: 12,
                  color: Color(0xFF333c3a),
                  fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      );
    },);
  }


  Future<bool> isUserIDAlreadyExist(User user,Firestore_helper fh)async
  {

    final userid = await fh.getUser(user);
    if(userid == null)
    {
      return true;
    }
    else
    {
      showMessage("user already exist,change userid!!!");
      return false;
    }

  }


  createAccount(User user,Firestore_helper fh)async
  {
    try
    {
      LoadingScreen();
      await fh.addUser(user);
      showMessage("Account created");
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm(),),);
    }
    catch(e)
    {
      showMessage("Something went wrong!");
    }
  }

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          child: Column(
              children: [
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset("lib/assets/cloudmate.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _registerFormKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FormTextFields(Title: "Userid",controller: _id,maxlength: 15,),
                    FormTextFields(
                      Title: "Password",
                      controller: _password,
                      maxlength: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async{
                        if(_registerFormKey.currentState!.validate())
                        {
                          if(_id.text.contains(" ") || _password.text.contains(" "))
                          {
                            showMessage("Do not include spaces in UserID and password");
                            return;
                          }
                          else{
                            User user = User(_id.text, _password.text,);
                            Firestore_helper firestore_helper = Firestore_helper();

                            if(await isUserIDAlreadyExist(user,firestore_helper))
                            {
                              createAccount(user, firestore_helper);
                            }

                          }

                        }

                      },
                      style: ButtonStyle(
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.fromLTRB(45, 15, 45, 15),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          backgroundColor:const MaterialStatePropertyAll(Colors.black)
                      ),
                      icon:const Icon(Icons.app_registration_rounded),
                      label:Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


class FormTextFields extends StatelessWidget {

  FormTextFields({super.key, required this.Title,required this.controller,required this.maxlength,this.keyboadtype});

  final String Title;
  TextEditingController controller;
  int maxlength;
  TextInputType? keyboadtype;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Title,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboadtype,
            cursorColor: Colors.grey,
            cursorHeight: 15,
            validator: (value) {
              if(value == null || value.isEmpty)
              {
                return "Field is required";
              }
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
              EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 2)
              ),
            ),
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
