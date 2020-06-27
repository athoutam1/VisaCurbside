import 'package:http/http.dart' as http;
import 'package:visa_curbside/models/store.dart';
import 'package:visa_curbside/models/item.dart';
import 'dart:convert';

class DatabaseHelper {

  Future<List<Store>> getStores(String query) async {
    List<Store> storesList = new List<Store>();
    http.Response res = await http.get('http://localhost:3005/merchant/search?query=' + query);
    List<dynamic> responses = jsonDecode(res.body);
    // print(responses);
    responses.forEach((element) {
      storesList.add(Store.fromMap(element));
    });
    return storesList;
  }

  Future<List<Item>> getItems(String query, int storeID) async {
    List<Item> itemsList = new List<Item>();
    http.Response res = await http.get('http://localhost:3005/merchant/itemSearch?query=' + query + '&storeID=' + storeID.toString());
    List<dynamic> responses = jsonDecode(res.body);
    // print(responses);
    responses.forEach((element) {
      itemsList.add(Item.fromMap(element));
    });
    return itemsList;
  }

  List<Item> getItemsForCartFromList(List<int> items)  {
    
    List<Item> itemsList = new List<Item>();
    items.forEach((element) async{
      
      http.Response res = await http.get('http://localhost:3005/merchant/itemDetails?itemID=' + element.toString());
      Item i = Item.fromMap(jsonDecode(res.body));
      itemsList.add(i);
    });
    print(itemsList);
    return itemsList;
  }
}