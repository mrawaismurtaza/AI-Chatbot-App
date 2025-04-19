import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot/features/blocs/profile/profile_bloc.dart';
import 'package:chatbot/features/blocs/profile/profile_event.dart';

class ProfileImagePicker extends StatefulWidget {
  final String profilePic;
  const ProfileImagePicker({super.key, required this.profilePic});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
      if (_selectedImage != null) {
        context.read<ProfileBloc>().add(UpdateProfilePicture(_selectedImage!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: theme.colorScheme.secondary,
        backgroundImage: _selectedImage != null
            ? FileImage(_selectedImage!)
            : widget.profilePic.isNotEmpty
                ? NetworkImage(widget.profilePic) as ImageProvider
                : null,
        child: widget.profilePic.isEmpty && _selectedImage == null
            ? const Text(
                'P',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
