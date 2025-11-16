import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_finder_app/src/models/user_model.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String email, String resumeUrl) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'resumeUrl': resumeUrl,
    });
  }

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      uid: uid!,
      name: snapshot['name'],
      email: snapshot['email'],
      resumeUrl: snapshot['resumeUrl'],
    );
  }

  Stream<UserModel> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //filter collection
  final CollectionReference filterCollection =
      FirebaseFirestore.instance.collection('filters');

  Future<void> updateFilterData(
      String keyword,
      String location,
      String experienceLevel,
      String workType,
      String jobType,
      bool easyApply) async {
    return await filterCollection.doc(uid).set({
      'keyword': keyword,
      'location': location,
      'experienceLevel': experienceLevel,
      'workType': workType,
      'jobType': jobType,
      'easyApply': easyApply,
    });
  }

  Future<void> updateJobStatus(String jobId, String status) async {
    return await userCollection
        .doc(uid)
        .collection('jobs')
        .doc(jobId)
        .update({'status': status});
  }

  Future<void> toggleFavorite(String jobId, bool isFavorite) async {
    return await userCollection
        .doc(uid)
        .collection('jobs')
        .doc(jobId)
        .update({'isFavorite': isFavorite});
  }
}
