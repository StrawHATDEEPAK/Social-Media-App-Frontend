// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

// List<News> newsFromJson(String str) =>
//     List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  News({
    required this.status,
    required this.totalHits,
    required this.page,
    required this.totalPages,
    required this.pageSize,
    required this.articles,
    required this.userInput,
  });

  String status;
  int totalHits;
  int page;
  int totalPages;
  int pageSize;
  List<Article> articles;
  UserInput userInput;

  factory News.fromJson(Map<String, dynamic> json) => News(
        status: json["status"],
        totalHits: json["total_hits"],
        page: json["page"],
        totalPages: json["total_pages"],
        pageSize: json["page_size"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
        userInput: UserInput.fromJson(json["user_input"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total_hits": totalHits,
        "page": page,
        "total_pages": totalPages,
        "page_size": pageSize,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
        "user_input": userInput.toJson(),
      };
}

class Article {
  Article({
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.publishedDatePrecision,
    required this.link,
    required this.cleanUrl,
    required this.excerpt,
    required this.summary,
    required this.rights,
    required this.rank,
    required this.topic,
    required this.country,
    this.language,
    required this.authors,
    required this.media,
    required this.isOpinion,
    this.twitterAccount,
    required this.score,
    required this.id,
  });

  String title;
  String author;
  DateTime publishedDate;
  PublishedDatePrecision? publishedDatePrecision;
  String link;
  String cleanUrl;
  String? excerpt;
  String? summary;
  String? rights;
  int rank;
  Topic? topic;
  Country? country;
  Language? language;
  String? authors;
  String? media;
  bool isOpinion;
  String? twitterAccount;
  double score;
  String? id;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        author: json["author"],
        publishedDate: DateTime.parse(json["published_date"]),
        publishedDatePrecision:
            publishedDatePrecisionValues.map[json["published_date_precision"]],
        link: json["link"],
        cleanUrl: json["clean_url"],
        excerpt: json["excerpt"],
        summary: json["summary"],
        rights: json["rights"],
        rank: json["rank"],
        topic: topicValues.map[json["topic"]],
        country: countryValues.map[json["country"]],
        language: languageValues.map[json["language"]],
        authors: json["authors"],
        media: json["media"],
        isOpinion: json["is_opinion"],
        twitterAccount: json["twitter_account"],
        score: json["_score"]?.toDouble(),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "published_date": publishedDate.toIso8601String(),
        "published_date_precision":
            publishedDatePrecisionValues.reverse[publishedDatePrecision],
        "link": link,
        "clean_url": cleanUrl,
        "excerpt": excerpt,
        "summary": summary,
        "rights": rights,
        "rank": rank,
        "topic": topicValues.reverse[topic],
        "country": countryValues.reverse[country],
        "language": languageValues.reverse[language],
        "authors": authors,
        "media": media,
        "is_opinion": isOpinion,
        "twitter_account": twitterAccount,
        "_score": score,
        "_id": id,
      };
}

enum Country { US, UNKNOWN, GB, LB, RU, FR, CA }

final countryValues = EnumValues({
  "CA": Country.CA,
  "FR": Country.FR,
  "GB": Country.GB,
  "LB": Country.LB,
  "RU": Country.RU,
  "unknown": Country.UNKNOWN,
  "US": Country.US
});

enum Language { EN, DE, AF }

final languageValues =
    EnumValues({"af": Language.AF, "de": Language.DE, "en": Language.EN});

enum PublishedDatePrecision { FULL, TIMEZONE_UNKNOWN }

final publishedDatePrecisionValues = EnumValues({
  "full": PublishedDatePrecision.FULL,
  "timezone unknown": PublishedDatePrecision.TIMEZONE_UNKNOWN
});

enum Topic { WORLD, NEWS, POLITICS }

final topicValues = EnumValues(
    {"news": Topic.NEWS, "politics": Topic.POLITICS, "world": Topic.WORLD});

class UserInput {
  UserInput({
    required this.q,
    required this.searchIn,
    this.lang,
    this.notLang,
    this.countries,
    this.notCountries,
    required this.from,
    this.to,
    required this.rankedOnly,
    this.fromRank,
    required this.toRank,
    required this.sortBy,
    required this.page,
    required this.size,
    this.sources,
    this.notSources,
    this.topic,
    this.publishedDatePrecision,
  });

  String q;
  List<String> searchIn;
  dynamic lang;
  dynamic notLang;
  dynamic countries;
  dynamic notCountries;
  DateTime from;
  dynamic to;
  String rankedOnly;
  dynamic fromRank;
  dynamic toRank;
  String sortBy;
  int page;
  int size;
  dynamic sources;
  dynamic notSources;
  dynamic topic;
  dynamic publishedDatePrecision;

  factory UserInput.fromJson(Map<String, dynamic> json) => UserInput(
        q: json["q"],
        searchIn: List<String>.from(json["search_in"].map((x) => x)),
        lang: json["lang"],
        notLang: json["not_lang"],
        countries: json["countries"],
        notCountries: json["not_countries"],
        from: DateTime.parse(json["from"]),
        to: json["to"],
        rankedOnly: json["ranked_only"],
        fromRank: json["from_rank"],
        toRank: json["to_rank"],
        sortBy: json["sort_by"],
        page: json["page"],
        size: json["size"],
        sources: json["sources"],
        notSources: json["not_sources"],
        topic: json["topic"],
        publishedDatePrecision: json["published_date_precision"],
      );

  Map<String, dynamic> toJson() => {
        "q": q,
        "search_in": List<dynamic>.from(searchIn.map((x) => x)),
        "lang": lang,
        "not_lang": notLang,
        "countries": countries,
        "not_countries": notCountries,
        "from": from.toIso8601String(),
        "to": to,
        "ranked_only": rankedOnly,
        "from_rank": fromRank,
        "to_rank": toRank,
        "sort_by": sortBy,
        "page": page,
        "size": size,
        "sources": sources,
        "not_sources": notSources,
        "topic": topic,
        "published_date_precision": publishedDatePrecision,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
