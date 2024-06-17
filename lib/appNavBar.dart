import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cmf/osTab.dart';
import 'package:cmf/learningTab.dart';
import 'package:cmf/terminalTab.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {

  List<Widget> Pages = [ TerminalTab(), const OsTab(), const LearningTab(),];
  int index = 1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
              backgroundColor: const Color(0xFFe4e2e5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child:const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child:const Text("Yes"),
                ),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor:Colors.white,
        extendBody: true,
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                backgroundColor:Colors.white,
                elevation: 0,
                selectedIconTheme:const IconThemeData(
                  size: 25,
                ),
                unselectedIconTheme:const IconThemeData(
                  size: 22,
                ),
                selectedLabelStyle:const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                selectedItemColor: Colors.black,
                enableFeedback: true,
                unselectedItemColor:Colors.black,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                currentIndex: index,
                onTap: (value) {
                  setState(
                        () {
                      index = value;
                    },
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.code_off_rounded,
                    ),
                    activeIcon: Icon(
                      Icons.code_rounded,
                    ),
                    label: "Terminal",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_filled),
                      label: "Home"
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.video_collection_outlined,
                    ),
                    label: "Learning",
                    activeIcon: Icon(
                      Icons.video_collection_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body:  Pages[index],
      ),
    );
  }
}
