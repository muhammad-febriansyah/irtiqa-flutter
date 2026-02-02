class PrivacyPolicyModel {
  final String version;
  final String lastUpdated;
  final List<PrivacySection> sections;

  PrivacyPolicyModel({
    required this.version,
    required this.lastUpdated,
    required this.sections,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      version: json['version'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      sections: (json['sections'] as List<dynamic>?)
              ?.map((section) => PrivacySection.fromJson(section))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'last_updated': lastUpdated,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class PrivacySection {
  final String title;
  final String content;

  PrivacySection({
    required this.title,
    required this.content,
  });

  factory PrivacySection.fromJson(Map<String, dynamic> json) {
    return PrivacySection(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}
