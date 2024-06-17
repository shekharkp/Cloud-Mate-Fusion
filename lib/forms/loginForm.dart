import 'package:cmf/appNavbar.dart';
import 'package:cmf/Database_helper/securedStorage.dart';
import 'package:flutter/material.dart';
import 'package:cmf/Database_helper/firebaseHelper.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final storage = Securedstorage();
  final TextEditingController _userid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child: const Column(
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


  @override
  void dispose() {
    _userid.dispose();
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
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FormTextFields(Title: "Userid",maxlength: 15,controller: _userid,),
                    FormTextFields(Title: "Password",maxlength: 15,controller: _password,),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async{
                        if(_formkey.currentState!.validate())
                        {
                          LoadingScreen();
                          Firestore_helper fh = Firestore_helper();
                          final Isuseridpass = await fh.getUserbyIDPass(_userid.text,_password.text);
                          if(Isuseridpass == true)
                          {
                            await storage.setLoginout("True");
                            storage.setuserID(_userid.text);
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AppNavBar(),),);
                          }
                          else
                          {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong ID or Password")));
                          }
                        }
                      },
                      style: ButtonStyle(
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.fromLTRB(55, 15, 55, 15),
                          ),
                          backgroundColor:const MaterialStatePropertyAll(Colors.black)
                      ),
                      icon:const Icon(Icons.login_rounded),
                      label:const Text("Login"),
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
  FormTextFields({super.key,required this.Title,required this.controller,required this.maxlength});
  final String Title;
  TextEditingController controller;
  int maxlength;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Title,
            style:const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black,
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
              contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black,width: 2),
              ),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
