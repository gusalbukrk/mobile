import 'dart:convert';

import 'package:mobile/models/listing.dart';

Listings listingsFromJson(String str) => Listings.fromJson(json.decode(str));

String listingsToJson(Listings data) => json.encode(data.toJson());

class Listings {
  Embedded embedded;
  ListingsLinks links;

  Listings({
    required this.embedded,
    required this.links,
  });

  factory Listings.fromJson(Map<String, dynamic> json) => Listings(
        embedded: Embedded.fromJson(json["_embedded"]),
        links: ListingsLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "_embedded": embedded.toJson(),
        "_links": links.toJson(),
      };
}

class Embedded {
  List<Listing> listings;

  Embedded({
    required this.listings,
  });

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        listings: List<Listing>.from(
            json["listings"].map((x) => Listing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "listings": List<dynamic>.from(listings.map((x) => x.toJson())),
      };
}

// class Listing {
//   String name;
//   String? description;
//   double price;
//   int quantity;
//   ListingLinks links;

//   Listing({
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.quantity,
//     required this.links,
//   });

//   factory Listing.fromJson(Map<String, dynamic> json) => Listing(
//         name: json["name"],
//         description: json["description"],
//         price: json["price"]?.toDouble(),
//         quantity: json["quantity"],
//         links: ListingLinks.fromJson(json["_links"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "description": description,
//         "price": price,
//         "quantity": quantity,
//         "_links": links.toJson(),
//       };
// }

// class ListingLinks {
//   Profile self;
//   Profile listing;
//   Profile category;
//   Profile ordersListing;
//   Profile seller;
//   Profile tags;

//   ListingLinks({
//     required this.self,
//     required this.listing,
//     required this.category,
//     required this.ordersListing,
//     required this.seller,
//     required this.tags,
//   });

//   factory ListingLinks.fromJson(Map<String, dynamic> json) => ListingLinks(
//         self: Profile.fromJson(json["self"]),
//         listing: Profile.fromJson(json["listing"]),
//         category: Profile.fromJson(json["category"]),
//         ordersListing: Profile.fromJson(json["ordersListing"]),
//         seller: Profile.fromJson(json["seller"]),
//         tags: Profile.fromJson(json["tags"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "self": self.toJson(),
//         "listing": listing.toJson(),
//         "category": category.toJson(),
//         "ordersListing": ordersListing.toJson(),
//         "seller": seller.toJson(),
//         "tags": tags.toJson(),
//       };
// }

class Profile {
  String href;

  Profile({
    required this.href,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class ListingsLinks {
  Profile self;
  Profile profile;

  ListingsLinks({
    required this.self,
    required this.profile,
  });

  factory ListingsLinks.fromJson(Map<String, dynamic> json) => ListingsLinks(
        self: Profile.fromJson(json["self"]),
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
        "profile": profile.toJson(),
      };
}
