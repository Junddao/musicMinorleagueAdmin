import 'package:flutter/material.dart';

import 'package:music_minorleague_admin/enum/lounge_bottom_widget_enum.dart';

class MiniWidgetStatusProvider with ChangeNotifier {
  BottomWidgets _bottomSeletListWidget = BottomWidgets.none;
  BottomWidgets _bottomPlayListWidget = BottomWidgets.none;
  BottomWidgets _myBottomSelectListWidget = BottomWidgets.none;
  bool _bMinButtonClick = false;

  // MyPlaylistWidgetEnum _myPlaylistWidgetEnum =
  //     MyPlaylistWidgetEnum.miniPlayerWidget;

  BottomWidgets get bottomSeletListWidget => _bottomSeletListWidget;
  set bottomSeletListWidget(BottomWidgets bottomSeletListWidget) {
    _bottomSeletListWidget = bottomSeletListWidget;
    notifyListeners();
  }

  BottomWidgets get bottomPlayListWidget => _bottomPlayListWidget;
  set bottomPlayListWidget(BottomWidgets bottomSeletListWidget) {
    _bottomPlayListWidget = bottomSeletListWidget;
    notifyListeners();
  }

  BottomWidgets get myBottomSelectListWidget => _myBottomSelectListWidget;
  set myBottomSelectListWidget(BottomWidgets myBottomSelectListWidget) {
    _myBottomSelectListWidget = myBottomSelectListWidget;
    notifyListeners();
  }

  bool get bMinButtonClick => _bMinButtonClick;
  set bMinButtonClick(bool bMinButtonClick) {
    _bMinButtonClick = bMinButtonClick;
    notifyListeners();
  }

  // MyPlaylistWidgetEnum get myPlaylistWidgetEnum => _myPlaylistWidgetEnum;
  // set myPlaylistWidgetEnum(MyPlaylistWidgetEnum myPlaylistWidgetEnum) {
  //   _myPlaylistWidgetEnum = myPlaylistWidgetEnum;
  //   notifyListeners();
  // }
}
