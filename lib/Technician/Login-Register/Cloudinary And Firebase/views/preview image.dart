import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Previewimage extends StatefulWidget {
  final String url;
  const Previewimage({super.key, required this.url});

  @override
  State<Previewimage> createState() => _PreviewimageState();
}

class _PreviewimageState extends State<Previewimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview")),
      body: Center(
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
