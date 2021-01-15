import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_minorleague_admin/data/music_info_data.dart';

class FirebaseDBHelper {
  static final userCollection = 'user';
  static final myMusicCollection = 'myMusic';
  static final mySelectedMusicCollection = 'mySelectedMusic';
  static final myUpdatedMusicCollection = 'myUpdatedMusicCollection';
  static final allMusicCollection = 'allMusic';
  static final firestoreinstance = FirebaseFirestore.instance;

  static Future<void> setData(
      String collection, String doc, Map<String, Object> data) async {
    await firestoreinstance.collection(collection).doc(doc).set(data);
  }

  static Future<void> setSubCollection(String mainCollection, String mainDoc,
      String subCollection, String subDoc, Map<String, Object> data) async {
    await firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .set({'id': mainDoc}).then((value) {
      firestoreinstance
          .collection(mainCollection)
          .doc(mainDoc)
          .collection(subCollection)
          .doc(subDoc)
          .set(data);
    });
  }

  static Future<void> updateFavoriteData(
      String collection, String doc, int data) async {
    await firestoreinstance.collection(collection).doc(doc).update({
      'favorite': data,
    });
  }

  static Future<void> updateData(
      String collection, String doc, Map<String, dynamic> data) async {
    await firestoreinstance.collection(collection).doc(doc).update({
      'userName': data['userName'],
      'photoUrl': data['photoUrl'],
      'backgroundPhotoUrl': data['backgroundPhotoUrl'],
      'youtubeUrl': data['youtubeUrl'],
      'introduce': data['introduce'],
    });
  }

  static Future<void> updateAllMusicArtist(
      String collection, String newArtist, String userId) async {
    await firestoreinstance
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        firestoreinstance.collection(collection).doc(element.id).update({
          'artist': newArtist,
        });
      });
    });
  }

  static Future<void> updateMyMusicArtist(
      String collection, String newArtist, String userId) async {
    return await firestoreinstance
        .collection(collection)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        firestoreinstance
            .collection(collection)
            .doc(result.id)
            .collection(FirebaseDBHelper.mySelectedMusicCollection)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            firestoreinstance
                .collection(collection)
                .doc(result.id)
                .collection(FirebaseDBHelper.mySelectedMusicCollection)
                .doc(element.id)
                .update({
              'artist': newArtist,
            });
          });
        });
      });
    });
  }

  static Future<void> deleteDoc(String collection, String doc) async {
    return await firestoreinstance.collection(collection).doc(doc).delete();
  }

  static Future<void> deleteSubDoc(String mainCollection, String mainDoc,
      String subCollection, String subDoc) async {
    return await firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .collection(subCollection)
        .doc(subDoc)
        .delete();
  }

  static Future<void> deleteAllSubDoc(String collection, String doc) async {
    return await firestoreinstance
        .collection(collection)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        firestoreinstance
            .collection(collection)
            .doc(result.id)
            .collection("mySelectedMusic")
            .doc(doc)
            .delete();
      });
    });
  }

  static Future<DocumentSnapshot> getData(String collection, String doc) async {
    return await firestoreinstance.collection(collection).doc(doc).get();
  }

  static Stream<QuerySnapshot> getDataStream(String collection) {
    return firestoreinstance
        .collection(collection)
        // .orderBy('favorite', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getMyMusicDataStream(
      String collection, String userId) {
    return firestoreinstance
        .collection(collection)
        .where('userId', isEqualTo: userId)
        // .orderBy('favorite', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getSubDataStream(
      String mainCollection, String mainDoc, String subCollection) {
    return firestoreinstance
        .collection(mainCollection)
        .doc(mainDoc)
        .collection(subCollection)
        .snapshots();
  }

  static List<MusicInfoData> getMusicDatabase(QuerySnapshot qs) {
    List<MusicInfoData> musicList = new List<MusicInfoData>();
    for (int idx = 0; idx < qs.docs.length; idx++) {
      MusicInfoData musicInfoData = new MusicInfoData();
      musicInfoData = MusicInfoData.fromMap(qs.docs[idx].data());

      musicList.add(musicInfoData);
    }

    return musicList;
  }
}
