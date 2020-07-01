import 'dart:convert';

class Item {
  final int id;
  final String name;
  final double price;
  final String imageURL;
  final String description;

  
  
  Item({
    this.id,
    this.name,
    this.price,
    this.imageURL,
    this.description,
  });

  

  Item copyWith({
    int id,
    String name,
    double price,
    String imageURL,
    String description,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageURL: imageURL ?? this.imageURL,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageURL': imageURL,
      'description': description,
    };
  }

  static Item fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Item(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imageURL: map['imageURL'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  static Item fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, name: $name, price: $price, imageURL: $imageURL, description: $description)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Item &&
      o.id == id &&
      o.name == name &&
      o.price == price &&
      o.imageURL == imageURL &&
      o.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      imageURL.hashCode ^
      description.hashCode;
  }
}
