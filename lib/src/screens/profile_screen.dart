import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:job_finder_app/src/models/user_model.dart';
import 'package:job_finder_app/src/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = FirebaseStorage.instance;

  String? _name;
  String? _email;
  String? _resumeUrl;

  Future<void> _uploadResume(String userId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        String fileName = 'resumes/$userId.pdf';
        await _storage.ref(fileName).putFile(file);
        String downloadURL = await _storage.ref(fileName).getDownloadURL();
        setState(() {
          _resumeUrl = downloadURL;
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamBuilder<UserModel>(
      stream: DatabaseService(uid: user!.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel? userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: userData!.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _name = val),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData.email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter an email' : null,
                      onChanged: (val) => setState(() => _email = val),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text('Upload Resume'),
                      onPressed: () => _uploadResume(user.uid),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _name ?? userData.name!,
                            _email ?? userData.email!,
                            _resumeUrl ?? userData.resumeUrl!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile Updated')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
