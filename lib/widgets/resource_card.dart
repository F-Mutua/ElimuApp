import 'package:flutter/material.dart';
import '../models/resource_model.dart';

class ResourceCard extends StatelessWidget {
  final ResourceModel resource;
  final VoidCallback onView;
  final VoidCallback onDownload;
  final VoidCallback? onDelete;
  final bool isDownloading;
  final double? downloadProgress;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onView,
    required this.onDownload,
    this.onDelete,
    this.isDownloading = false,
    this.downloadProgress,
  });

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'textbook':
        return Icons.menu_book;
      case 'note':
        return Icons.note;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.play_circle_fill;
      default:
        return Icons.description;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'textbook':
        return const Color(0xFF4CAF50); // Green
      case 'note':
        return const Color(0xFFFFC107); // Amber
      case 'pdf':
        return const Color(0xFFF44336); // Red
      case 'video':
        return const Color(0xFF2196F3); // Blue
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(resource.type);
    final icon = _getIconForType(resource.type);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: resource.isDownloaded ? onView : null,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.subject,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (resource.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        resource.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (isDownloading && downloadProgress != null) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: downloadProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(downloadProgress! * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Actions
              Column(
                children: [
                  if (resource.isDownloaded) ...[
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Color(0xFF4CAF50)),
                      onPressed: onView,
                      tooltip: 'View',
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                      ),
                  ] else if (isDownloading) ...[
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.download, color: Color(0xFF4CAF50)),
                      onPressed: onDownload,
                      tooltip: 'Download',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

