import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resource_model.dart';
import '../services/offline_service.dart';
import '../services/download_service.dart';
import '../widgets/resource_card.dart';
import 'category_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<ResourceModel> _downloadedResources = [];
  bool _isLoading = true;
  String _totalSize = '0 B';

  @override
  void initState() {
    super.initState();
    _loadDownloadedResources();
  }

  Future<void> _loadDownloadedResources() async {
    setState(() => _isLoading = true);

    try {
      final offlineService = Provider.of<OfflineService>(
        context,
        listen: false,
      );
      final downloadService = Provider.of<DownloadService>(
        context,
        listen: false,
      );

      final resources = await offlineService.getDownloadedResources();
      final totalBytes = await downloadService.getTotalDownloadSize();
      final formattedSize = downloadService.formatBytes(totalBytes);

      setState(() {
        _downloadedResources = resources;
        _totalSize = formattedSize;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading downloaded resources: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteResource(ResourceModel resource) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resource'),
        content: Text('Are you sure you want to delete "${resource.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final offlineService = Provider.of<OfflineService>(context, listen: false);
    final downloadService = Provider.of<DownloadService>(
      context,
      listen: false,
    );

    try {
      // Delete file from storage
      if (resource.localPath != null) {
        await downloadService.deleteFile(resource.localPath!);
      }

      // Remove from offline service
      await offlineService.removeDownloadedResource(resource.id);

      // Reload list
      await _loadDownloadedResources();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resource deleted successfully'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting resource: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewResource(ResourceModel resource) {
    if (!resource.isDownloaded || resource.localPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resource file not found'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (resource.type == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(filePath: resource.localPath!),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PDFViewerScreen(
            filePath: resource.localPath!,
            title: resource.title,
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_outlined,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Downloads Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Download resources from the learning hub to access them offline',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate back to home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedResources() {
    // Group resources by grade
    final Map<String, List<ResourceModel>> groupedByGrade = {};
    for (var resource in _downloadedResources) {
      if (!groupedByGrade.containsKey(resource.grade)) {
        groupedByGrade[resource.grade] = [];
      }
      groupedByGrade[resource.grade]!.add(resource);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: groupedByGrade.length,
      itemBuilder: (context, index) {
        final grade = groupedByGrade.keys.elementAt(index);
        final resources = groupedByGrade[grade]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Grade $grade',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ...resources.map(
              (resource) => ResourceCard(
                resource: resource,
                onView: () => _viewResource(resource),
                onDownload: () {}, // Already downloaded
                onDelete: () => _deleteResource(resource),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          'Offline Downloads',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_downloadedResources.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.storage, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _totalSize,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _downloadedResources.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Summary Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        Icons.file_download,
                        _downloadedResources.length.toString(),
                        'Resources',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),
                      _buildStat(Icons.storage, _totalSize, 'Total Size'),
                    ],
                  ),
                ),
                // Resources List
                Expanded(child: _buildGroupedResources()),
              ],
            ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
