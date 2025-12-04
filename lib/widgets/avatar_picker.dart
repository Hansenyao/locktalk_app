import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final String? initialUrl;
  final void Function(File?) onImagePicked;
  final double size;

  const AvatarPicker({
    super.key,
    this.initialUrl,
    required this.onImagePicked,
    this.size = 90,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  // Select avatar photo from gallery
  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
      widget.onImagePicked(_selectedFile);
    }
  }

  // Create a avator by taking a photo
  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
      widget.onImagePicked(_selectedFile);
    }
  }

  // Avatar source selection dialog
  void _showSourceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Choose Avatar"),
        content: Text("Select image from:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickFromGallery();
            },
            child: Text("Gallery"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _takePhoto();
            },
            child: Text("Camera"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    return GestureDetector(
      onTap: _showSourceDialog,
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.grey[300],

        backgroundImage: _selectedFile != null
            ? FileImage(_selectedFile!)
            : (widget.initialUrl != null
                      ? NetworkImage(widget.initialUrl!)
                      : null)
                  as ImageProvider<Object>?,

        child: _selectedFile == null && widget.initialUrl == null
            ? Icon(Icons.add_a_photo, size: size * 0.4, color: Colors.black54)
            : null,
      ),
    );
  }
}
