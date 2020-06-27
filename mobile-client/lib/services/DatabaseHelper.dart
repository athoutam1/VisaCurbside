import 'package:http/http.dart' as http;
import 'package:visa_curbside/models/store.dart';
import 'dart:convert';

class DatabaseHelper {

  Future<List<Store>> getStores() async {
    List<Store> storesList = new List<Store>();
    http.Response res = await http.get('http://localhost:3005/merchant/search?query=');
    List<dynamic> responses = jsonDecode(res.body);
    // print(responses);
    responses.forEach((element) {
      storesList.add(Store.fromMap(element));
    });
    return storesList;
  }
}