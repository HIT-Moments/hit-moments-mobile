class Music {
  final String id;
  final String name;
  final String linkMusic;
  final String author;

  Music(
      {required this.id,
      required this.name,
      required this.linkMusic,
      required this.author});

  factory Music.fromJson(dynamic json) {
    return Music(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      linkMusic: json['link'] ?? '',
      author: json['author'] ?? '',
    );
  }
}
