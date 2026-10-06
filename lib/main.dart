import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentRegistrationPage(),
    );
  }
}

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final nameController = TextEditingController();
  final sectionController = TextEditingController();
  final yearLevelController = TextEditingController();

  void nextPage() {
    if (nameController.text.trim().isEmpty ||
        sectionController.text.trim().isEmpty ||
        yearLevelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectSchedulePage(
          name: nameController.text.trim(),
          section: sectionController.text.trim(),
          yearLevel: yearLevelController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    yearLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: sectionController,
              decoration: const InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: yearLevelController,
              decoration: const InputDecoration(
                labelText: 'Yr. Level',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: nextPage,
                child: const Text('NEXT', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectSchedulePage extends StatefulWidget {
  final String name;
  final String section;
  final String yearLevel;

  const SubjectSchedulePage({
    super.key,
    required this.name,
    required this.section,
    required this.yearLevel,
  });

  @override
  State<SubjectSchedulePage> createState() => _SubjectSchedulePageState();
}

class _SubjectSchedulePageState extends State<SubjectSchedulePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final subject1Controller = TextEditingController();
  final schedule1Controller = TextEditingController();

  final subject2Controller = TextEditingController();
  final schedule2Controller = TextEditingController();

  final subject3Controller = TextEditingController();
  final schedule3Controller = TextEditingController();

  bool isSaving = false;

  Future<void> saveData() async {
    if (subject1Controller.text.trim().isEmpty ||
        schedule1Controller.text.trim().isEmpty ||
        subject2Controller.text.trim().isEmpty ||
        schedule2Controller.text.trim().isEmpty ||
        subject3Controller.text.trim().isEmpty ||
        schedule3Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all subjects and schedules'),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await firestore.collection('students').add({
        'name': widget.name,
        'section': widget.section,
        'yearLevel': widget.yearLevel,

        'subjects': [
          {
            'subject': subject1Controller.text.trim(),
            'schedule': schedule1Controller.text.trim(),
          },
          {
            'subject': subject2Controller.text.trim(),
            'schedule': schedule2Controller.text.trim(),
          },
          {
            'subject': subject3Controller.text.trim(),
            'schedule': schedule3Controller.text.trim(),
          },
        ],

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentProfilePage(
            name: widget.name,
            section: widget.section,
            yearLevel: widget.yearLevel,
            subject1: subject1Controller.text.trim(),
            schedule1: schedule1Controller.text.trim(),
            subject2: subject2Controller.text.trim(),
            schedule2: schedule2Controller.text.trim(),
            subject3: subject3Controller.text.trim(),
            schedule3: schedule3Controller.text.trim(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    subject1Controller.dispose();
    schedule1Controller.dispose();

    subject2Controller.dispose();
    schedule2Controller.dispose();

    subject3Controller.dispose();
    schedule3Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Schedule'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: subject1Controller,
              decoration: const InputDecoration(
                labelText: 'Subject 1',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: schedule1Controller,
              decoration: const InputDecoration(
                labelText: 'Schedule 1',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: subject2Controller,
              decoration: const InputDecoration(
                labelText: 'Subject 2',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: schedule2Controller,
              decoration: const InputDecoration(
                labelText: 'Schedule 2',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: subject3Controller,
              decoration: const InputDecoration(
                labelText: 'Subject 3',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: schedule3Controller,
              decoration: const InputDecoration(
                labelText: 'Schedule 3',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveData,
                child: Text(
                  isSaving ? 'SAVING...' : 'SAVE',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentProfilePage extends StatelessWidget {
  final String name;
  final String section;
  final String yearLevel;

  final String subject1;
  final String schedule1;

  final String subject2;
  final String schedule2;

  final String subject3;
  final String schedule3;

  const StudentProfilePage({
    super.key,
    required this.name,
    required this.section,
    required this.yearLevel,
    required this.subject1,
    required this.schedule1,
    required this.subject2,
    required this.schedule2,
    required this.subject3,
    required this.schedule3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text('Name: $name', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Text('Section: $section', style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Text(
              'Year Level: $yearLevel',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            const Text(
              'Subject Schedule',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(title: Text(subject1), subtitle: Text(schedule1)),
            ),

            Card(
              child: ListTile(title: Text(subject2), subtitle: Text(schedule2)),
            ),

            Card(
              child: ListTile(title: Text(subject3), subtitle: Text(schedule3)),
            ),
          ],
        ),
      ),
    );
  }
}
