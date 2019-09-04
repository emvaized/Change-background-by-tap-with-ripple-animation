import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Test app for BeKey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List _colors = [
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.pink,
    Colors.cyan,
    Colors.green,
    Colors.orange,
    Colors.brown,
    Colors.teal
  ];

  List _colorNames = [
    'blue',
    'indigo',
    'pink',
    'cyan',
    'green',
    'orange',
    'brown',
    'teal'
  ];

  Random random = new Random();
  Offset _touchPoint = Offset.zero;
  Animation _newColorScale;
  AnimationController _newColorScaleController;
  Color _backgroundColor;
  Color _newColor;
  int _colorIndex;
  int _previousColorIndex;
  bool _initialTextIsVisible;

  @override
  void initState() {
    _initialTextIsVisible = true;
    _backgroundColor = Colors.white;
    _newColor = Colors.black;
    _colorIndex = 0;
    _previousColorIndex = 1;
    _newColorScaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 650));
    _newColorScale =
        Tween(begin: 0.0, end: 3.5).animate(_newColorScaleController);
    super.initState();
  }

  _updateColor(details) {
    setState(() {
      _touchPoint = details.globalPosition;
    });
    _newColorScaleController.reset();
    _newColorScaleController.forward().then((anim) {
      setState(() {
        _initialTextIsVisible = false;
        _backgroundColor = _newColor;
      });
    });
    _getRandomNewColor();
  }

  void _getRandomNewColor() {
    _colorIndex = random.nextInt(_colors.length);
    if (_colorIndex == _previousColorIndex) {
      _getRandomNewColor();
    }
    _newColor = _colors[_colorIndex];
    _previousColorIndex = _colorIndex;
  }

  _restartColors() {
    setState(() {
      _backgroundColor = Colors.white;
      _initialTextIsVisible = true;
      _newColorScaleController.reverse();
    });
  }

  @override
  void dispose() {
    _newColorScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: _restartColors,
            color: Colors.black87,
            tooltip: 'Restart colors',
          )
        ],
      ),
      body: GestureDetector(
        onPanDown: (details) => _updateColor(details),
        child: Container(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width,
            color: _backgroundColor,
            child: Stack(
              children: <Widget>[
                Visibility(
                  visible: _initialTextIsVisible,
                  child: Center(
                    child: Text(
                      'Tap screen',
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  left: _touchPoint.dx - 200,
                  top: _touchPoint.dy - 410,
                  child: ScaleTransition(
                      scale: _newColorScale,
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: _newColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Text(
                            _colorNames[_colorIndex],
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          )),
                        ),
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
