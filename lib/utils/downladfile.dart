import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';

Future<void> downloadFile(
    String url, String fileName, String dir, context) async {
  print('starting download $fileName');
  final downloaderUtils = DownloaderUtils(
    progressCallback: (current, total) {
      final progress = (current / total) * 100;
      print('Downloading: $progress');
    },
    file: File('$dir/$fileName'),
    progress: ProgressImplementation(),
    onDone: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved file at $dir/$fileName'),
    )),
    deleteOnCancel: true,
  );

  await Flowder.download(url, downloaderUtils);

  // print('here your donwload file $filePath');
}
