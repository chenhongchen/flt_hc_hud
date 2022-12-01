import 'package:flutter/material.dart';
import 'hc_progressbar.dart';
import 'hc_activity_indicator.dart';

enum HCHudType {
  /// show loading with CupertinoActivityIndicator and text
  loading,

  /// show Icons.check and Text
  success,

  /// show Icons.close and Text
  error,

  /// show circle progress view and text
  progress,

  /// show text only
  text,

  /// show custom widget only
  custom,
}

class HCHud extends StatefulWidget {
  final Widget child;
  final Color? bgColor;
  final Color? foreColor;
  final Color? textColor;
  final double? width;
  final double? height;

  HCHud({
    required this.child,
    this.bgColor,
    this.foreColor,
    this.textColor,
    this.width,
    this.height,
  });

  static _HCHudState? of(BuildContext? context) {
    _HCHudState? hudState;
    if (context == null) return hudState;
    try {
      hudState = context.findAncestorStateOfType<_HCHudState>();
    } catch (e) {}
    return hudState;
  }

  @override
  _HCHudState createState() => _HCHudState();
}

class _HCHudState extends State<HCHud> with SingleTickerProviderStateMixin {
  AnimationController? _animation;
  var _isVisible = false;
  var _text = "";
  var _opacity = 0.0;
  var _progressType = HCHudType.loading;
  var _progressValue = 0.0;

  double? _x;
  double? _y;
  double? _widgetW;
  double? _widgetH;

  double _defW = 0;
  double _defH = 0;
  BoxConstraints? _constraints;

  final GlobalKey _globalKey = GlobalKey();
  final double _hMargin = 30;

  bool _enable = true;

  Widget? _customHudView;

  bool _animated = true;

  int _lastShowStartTimeStamp = 0;
  final int _showMilliseconds = 2000;

  bool _disposed = false;

  late Color _bgColor;
  late Color _foreColor;
  late Color _textColor;

  void _initData() {
    _bgColor = widget.bgColor ?? Color(0xFFF6F6F6);
    _foreColor = widget.foreColor ?? Color(0xFF1F93EA);
    _textColor = widget.textColor ?? Color(0XFF666666);
  }

  @override
  void initState() {
    _initData();
    _animation = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        if (_disposed) {
          return;
        }
        setState(() {
          _opacity = _animation?.value ?? 0.0;
        });
      })
      ..addStatusListener((status) {
        if (_disposed) {
          return;
        }
        if (status == AnimationStatus.dismissed) {
          setState(() {});
        }
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setDefSize();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _constraints = constraints;
      return Stack(
        children: <Widget>[
          widget.child,
          (_opacity == 0.0
              ? Container(
                  width: 0,
                  height: 0,
                )
              : Positioned(
                  left: _x,
                  top: _y,
                  child: Opacity(
                    opacity: _opacity,
                    child: _enable
                        ? Container(
                            key: _globalKey,
                            width: _widgetW,
                            color: Colors.transparent,
                            child: _progressType == HCHudType.custom
                                ? _customHudView
                                : _createHud(),
                          )
                        : Container(
                            key: _globalKey,
                            width: _widgetW,
                            height: _widgetH,
                            color: Colors.transparent,
                            child: _progressType == HCHudType.custom
                                ? _customHudView
                                : _createHud(),
                          ),
                  ))),
        ],
      );
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _animation?.dispose();
    _animation = null;
    super.dispose();
  }

  /// dismiss hud
  void dismiss({bool? animated}) {
    if (_disposed) {
      return;
    }
    _isVisible = false;
    _opacity = 0.0;
    if (animated ?? true) {
      _animation?.reverse();
    }
    setState(() {});
  }

  /// show hud with type and text
  void show(
    HCHudType type,
    String text, {
    double? x,
    double? y,
    double? width,
    double? height,
    bool enable = true,
    bool? animated,
  }) {
    if (_disposed) {
      return;
    }
    _setDefSize();
    _isVisible = true;
    _enable = enable;
    _animated = animated ?? true;
    if ((width == null || height == null) && (_defW <= 0 || _defH <= 0)) {
      Future.delayed(Duration(seconds: 0), () {
        _setDefSize();
        if (_isVisible) {
          _text = text;
          _progressType = type;
          _widgetW = width != null ? width : _defW;
          _widgetH = height != null ? height : _defH;
          _x = x ?? ((MediaQuery.of(context).size.width - _widgetW!) * 0.5);
          if (y != null) {
            _y = y;
            if (_animated) {
              _animation?.reset();
              _animation?.forward();
            } else {
              _opacity = 1.0;
            }
          } else {
            _opacity = 0.001;
            _showAtHeightCenter(_widgetH!);
          }
          setState(() {});
        }
      });
    } else {
      _text = text;
      _progressType = type;
      _widgetW = width != null ? width : _defW;
      _widgetH = height != null ? height : _defH;
      _x = x ?? ((MediaQuery.of(context).size.width - _widgetW!) * 0.5);
      if (y != null) {
        _y = y;
        if (_animated) {
          _animation?.reset();
          _animation?.forward();
        } else {
          _opacity = 1.0;
        }
      } else {
        _opacity = 0.001;
        _showAtHeightCenter(_widgetH!);
      }
      setState(() {});
    }
  }

  /// show loading with text
  void showLoading(
      {String text = "loading",
      double? x,
      double? y,
      double? width,
      double? height,
      bool enable = true,
      bool? animated}) {
    this.show(HCHudType.loading, text,
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated);
  }

  /// show success icon with text and dismiss automatic
  Future showSuccessAndDismiss(
      {String text = '',
      double? x,
      double? y,
      double? width,
      double? height,
      bool enable = true,
      bool? animated,
      int? showMilliseconds}) async {
    await this.showAndDismiss(HCHudType.success, text,
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated,
        showMilliseconds: showMilliseconds);
  }

  /// show error icon with text and dismiss automatic
  Future showErrorAndDismiss(
      {String text = '',
      double? x,
      double? y,
      double? width,
      double? height,
      bool enable = true,
      bool? animated,
      int? showMilliseconds}) async {
    await this.showAndDismiss(HCHudType.error, text,
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated,
        showMilliseconds: showMilliseconds);
  }

  /// show text only and dismiss automatic
  Future showTextAndDismiss(
      {String text = '',
      double? x,
      double? y,
      double? width,
      double? height,
      bool enable = true,
      bool? animated,
      int? showMilliseconds}) async {
    await this.showAndDismiss(HCHudType.text, text,
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated,
        showMilliseconds: showMilliseconds);
  }

  /// show loading with text
  void showCustomHudView(
      {double? x,
      double? y,
      double? width,
      double? height,
      Widget? hudView,
      bool enable = true,
      bool? animated}) {
    if (hudView == null) return;
    _customHudView = hudView;
    this.show(HCHudType.custom, '',
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated);
  }

  /// show text only and dismiss automatic
  Future showCustomHudViewAndDismiss(
      {double? x,
      double? y,
      double? width,
      double? height,
      Widget? hudView,
      bool enable = true,
      bool? animated,
      int? showMilliseconds}) async {
    if (hudView == null) return;
    _customHudView = hudView;
    await this.showAndDismiss(HCHudType.custom, '',
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated,
        showMilliseconds: showMilliseconds);
  }

  /// update progress value and text when ProgressHudType = progress
  ///
  /// should call `show(ProgressHudType.progress, "Loading")` before use
  void updateProgress(double progress, String text) {
    if (_disposed) {
      return;
    }
    setState(() {
      _progressValue = progress;
      _text = text;
    });
  }

  /// show hud and dismiss automatically
  Future showAndDismiss(HCHudType type, String text,
      {double? x,
      double? y,
      double? width,
      double? height,
      bool enable = true,
      bool? animated,
      int? showMilliseconds}) async {
    if (_disposed) {
      return;
    }
    dismiss(animated: false);
    _lastShowStartTimeStamp = DateTime.now().millisecondsSinceEpoch;
    show(type, text,
        x: x,
        y: y,
        width: width,
        height: height,
        enable: enable,
        animated: animated);
//    var millisecond = max(500 + text.length * 200, 1000);
    showMilliseconds ??= _showMilliseconds;
    var duration = Duration(milliseconds: showMilliseconds);
    await Future.delayed(duration);

    int curTimeStamp = DateTime.now().millisecondsSinceEpoch;
    if (curTimeStamp - _lastShowStartTimeStamp < showMilliseconds) {
      return;
    }
    dismiss(animated: animated);
  }

  Widget _createHud() {
    const double kIconSize = 30;
    switch (_progressType) {
      case HCHudType.loading:
        var sizeBox = SizedBox(
            width: kIconSize,
            height: kIconSize,
            child: HCActivityIndicator(
              animating: true,
              radius: 10,
              color: _foreColor,
            ));
        return _createHudView(sizeBox);
      case HCHudType.error:
        return _createHudView(
            Icon(Icons.close, color: _foreColor, size: kIconSize));
      case HCHudType.success:
        return _createHudView(
            Icon(Icons.check, color: _foreColor, size: kIconSize));
      case HCHudType.progress:
        var progressWidget = CustomPaint(
          painter: HCProgressBarPainter(progress: _progressValue),
          size: Size(kIconSize, kIconSize),
        );
        return _createHudView(progressWidget);
      case HCHudType.text:
        return _createHudView(Container());
      default:
        throw Exception("not implementation");
    }
  }

  Widget _createHudView(Widget child) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(_hMargin, 0, _hMargin, 0),
        decoration: BoxDecoration(
            color: _bgColor,
            /*Color.fromARGB(255, 33, 33, 33)*/
            borderRadius: BorderRadius.circular(20)),
        constraints: BoxConstraints(minHeight: 50, minWidth: 50),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: _createHudViewChild(child),
        ),
      ),
    );
  }

  Widget _createHudViewChild(Widget child) {
    if (_progressType == HCHudType.text) {
      return Container(
          padding: EdgeInsets.all(6),
          child: Text(_text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none)));
    } else if (_text.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6),
            child: child,
          ),
          Container(
            child: Text(_text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none)),
          )
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.all(6),
        child: child,
      );
    }
  }

  void _setDefSize() {
    double w = _constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    double h = _constraints?.maxHeight ?? MediaQuery.of(context).size.height;
    if (widget.width is double && (widget.width ?? 0) > 0) {
      _defW = widget.width!;
    } else if (w > 0) {
      _defW = w;
    } else {
      _defW = 0;
    }

    if (widget.height is double && (widget.height ?? 0) > 0) {
      _defH = widget.height!;
    } else if (h > 0) {
      _defH = h;
    } else {
      _defH = 0;
    }
  }

  _showAtHeightCenter(double widgetH) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_disposed) {
        return;
      }
      double hudH = _globalKey.currentContext?.size?.height ?? 0;
      _y = (widgetH - hudH) * 0.5;
      if (_isVisible) {
        if (_animated) {
          _animation?.reset();
          _animation?.forward();
        } else {
          _opacity = 1.0;
        }
      } else {
        _opacity = 0.0;
      }
      setState(() {});
    });
  }
}
