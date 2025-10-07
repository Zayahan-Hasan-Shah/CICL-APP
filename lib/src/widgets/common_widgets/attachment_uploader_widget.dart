import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf', 'png', 'svg'],
      allowMultiple: true,
    );

    if (result != null) {
      final newFiles = [...widget.files, ...result.files];
      widget.onChanged(newFiles); // push changes up
    }
  }

  void _removeFile(int index) {
    final newFiles = List<PlatformFile>.from(widget.files)..removeAt(index);
    widget.onChanged(newFiles); // push changes up
  }

  @override
  Widget build(BuildContext context) {
    final files = widget.files; // always take from parent
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            child: const Center(
              child: Text(
                "Select File",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (files.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final isPdf = file.extension == 'pdf';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
}
