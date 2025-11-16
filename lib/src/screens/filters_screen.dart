import 'package:flutter/material.dart';
import 'package:job_finder_app/src/services/database_service.dart';
import 'package.provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final _formKey = GlobalKey<FormState>();

  String _keyword = '';
  String _location = '';
  String _experienceLevel = 'Entry';
  String _workType = 'Remote';
  String _jobType = 'Full-time';
  bool _easyApply = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Keyword'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter a keyword' : null,
                onChanged: (val) => setState(() => _keyword = val),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter a location' : null,
                onChanged: (val) => setState(() => _location = val),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _experienceLevel,
                decoration: const InputDecoration(labelText: 'Experience Level'),
                items: <String>['Entry', 'Mid', 'Senior']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _experienceLevel = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _workType,
                decoration: const InputDecoration(labelText: 'Work Type'),
                items: <String>['Remote', 'Hybrid', 'On-Site']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _workType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _jobType,
                decoration: const InputDecoration(labelText: 'Job Type'),
                items: <String>[
                  'Full-time',
                  'Part-time',
                  'Contract',
                  'Internship'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _jobType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              SwitchListTile(
                title: const Text('Easy Apply'),
                value: _easyApply,
                onChanged: (bool value) {
                  setState(() {
                    _easyApply = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Save Filters'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await DatabaseService(uid: user!.uid).updateFilterData(
                      _keyword,
                      _location,
                      _experienceLevel,
                      _workType,
                      _jobType,
                      _easyApply,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filters Saved')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
