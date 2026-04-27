// To parse this JSON data, do
//
// final searchResultsModel = searchResultsModelFromJson(jsonString);

import 'dart:convert';

import '../../adverizing/model/advertise_model.dart';

SearchResultsModel searchResultsModelFromJson(String str) =>
    SearchResultsModel.fromJson(json.decode(str));

String searchResultsModelToJson(SearchResultsModel data) =>
    json.encode(data.toJson());

class SearchResultsModel {
  bool status;
  SearchData data;

  SearchResultsModel({
    required this.status,
    required this.data,
  });

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) =>
      SearchResultsModel(
        status: json["status"],
        data: SearchData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class SearchData {
  int currentPage;
  List<Advertise> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<PaginationLink> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  SearchData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        currentPage: json["current_page"],
        data: List<Advertise>.from(
            json["data"].map((x) => Advertise.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"] ?? 0,
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<PaginationLink>.from(
            json["links"].map((x) => PaginationLink.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class PaginationLink {
  String? url;
  String label;
  bool active;

  PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      PaginationLink(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
