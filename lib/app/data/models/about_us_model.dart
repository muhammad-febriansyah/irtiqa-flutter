class AboutUsModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? image;

  AboutUsModel({this.id, this.title, this.desc, this.image});

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'desc': desc, 'image': image};
  }
}
