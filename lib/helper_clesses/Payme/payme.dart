import 'dart:convert';
import 'dart:math';

import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/helper_clesses/Payme/errors.dart';
import 'package:http/http.dart' as http;

class Payme {
  final String _url = "https://checkout.test.paycom.uz/api";
  final String _id = "60a8b7bea44459bf07890f34";
  final String number;
  final String CARDS_CREATE_METHOD = "cards.create";
  final String CARDS_GET_VERIFY_CODE = "cards.get_verify_code";
  final String CARDS_VERIFY = 'cards.verify';
  final String expire;
  final String userId;
  final String amountId;
  String _token;
  int wait = 0;
  int _idRequest;

  Payme({this.number, this.expire, this.userId, this.amountId}) {
    var rng = new Random();
    _idRequest = rng.nextInt(10000);
  }

  Map<String, String> _setHeader() {
    return {"X-Auth": _id};
  }

  String body(String method, Map<String, dynamic> params) {
    Map<String, dynamic> toJson = {
      "id": _idRequest,
      "method": method,
      "params": params,
    };
    return jsonEncode(toJson);
  }

  Future cardsCreate() async {
    checkTimestamp();
    Map<String, dynamic> params = {
      "card": {"number": number, "expire": expire, "save": true},
    };
    final result = await http.post(_url,
        headers: _setHeader(), body: body(CARDS_CREATE_METHOD, params));
    Map response = jsonDecode(result.body);
    print(result.body);
    if (!response.containsKey('error')) {
      Map card = response['result']['card'];
      _token = card['token'];
      return card['verify'];
    }

    Errors.handlePayme(response, Errors.payme['create_cards']);
  }

  Future<bool> getVerifyCode() async {
    checkTimestamp();
    Map<String,dynamic> params = {
      'token': _token,
    };
    final result = await http.post(_url,
        headers: _setHeader(), body: body(CARDS_GET_VERIFY_CODE, params));
    print("GET VERIFY CODE ${result.body}");
    if (result.statusCode == 200) {
      Map body = jsonDecode(result.body);
      int wait = body['result']['wait'];
      bool sent = body['result']['sent'];
      if (!sent)
        throw Errors.payme['not_sent_get_verify'];
      this.wait = _getTimestamp(wait);
      return sent;
    }
    throw Errors.payme['not_sent_get_verify'];
  }

  int _getTimestamp(int wait) {
    int current = DateTime.now().millisecondsSinceEpoch;
    return current + wait;
  }

  void checkTimestamp() {
    if (wait == 0 || wait <= DateTime.now().millisecondsSinceEpoch) {
      return;
    }
    throw Errors.payme['time_get_verify'];
  }

  Future<Map> cardsVerify(String code) async {
    Map<String,dynamic> params = {'token': _token, 'code': code};
    final result = await http.post(_url,
        headers: _setHeader(), body: body(CARDS_VERIFY, params));
    print("CARDS VERIFY  ${result.body}");
    if (result.statusCode == 200) {
      Map body = jsonDecode(result.body);
      if(!body.containsKey('error')) {
        Map card = body['result']["card"];
        bool recurrent = card['recurrent'];
        bool verify = card['verify'];
        if (verify) {
          final result = await pay();
          return result;
        }
      }
      Errors.handlePayme(body, Errors.payme['verify']);
    }
  }

  Future<Map> pay() async {
    final result = await http.post("${SingletonConnection.URL}/subscribe_pay/",
        headers: _setHeader(),
        body: jsonEncode(
            {'id_user': userId, 'token': _token, 'id_amount': amountId}));
    print(result.body);
    Map body = jsonDecode(result.body);

    return body;
  }
}
