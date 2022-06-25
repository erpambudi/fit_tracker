import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_tracker/models/weight_model.dart';

class WeightServices {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('weights');

  Future<void> addWeight(WeightModel weight) async {
    try {
      await collection.doc().set(weight.toJson());
    } catch (e) {
      throw Exception("Error adding weight");
    }
  }

  Future<void> removeWeight(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      throw Exception("Error remove weight");
    }
  }

  Future<void> updateWeight(String id, double weight) async {
    try {
      await collection.doc(id).update({"weight": weight});
    } catch (e) {
      throw Exception("Error update weight");
    }
  }

  Future<List<WeightModel>> getAllWeight(String uid) async {
    QuerySnapshot snapshot = await collection
        .where("uid", isEqualTo: uid)
        .orderBy("date", descending: true)
        .get();
    try {
      return snapshot.docs
          .map((e) => WeightModel(
                id: e.id,
                uid: e["uid"],
                date: DateTime.fromMillisecondsSinceEpoch(e["date"]),
                weight: e["weight"],
              ))
          .toList();
    } catch (e) {
      throw Exception("Error getting weights");
    }
  }
}
