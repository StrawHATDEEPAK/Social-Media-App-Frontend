import 'dart:convert';

class Media {
  final String? url;
  final String? mediatype;

  Media(this.url, this.mediatype);

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'mediatype': mediatype,
    };
  }

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      map['url'] ?? '',
      map['mediatype'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Media.fromJson(String source) => Media.fromMap(json.decode(source));
}
