import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._();

  DbHelper._();

  Future<void> initFirestore() async {
    // No need to initialize Firestore explicitly, assuming Firebase is already set up in your project.
  }

  Future<void> insertData(String collection, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }

  Future<List<Map<String, dynamic>>> getData(String collection) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> updateData(String collection, String documentId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).doc(documentId).update(data);
  }

  Future<void> deleteData(String collection, String documentId) async {
    await FirebaseFirestore.instance.collection(collection).doc(documentId).delete();
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
