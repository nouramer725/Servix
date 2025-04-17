import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constents/constent.dart';

class ProfileImageWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileImageWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user-files")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("uploads")
              .snapshots(),
          builder: (context, snapshot) {
            String? personalFileUrl;
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              personalFileUrl = snapshot.data!.docs.first['personalFileUrl'];
            }

            return GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70,
                backgroundImage: personalFileUrl != null
                    ? NetworkImage(personalFileUrl)
                    : null,
                child: personalFileUrl == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
            );
          },
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: ApplicationColor,
              child: const Icon(Icons.camera_alt_outlined,
                  size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
