// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/widgets/custom_button.dart';

import '../provider/auth_provider.dart';
import '../provider/list_provider.dart';
import '../provider/upload_provider.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Story',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              context.watch<UploadProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 300,
                      ),
                    )
                  : _showImage(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                        hintText: 'Gallery', function: () => _onGalleryView()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                        hintText: 'Camera', function: () => _onCameraView()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF94c8ff),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                  hintText: 'Upload',
                  function: () =>
                      _onUpload(context.read<AuthProvider>().token)),
            ],
          ),
        ),
      ),
    );
  }

  _onUpload(String token) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();

    final imagePath = uploadProvider.imagePath;
    final imageFile = uploadProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(
      token,
      _descriptionController.text,
      newBytes,
      fileName,
    );

    if (uploadProvider.uploadResponse != null) {
      uploadProvider.setImageFile(null);
      uploadProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );

    if (uploadProvider.message.contains("success")) {
      _descriptionController.clear();
      context
          .read<StoryListProvider>()
          .fetchStoryList(context.read<AuthProvider>().token);
      context.pop();
    }
  }

  _onGalleryView() async {
    final provider = context.read<UploadProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<UploadProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<UploadProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
