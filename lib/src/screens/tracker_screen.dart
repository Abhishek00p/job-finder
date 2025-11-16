import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_finder_app/src/models/job_model.dart';
import 'package:job_finder_app/src/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracker'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('jobs')
            .where('status', isNotEqualTo: 'new')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              Job job = Job(
                id: document.id,
                title: data['title'],
                company: data['company'],
                location: data['location'],
                description: data['description'],
                url: data['url'],
                matchScore: data['matchScore'],
                matchReasoning: data['matchReasoning'],
                coverLetter: data['coverLetter'],
                postedDate: (data['postedDate'] as Timestamp).toDate(),
                scrapedDate: (data['scrapedDate'] as Timestamp).toDate(),
                jobType: data['jobType'],
                workType: data['workType'],
                easyApply: data['easyApply'],
                status: data['status'],
              );
              return ListTile(
                title: Text(job.title),
                subtitle: Text(job.company),
                trailing: DropdownButton<String>(
                  value: job.status,
                  items: <String>[
                    'saved',
                    'applied',
                    'interviewing',
                    'rejected',
                    'offered'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    DatabaseService(uid: user.uid)
                        .updateJobStatus(job.id, newValue!);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
