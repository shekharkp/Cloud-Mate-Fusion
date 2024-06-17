import 'package:flutter/material.dart';
import '../Database_helper/securedStorage.dart';
import '../Database_helper/firebaseHelper.dart';
import 'package:cmf/Entities/user.dart';
import '../Entities/videos.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningTab extends StatefulWidget {
  const LearningTab({super.key});
  @override
  State<LearningTab> createState() => _LearningTabState();
}

class _LearningTabState extends State<LearningTab> {

  final Securedstorage _securedstorage = Securedstorage();
  final Firestore_helper _firestore_helper = Firestore_helper();

  Future<void> _launchUrl(_url) async {

      await launchUrl(_url);
  }

  Future<String> getUsername()async
  {
    var userID = await _securedstorage.getuserID();
    User userInfo = await _firestore_helper.getUserByID(userID);
    print(userInfo.userid);
    return userInfo.userid;
  }


  Future<List<Videos>> _getAllVideos() async
  {
    return await _firestore_helper.getAllVideos();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {

        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                    future: _getAllVideos(),
                    builder: (context,AsyncSnapshot<List<Videos>> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                      {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 300),
                          child: Center(child: CircularProgressIndicator(color: Color(0xFF333c3a),)),
                        );
                      }
                      else if (snapshot.hasError)
                      {
                        return const Center(
                          heightFactor: 20,
                          child: Text(
                            "Failed to fetch,Check your connection!!!",
                            style: TextStyle(
                                color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      else if(snapshot.hasData) {
                        return AnimatedList(
                          initialItemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics:const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index, animation) {
                            return Container(
                              padding:const EdgeInsets.all(10),
                              decoration:const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  //Post_image
                                  AspectRatio(
                                    aspectRatio: 1 / 0.6,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot.data![index].content),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Post_Title
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          snapshot.data![index].title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style:const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                      const SizedBox(height: 10,),
                                      ElevatedButton(
                                        style:const ButtonStyle(
                                          backgroundColor:
                                           MaterialStatePropertyAll(
                                            Colors.black,),
                                          elevation: MaterialStatePropertyAll(
                                              8),
                                        ),
                                        onPressed: () async {
                                           final Uri _url = Uri.parse(snapshot.data![index].videoLink);
                                           print(snapshot.data![index].videoLink);
                                           print(_url);
                                            _launchUrl(_url);

                                        },
                                        child:const Text(
                                          "Watch video",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                    ],
                                  ),
                            );
                          },
                        );
                      }
                      else
                      {
                        return const Center(
                          heightFactor: 20,
                          child: Text(
                            "Videos not found!",
                            style: TextStyle(
                                color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
            ],
          ),
          ),
        ),
      );

  }
}


