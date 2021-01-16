import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';

import 'package:music_minorleague_admin/enum/music_approval_enum.dart';
import 'package:music_minorleague_admin/enum/music_type_enum.dart';

class MusicInfoData {
  String id;
  String userId;
  String title;
  String artist;
  String musicPath;
  String imagePath;
  String musicFileName;
  String imageFileName;
  String dateTime;
  int favorite;
  MusicApprovalEnum approval;
  MusicTypeEnum musicType;
  MusicInfoData({
    this.id,
    this.userId,
    this.title,
    this.artist,
    this.musicPath,
    this.imagePath,
    this.musicFileName,
    this.imageFileName,
    this.dateTime,
    this.favorite,
    this.approval,
    this.musicType,
    // UserProfileData userProfileData;
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'artist': artist,
      'musicPath': musicPath,
      'imagePath': imagePath,
      'musicFileName': musicFileName,
      'imageFileName': imageFileName,
      'dateTime': dateTime,
      'favorite': favorite,
      'approval': EnumToString.convertToString(approval),
      'musicType': EnumToString.convertToString(musicType),
    };
  }

  factory MusicInfoData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MusicInfoData(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      artist: map['artist'],
      musicPath: map['musicPath'],
      imagePath: map['imagePath'],
      musicFileName: map['musicFileName'],
      imageFileName: map['imageFileName'],
      dateTime: map['dateTime'],
      favorite: map['favorite'],
      approval:
          EnumToString.fromString(MusicApprovalEnum.values, map['approval']),
      musicType:
          EnumToString.fromString(MusicTypeEnum.values, map['musicType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicInfoData.fromJson(String source) =>
      MusicInfoData.fromMap(json.decode(source));
}
