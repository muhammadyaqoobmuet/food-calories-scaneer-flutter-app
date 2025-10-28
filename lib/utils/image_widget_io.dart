import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

Widget buildImageWidget(
  String imagePath, {
  double? width,
  double? height,
  BoxFit? fit,
}) {
  // data URL (base64)
  if (imagePath.startsWith('data:')) {
    try {
      final bytes = base64Decode(imagePath.split(',').last);
      return Image.memory(bytes, width: width, height: height, fit: fit);
    } catch (_) {
      return const Icon(Icons.broken_image);
    }
  }

  // network or blob URL
  if (imagePath.startsWith('http') || imagePath.startsWith('blob:')) {
    return Image.network(imagePath, width: width, height: height, fit: fit);
  }

  // Assume local file path
  try {
    return Image.file(File(imagePath), width: width, height: height, fit: fit);
  } catch (_) {
    return const Icon(Icons.broken_image);
  }
}
