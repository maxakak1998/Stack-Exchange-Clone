class Tag {
  int count;
  String name;
  Tag.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        name = json['name'];
}
