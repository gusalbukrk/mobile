// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Embedded embedded;
  OrdersLinks links;

  Orders({
    required this.embedded,
    required this.links,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        embedded: Embedded.fromJson(json["_embedded"]),
        links: OrdersLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "_embedded": embedded.toJson(),
        "_links": links.toJson(),
      };
}

class Embedded {
  List<Order> orders;

  Embedded({
    required this.orders,
  });

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  DateTime date;
  double total;
  OrderLinks links;

  Order({
    required this.date,
    required this.total,
    required this.links,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        date: DateTime.parse(json["date"]),
        total: json["total"]?.toDouble(),
        links: OrderLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "total": total,
        "_links": links.toJson(),
      };
}

class OrderLinks {
  Self self;
  Self order;
  Self orderListings;
  Self buyer;
  Self review;

  OrderLinks({
    required this.self,
    required this.order,
    required this.orderListings,
    required this.buyer,
    required this.review,
  });

  factory OrderLinks.fromJson(Map<String, dynamic> json) => OrderLinks(
        self: Self.fromJson(json["self"]),
        order: Self.fromJson(json["order"]),
        orderListings: Self.fromJson(json["orderListings"]),
        buyer: Self.fromJson(json["buyer"]),
        review: Self.fromJson(json["review"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
        "order": order.toJson(),
        "orderListings": orderListings.toJson(),
        "buyer": buyer.toJson(),
        "review": review.toJson(),
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

class OrdersLinks {
  Self self;

  OrdersLinks({
    required this.self,
  });

  factory OrdersLinks.fromJson(Map<String, dynamic> json) => OrdersLinks(
        self: Self.fromJson(json["self"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
      };
}
