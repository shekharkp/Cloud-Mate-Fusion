import 'package:cmf/Entities/user.dart';
import 'package:cmf/Entities/videos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class Firestore_helper {
  final db = FirebaseFirestore.instance;

  //Methods for user
  Future<void> addUser(User user) async {
    await db.collection("Users").add(user.toJson());
  }

  Future<dynamic> getUser(User user) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query =
    await ref.where("userid", isEqualTo: user.userid).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      User user = User(
          element["userid"],
          element["password"],);
      return user;
    } else {
      return null;
    }
  }

  Future<dynamic> getUserByID(String userID) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query = await ref.where("userid", isEqualTo: userID).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      User user = User(element["userid"], element["password"],);
      return user;
    } else {
      return null;
    }
  }

  Future<bool> getUserbyIDPass(String userid, String password) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query = await ref.where("userid", isEqualTo: userid).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      if (element["userid"] == userid && element["password"] == password) {
        return true;
      }
    }
    return false;
  }

  Updateuser(User user,String userid) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query =
    await ref.where("userid", isEqualTo: userid).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update(user.toJson());
  }


  Future<List<Videos>> getAllVideos() async {
    CollectionReference collectionReference = await db.collection("Videos");
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Videos> videos = [];
    querySnapshot.docs.forEach(
          (element) {
        videos.add(
          Videos(
            element["videoId"],
            element["title"],
            element["content"],
            element["imagePath"],
            element["videoLink"]
          ),
        );
      },
    );
    return videos;
  }

}

