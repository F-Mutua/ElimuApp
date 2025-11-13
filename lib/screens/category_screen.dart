import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/resource_model.dart';
import '../widgets/resource_card.dart';
import '../services/download_service.dart';
import '../services/offline_service.dart';
import '../services/firebase_service.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class CategoryScreen extends StatefulWidget {
  final String grade;

  const CategoryScreen({super.key, required this.grade});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ResourceModel> _allResources = [];
  List<ResourceModel> _textbooks = [];
  List<ResourceModel> _notes = [];
  List<ResourceModel> _pdfs = [];
  List<ResourceModel> _videos = [];
  bool _isLoading = true;
  final Map<String, bool> _downloadingResources = {};
  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadResources();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);

    try {
      final firebaseService = Provider.of<FirebaseService>(
        context,
        listen: false,
      );
      final offlineService = Provider.of<OfflineService>(
        context,
        listen: false,
      );

      List<ResourceModel> resources = [];

      // Try to load from Firestore first
      try {
        resources = await firebaseService.getResourcesByGrade(widget.grade);
        debugPrint('Loaded ${resources.length} resources from Firestore');
      } catch (firestoreError) {
        debugPrint(
          'Firestore error: $firestoreError. Falling back to local JSON.',
        );

        // Fallback to local JSON file if Firestore fails
        final String jsonString = await rootBundle.loadString(
          'data/grade${widget.grade}.json',
        );
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        // Parse textbooks
        if (jsonData['textbooks'] != null) {
          for (var item in jsonData['textbooks']) {
            resources.add(
              ResourceModel.fromJson({
                ...item,
                'type': 'textbook',
                'grade': widget.grade,
              }),
            );
          }
        }

        // Parse notes
        if (jsonData['notes'] != null) {
          for (var item in jsonData['notes']) {
            resources.add(
              ResourceModel.fromJson({
                ...item,
                'type': 'note',
                'grade': widget.grade,
              }),
            );
          }
        }

        // Parse PDFs
        if (jsonData['pdfs'] != null) {
          for (var item in jsonData['pdfs']) {
            resources.add(
              ResourceModel.fromJson({
                ...item,
                'type': 'pdf',
                'grade': widget.grade,
              }),
            );
          }
        }

        // Parse videos
        if (jsonData['videos'] != null) {
          for (var item in jsonData['videos']) {
            resources.add(
              ResourceModel.fromJson({
                ...item,
                'type': 'video',
                'grade': widget.grade,
              }),
            );
          }
        }

        debugPrint('Loaded ${resources.length} resources from local JSON');
      }

      // Check which resources are downloaded
      final downloadedResources = await offlineService.getDownloadedResources();

      for (var resource in resources) {
        final downloaded = downloadedResources.firstWhere(
          (r) => r.id == resource.id,
          orElse: () => resource,
        );
        resource.isDownloaded = downloaded.isDownloaded;
        resource.localPath = downloaded.localPath;
      }

      if (!mounted) return;

      setState(() {
        _allResources = resources;
        _textbooks = resources.where((r) => r.type == 'textbook').toList();
        _notes = resources.where((r) => r.type == 'note').toList();
        _pdfs = resources.where((r) => r.type == 'pdf').toList();
        _videos = resources.where((r) => r.type == 'video').toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading resources: $e');

      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading resources: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadResource(ResourceModel resource) async {
    setState(() {
      _downloadingResources[resource.id] = true;
      _downloadProgress[resource.id] = 0.0;
    });

    try {
      final downloadService = Provider.of<DownloadService>(
        context,
        listen: false,
      );
      final offlineService = Provider.of<OfflineService>(
        context,
        listen: false,
      );

      final localPath = await downloadService.downloadFile(resource, (
        received,
        total,
      ) {
        setState(() {
          _downloadProgress[resource.id] = received / total;
        });
      });

      if (localPath != null) {
        final updatedResource = resource.copyWith(
          isDownloaded: true,
          localPath: localPath,
        );

        await offlineService.saveDownloadedResource(updatedResource);

        setState(() {
          final index = _allResources.indexWhere((r) => r.id == resource.id);
          if (index != -1) {
            _allResources[index] = updatedResource;
          }
          _downloadingResources[resource.id] = false;
          _downloadProgress.remove(resource.id);
        });

        _loadResources(); // Reload to update UI

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Downloaded Successfully!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _downloadingResources[resource.id] = false;
        _downloadProgress.remove(resource.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
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
          content: Text('Please download the resource first'),
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

  Widget _buildResourceList(List<ResourceModel> resources) {
    if (resources.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No resources available yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return ResourceCard(
          resource: resource,
          onView: () => _viewResource(resource),
          onDownload: () => _downloadResource(resource),
          isDownloading: _downloadingResources[resource.id] ?? false,
          downloadProgress: _downloadProgress[resource.id],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          'Grade ${widget.grade} Learning Hub',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Textbooks', icon: Icon(Icons.menu_book, size: 20)),
            Tab(text: 'Notes', icon: Icon(Icons.note, size: 20)),
            Tab(text: 'PDFs', icon: Icon(Icons.picture_as_pdf, size: 20)),
            Tab(text: 'Videos', icon: Icon(Icons.play_circle_fill, size: 20)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildResourceList(_textbooks),
                _buildResourceList(_notes),
                _buildResourceList(_pdfs),
                _buildResourceList(_videos),
              ],
            ),
    );
  }
}

// PDF Viewer Screen
class PDFViewerScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const PDFViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}

// Video Player Screen (placeholder - will be implemented with chewie)
class VideoPlayerScreen extends StatelessWidget {
  final String filePath;

  const VideoPlayerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Video player will be implemented here')),
    );
  }
}
