import 'package:cloud_firestore/cloud_firestore.dart';

class Article{
  String? title;
  String? desc;
  String? image;
  String? timestamp;

  Article({
    this.title,
    this.desc,
    this.image,
    this.timestamp
});
  factory Article.fromFirestore(DocumentSnapshot snapshot){
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Article(
      title: d['title'],
      desc: d['description'],
      image: d['thumbnail'],
      timestamp: d['timestamp']
    );
  }
}