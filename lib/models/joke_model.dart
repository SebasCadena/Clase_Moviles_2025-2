class JOKE {
  List<String> categories;
  String created_at;
  String icon_url;
  String id;
  String updated_at;
  String url;
  String value;

  JOKE({
    required this.categories,
    required this.created_at,
    required this.icon_url,
    required this.id,
    required this.updated_at,
    required this.url,
    required this.value,
  });

  factory JOKE.fromJson(Map<String, dynamic> json) {
    // categories puede ser null o no ser una lista
    final cats = (json['categories'] is Iterable)
        ? List<String>.from(json['categories'])
        : <String>[];

    return JOKE(
      categories: cats,
      created_at: json['created_at']?.toString() ?? '',
      icon_url: json['icon_url']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}
