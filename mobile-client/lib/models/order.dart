import 'dart:convert';

import 'package:collection/collection.dart';

class Order {
  final int id;
  final String storeID;
  final List<int> itemIDs;
  final String shopperID;
  final int isPending;
  final int isReadyForPickup;
  final String time;

  Order({
    this.id,
    this.storeID,
    this.itemIDs,
    this.shopperID,
    this.isPending,
    this.isReadyForPickup,
    this.time,
  });

  

  Order copyWith({
    int id,
    String storeID,
    List<int> itemIDs,
    String shopperID,
    bool isPending,
    bool isReadyForPickup,
    String time,
  }) {
    return Order(
      id: id ?? this.id,
      storeID: storeID ?? this.storeID,
      itemIDs: itemIDs ?? this.itemIDs,
      shopperID: shopperID ?? this.shopperID,
      isPending: isPending ?? this.isPending,
      isReadyForPickup: isReadyForPickup ?? this.isReadyForPickup,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeID': storeID,
      'itemIDs': itemIDs,
      'shopperID': shopperID,
      'isPending': isPending,
      'isReadyForPickup': isReadyForPickup,
      'time': time,
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Order(
      id: map['id'],
      storeID: map['storeID'],
      itemIDs: List<int>.from(map['itemIDs']),
      shopperID: map['shopperID'],
      isPending: map['isPending'],
      isReadyForPickup: map['isReadyForPickup'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  static Order fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, storeID: $storeID, itemIDs: $itemIDs, shopperID: $shopperID, isPending: $isPending, isReadyForPickup: $isReadyForPickup, time: $time)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return o is Order &&
      o.id == id &&
      o.storeID == storeID &&
      listEquals(o.itemIDs, itemIDs) &&
      o.shopperID == shopperID &&
      o.isPending == isPending &&
      o.isReadyForPickup == isReadyForPickup &&
      o.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      storeID.hashCode ^
      itemIDs.hashCode ^
      shopperID.hashCode ^
      isPending.hashCode ^
      isReadyForPickup.hashCode ^
      time.hashCode;
  }
}
