import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Lesson {
  late String name;
  late int midtermNote;
  late int finalNote;
  late int note;

  Lesson(){}

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData(Lesson lesson) async {
    try {
      await _firestore.collection('lessons').add({
        'name': lesson.name,
        'midterm': lesson.midtermNote,
        'final': lesson.finalNote,
        'note': lesson.note,
      });
      print("Veri başarıyla eklendi!");
    } catch (e) {
      print("Veri eklenirken hata oluştu: $e");
    }
  }
   Future<List<Lesson>> fetchLessons() async {
    try {
      var querySnapshot = await _firestore.collection('lessons').get();

      // Firestore verilerini Lesson nesnelerine dönüştürme
      List<Lesson> lessons = querySnapshot.docs.map((doc) {
        var data = doc.data();
        Lesson lesson=Lesson();
        lesson.name=data['name'] ?? '';
        lesson.midtermNote=data['midterm'] ?? '';
        lesson.finalNote=data['final'] ?? '';
        lesson.note=data['note'] ?? '';
          return lesson;
      }).toList();

      return lessons;
    } catch (e) {
      print("Veriler çekilirken hata oluştu: $e");
      return [];
    }
  }
}
  

