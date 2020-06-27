import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Store {

  final String merchantID;
  final String merchantName;
  final int storeID;
  final String storeName;
  Store({
    this.merchantID,
    this.merchantName,
    this.storeID,
    this.storeName,
  });
  

  Store copyWith({
    String merchantID,
    String merchantName,
    int storeID,
    String storeName,
  }) {
    return Store(
      merchantID: merchantID ?? this.merchantID,
      merchantName: merchantName ?? this.merchantName,
      storeID: storeID ?? this.storeID,
      storeName: storeName ?? this.storeName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merchantID': merchantID,
      'merchantName': merchantName,
      'storeID': storeID,
      'storeName': storeName,
    };
  }

  static Store fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Store(
      merchantID: map['merchantID'],
      merchantName: map['merchantName'],
      storeID: map['storeID'],
      storeName: map['storeName'],
    );
  }

  String toJson() => json.encode(toMap());

  static Store fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(merchantID: $merchantID, merchantName: $merchantName, storeID: $storeID, storeName: $storeName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Store &&
      o.merchantID == merchantID &&
      o.merchantName == merchantName &&
      o.storeID == storeID &&
      o.storeName == storeName;
  }

  @override
  int get hashCode {
    return merchantID.hashCode ^
      merchantName.hashCode ^
      storeID.hashCode ^
      storeName.hashCode;
  }
}
