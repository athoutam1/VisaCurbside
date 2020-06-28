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

  
  Store({
    this.merchantID,
    this.merchantName,
    this.storeID,
    this.storeName,
    this.description,
    this.location,
  });

  

  Store copyWith({
    String merchantID,
    String merchantName,
    int storeID,
    String storeName,
    String description,
    String location,
  }) {
    return Store(
      merchantID: merchantID ?? this.merchantID,
      merchantName: merchantName ?? this.merchantName,
      storeID: storeID ?? this.storeID,
      storeName: storeName ?? this.storeName,
      description: description ?? this.description,
      location: location ?? this.location,
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
    );
  }

  String toJson() => json.encode(toMap());

  static Store fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(merchantID: $merchantID, merchantName: $merchantName, storeID: $storeID, storeName: $storeName, description: $description, location: $location)';
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
      o.location == location;
  }

  @override
  int get hashCode {
    return merchantID.hashCode ^
      merchantName.hashCode ^
      storeID.hashCode ^
      storeName.hashCode ^
      description.hashCode ^
      location.hashCode;
  }
}
