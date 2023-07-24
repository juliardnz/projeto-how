import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/client.dart';

const clientListKey = 'client_list';

class ClientRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Client>> getClientList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(clientListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Client.fromJson(e)).toList();

  }

  void saveClientList(List<Client> clients) {
    json.encode(clients);
    final String jsonString = json.encode(clients);
    sharedPreferences.setString(clientListKey, jsonString);


  }

}