import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileClient extends StatelessWidget {
  const ProfileClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfile'),
      ),
      body: const Center(
        child: Text('Perfil do Cliente'),
      )
    );
  }
}
