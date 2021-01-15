import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:music_minorleague_admin/data/music_info_data.dart';

class PlayMusic {
  static AssetsAudioPlayer _assetsAudioPlayer = new AssetsAudioPlayer();

  static clearAudioPlayer() {
    AssetsAudioPlayer.allPlayers().clear();
  }

  static makeNewPlayer() {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  static Future<void> stopFunc() async {
    await _assetsAudioPlayer.stop();
  }

  static Future<void> playUrlFunc(MusicInfoData currentMusicData) async {
    final audio = Audio.network(currentMusicData.musicPath,
        metas: Metas(
          id: currentMusicData.id,
          title: currentMusicData.title,
          artist: currentMusicData.artist,
          image: MetasImage.network(currentMusicData.imagePath),
          extra: currentMusicData.toMap(),
        ));
    _assetsAudioPlayer.open(audio, showNotification: true);
  }

  static Future<void> playFileFunc(String filePath) {
    _assetsAudioPlayer.open(Audio.file(filePath));
  }

  static Future<void> playListFunc(
      List<MusicInfoData> selectedMusicList) async {
    List<Audio> audios = List.generate(
        selectedMusicList.length,
        (index) => new Audio.network(selectedMusicList[index].musicPath,
            metas: Metas(
              id: selectedMusicList[index].id,
              title: selectedMusicList[index].title,
              artist: selectedMusicList[index].artist,
              image: MetasImage.network(selectedMusicList[index].imagePath),
              extra: selectedMusicList[index].toMap(),
            )));
    _assetsAudioPlayer.open(
      Playlist(
        startIndex: 0,
        audios: audios,
      ),
      loopMode: LoopMode.playlist,
      showNotification: true,
    );
  }

  static next() {
    _assetsAudioPlayer.next();
  }

  static previous() {
    _assetsAudioPlayer.previous();
  }

  static playlistPlayAtIndex(int index) {
    _assetsAudioPlayer.playlistPlayAtIndex(index);
  }

  static playFunc() {
    _assetsAudioPlayer.play();
  }

  static pauseFunc() {
    _assetsAudioPlayer.pause();
  }

  static playOrPauseFunc() {
    _assetsAudioPlayer.playOrPause();
  }

  static seekFunc(Duration pos) {
    _assetsAudioPlayer.seek(pos);
  }

  static Stream getCurrentStream() {
    return _assetsAudioPlayer.current.asBroadcastStream();
  }

  static Stream getPositionStream() {
    return _assetsAudioPlayer.currentPosition;
  }

  static Stream getSongLengthStream() {
    return _assetsAudioPlayer.realtimePlayingInfos;
  }

  static AssetsAudioPlayer assetsAudioPlayer() {
    return _assetsAudioPlayer;
  }

  static Stream<bool> isPlayingFunc() {
    return _assetsAudioPlayer.isPlaying.asBroadcastStream();
  }
}
