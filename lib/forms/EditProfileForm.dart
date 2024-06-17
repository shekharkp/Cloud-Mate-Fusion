import 'package:flutter/material.dart';
import '../Database_helper/firebaseHelper.dart';
import 'package:cmf/Entities/user.dart';
import 'package:cmf/Database_helper/securedStorage.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final storage = Securedstorage();
  final Firestore_helper firestore_helper = Firestore_helper();

  Future<User> getUserInfo() async {
    var userID = await storage.getuserID();
    var user = await firestore_helper.getUserByID(userID);
    return user;
  }

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

  final TextEditingController _userid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();



  @override
  void dispose() {
    _userid.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 250, 20, 40),
            child: Column(
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333c3a)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: getUserInfo(),
                        builder: (context, AsyncSnapshot<User> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(color: Color(0xFF333c3a),));
                          } else if (snapshot.hasData) {
                            _userid.text = snapshot.data!.userid;
                            _password.text = snapshot.data!.password;
                            return Column(
                              children: [
                                FormTextFields(
                                    Title: "User Id",
                                    maxlength: 25,
                                    controller: _userid),
                                FormTextFields(
                                  Title: "Password",
                                  controller: _password,
                                  maxlength: 15,
                                ),
                              ],
                            );
                          } else {
                            _userid.text = "Failed to fetch";
                            return const Text("Failed to fetch");
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton.icon(
                        style:const ButtonStyle(
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.fromLTRB(45, 15, 45, 15),
                          ),
                          backgroundColor:
                           MaterialStatePropertyAll(Colors.black,),),
                        icon: Icon(Icons.save_rounded),
                        label:Text("Save"),
                        onPressed: () async {
                          if(_formkey.currentState!.validate())
                          {
                            if(_password.text.contains(" ") && _userid.text.contains(" "))
                            {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Don't put spaces in User Id and Password!!!")));
                              return;
                            }
                            LoadingScreen();
                            User user = User(_userid.text, _password.text,);
                            String userid = await storage.getuserID();
                            firestore_helper.Updateuser(user,userid);
                            await storage.setuserID(_userid.text);
                            Navigator.of(context).pop(context);
                            Navigator.of(context).pop(context);

                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
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