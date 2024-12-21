import 'package:flutter/material.dart';
import '../models/Lesson.dart';

class FormPage extends StatefulWidget {
  final List<Lesson> lessons;
  final Lesson? selectedLesson;

  FormPage(this.lessons, {this.selectedLesson});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  

  GlobalKey<FormState> _formKey = GlobalKey();
  late Lesson selectedLesson;

  final nameController = TextEditingController();
  final midtermController = TextEditingController();
  final finalController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLesson = widget.selectedLesson ?? Lesson(); // Eğer selectedLesson null ise, yeni bir Lesson objesi oluşturuyoruz
  }

  @override
  void dispose() {
    nameController.dispose();
    midtermController.dispose();
    finalController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
                widget.selectedLesson == null ? "New Lesson" : "Edit Lesson"),
            backgroundColor: Colors.lightBlue,
          ),
          body: Container(
            padding: EdgeInsets.all(15),
            child: createForm(_formKey),
          ),
        ),
      ),
    );
  }

  Widget createForm(GlobalKey<FormState> _formKey) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Ders Adı:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen ders adını girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: midtermController,
            decoration: const InputDecoration(labelText: 'Vize Notu:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen vize notunuzu girin';
              }
              final number = int.tryParse(value);
              if (number == null) {
                return 'Geçersiz sayı';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: finalController,
            decoration: const InputDecoration(labelText: 'Final notu:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen final notunuzu girin';
              }
              final number = int.tryParse(value);
              if (number == null) {
                return 'Geçersiz sayı';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 5),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Dönem içi not:'),
            controller: noteController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen değerlendirme notunuzu girin';
              }
              final number = int.tryParse(value);
              if (number == null) {
                return 'Geçersiz sayı';
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Lesson lesson = Lesson();
                lesson.name = nameController.text;
                lesson.midtermNote = int.parse(midtermController.text);
                lesson.finalNote = int.parse(finalController.text);
                lesson.note = int.parse(noteController.text);

                if (widget.selectedLesson != null) {
                  
                  widget.lessons[
                      widget.lessons.indexOf(widget.selectedLesson!)] = lesson;
                } else {
                  lesson.addData(lesson);
                  widget.lessons.add(lesson);
                }

                setState(() {});
                Navigator.pop(context, widget.lessons);
              }
            },
            child: Text(widget.selectedLesson == null ? "Kaydet" : "Güncelle"),
          ),
        ],
      ),
    );
  }
}
