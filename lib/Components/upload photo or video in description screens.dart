import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'PreviewScreen.dart';

class FilePickerWidget extends StatefulWidget {
  final String? filePath; // Accept filePath in the constructor
  final Function(String?) onFilePicked;

  FilePickerWidget({
    Key? key,
    required this.filePath,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.filePath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildCircleFilePicker(
              filePath: widget.filePath,
              onFilePicked: widget.onFilePicked,
              showError: false,
            ),
          ),
        if (widget.filePath == null) // Show the file picker if no filePath
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildCircleFilePicker(
              filePath: null,
              onFilePicked: widget.onFilePicked,
              showError: false,
            ),
          ),
      ],
    );
  }

  Widget _buildCircleFilePicker({
    required String? filePath,
    required Function(String?) onFilePicked,
    required bool showError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (filePath == null) {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: [
                  'jpg',
                  'jpeg',
                  'png',
                  'mp4',
                  'mov',
                  'avi',
                  'mp3',
                  'wav',
                  'aac',
                  'm4a',
                ],
              );
              if (result != null) {
                onFilePicked(result.files.single.path);
              }
            }
          },
          onLongPress: () {
            if (filePath != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(filePath: filePath),
                ),
              );
            }
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: showError ? Colors.red : Colors.grey,
                width: 2,
              ),
            ),
            child: filePath != null
                ? ClipOval(
                    child: (filePath.endsWith('.mp4') ||
                            filePath.endsWith('.mov') ||
                            filePath.endsWith('.avi') ||
                            filePath.endsWith('.mp3') ||
                            filePath.endsWith('.wav') ||
                            filePath.endsWith('.aac') ||
                            filePath.endsWith('.m4a'))
                        ? Icon(Icons.play_arrow, size: 28, color: Colors.grey)
                        : Image.file(
                            File(filePath),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  )
                : Icon(Icons.add, size: 28, color: Colors.grey), // "Add" icon
          ),
        ),
        const SizedBox(height: 8),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'This field is required'.tr(),
              style: GoogleFonts.castoro(color: Colors.red, fontSize: 12),
            ),
          )
      ],
    );
  }
}
