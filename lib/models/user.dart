import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String email;
  String? cpf;
  String? cnpj;
  UserLinks links;

  User({
    required this.email,
    this.cpf,
    this.cnpj,
    required this.links,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        cpf: json["cpf"],
        cnpj: json["cnpj"],
        links: UserLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "cpf": cpf,
        "cnpj": cnpj,
        "_links": links.toJson(),
      };
}

class UserLinks {
  UserLinksLink self;

  // buyer properties
  UserLinksLink? buyer;
  UserLinksLink? orders;

  // seller properties
  UserLinksLink? seller;
  UserLinksLink? listings;

  UserLinks({
    required this.self,
    this.buyer,
    this.orders,
    this.seller,
    this.listings,
  });

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: UserLinksLink.fromJson(json["self"]),
        buyer: json["buyer"] == null
            ? null
            : UserLinksLink.fromJson(json["buyer"]),
        orders: json["orders"] == null
            ? null
            : UserLinksLink.fromJson(json["orders"]),
        seller: json["seller"] == null
            ? null
            : UserLinksLink.fromJson(json["seller"]),
        listings: json["listings"] == null
            ? null
            : UserLinksLink.fromJson(json["listings"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
        "buyer": buyer?.toJson(),
        "orders": orders?.toJson(),
        "seller": seller?.toJson(),
        "listings": listings?.toJson(),
      };
}

class UserLinksLink {
  String href;

  UserLinksLink({
    required this.href,
  });

  factory UserLinksLink.fromJson(Map<String, dynamic> json) => UserLinksLink(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}
