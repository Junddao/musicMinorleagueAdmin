import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague_admin/style/colors.dart';
import 'package:music_minorleague_admin/style/textstyles.dart';
import 'package:music_minorleague_admin/util/play_func.dart';

class PositionSeekWidget extends StatefulWidget {
  const PositionSeekWidget({
    Key key,
    @required this.position,
    @required this.infos,
    @required this.musicLength,
  }) : super(key: key);

  final Duration position;
  final RealtimePlayingInfos infos;
  final Duration musicLength;

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  bool listenOnlyUserInterraction = false;
  Duration _visibleValue;
  @override
  void initState() {
    _visibleValue = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PositionSeekWidget oldWidget) {
    if (!listenOnlyUserInterraction) {
      _visibleValue <= widget.musicLength
          ? _visibleValue = widget.position
          : _visibleValue = widget.musicLength;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  // position = infos.currentPosition;
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: MTextStyles.bold10Black,
                          text: durationToString(_visibleValue),
                        ),
                        TextSpan(
                            style: MTextStyles.regular10Grey06, text: ' / '),
                        TextSpan(
                          style: MTextStyles.regular10WarmGrey,
                          text: durationToString(widget.infos.duration),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: MColors.tomato,
              inactiveTrackColor: MColors.warm_grey,
              trackHeight: 2.0,
              thumbColor: MColors.tomato,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayColor: Colors.purple.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
            ),
            child: Slider(
              min: 0,
              max: widget.musicLength.inMilliseconds.toDouble(),
              value: _visibleValue.inMilliseconds.toDouble(),
              onChangeStart: (value) {
                setState(() {
                  listenOnlyUserInterraction = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  Duration d = Duration(milliseconds: value.floor());
                  // widget.position = d;
                  _visibleValue = d;

                  // PlayMusic.getPositionStream().
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  listenOnlyUserInterraction = false;
                  PlayMusic.seekFunc(_visibleValue);
                });
              },
              // onChangeStart: (_) {
              //   setState(() {
              //     listenOnlyUserInterraction = true;
              //   });
              // },
            ),
          ),
        ),
      ],
    );
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
