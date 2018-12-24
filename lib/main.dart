/*
 * Created Just for fun
 * This one is incomplete so maybe I'll complete this (nearly in a decade)
 * If you found any issue please submit pr instead of issue :P
 * This code could be optimized (not sure) never worked or studied flutter
 * just went through documentation whenever stuck. Optimize it if possible
 */
import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        backgroundColor: Colors.transparent,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<String> data = [
    "Awesome Flutter",
    "Awesome Flutter",
    "Awesome Flutter",
    "Awesome Flutter"
  ];
  AnimationController _animationController, _animationBackgroundController;
  CurvedAnimation _tapController, _backgroundController;
  int _activeIndex;
  int _oldActiveIndex;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animationBackgroundController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _tapController = CurvedAnimation(
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
      parent: _animationController,
    );

    _backgroundController = CurvedAnimation(
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
      parent: _animationBackgroundController,
    );

    _animationController.forward();
    _activeIndex = 0;
    _oldActiveIndex = -1;
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          crossFadeImage(0),
          crossFadeImage(1),
          crossFadeImage(2),
          crossFadeImage(3),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.5)
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: searchBar(),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        fit: StackFit.expand,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: FadeTransition(
                      opacity: _tapController,
                      child: recipeDetail(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      height: 130,
                      child: PageView.builder(
                        onPageChanged: (page) => _startAnimation(page),
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: recipeCard("${data[index]} ${index + 1}"),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder transitionImageBuilder(
      String image, double opacity, controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Image.asset(
        "assets/$image",
        fit: BoxFit.cover,
      ),
    );
  }

  ClipRRect searchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(70),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              alignment: Alignment(1.0, 0.0),
//              width: _searchAnimation.value.toDouble(),
              child: TextField(
                enabled: false,
                //Just here to make it look better doesn't do anything
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white, size: 30.0),
                    labelStyle: TextStyle(fontSize: 30.0, color: Colors.white),
                    border: InputBorder.none,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Search for recepies and channels",
                    fillColor: Colors.white70.withOpacity(0.32)),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding recipeCard(data) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    'assets/sandwich_ico.png',
                    height: 100,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: cardDetailRightInfo(data),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column cardDetailRightInfo(data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$data \nInformation Stick",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "_____________",
          style: TextStyle(color: Colors.yellow),
        ), //Dirty but 5 sec workaround :P
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('assets/sandwich.jpg'),
                radius: 12.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "James T. Kirk",
                    style: TextStyle(color: Colors.white),
                  ), //Why not captain of USS Enterprise (NCC-1701)
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column recipeDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${data[_activeIndex]} ${_activeIndex + 1}",
          style: TextStyle(fontSize: 50, color: Colors.white),
        ),
        Text(
          "A sandwich is a food typically consisting of vegetables, sliced cheese or meat, placed on or between slices of bread, or more generally any dish wherein two or more pieces of bread serve as a container or wrapper for another food type",
          style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  void _startAnimation(page) {
    _animationController.reverse().then((data) {
      setState(() {
        _oldActiveIndex = _activeIndex;
        _activeIndex = page;
      });
      _animationBackgroundController.forward(from: 0.0);
      _animationController.forward();
    });
  }

  double _fadeOutAnimation(index) {
    if (_oldActiveIndex == index) {
      return 1 - _backgroundController.value;
    }
    if (_activeIndex == index && _oldActiveIndex != -1) {
      return _backgroundController.value;
    }
    if (_oldActiveIndex == -1 && index == 0) {
      return 1.0;
    }
    return 0.0;
  }

  Widget crossFadeImage(index) {
    return AnimatedBuilder(
      animation: _animationBackgroundController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeOutAnimation(index),
          child: child,
        );
      },
      child: Image.asset(
        "assets/image_${index + 1}.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}

/*
 * Went through entire code??
 * Here is a potato for you
 * https://www.youtube.com/watch?v=q7uyKYeGPdE
 */
