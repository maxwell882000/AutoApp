import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'SingletonAdds.dart';
import 'SingletonGlobal.dart';
import 'SingletonRecomendation.dart';
import 'SingletonUnits.dart';
import 'SingletonUserInformation.dart';

class SingletonConnection {
  static final String URL = "https://machina.uz";
  static final SingletonConnection _instance = SingletonConnection._internal();

  factory SingletonConnection() {
    return _instance;
  }


  Future<bool> cleanTemp() async {
    final response =
        await http.get("$URL/clean/temp/${SingletonUserInformation().userId}");
    if (response.statusCode == 200) {}
  }

  Future<void> loadAdds() async {
    final response = await http
        .get("$URL/adds/", headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      Map json = jsonDecode(utf8.decode(response.bodyBytes));
      final result = await http.get("$URL/adds/${json['id']}/",
          headers: {'Content-Type': 'application/json'});
      SingletonAdds().setLinks(json['links']);
      SingletonAdds().setImages(result.bodyBytes);
    }
  }

  Future<bool> getLocation() async {
    Location location = SingletonUserInformation().newCard.attach.location;
    print("LOCATION GET");
    print(location.toJson());
    if (location.longitude != -1 && location.latitude != -1) {
      return true;
    }
    if (location.id != 0) {
      final result = await http.get('$URL/location/${location.id}/',
          headers: {'Content-Type': 'application/json'});
      print("Status code ${result.statusCode}");
      if (result.statusCode == 200) {
        final json = jsonDecode(utf8.decode(result.bodyBytes));
        print(json);
        location.fromJson(json);
        print(location.toJson());
        if (location.latitude != 0 && location.longitude != 0) {
          return true;
        }
      }
    }
    return false;
  }

  Future<Requests> shareTransport(String account, String id) async {
    bool internet = await checkConnection();
    if (internet) {
      final response = await http.post(
          "$URL/shareChoice/${SingletonUserInformation().emailOrPhone}/",
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'emailOrPhone': account,
            'id': id,
          }));

      if (response.statusCode == 200) {
        return Requests.SUCCESSFULLY_CREATED;
      } else if (response.statusCode == 400) {
        return Requests.BAD_REQUEST;
      } else if (response.statusCode == 404) {
        return Requests.NOT_FOUND;
      }
    }
    return Requests.NO_INTERNET;
  }

  Future<List> getTransports() async {
    final result = await http.get(
        '$URL/shareChoice/${SingletonUserInformation().emailOrPhone}/',
        headers: {'Content-Type': 'application/json'});

    final json = jsonDecode(utf8.decode(result.bodyBytes));
    return json;
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> deleteCache(List images, List expenses) async {
    images.forEach((element) {
      deleteImage(int.parse(element));
    });
    expenses.forEach((element) {
      deleteExpense(int.parse(element));
    });
  }

  Future<void> deleteImage(int id) async {
    bool connection = await checkConnection();

    if (connection) {
      final result = await http
          .delete("$URL/cards/images_upload/$id/", headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (jsonDecode(result.body)['status'] == 200) {
        return;
      }
    }
  }

  Future<void> deleteExpense(int id) async {
    bool connection = await checkConnection();

    if (connection) {
      final response = await http.delete(
        '$URL/expense/$id/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }

  void deleteUser() async {
    final response = await http.delete(
      "$URL/units/${SingletonUserInformation().emailOrPhone}/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
  }

  void updateExpenses() {
    http.put("$URL/updateExpenses/${SingletonUserInformation().expenses.id}/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "all_time": SingletonUserInformation().expenses.all_time,
          "in_this_month": SingletonUserInformation().expenses.in_this_month,
        }));
  }

  void updateExpense(int id, Map<String, dynamic> json) {
    http.put("$URL/expense/$id/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(json));
  }

  Future<Map> createExpense() async {
    final response = await http.post("$URL/expense/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': "_",
          'sum': 0,
          'amount': 0,
          "user_id": SingletonUserInformation().userId,
        }));
    print("RESPONSE FROM CREATE EXPENSE");
    print(response.body);
    Map json = jsonDecode(response.body);

    return json;
  }

  Future<void> recommendData() async {
    final response = await http.post('$URL/recomendations/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name_of_marka': SingletonUserInformation().marka,
          'name_of_model': SingletonUserInformation().model,
        }));
    print("RECOMMEND DATA ");
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      SingletonRecomendation().fromJson(json);
    } else {
      print(response);
    }
  }

  Future<http.Response> downloadImage(int id) async {
    final response = await http.get("$URL/download/$id/");
    return response;
  }

  Future<void> recommendImage() async {
    final response = await http.get(
      "$URL/recomendations/${SingletonRecomendation().id}/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    SingletonRecomendation().setImageUnit(response.bodyBytes);
  }

  Future sendImage(String path) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$URL/cards/images_upload"));
    request.fields
        .addAll({"user_id": SingletonUserInformation().userId.toString()});
    request.files.add(await http.MultipartFile.fromPath("image", path));
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
    });
    return await request.send();
  }
  Future<Map> getStoreCards(String tag, List card) async {
    final result = await http.get("${SingletonConnection.URL}/$tag");
    print(result.body);
    List json = jsonDecode(utf8.decode(result.bodyBytes));

    print(json);
    if (json.isNotEmpty) {
      json.forEach((e) =>
          card.add(new CardUser(
              e['id'],
              e['name_of_card'],
              DateTime.parse(e['date']),
              e['comments'],
              e['attach']['id'],
              e['attach']['location'],
              e['attach']['image'],
              e['change']['id'],
              SingletonUnits().convertDistanceForUser(e['change']['run']),
              SingletonUnits().convertDistanceForUser(
                  e['change']['initial_run']),
              e['change']['time'],
              e['expense'])));
    }

  }

  Future<void> modifyCard() async {
    CardUser card = SingletonUserInformation().newCard;
    Map<String, dynamic> json = card.toJson();
    json.addAll({"user_id": SingletonUserInformation().userId});
    if (card.attach.uploadedImage.isNotEmpty) {
      json.addAll({"images_list": card.attach.uploadedImage});
    }
    if (card.attach.location.longitude != -1 &&
        card.attach.location.latitude != -1) {
      print(card.attach.location.toJson());
      json.addAll({"location": card.attach.location.toJson()});
    }

    if (card.change.run == 0) {
      json.addAll({'time': card.change.time});
    } else {
      json.addAll(
          {'run': SingletonUnits().convertDistanceForDB(card.change.run)});
      json.addAll({
        'initial_run': SingletonUnits()
            .convertDistanceForDB(SingletonUserInformation().run)
      });
    }
    json.addAll({'id_attach': card.attach.id});
    json.addAll({'id_change': card.change.id});

    if (card.uploadedExpense.isNotEmpty)
      json.addAll({'expense_list': card.uploadedExpense});
    final result = await http.put('$URL/cards/${card.id}/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(json));
    print("MODIFY CARDSSS");
    print(result.body);
  }

  Future<void> createCards() async {
    CardUser card = SingletonUserInformation().newCard;
    Map<String, dynamic> json = card.toJson();
    json.addAll({"user_id": SingletonUserInformation().userId});
    if (card.attach.uploadedImage.isNotEmpty) {
      json.addAll({"images_list": card.attach.uploadedImage});
    }
    if (card.attach.location.longitude != -1 &&
        card.attach.location.latitude != -1) {
      json.addAll({"location": card.attach.location.toJson()});
    }
    if (card.change.run == 0) {
      json.addAll({'time': card.change.time});
    } else {
      json.addAll(
          {'run': SingletonUnits().convertDistanceForDB(card.change.run)});
      json.addAll({
        'initial_run': SingletonUnits()
            .convertDistanceForDB(SingletonUserInformation().run)
      });
    }

    Map got;
    print("ASDASDASD");
    print(json);
    if (SingletonUserInformation().cards.id != null &&
        SingletonUserInformation().cards.id != 0) {
      json.addAll({"id": SingletonUserInformation().cards.id});
      final response = await http.post('$URL/cards/',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(json));
      if (response.statusCode == 200) got = jsonDecode(response.body);
    } else {
      final response =
          await http.post('$URL/cards/${SingletonUserInformation().id}/',
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(json));
      print(response.body);
      if (response.statusCode == 200) {
        got = jsonDecode(response.body);
        SingletonUserInformation().cards.setId(got['id_cards']);
      }
    }
    print(got);
    if (got != null) {
      SingletonUserInformation().newCard.attach.setId(got['id_attach']);
      SingletonUserInformation().newCard.change.setId(got['id_change']);
      SingletonUserInformation().newCard.setId(got['id_card']);
      SingletonUserInformation().newCard.attach.location.setId(got['id_card']);
    }
  }

  Future registerCar() async{
    return http.post(
        '${SingletonConnection.URL}/transport/${SingletonUserInformation().emailOrPhone}/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(SingletonUserInformation().toJson()));
  }

  Future<bool> authorizedData({String text = ""}) async {
    if (text.isEmpty) {
      text = "${SingletonUserInformation().emailOrPhone}/";
    }
    final result = await http.get('$URL/transport/$text',
        headers: {'Content-Type': 'application/json'});
    print(result.body);
    print(result.statusCode);
    if (result.statusCode == 200) {
      final json = jsonDecode(utf8.decode(result.bodyBytes));

      SingletonUnits().fromJson(json['units']);
      SingletonUserInformation().setDate(DateTime.parse(json['date']));

      SingletonUserInformation().setProAccount(json['pro_account']);
      SingletonUserInformation().setUserId(json['user_id']);
      if (json["cards"] == null)
        SingletonUserInformation().setNOACCOUNT(true);
      else {
        SingletonUserInformation().fromJson(json['cards']);
        await recommendData();
      }
      return true;
    }
    return false;
  }

  SingletonConnection._internal();
}
