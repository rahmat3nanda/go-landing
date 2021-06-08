import 'package:flutter/material.dart';
import 'package:go_landing/model/app/container_model.dart';

class Landing1Page extends StatefulWidget {
  @override
  _Landing1PageState createState() => _Landing1PageState();
}

class _Landing1PageState extends State<Landing1Page> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  ContainerModel _mainContainer;
  ContainerModel _defaultMainContainer;
  ContainerModel _secondContainer;
  ContainerModel _defaultSecondContainer;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _mainContainer = ContainerModel();
    _secondContainer = ContainerModel();
  }

  void _onPanUpdateMain(DragUpdateDetails d) {
    int s = 8;
    MediaQueryData data = MediaQuery.of(context);
    if (d.delta.dy > s) {
      setState(() {
        _mainContainer = _defaultMainContainer;
      });
    } else if (d.delta.dy < -s) {
      setState(() {
        _mainContainer.height =
            data.size.height - data.padding.top - kToolbarHeight;
        _mainContainer.borderRadius =
            BorderRadius.vertical(top: Radius.circular(24.0));
      });
    }
  }

  void _onPanUpdateSecond(DragUpdateDetails d) {
    int s = 8;
    MediaQueryData data = MediaQuery.of(context);
    if (d.delta.dy > s) {
      setState(() {
        _secondContainer = _defaultSecondContainer;
        _mainContainer.height =
            data.size.height - data.padding.top - kToolbarHeight;
      });
    } else if (d.delta.dy < -s) {
      setState(() {
        _mainContainer.height = data.size.height;
        _secondContainer.height = data.size.height - data.padding.top;
        _secondContainer.borderRadius =
            BorderRadius.vertical(top: Radius.circular(24.0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    MediaQueryData d = MediaQuery.of(context);
    _defaultMainContainer = ContainerModel(
      width: d.size.width,
      height: kToolbarHeight * 1.5,
      borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
    );
    _defaultSecondContainer = ContainerModel(
      width: d.size.width * .8,
      height: kToolbarHeight * 1.75,
      borderRadius: BorderRadius.circular(32.0),
    );
    return Stack(
      children: [
        Container(
          width: d.size.width,
          height: d.size.height,
          color: Colors.blue,
        ),
        _mainView(),
      ],
    );
  }

  Widget _mainView() {
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        height: _mainContainer.height ?? _defaultMainContainer.height,
        width: _mainContainer.width ?? _defaultMainContainer.width,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius:
              _mainContainer.borderRadius ?? _defaultMainContainer.borderRadius,
        ),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Column(
          children: [
            Container(
              width: _mainContainer.width ?? _defaultMainContainer.width,
              height: kToolbarHeight * .5,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 128.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  GestureDetector(onPanUpdate: _onPanUpdateMain),
                ],
              ),
            ),
            Expanded(
              child: IgnorePointer(
                ignoring: _mainContainer.height == _defaultMainContainer.height,
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring:
                          _mainContainer.height == _defaultMainContainer.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 100,
                        itemBuilder: (context, i) => Text("Main $i"),
                      ),
                    ),
                    _secondView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondView() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: (_mainContainer.height ?? _defaultMainContainer.height) ==
                _defaultMainContainer.height
            ? 0.0
            : 1.0,
        duration: Duration(seconds: 1),
        child: AnimatedContainer(
          margin: EdgeInsets.all(
              (_secondContainer.height ?? _defaultSecondContainer.height) ==
                      _defaultSecondContainer.height
                  ? 16.0
                  : 0.0),
          height: _secondContainer.height ?? _defaultSecondContainer.height,
          width: _secondContainer.width ?? _defaultSecondContainer.width,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: _secondContainer.borderRadius ??
                _defaultSecondContainer.borderRadius,
          ),
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          child: Column(
            children: [
              Container(
                width: _secondContainer.width ?? _defaultSecondContainer.width,
                height: kToolbarHeight * .5,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 128.0,
                        height: 18.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    GestureDetector(onPanUpdate: _onPanUpdateSecond),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
