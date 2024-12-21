import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_app/pages/FormPage.dart';

import 'models/Lesson.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Lesson> lessons = <Lesson>[];
  Lesson selectedLesson = Lesson();

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  // Dersleri yüklemek için Firestore'dan veri çekme
  Future<void> _loadLessons() async {
    Lesson lesson = Lesson();  // Lesson sınıfını kullanarak verileri alıyoruz
    List<Lesson> fetchedLessons = await lesson.fetchLessons();

    setState(() {
      lessons = fetchedLessons; // Verileri lessons listesine ekliyoruz
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Student App"),
            backgroundColor: Colors.indigoAccent,
            leading: const Icon(Icons.menu),
          ),
          body: Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) => ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all(const RoundedRectangleBorder(
                             borderRadius: BorderRadius
                                .zero, 
                          )),
                          overlayColor: WidgetStateProperty.all(Colors
                              .blueGrey),
                          animationDuration: Duration(seconds:1 ),
                        ),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height / 4,
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.amber,
                            border: Border.all(style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(lessons[index].name),
                              const Divider(
                                color: Colors.black,
                                height: 1.5,
                              ),
                              Text("Vize notu: ${lessons[index].midtermNote}"),
                              Text("Final Notu: ${lessons[index].finalNote}"),
                              Text(
                                  "Dönem içi Değerlendirme: ${lessons[index].note}"),
                            ],
                          ),
                        ),
                        onPressed: () {
                          selectedLesson = lessons[index];
                        },
                      )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    
                    onPressed: () async {
                      // Wait for the returned lessons list when popping the FormPage
                      final updatedLessons = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPage(lessons),
                        ),
                      );
                  
                      // Update the lessons list with the returned data
                      if (updatedLessons != null) {
                        setState(() {
                          lessons = updatedLessons;
                        });
                      }
                    },
                    child: Text("New Lesson "),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lessons.remove(selectedLesson);
                      });
                    },
                    child: Text("Delete the Lesson "),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    
                      onPressed: () async {
                      // Wait for the returned lessons list when popping the FormPage
                      final updatedLessons = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPage(lessons,selectedLesson: selectedLesson,),
                        ),
                      );
                  
                      // Update the lessons list with the returned data
                      if (updatedLessons != null) {
                        setState(() {
                          lessons = updatedLessons;
                        });
                      }
                    
                      
                    },
                    child: Text("Update the lesson "),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
