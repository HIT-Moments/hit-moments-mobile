class MomentModel{

  final String? userID;
  final String? imgAvatar;
  final String? userName;
  final String? image;
  final String? uploadLocation;
  final bool? isDeleted;
  final DateTime? createAt;
  final DateTime? updateAt;
  final String? momentID;
  final String? content;
  final String? weather;
  final String? musicId;
  final String? linkMusic;

  MomentModel( {
    this.imgAvatar,
    this.userName,
    this.userID,
    this.image,
    this.uploadLocation,
    this.isDeleted,
    this.createAt,
    this.updateAt,
    this.momentID,
    this.content,
    this.weather,
    this.musicId,
    this.linkMusic,
  });

  factory MomentModel.fromJson(Map<String, dynamic> json){
    return MomentModel(
      momentID: json['_id'],
      userID: json['user']['id'],
      userName: json['user']['fullname'],
      imgAvatar: json['user']['avatar'],
      uploadLocation: json['uploadLocation'],
      isDeleted: json['isDeleted'],
      image: json['image'],
      content: json['content'],
      weather: json['weather'],
      createAt: DateTime.parse(json['createdAt']),
      updateAt: DateTime.parse(json['updatedAt']),
      musicId: json['musicId'],
      linkMusic: json['linkMusic'],
    );
  }


}