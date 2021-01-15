import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague_admin/data/music_info_data.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                                    return StreamBuilder(
                                        stream: PlayMusic.isPlayingFunc(),
                                        builder: (context, playingSnapshot) {
                                          final isPlaying =
                                              playingSnapshot.data;
                                          return ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            leading: ClipOval(
                                              // borderRadius:
                                              //     BorderRadius.circular(4.0),
                                              child: ExtendedImage.network(
                                                _musicList[index]?.imagePath,
                                                cache: true,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                clearMemoryCacheWhenDispose:
                                                    true,
                                              ),
                                            ),
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _musicList[index].title,
                                                  style:
                                                      MTextStyles.bold14Grey06,
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
                                                    color: isPlaying == true &&
                                                            _musicList[index]
                                                                    .id ==
                                                                currentMusicId
                                                        ? MColors.black
                                                        : MColors.warm_grey,
                                                    onPressed: () {
                                                      MusicInfoData
                                                          musicInfoData =
                                                          MusicInfoData.fromMap(
                                                              _musicList[index]
                                                                  .toMap());

                                                      playOrpauseMusic(
                                                          musicInfoData,
                                                          currentMusicId);
                                                    }),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .delete_forever_outlined),
                                                  onPressed: () {
                                                    deleteMyMusic(index);
                                                  },
                                                ),
                                              ],
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
    // allmusic db delete
    FirebaseDBHelper.deleteDoc(FirebaseDBHelper.allMusicCollection, doc);

    // mymusic db delete
    FirebaseDBHelper.deleteAllSubDoc(FirebaseDBHelper.myMusicCollection, doc);

    //  image file delete
    FirebaseStorage.instance
        .refFromURL(_musicList[index].imagePath)
        .delete()
        .then((value) {
      print('image delete complete!');
    });
    //  music file delete
    FirebaseStorage.instance
        .refFromURL(_musicList[index].musicPath)
        .delete()
        .then((value) {
      print('music delete complete!');
    });

    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomPlayListWidget = BottomWidgets.none;
  }
}
