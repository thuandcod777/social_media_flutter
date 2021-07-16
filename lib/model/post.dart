class PostModel {
  String mediaUrl;

  PostModel({this.mediaUrl});

  PostModel.fromJson(Map<String, dynamic> json) {
    mediaUrl = json['mediaUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaUrl'] = this.mediaUrl;
    return data;
  }
}
