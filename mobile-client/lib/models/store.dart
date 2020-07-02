import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Store {

  final String merchantID;
  final String merchantName;
  final int storeID;
  final String storeName;
  final String description;
  final String location;
  final String imageURL;
  final String logoURL;

  
  Store({
    this.merchantID,
    this.merchantName,
    this.storeID,
    this.storeName,
    this.description,
    this.location,
    this.imageURL,
    this.logoURL,
  });

  

  Store copyWith({
    String merchantID,
    String merchantName,
    int storeID,
    String storeName,
    String description,
    String location,
    String imageURL,
    String logoURL,
  }) {
    return Store(
      merchantID: merchantID ?? this.merchantID,
      merchantName: merchantName ?? this.merchantName,
      storeID: storeID ?? this.storeID,
      storeName: storeName ?? this.storeName,
      description: description ?? this.description,
      location: location ?? this.location,
      imageURL: imageURL ?? this.imageURL,
      logoURL: logoURL ?? this.logoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merchantID': merchantID,
      'merchantName': merchantName,
      'storeID': storeID,
      'storeName': storeName,
      'description': description,
      'location': location,
      'imageURL': imageURL,
      'logoURL': logoURL,
    };
  }

  static Store fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Store(
      merchantID: map['merchantID'],
      merchantName: map['merchantName'],
      storeID: map['storeID'],
      storeName: map['storeName'],
      description: map['description'],
      location: map['location'],
      imageURL: map['imageURL'],
      logoURL: map['logoURL'],
    );
  }

  String toJson() => json.encode(toMap());

  static Store fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(merchantID: $merchantID, merchantName: $merchantName, storeID: $storeID, storeName: $storeName, description: $description, location: $location, imageURL: $imageURL, logoURL: $logoURL)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Store &&
      o.merchantID == merchantID &&
      o.merchantName == merchantName &&
      o.storeID == storeID &&
      o.storeName == storeName &&
      o.description == description &&
      o.location == location &&
      o.imageURL == imageURL &&
      o.logoURL == logoURL;
  }

  @override
  int get hashCode {
    return merchantID.hashCode ^
      merchantName.hashCode ^
      storeID.hashCode ^
      storeName.hashCode ^
      description.hashCode ^
      location.hashCode ^
      imageURL.hashCode ^
      logoURL.hashCode;
  }
}
