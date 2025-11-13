class ResourceModel {
  final String id;
  final String title;
  final String subject;
  final String type; // 'textbook', 'note', 'pdf', 'video'
  final String url;
  final String? thumbnailUrl;
  final String grade; // '6', '7', '8', '9'
  final int? fileSize; // in bytes
  final String? description;
  bool isDownloaded;
  String? localPath;

  ResourceModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.grade,
    this.fileSize,
    this.description,
    this.isDownloaded = false,
    this.localPath,
  });

  // Convert from JSON
  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      grade: json['grade'] ?? '',
      fileSize: json['fileSize'],
      description: json['description'],
      isDownloaded: json['isDownloaded'] ?? false,
      localPath: json['localPath'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'grade': grade,
      'fileSize': fileSize,
      'description': description,
      'isDownloaded': isDownloaded,
      'localPath': localPath,
    };
  }

  // Copy with method for updating properties
  ResourceModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? type,
    String? url,
    String? thumbnailUrl,
    String? grade,
    int? fileSize,
    String? description,
    bool? isDownloaded,
    String? localPath,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      grade: grade ?? this.grade,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? grade;
  final List<String>? challengingSubjects;
  final String? learningPreference; // 'reading', 'videos', 'both'
  final bool hasRegularInternet;
  final bool isFirstTime;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.grade,
    this.challengingSubjects,
    this.learningPreference,
    this.hasRegularInternet = false,
    this.isFirstTime = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      grade: json['grade'],
      challengingSubjects: json['challengingSubjects'] != null
          ? List<String>.from(json['challengingSubjects'])
          : null,
      learningPreference: json['learningPreference'],
      hasRegularInternet: json['hasRegularInternet'] ?? false,
      isFirstTime: json['isFirstTime'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'grade': grade,
      'challengingSubjects': challengingSubjects,
      'learningPreference': learningPreference,
      'hasRegularInternet': hasRegularInternet,
      'isFirstTime': isFirstTime,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? grade,
    List<String>? challengingSubjects,
    String? learningPreference,
    bool? hasRegularInternet,
    bool? isFirstTime,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      challengingSubjects: challengingSubjects ?? this.challengingSubjects,
      learningPreference: learningPreference ?? this.learningPreference,
      hasRegularInternet: hasRegularInternet ?? this.hasRegularInternet,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}

