import 'package:cmf/Database_helper/securedStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cmf/forms/loginForm.dart';
import 'forms/registerForm.dart';
import 'package:cmf/appNavBar.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final storage = Securedstorage();

  verifyLogin() async {
    String? isLogin = await storage.getLoginout();
    return isLogin;
  }



  @override
  void initState() {
    verifyLogin();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Poppins"),
        home: FutureBuilder(
          future: verifyLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return snapshot.data == "True"
                  ? const AppNavBar()
                  : const MyHomePage();
            } else {
              return const Scaffold(
                body: Text("Something went wrong"),
              );
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final storage = Securedstorage();
  bool isShowingContainer = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: const Text("Do you really wanted to exit!!!"),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.black,
                    ),
                  ),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.black,
                    ),
                  ),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children:[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.asset("lib/assets/cloudmate.png"),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 150, 15, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginForm(),
                                    ));
                              },
                              icon:const Icon(
                                Icons.login_outlined,
                                size: 15,
                                color: Colors.white,
                              ),
                              label:const Text(
                                "Login",
                                style:const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                  padding:const MaterialStatePropertyAll(
                                    EdgeInsets.fromLTRB(45, 15, 45, 15),
                                  ),
                                  backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black),
                                  elevation:const MaterialStatePropertyAll(10),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>const RegisterForm(),
                                    ));
                              },
                              icon:const Icon(
                                Icons.app_registration_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              label:const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
                              ),
                              style: ButtonStyle(
                                  padding:const MaterialStatePropertyAll(
                                    EdgeInsets.fromLTRB(45, 15, 45, 15),
                                  ),
                                  elevation:const MaterialStatePropertyAll(10),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
