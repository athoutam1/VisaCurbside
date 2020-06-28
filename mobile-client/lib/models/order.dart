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
  final String storeName;
  final double total;


  Order({
    this.id,
    this.storeID,
    this.itemIDs,
    this.shopperID,
    this.isPending,
    this.isReadyForPickup,
    this.time,
    this.storeName,
    this.total,
  });
  
  

  Order copyWith({
    int id,
    String storeID,
    List<int> itemIDs,
    String shopperID,
    int isPending,
    int isReadyForPickup,
    String time,
    String storeName,
    double total,
  }) {
    return Order(
      id: id ?? this.id,
      storeID: storeID ?? this.storeID,
      itemIDs: itemIDs ?? this.itemIDs,
      shopperID: shopperID ?? this.shopperID,
      isPending: isPending ?? this.isPending,
      isReadyForPickup: isReadyForPickup ?? this.isReadyForPickup,
      time: time ?? this.time,
      storeName: storeName ?? this.storeName,
      total: total ?? this.total,
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
      'storeName': storeName,
      'total': total,
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
      storeName: map['storeName'],
      total: map['total'],
    );
  }

  String toJson() => json.encode(toMap());

  static Order fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, storeID: $storeID, itemIDs: $itemIDs, shopperID: $shopperID, isPending: $isPending, isReadyForPickup: $isReadyForPickup, time: $time, storeName: $storeName, total: $total)';
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
      o.time == time &&
      o.storeName == storeName &&
      o.total == total;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      storeID.hashCode ^
      itemIDs.hashCode ^
      shopperID.hashCode ^
      isPending.hashCode ^
      isReadyForPickup.hashCode ^
      time.hashCode ^
      storeName.hashCode ^
      total.hashCode;
  }
}
