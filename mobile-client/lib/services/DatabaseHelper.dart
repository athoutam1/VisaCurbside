import 'package:http/http.dart' as http;
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/models/item.dart';
import 'dart:convert';
import 'package:visa_curbside/models/order.dart';


class DatabaseHelper {

  Future<List<Store>> getStores(String query) async {
    List<Store> storesList = new List<Store>();
    http.Response res = await http.get('http://localhost:3005/merchant/search?query=' + query);
    List<dynamic> responses = jsonDecode(res.body);
    responses.forEach((element) {
      storesList.add(Store.fromMap(element));
    });
    return storesList;
  }

  Future<List<Item>> getItems(String query, int storeID) async {
    List<Item> itemsList = new List<Item>();
    http.Response res = await http.get('http://localhost:3005/merchant/itemSearch?query=' + query + '&storeID=' + storeID.toString());
    List<dynamic> responses = jsonDecode(res.body);
    responses.forEach((element) {
      itemsList.add(Item.fromMap(element));
    });
    return itemsList;
  }

  Future<List<Item>> getItemsFromIDs(List<int> items)  async {
    List<Item> itemsList = new List();
    items.forEach((element) async {
      http.Response res = await http.get('http://localhost:3005/merchant/itemDetails?itemID=' + element.toString());
      Item i = Item.fromMap(jsonDecode(res.body));
      itemsList.add(i);
    });
    //manually creating a delay to allow calls to happen. Hard coded time delay, not the way to do it.
    await new Future.delayed(const Duration(milliseconds: 25));
    return itemsList;
  }

  Future<List<Order>> getOrdersFromUID(String uid) async {
    List<Order> ordersList = new List();
    http.Response res = await http.get('http://localhost:3005/order/getOrdersByUser?userID=' + uid);
    List<dynamic> responses = jsonDecode(res.body);
    responses.forEach((element) {
      ordersList.add(Order.fromMap(element));
    });
    return getOrderSequence(ordersList);
  }


  List<Order> getOrderSequence(List<Order> orders) {
    List<Order> pending = new List();
    List<Order> past = new List();
    List<Order> ready = new List();
    List<Order> finalList = new List();

    orders.forEach((element) {
      if (element.isPending == 1 && element.isReadyForPickup == 1) {
        pending.add(element);               
      } else if (element.isPending == 1 && element.isReadyForPickup == 0) {
        pending.add(element);
      } else if (element.isPending == 0 && element.isReadyForPickup == 1) {
        ready.add(element);
      } else {
        past.add(element);
      }
    });
    
    finalList.add(Order(shopperID: "READY_FOR_PICKUP_HEADER"));
    if (ready.length == 0) {
      finalList.add(Order(shopperID: "NO_READY_FOR_PICKUP_ORDERS"));
    }
    ready.forEach((element) {
      finalList.add(element);
    });

    
    finalList.add(Order(shopperID: "PENDING_HEADER"));
    if (pending.length == 0) {
      finalList.add(Order(shopperID: "NO_PENDING_ORDERS"));
    }
    pending.forEach((element) {
      finalList.add(element);
    });

    finalList.add(Order(shopperID: "PAST_ORDER_HEADER"));
    if (past.length == 0) {
      finalList.add(Order(shopperID: "NO_PAST_ORDERS"));
    }
    past.forEach((element) {
      finalList.add(element);
    });
    return finalList;
  }

  Future<Store> getStoreDetailsFromID(int storeID) async {
    Store store;
    http.Response res = await http.get('http://localhost:3005/merchant/storeDetails?id=' + storeID.toString());
    store = Store.fromJson(res.body);
    return store;
  }
}
