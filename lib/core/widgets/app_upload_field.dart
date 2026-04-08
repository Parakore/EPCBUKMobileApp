import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppUploadField extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onTap;
  final String? hint;

  const AppUploadField({
    super.key,
    required this.label,
    this.fileName,
    required this.onTap,
    this.hint = 'Click to upload PDF or Image',
  });

  @override
  Widget build(BuildContext context) {
    final bool isUploaded = fileName != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                letterSpacing: 1,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppTheme.primaryGreen.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUploaded ? AppTheme.primaryGreen : Colors.grey[300]!,
                style: isUploaded ? BorderStyle.solid : BorderStyle.solid,
                width: isUploaded ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  isUploaded ? Icons.check_circle : Icons.cloud_upload_outlined,
                  color: isUploaded ? AppTheme.primaryGreen : Colors.grey[400],
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  isUploaded ? 'Document Uploaded' : 'Select Document',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color:
                        isUploaded ? AppTheme.primaryGreen : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName ?? hint!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isUploaded ? AppTheme.primaryGreen : Colors.grey[500],
                    fontStyle: isUploaded ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
