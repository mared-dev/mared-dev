import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/config.dart';
import 'package:mared_social/constants/mux_constants.dart';
import 'package:http/http.dart' as http;

Future<String> uploadVideoToMux(String videoFirebaseUrl) async {
  try {
    print('${MUX_BASE_URL}assets');
    // var response =
    //     await http.post(, body: {'name': 'doodle', 'color': 'blue'});

    var result = await getIt
        .get<Dio>()
        .post(MUX_BASE_URL + 'assets', data: {"videoUrl": videoFirebaseUrl});
    print('@@@@@@@@@@@@@@@@');
    print(result.data);
    print(result.data.runtimeType);

    print(MUX_STREAM_SERVER +
        result.data['data']['playback_ids'][0]['id'] +
        MUX_VIDEO_EXTENSION);
    return MUX_STREAM_SERVER +
        result.data['data']['playback_ids'][0]['id'] +
        MUX_VIDEO_EXTENSION;
  } catch (e) {
    print(e);
    return Future.value("");
  }
}
