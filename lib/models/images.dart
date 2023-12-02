// To parse this JSON data, do
//
//     final images = imagesFromJson(jsonString);

import 'dart:convert';

Images imagesFromJson(String str) => Images.fromJson(json.decode(str));

String imagesToJson(Images data) => json.encode(data.toJson());

class Images {
  Embedded embedded;
  ImagesLinks links;

  Images({
    required this.embedded,
    required this.links,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        embedded: Embedded.fromJson(json["_embedded"]),
        links: ImagesLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "_embedded": embedded.toJson(),
        "_links": links.toJson(),
      };
}

class Embedded {
  List<SingleImage> images;

  Embedded({
    required this.images,
  });

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        images: List<SingleImage>.from(
            json["images"].map((x) => SingleImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class SingleImage {
  // avoid collision with package:flutter/src/widgets/image.dart
  String name;
  ImageLinks links;

  SingleImage({
    required this.name,
    required this.links,
  });

  factory SingleImage.fromJson(Map<String, dynamic> json) => SingleImage(
        name: json["name"],
        links: ImageLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "_links": links.toJson(),
      };
}

class ImageLinks {
  Self self;
  Self image;

  ImageLinks({
    required this.self,
    required this.image,
  });

  factory ImageLinks.fromJson(Map<String, dynamic> json) => ImageLinks(
        self: Self.fromJson(json["self"]),
        image: Self.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
        "image": image.toJson(),
      };
}

class Self {
  String href;

  Self({
    required this.href,
  });

  factory Self.fromJson(Map<String, dynamic> json) => Self(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class ImagesLinks {
  Self self;

  ImagesLinks({
    required this.self,
  });

  factory ImagesLinks.fromJson(Map<String, dynamic> json) => ImagesLinks(
        self: Self.fromJson(json["self"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
      };
}
