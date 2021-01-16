import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:music_minorleague_admin/data/music_info_data.dart';
import 'package:music_minorleague_admin/enum/music_approval_enum.dart';
import 'package:music_minorleague_admin/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague_admin/style/colors.dart';
import 'package:music_minorleague_admin/style/size_config.dart';
import 'package:music_minorleague_admin/style/textstyles.dart';
import 'package:music_minorleague_admin/util/firebase_db_helper.dart';
import 'package:music_minorleague_admin/util/play_func.dart';
import 'package:music_minorleague_admin/widgets/small_play_list_widget.dart';
import 'package:provider/provider.dart';

import 'enum/lounge_bottom_widget_enum.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MusicInfoData> _musicList = new List<MusicInfoData>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar();
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder(
              stream: FirebaseDBHelper.getDataStream(
                  FirebaseDBHelper.allMusicCollection),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData == false) {
                  return SizedBox.shrink();
                } else {
                  _musicList = FirebaseDBHelper.getMusicDatabase(snapshot.data);
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _musicList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: 72,
                              child: StreamBuilder(
                                  stream: PlayMusic.getCurrentStream(),
                                  builder: (context, currentSnapshot) {
                                    final Playing playing =
                                        currentSnapshot.data;

                                    final String currentMusicId =
                                        playing?.audio?.audio?.metas?.id;

                                    final String approvalState =
                                        EnumToString.convertToString(
                                            _musicList[index].approval);
                                    return StreamBuilder(
                                        stream: PlayMusic.isPlayingFunc(),
                                        builder: (context, playingSnapshot) {
                                          final isPlaying =
                                              playingSnapshot.data;
                                          return Slidable(
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            // actions: <Widget>[
                                            //   IconSlideAction(
                                            //     caption: 'Archive',
                                            //     color: Colors.blue,
                                            //     icon: Icons.archive,
                                            //     onTap: () =>
                                            //         _showSnackBar('Archive'),
                                            //   ),
                                            //   IconSlideAction(
                                            //     caption: 'Share',
                                            //     color: Colors.indigo,
                                            //     icon: Icons.share,
                                            //     onTap: () =>
                                            //         _showSnackBar('Share'),
                                            //   ),
                                            // ],
                                            secondaryActions: <Widget>[
                                              IconSlideAction(
                                                  caption: 'approval',
                                                  color: Colors.blue,
                                                  icon: Icons.approval,
                                                  onTap: () {
                                                    showAndHideSnackBar(
                                                        'approval');
                                                    changeRequestState(
                                                        MusicApprovalEnum
                                                            .approval,
                                                        _musicList[index]);
                                                  }),
                                              IconSlideAction(
                                                  caption: 'reject',
                                                  color: Colors.red,
                                                  icon: Icons.cancel_outlined,
                                                  onTap: () {
                                                    showAndHideSnackBar(
                                                        'reject');
                                                    changeRequestState(
                                                        MusicApprovalEnum
                                                            .reject,
                                                        _musicList[index]);
                                                  }),
                                              IconSlideAction(
                                                  caption: 'Delete',
                                                  color: Colors.yellow,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    showAndHideSnackBar(
                                                        'Delete');
                                                    deleteMyMusic(index);
                                                  }),
                                            ],
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                child: Text(
                                                  approvalState.substring(0, 3),
                                                  style:
                                                      MTextStyles.bold10Black,
                                                ),
                                                backgroundColor: getColor(
                                                    _musicList[index].approval),
                                              ),
                                              title: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _musicList[index].title,
                                                    style: MTextStyles
                                                        .bold14Grey06,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    _musicList[index].artist,
                                                    maxLines: 1,
                                                    style: MTextStyles
                                                        .regular12WarmGrey_underline,
                                                  ),
                                                ],
                                              ),
                                              trailing: Wrap(
                                                children: [
                                                  IconButton(
                                                      iconSize: 14,
                                                      icon: Icon(
                                                        isPlaying == true &&
                                                                _musicList[index]
                                                                        .id ==
                                                                    currentMusicId
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                      ),
                                                      color: isPlaying ==
                                                                  true &&
                                                              _musicList[index]
                                                                      .id ==
                                                                  currentMusicId
                                                          ? MColors.black
                                                          : MColors.warm_grey,
                                                      onPressed: () {
                                                        MusicInfoData
                                                            musicInfoData =
                                                            MusicInfoData.fromMap(
                                                                _musicList[
                                                                        index]
                                                                    .toMap());

                                                        playOrpauseMusic(
                                                            musicInfoData,
                                                            currentMusicId);
                                                      }),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }),
                            ),
                          ),
                          Divider(
                            height: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ],
                      );
                    },
                  );
                }
              }),
          Visibility(
            visible: Provider.of<MiniWidgetStatusProvider>(context)
                        .bottomPlayListWidget ==
                    BottomWidgets.miniPlayer
                ? true
                : false,
            child: SmallPlayListWidget(),
          ),
        ],
      ),
    );
  }

  void playOrpauseMusic(MusicInfoData musicInfoData, String currentPlayingId) {
    if (currentPlayingId == musicInfoData.id) {
      PlayMusic.playOrPauseFunc();
    } else {
      PlayMusic.stopFunc().whenComplete(() {
        PlayMusic.clearAudioPlayer();
        PlayMusic.makeNewPlayer();
        PlayMusic.playUrlFunc(musicInfoData).whenComplete(() {
          context.read<MiniWidgetStatusProvider>().bottomPlayListWidget =
              BottomWidgets.miniPlayer;
        });
      });
    }
  }

  void deleteMyMusic(int index) {
    String doc = _musicList[index].id;
    String folderName = _musicList[index].userId;

    //  image file delete
    // FirebaseStorage.instance
    //     .refFromURL(_musicList[index].imagePath)
    //     .delete()
    //     .then((value) {
    //   print('image delete complete!');
    // });

    deleteFileFRomFirebase(folderName, _musicList[index].imagePath);
    deleteFileFRomFirebase(folderName, _musicList[index].musicPath);
    //  music file delete

    // FirebaseStorage.instance
    //     .refFromURL(_musicList[index].musicPath)
    //     .delete()
    //     .then((value) {
    //   print('music delete complete!');
    // });

    // allmusic db delete
    FirebaseDBHelper.deleteDoc(FirebaseDBHelper.allMusicCollection, doc);

    // mymusic db delete
    FirebaseDBHelper.deleteAllSubDoc(FirebaseDBHelper.myMusicCollection, doc);

    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomPlayListWidget = BottomWidgets.none;
  }

  getColor(MusicApprovalEnum approvalState) {
    Color backgourndColor = Colors.white;
    switch (approvalState) {
      case MusicApprovalEnum.request:
        backgourndColor = Colors.grey[300];
        break;
      case MusicApprovalEnum.approval:
        backgourndColor = Colors.blue[300];
        break;

      case MusicApprovalEnum.reject:
        backgourndColor = Colors.red[300];
        break;
      case MusicApprovalEnum.none:
        break;
    }
    return backgourndColor;
  }

  void showAndHideSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(content),
          ],
        ),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    });
  }

  void changeRequestState(
      MusicApprovalEnum approvalState, MusicInfoData musicInfoData) {
    String collection = FirebaseDBHelper.allMusicCollection;
    String doc = musicInfoData.id;
    String data = EnumToString.convertToString(approvalState);
    switch (approvalState) {
      case MusicApprovalEnum.approval:
        FirebaseDBHelper.updateApprovalStateData(
          collection,
          doc,
          data,
        );
        break;

      case MusicApprovalEnum.reject:
        FirebaseDBHelper.updateApprovalStateData(
          collection,
          doc,
          data,
        );
        break;

      case MusicApprovalEnum.none:
        break;
      case MusicApprovalEnum.request:
        break;
    }
  }

  /// [Delete file] from firebase storage
  Future<void> deleteFileFRomFirebase(String folderName, String url) async {
    try {
      String filePath = url.replaceAll(
          new RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/musicminorleague.appspot.com/o/'),
          '');

      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
      Reference storageReference = FirebaseStorage.instance.ref();
      await storageReference
          .child(folderName)
          .child(filePath)
          .delete()
          .catchError((val) {
        print('[Error]' + val);
      }).then((_) {
        print('[Sucess] Image deleted');
      });
    } catch (error) {
      print(error);
    }
  }
}
