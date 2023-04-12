import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/user.dart';
import 'package:news_app/providers/auth_provider.dart';

class UserRepository {
  UserRepository(this.ref);
  Ref ref;
  CollectionReference newsRef = FirebaseFirestore.instance.collection('user');

  void addUser(User user) {
    newsRef.doc(user.id).set(user.toJson());
  }

  Future<User> getUser() async {
    final userId = ref.watch(authStateProvider).value!.uid;
    final response = await newsRef.doc(userId).get();
    User user = User.fromJson(response.data() as Map<String, dynamic>);
    return user;
  }
}
