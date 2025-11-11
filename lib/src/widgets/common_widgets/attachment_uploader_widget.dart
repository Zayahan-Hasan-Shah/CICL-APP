import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// ---------------------------------------------------------------------------
///  PUBLIC WIDGET – use exactly like before
/// ---------------------------------------------------------------------------
class AttachmentUploader extends FormField<List<PlatformFile>> {
  AttachmentUploader({
    Key? key,
    FormFieldValidator<List<PlatformFile>>? validator,
    required Function(List<PlatformFile>) onFilesChanged,
    List<PlatformFile>? initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          key: key,
          initialValue: initialValue ?? [],
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<List<PlatformFile>> state) {
            return _AttachmentUploaderContent(
              files: state.value ?? [],
              onChanged: (files) {
                state.didChange(files);
                onFilesChanged(files);
              },
              errorText: state.errorText,
            );
          },
        );
}

/// ---------------------------------------------------------------------------
///  PRIVATE IMPLEMENTATION
/// ---------------------------------------------------------------------------
class _AttachmentUploaderContent extends StatefulWidget {
  final List<PlatformFile> files;
  final Function(List<PlatformFile>) onChanged;
  final String? errorText;

  const _AttachmentUploaderContent({
    Key? key,
    required this.files,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<_AttachmentUploaderContent> createState() =>
      _AttachmentUploaderContentState();
}

class _AttachmentUploaderContentState
    extends State<_AttachmentUploaderContent> {
  final ImagePicker _picker = ImagePicker();

  // --------------------------------------------------------------
  // 1. Pick from Gallery / Files
  // --------------------------------------------------------------
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'svg'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final newFiles = [...widget.files, ...result.files];
      widget.onChanged(newFiles);
    }
  }

  // --------------------------------------------------------------
  // 2. Take a photo with the camera
  // --------------------------------------------------------------
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // optional compression
    );

    if (photo != null) {
      // Convert XFile → PlatformFile (file_picker format)
      final platformFile = PlatformFile(
        name: photo.name,
        path: photo.path,
        size: await File(photo.path).length(),
        bytes: await photo.readAsBytes(),
      );

      final newFiles = [...widget.files, platformFile];
      widget.onChanged(newFiles);
    }
  }

  // --------------------------------------------------------------
  // 3. Remove a file
  // --------------------------------------------------------------
  void _removeFile(int index) {
    final newFiles = List<PlatformFile>.from(widget.files)..removeAt(index);
    widget.onChanged(newFiles);
  }

  // --------------------------------------------------------------
  // UI
  // --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final files = widget.files;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- ACTION ROW ----------
        Row(
          children: [
            // SELECT FILE
            Expanded(
              child: _actionButton(
                label: 'Select File',
                icon: Icons.attach_file,
                onTap: _pickFiles,
              ),
            ),
            const SizedBox(width: 12),
            // TAKE PHOTO
            Expanded(
              child: _actionButton(
                label: 'Take Photo',
                icon: Icons.camera_alt,
                onTap: _takePhoto,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ---------- LIST OF ATTACHMENTS ----------
        if (files.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final isPdf = file.extension?.toLowerCase() == 'pdf';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isPdf ? Icons.picture_as_pdf : Icons.image,
                      color: isPdf ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        file.name,
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _removeFile(index),
                    ),
                  ],
                ),
              );
            },
          ),

        // ---------- ERROR ----------
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // --------------------------------------------------------------
  // Helper: reusable button style
  // --------------------------------------------------------------
  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}