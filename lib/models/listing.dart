import 'dart:convert';

Listing listingFromJson(String str) => Listing.fromJson(json.decode(str));

String listingToJson(Listing data) => json.encode(data.toJson());

class Listing {
  String name;
  String? description;
  double price;
  int quantity;
  Links links;

  Listing({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.links,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        links: Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "quantity": quantity,
        "_links": links.toJson(),
      };
}

class Links {
  Category self;
  Category listing;
  Category category;
  Category ordersListing;
  Category seller;
  Category tags;

  Links({
    required this.self,
    required this.listing,
    required this.category,
    required this.ordersListing,
    required this.seller,
    required this.tags,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: Category.fromJson(json["self"]),
        listing: Category.fromJson(json["listing"]),
        category: Category.fromJson(json["category"]),
        ordersListing: Category.fromJson(json["ordersListing"]),
        seller: Category.fromJson(json["seller"]),
        tags: Category.fromJson(json["tags"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
        "listing": listing.toJson(),
        "category": category.toJson(),
        "ordersListing": ordersListing.toJson(),
        "seller": seller.toJson(),
        "tags": tags.toJson(),
      };
}

class Category {
  String href;

  Category({
    required this.href,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}
