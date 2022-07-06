import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class PostsRepo {
  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  static getUsersForCategories(List<CategoryModel> categories) async {
    List<String> categoriesNames =
        categories.map<String>((e) => e.categoryName).toList();
    var data = await collection
        .where('store', isEqualTo: true)
        .where("postcategory", whereIn: categoriesNames)
        .get();
    return data.docs;
  }
}
