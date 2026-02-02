class AppSettingsModel {
  final String? appName;
  final String? logo;
  final String? tagline;
  final String? description;

  AppSettingsModel({
    this.appName,
    this.logo,
    this.tagline,
    this.description,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      appName: json['app_name'] as String?,
      logo: json['logo'] as String?,
      tagline: json['tagline'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'logo': logo,
      'tagline': tagline,
      'description': description,
    };
  }
}
