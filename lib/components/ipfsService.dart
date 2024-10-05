// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
//PICKER
  static Future<String?> pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      //Nothing picked
      if (image == null) {
        Fluttertoast.showToast(
          msg: 'No Image Selected',
        );
        return null;
      } else {
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => ProgressDialog(
              status: 'Uploading to IPFS',
            ),
          );
        }

        // upload image to ipfs
        final cid = await FlutterIpfs().uploadToIpfs(image.path);

        // Popping out the dialog box
        if (context.mounted) {
          Navigator.pop(context);
        }

        //Return Path
        return cid;
      }
    } catch (e) {
      debugPrint('Error at image picker: $e');
      SnackBar(
        content: Text(
          'Error at image picker: $e',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
      );
      return null;
    }
  }
}
