import 'dart:convert';
import 'dart:io';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

getFileName(String path) {
  return basename(path);
}

Future<File> getImageFromCamera() async {
  final picker = ImagePicker();
  File? _file;
  final pickedImage = await picker.pickImage(source: ImageSource.camera);

  if (pickedImage != null) {
    _file = File(pickedImage.path);
  } else {
    debugPrint('No image selected.');
  }
  return _file!;
}

Future<File> getImageFromGallery() async {
  final picker = ImagePicker();
  File? _file;
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    _file = File(pickedImage.path);
  } else {
    debugPrint('No image selected.');
  }
  return _file!;
}

List<int> getFileForWeb() {
  List<int>? imageFileBytes;
  Uint8List _bytesData;

  try {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    // uploadInput.accept = 'application/pdf';
    uploadInput.click();

    html.document.body?.append(uploadInput);

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();
      reader.onLoadEnd.listen((e) {
        _bytesData = const Base64Decoder()
            .convert(reader.result.toString().split(",").last);

        imageFileBytes = _bytesData;
      });
      reader.readAsDataUrl(file);
    });

    uploadInput.remove();
  } catch (e) {
    print(e);
  }
  return imageFileBytes!;
}

Future<File> getFileFromGallery() async {
  File? _file;
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png']);
  if (result != null) {
    _file = File(result.files.single.path!);
  } else {
    debugPrint('No file selected.');
  }
  return _file!;
}

Future<File?> getFileFromDevice(BuildContext context) async {
  File? _file;
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'फोटो काढा अथवा गॅलरी मधून निवडा',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  _file = await getImageFromCamera();
                  Navigator.pop(context);
                },
                child: Text(
                  'कॅमेरा',
                  style: GoogleFonts.poppins(fontSize: 14),
                )),
            TextButton(
                onPressed: () async {
                  _file = await getImageFromGallery();
                  Navigator.pop(context);
                },
                child: Text(
                  'गॅलरी',
                  style: GoogleFonts.poppins(fontSize: 14),
                ))
          ],
        );
      });
  return _file;
}



// FormData getFormData(){}