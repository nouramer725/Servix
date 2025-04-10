import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../Theme/Theme_Provider.dart';

class PreviewScreen extends StatefulWidget {
  final String filePath;
  const PreviewScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.filePath.endsWith('.mp4') ||
        widget.filePath.endsWith('.mov') ||
        widget.filePath.endsWith('.avi')) {
      _controller = VideoPlayerController.file(File(widget.filePath))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? const Color(0xFF333739)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? const Color(0xFF333739)
            : Colors.white,
        title: Text('Preview', style: GoogleFonts.castoro(fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.filePath.endsWith('.mp4') ||
                widget.filePath.endsWith('.mov') ||
                widget.filePath.endsWith('.avi')
            ? _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator()
            : Image.file(
                File(widget.filePath),
              ),
      ),
      floatingActionButton: widget.filePath.endsWith('.mp4') ||
              widget.filePath.endsWith('.mov') ||
              widget.filePath.endsWith('.avi') ||
              widget.filePath.endsWith('.wmv')
          ? FloatingActionButton(
              backgroundColor: ApplicationColor,
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
