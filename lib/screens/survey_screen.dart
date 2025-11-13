import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../services/offline_service.dart';
import '../models/resource_model.dart';
import 'home_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String? _selectedGrade;
  final List<String> _selectedSubjects = [];
  String? _learningPreference;
  bool _hasRegularInternet = false;
  bool _isLoading = false;

  final List<String> _grades = ['6', '7', '8', '9'];
  final List<String> _subjects = [
    'Math',
    'Science',
    'English',
    'Kiswahili',
    'Social Studies',
    'CRE/IRE',
  ];

  Future<void> _submitSurvey() async {
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your grade'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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

      // Prepare survey data
      final surveyData = {
        'grade': _selectedGrade,
        'challengingSubjects': _selectedSubjects,
        'learningPreference': _learningPreference ?? 'both',
        'hasRegularInternet': _hasRegularInternet,
        'isFirstTime': false,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save to offline storage
      await offlineService.saveSurveyData(surveyData);
      await offlineService.setFirstTime(false);
      await offlineService.saveSelectedGrade(_selectedGrade!);

      // Save to Firebase if user is authenticated
      final currentUser = firebaseService.currentUser;
      if (currentUser != null) {
        final userData = UserModel(
          id: currentUser.uid,
          email: currentUser.email ?? '',
          name: currentUser.displayName,
          grade: _selectedGrade,
          challengingSubjects: _selectedSubjects,
          learningPreference: _learningPreference ?? 'both',
          hasRegularInternet: _hasRegularInternet,
          isFirstTime: false,
        );
        await firebaseService.saveUserData(userData);
      }

      if (!mounted) return;

      // Navigate to home screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving survey: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Welcome! Tell us about yourself'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              const Text(
                'Help us personalize your learning experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Answer a few quick questions to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Question 1: Grade
              const Text(
                '1. What grade are you in?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGrade,
                    hint: const Text('Select your grade'),
                    isExpanded: true,
                    items: _grades.map((grade) {
                      return DropdownMenuItem(
                        value: grade,
                        child: Text('Grade $grade'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedGrade = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Question 2: Challenging Subjects
              const Text(
                '2. Which subjects do you find most challenging?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _subjects.map((subject) {
                  final isSelected = _selectedSubjects.contains(subject);
                  return FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSubjects.add(subject);
                        } else {
                          _selectedSubjects.remove(subject);
                        }
                      });
                    },
                    selectedColor: const Color(
                      0xFF4CAF50,
                    ).withValues(alpha: 0.3),
                    checkmarkColor: const Color(0xFF4CAF50),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Question 3: Learning Preference
              const Text(
                '3. Do you prefer reading, watching videos, or both?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPreferenceOption('Reading', 'reading'),
                    _buildPreferenceOption('Watching Videos', 'videos'),
                    _buildPreferenceOption('Both', 'both'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Question 4: Internet Access
              const Text(
                '4. Do you have regular internet access?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: Text(_hasRegularInternet ? 'Yes' : 'No'),
                  subtitle: const Text(
                    'This helps us optimize offline features',
                  ),
                  value: _hasRegularInternet,
                  onChanged: (value) {
                    setState(() => _hasRegularInternet = value);
                  },
                  activeThumbColor: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitSurvey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceOption(String title, String value) {
    final isSelected = _learningPreference == value;
    return InkWell(
      onTap: () {
        setState(() => _learningPreference = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
