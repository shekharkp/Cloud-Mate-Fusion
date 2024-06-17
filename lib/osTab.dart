import 'package:flutter/material.dart';
import 'package:cmf/Entities/os.dart';
import 'package:cmf/Database_helper/securedStorage.dart';
import 'package:cmf/Entities/user.dart';
import 'package:cmf/Database_helper/firebaseHelper.dart';
import 'package:cmf/forms/EditProfileForm.dart';
import 'package:cmf/main.dart';
import 'package:cmf/forms/showOs.dart';

class OsTab extends StatefulWidget {
  const OsTab({super.key});

  @override
  State<OsTab> createState() => _OsTabState();
}

class _OsTabState extends State<OsTab> {
  final TextEditingController _searchBar = TextEditingController();
  final Securedstorage _securedstorage = Securedstorage();
  final Firestore_helper _firestore_helper = Firestore_helper();

  List<OS> vms = [
    OS(
      osName: "Ubuntu 20.04 LTS",
      osDescription: "Cpu 2 core  2 GB mem 20 HDD starage ",
      osimage: "lib/assets/ubuntu-logo.png",
      info:
          """Ubuntu is one of the most popular Linux distributions, known for its user-friendly interface and extensive software repository. It is based on Debian and is available in several editions, including Desktop, Server, and Core. Ubuntu is widely used both for personal computing and as a server operating system.
             \nIP/Hostname: 0.0.0.0/0
             \nPassword: mateserver
             \nSSH Link: ssh username@ipaddress""",
      Credentials: "ubuntuuser@192.0.76.5.44"
    ),
    OS(
        osName: "Cent OS stream 9",
        osDescription: "Cpu 2 core  2 GB mem 20 HDD starage",
        osimage: "lib/assets/centos-1-logo-png-transparent.png",
        info:
            """CentOS stands for "Community Enterprise Operating System." It is a Linux distribution that is widely used in server environments due to its stability and long-term support. CentOS is essentially a free version of Red Hat Enterprise Linux (RHEL), as it is built from the same source code. This makes it an excellent choice for businesses and organizations looking for a reliable operating system without the cost associated with RHEL.
                \nIP/Hostname: 0.0.0.0/0
                \nPassword: 
                \nSSH Link: ssh username@ipaddress""",
        Credentials: "centosuser@192.7.50.04"),
    OS(
        osName: "Fedora",
        osDescription: "Cpu 2 core  2 GB mem 20 HDD starage ",
        osimage: "lib/assets/ubuntu-logo.png",
        info:
            """ Fedora is a cutting-edge Linux distribution sponsored by Red Hat and known for its focus on innovation and the latest software packages. It serves as a testing ground for features that may eventually be incorporated into Red Hat Enterprise Linux (RHEL). Fedora is popular among developers and enthusiasts who want access to the newest technologies.
             \nIP/Hostname: 0.0.0.0/0
             \nPassword:defualtpasswd
             \nSSH Link: ssh username@ipaddress""",
        Credentials: "fedorauser@192.07.95.44"),
    OS(
        osName: "AlmaLinux",
        osDescription: "Cpu 2 core  2 GB mem 20 HDD starage ",
        osimage: "lib/assets/centos-1-logo-png-transparent.png",
        info:
            """ AlmaLinux is a relatively new Linux distribution created as a replacement for CentOS following CentOS's shift in focus away from its traditional role as a downstream rebuild of RHEL. AlmaLinux aims to provide a stable and community-supported alternative to CentOS, ensuring continuity for users who rely on CentOS's characteristics.
             \nIP/Hostname: 0.0.0.0/0
             \nPassword:defualtpasswd
             \nSSH Link: ssh username@ipaddress""",
        Credentials: "almauser@192.44.73.55")
  ];


  Future<String> getUserPassword() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return "${user.password}";
  }

  Future<String> getUserId() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return "${user.userid}";
  }

  Future<List<OS>> getAllOs() async {
    List<OS> Os = await vms;
    return Os;
  }

  Future<List<OS>> _search(String query, Future<List<OS>> oslist) async {
    List<OS> filteredList = [];
    await oslist.then((value) {
      value.forEach((element) {
        if (element.osName.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(element);
        }
      });
    });

    return filteredList;
  }


  ShowProfile() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              height: 300,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "User Id",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureText(
                    getText: getUserId(),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "User Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureText(
                    getText: getUserPassword(),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style:const ButtonStyle(
                              padding:  MaterialStatePropertyAll(
                                EdgeInsets.only(
                                    right: 25, left: 25, top: 12, bottom: 12),
                              ),
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                              elevation:  MaterialStatePropertyAll(10),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileForm(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit Profile"),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.only(
                                      right: 35, left: 35, top: 10, bottom: 10),
                                ),
                                textStyle: MaterialStatePropertyAll(
                                    TextStyle(color: Colors.white)),
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.black),
                                elevation: MaterialStatePropertyAll(10)),
                            onPressed: () async{
                              await _securedstorage.setLoginout("False");
                              await _securedstorage.setConnectionStatus("Disconnected");
                              await _securedstorage.sethostIP("null");
                              await _securedstorage.setusername("null");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                height: 100,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchBar(
                            controller: _searchBar,
                            shape: const MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                            hintText: "Search VMs here",
                            textStyle: const MaterialStatePropertyAll(
                                TextStyle(color: Colors.white)),
                            side: const MaterialStatePropertyAll(
                                BorderSide(color: Colors.white, width: 2)),
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.black),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              ShowProfile();
                            },
                            icon:const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 20,
                        decoration:const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                            color: Colors.white),
                      ),
                      const Text(
                        "Discover Mateservers",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20,),
                      FutureBuilder(
                        future: _search(_searchBar.text, getAllOs()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: const CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return AnimatedList(
                              initialItemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index, animation) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowOs(imageProvider: Image.asset(snapshot.data![index].osimage).image, title: snapshot.data![index].osName, content: snapshot.data![index].osDescription, info: snapshot.data![index].info,credentials: snapshot.data![index].Credentials),));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: Image.asset(snapshot
                                                          .data![index].osimage)
                                                      .image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data![index].osName,
                                                  style: TextStyle(fontSize: 20)),
                                              Text(snapshot
                                                  .data![index].osDescription),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text("Smoething went wrong"),
                            );
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FutureText extends StatefulWidget {
  const FutureText({super.key, required this.getText, required this.style});
  final Future<String> getText;
  final TextStyle style;
  @override
  State<FutureText> createState() => _FutureTextState();
}

class _FutureTextState extends State<FutureText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getText,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            style: widget.style,
          );
        } else if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: widget.style,
          );
        } else {
          return Text("Failed to fetch", style: widget.style);
        }
      },
    );
  }
}
