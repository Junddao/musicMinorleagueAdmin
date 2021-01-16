import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask task = firebaseStorageRef.putFile(imageToUpload);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      // Handle your snapshot events...
    }, onError: (e) {
      // Check if cancelled by checking error code.
      if (e.code == 'canceled') {
        print('The task has been canceled');
      }
      // Or, you can also check for cancellations via the final task.snapshot state.
      if (task.snapshot.state == TaskState.canceled) {
        print('The task has been canceled');
      }
      // If the task failed for any other reason then state would be:
      print(TaskState.error);
    });

    try {
      await task;
      print('Upload complete.');
      var downloadUrl = await task.snapshot.ref.getDownloadURL();
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }

    return null;
  }

  Future deleteImage(String folderName, String imageFileName) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(folderName).child(imageFileName);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
