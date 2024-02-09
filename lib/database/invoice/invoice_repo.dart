import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/interface/invoice_repo_interface.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';
import 'package:smart_case/util/smart_case_init.dart';

class InvoiceRepo extends InvoiceRepoInterface {
  static final InvoiceRepo _instance = InvoiceRepo._internal();

  factory InvoiceRepo() {
    return _instance;
  }

  InvoiceRepo._internal();

  @override
  Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body}) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(
        '${currentUser.url}/api/account/invoices',
        data: json.encode(body),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> fetch(int id) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'api/account/invoices/$id')
            .toString(),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> filter() {
    // TODO: implement filter
    throw UnimplementedError();
  }

  @override
  Future<dynamic> post(Map<String, dynamic> data) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    log(json.encode(data));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'api/account/invoice/create')
            .toString(),
        data: json.encode(data),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
  }

  @override
  Future<dynamic> put(Map<String, dynamic> data, int id) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      // dio.options.followRedirects = false;

      var response = await dio.put(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'account/invoice/update/$id')
            .toString(),
        data: json.encode(data),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("A Success occurred: ${response.statusCode}");
        }
        await RequisitionApi
            .fetchAll(); // TODO: Remove when bloc is successfully added.
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
  }
}
