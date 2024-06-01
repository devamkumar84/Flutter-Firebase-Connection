import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:may_two/models/article.dart';

class Home extends ChangeNotifier{
  List _data = [];
  List get data => _data;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future getHomeData()async {
    QuerySnapshot rawData;
    rawData = await firestore.collection('contents').orderBy('timestamp', descending: true).get();
    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs);
    _data = _snap.map((e)=>Article.fromFirestore(e)).toList();
    notifyListeners();
  }
  onRefresh(){
    _data.clear();
    getHomeData();
    notifyListeners();
  }
}