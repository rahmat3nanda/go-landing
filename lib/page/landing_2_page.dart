import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:go_landing/model/app/container_model.dart';

class Landing2Page extends StatefulWidget {
  @override
  _Landing2PageState createState() => _Landing2PageState();
}

class _Landing2PageState extends State<Landing2Page>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey;
  bool _mainExpanded;
  bool _secondExpanded;
  ContainerModel _secondContainer;
  ContainerModel _defaultSecondContainer;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _mainExpanded = false;
    _secondExpanded = false;
    _secondContainer = ContainerModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Size s = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: s.width,
          height: s.height,
          color: Colors.blue,
        ),
        _mainView(),
        _secondView(),
      ],
    );
  }

  Widget _mainView() {
    MediaQueryData d = MediaQuery.of(context);
    double max =
        (d.size.height - d.padding.top - kToolbarHeight) / d.size.height;
    double min = kToolbarHeight / d.size.height;
    return Positioned.fill(
      child: DraggableScrollableSheet(
        initialChildSize: min,
        minChildSize: min,
        maxChildSize: max,
        expand: false,
        builder: (context, controller) {
          controller.addListener(() {
            setState(() {
              _mainExpanded = !controller.position.pixels.isNegative;
            });
          });
          return Container(
            width: d.size.width,
            padding: const EdgeInsets.only(top: 12.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 100,
                    itemBuilder: (context, i) => Text("Main $i"),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      width: d.size.width,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Center(
                        child: Container(
                          width: 128.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _secondView() {
    MediaQueryData d = MediaQuery.of(context);
    Size s = d.size;
    double max =
        (d.size.height - d.padding.top - kToolbarHeight) / d.size.height;
    double min = kToolbarHeight * 2.5 / s.height;
    _defaultSecondContainer = ContainerModel(
      width: d.size.width * .85,
      height: kToolbarHeight * 1.75,
      borderRadius: BorderRadius.circular(16.0),
      margin: EdgeInsets.only(bottom: 32.0),
    );
    return Positioned.fill(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !_mainExpanded,
        child: AnimatedOpacity(
          opacity: _mainExpanded ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: DraggableScrollableSheet(
            initialChildSize: min,
            minChildSize: min,
            maxChildSize: max,
            expand: false,
            builder: (context, controller) {
              controller.addListener(() {
                setState(() {
                  _secondExpanded = !controller.position.pixels.isNegative;
                  if (_secondExpanded) {
                    _secondContainer.width = d.size.width;
                    _secondContainer.margin = EdgeInsets.zero;
                    _secondContainer.borderRadius =
                        BorderRadius.vertical(top: Radius.circular(16.0));
                  } else {
                    _secondContainer = _defaultSecondContainer;
                  }
                });
              });
              return Center(
                child: AnimatedContainer(
                  width:
                      _secondContainer.width ?? _defaultSecondContainer.width,
                  padding: const EdgeInsets.only(top: 12.0),
                  margin:
                      _secondContainer.margin ?? _defaultSecondContainer.margin,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: _secondContainer.borderRadius ??
                        _defaultSecondContainer.borderRadius,
                  ),
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 700),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: SingleChildScrollView(
                          controller: controller,
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 100,
                            itemBuilder: (context, i) => Text("Item $i"),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Container(
                            width: _secondContainer.width ??
                                _defaultSecondContainer.width,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Container(
                                width: 128.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
