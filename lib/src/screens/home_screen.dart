import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_finder_app/src/models/job_model.dart';
import 'package:job_finder_app/src/widgets/job_card.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('jobs')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => const Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: 18.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(
                          width: double.infinity,
                          height: 14.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(
                          width: 100.0,
                          height: 14.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
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
              return JobCard(job: job);
            }).toList(),
          );
        },
      ),
    );
  }
}
