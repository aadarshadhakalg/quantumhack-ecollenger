import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecollenger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecollenger/UI/FadeIndexStack.dart';
import 'package:ecollenger/constants.dart';
import 'package:ecollenger/UI/ChallengeContainer.dart';
import 'package:ecollenger/UI/CircleButtons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecollenger/profile.dart';

class Dashboard extends StatefulWidget {
  final String uuid;
  Dashboard({Key key, this.uuid}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List acceptedChallenges = [];
  final GoogleSignIn googleSignIn = GoogleSignIn();

  double topPositionScreen = 0;
  double leftPositionScreen = 0;
  double screenWidth;
  double screenHeight;
  bool drawerOpen = false;
  List challengeList = [
    {
      "imageUrl":
          "https://thumbs.dreamstime.com/b/man-watering-tree-hose-woman-plantation-concept-164422564.jpg",
      "challenge": "Plant Trees Around Your Area",
      "days": 10,
      "hours": 23,
      "min": 56,
      "point": 5,
    },
    {
      "imageUrl":
          "https://thumbs.dreamstime.com/b/man-watering-tree-hose-woman-plantation-concept-164422564.jpg",
      "challenge": "Waste Management Challenge",
      "days": 10,
      "hours": 23,
      "min": 56,
      "point": 10,
    },
    {
      "imageUrl":
          "https://thumbs.dreamstime.com/b/man-watering-tree-hose-woman-plantation-concept-164422564.jpg",
      "challenge": "Save a Animal Challenge",
      "days": 10,
      "hours": 23,
      "min": 56,
      "point": 23,
    },
  ];
  String nickname = '';
  String photoUrl = '';
  String email = '';

  int collectedPoints = 0;
  @override
  void initState() {
    readLocal();
    getChallenges();
    super.initState();
  }

  void readLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nickname = prefs.getString('nickname') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      email = prefs.getString('email') ?? '';
      collectedPoints = prefs.getInt('point') ?? '';
    });
  }

  Future<void> getChallenges() async {
    print(widget.uuid);
    final QuerySnapshot result = await Firestore.instance
        .collection('todos')
        .where('id', isEqualTo: widget.uuid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((element) {
      setState(() {
        acceptedChallenges.add({
          "imageUrl": element['imageUrl'],
          "challenge": element["challenge"],
          "days": element["days"],
          "hours": element["hours"],
          "min": element["min"],
          "point": element["point"],
        });
        challengeList.removeWhere(
            (element2) => element2['challenge'].contains(element['challenge']));
        challengeList.join(', ');
      });
    });
    print(challengeList);
  }

  var stackIndex = 0;

  List savedChallenges = [];
  List completedChallenges = [];

  // Header UI //
  _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.bell,
                color: Colors.black,
              ),
              //TODO: Implement Notification
              onPressed: null,
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: GestureDetector(
              onTap: () {
                if (!drawerOpen) {
                  setState(() {
                    topPositionScreen = (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height / 1.2) /
                        2;
                    leftPositionScreen =
                        MediaQuery.of(context).size.width / 1.4;
                    screenHeight = MediaQuery.of(context).size.height / 1.2;
                    screenWidth = MediaQuery.of(context).size.width / 1.2;
                    drawerOpen = true;
                  });
                } else {
                  setState(() {
                    topPositionScreen = 0;
                    leftPositionScreen = 0;
                    screenHeight = null;
                    screenWidth = null;
                    drawerOpen = false;
                  });
                }
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 1),
                      blurRadius: 1,
                      spreadRadius: 1,
                    )
                  ],
                  image: DecorationImage(
                    image: NetworkImage(photoUrl),
                  ),
                ),
                child: AnimatedOpacity(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  opacity: drawerOpen ? 1 : 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: AnimatedOpacity(
              duration: Duration(
                milliseconds: 300,
              ),
              opacity: drawerOpen ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 28.0,
                    ),
                  ),
                  Text(
                    nickname,
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "2020 August 29, Saturday",
                    style: klabelText,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Challenges UI - Shows Challenges //

  _challenges() {
    var voilaText = ktitleText;
    var doneText = ktitleText;

    if (challengeList.isNotEmpty) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            width: MediaQuery.of(context).size.width,
            height: 250.0,
            child: FadeIndexedStack(
              index: stackIndex >= challengeList.length ? 0 : stackIndex,
              children: List<Widget>.generate(
                challengeList.length,
                (index) => ChallengeContainer(
                  context: context,
                  imageUrl: challengeList[index]["imageUrl"],
                  challenge: challengeList[index]["challenge"],
                  days: challengeList[index]["days"],
                  hours: challengeList[index]["hours"],
                  min: challengeList[index]["min"],
                  point: challengeList[index]["point"],
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) => Positioned(
              bottom: 5,
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleButtons(
                      icon: FontAwesomeIcons.exchangeAlt,
                      iconColor: Colors.red,
                      onTap: () {
                        //TODO: Implement Delete
                        setState(() {
                          stackIndex == challengeList.length - 1
                              ? stackIndex = 0
                              : stackIndex++;
                        });
                      },
                    ),
                    CircleButtons(
                      icon: FontAwesomeIcons.save,
                      iconColor: Colors.yellow[900],
                      onTap: () {
                        savedChallenges.contains(challengeList[stackIndex])
                            ? Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Challenge Already Saved!")))
                            : savedChallenges.add(challengeList[stackIndex]);
                        setState(() {
                          stackIndex == challengeList.length - 1
                              ? stackIndex = 0
                              : stackIndex++;
                        });
                      },
                    ),
                    CircleButtons(
                      icon: FontAwesomeIcons.plus,
                      iconColor: Colors.green,
                      onTap: () {
                        acceptedChallenges.add(challengeList[stackIndex]);
                        DocumentReference documentReference =
                            Firestore.instance.collection('todos').document();
                        documentReference.setData(
                          {
                            "imageUrl": challengeList[stackIndex]['imageUrl'],
                            "challenge": challengeList[stackIndex]["challenge"],
                            "days": challengeList[stackIndex]["days"],
                            "hours": challengeList[stackIndex]["hours"],
                            "min": challengeList[stackIndex]["min"],
                            "point": challengeList[stackIndex]["point"],
                            "id": widget.uuid,
                            "docId": documentReference.documentID
                          },
                        );

                        challengeList.removeAt(stackIndex);
                        setState(() {
                          if (stackIndex >= challengeList.length - 1) {
                            stackIndex = 0;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 30.0,
        ),
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.green,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: FutureBuilder(
              future: Future.delayed(
                  Duration(
                    milliseconds: 50,
                  ), () {
                doneText = klabelText.copyWith(color: Colors.black87);
                voilaText = klabelText;
              }),
              builder: (BuildContext context, AsyncSnapshot snapshot) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedDefaultTextStyle(
                    style: voilaText,
                    duration: Duration(
                      milliseconds: 300,
                    ),
                    child: Text(
                      "Voila! ",
                      style: ktitleText.copyWith(
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    style: doneText,
                    duration: Duration(
                      seconds: 1,
                    ),
                    child: Text(
                      "You're Done",
                      style: ktitleText.copyWith(fontSize: 25.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  _acceptedChallenges() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('todos')
          .where('id', isEqualTo: widget.uuid)
          .snapshots(),
      //print an integer every 2secs, 10 times
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.documents.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    height: 100,
                    image: NetworkImage(
                        "https://itrealty.ca/assets/img/basic/no-result-found.png")),
                Text(
                  "It's Empty",
                  style: ktitleText,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    challengeList.add(snapshot.data.documents[index]);

                    Firestore.instance
                        .collection('todos')
                        .document(snapshot.data.documents[index]['docId'])
                        .delete();
                    setState(() {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Challenge Removed"),
                        ),
                      );
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      snapshot.data.documents[index]["point"].toString(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      snapshot.data.documents[index]["challenge"],
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          completedChallenges
                              .add(snapshot.data.documents[index]);
                          collectedPoints +=
                              snapshot.data.documents[index]["point"];

                          Firestore.instance
                              .collection('users')
                              .document(widget.uuid)
                              .updateData({'point': collectedPoints});

                          Firestore.instance
                              .collection('todos')
                              .document(snapshot.data.documents[index]['docId'])
                              .delete();
                        },
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Future<Null> handleSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('nickname');
    prefs.remove('photoUrl');
    prefs.remove('point');

    prefs.setBool('isLogged', false);
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }

  _drawer() {
    return Container(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 1.4,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            accountName: AnimatedOpacity(
              duration: Duration(
                milliseconds: 300,
              ),
              opacity: drawerOpen ? 1 : 0,
              child: Text(
                nickname,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            accountEmail: AnimatedOpacity(
              duration: Duration(
                milliseconds: 300,
              ),
              opacity: drawerOpen ? 1 : 0,
              child: Text(
                email,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            currentAccountPicture: AnimatedOpacity(
              duration: Duration(
                milliseconds: 300,
              ),
              opacity: drawerOpen ? 1 : 0,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: ListTile(
              title: Text(
                "Your Points",
                style: kdrawerText,
              ),
              subtitle: Text(
                collectedPoints.toString(),
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: null),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: ListTile(
              title: Text(
                "Profile Settings",
                style: kdrawerText,
              ),
              subtitle: Text(
                nickname,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      topPositionScreen = 0;
                      leftPositionScreen = 0;
                      screenHeight = null;
                      screenWidth = null;
                      drawerOpen = false;
                    });
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) => Profile()));
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: ListTile(
              title: Text(
                "Logout",
                style: kdrawerText,
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: handleSignOut),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "App Version : 1.0.0",
              style: kdrawerText,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          _drawer(),
          AnimatedPositioned(
            top: topPositionScreen,
            left: leftPositionScreen,
            duration: Duration(
              milliseconds: 300,
            ),
            child: AnimatedContainer(
              foregroundDecoration: BoxDecoration(
                color: drawerOpen ? Colors.black12 : Colors.transparent,
              ),
              duration: Duration(
                milliseconds: 300,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    spreadRadius: 0,
                  )
                ],
              ),
              height: screenHeight ?? MediaQuery.of(context).size.height,
              width: screenWidth ?? MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _header(),
                    _challenges(),
                    SizedBox(
                      height: 30.0,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          decoration: kchallengeBoxDecoration,
                          height: 250.0,
                          child: _acceptedChallenges(),
                        ),
                        Positioned(
                          top: 0,
                          left: 10,
                          child: Container(
                            height: 20.0,
                            color: Colors.white,
                            child: Text(
                              " Your Challenges: ",
                              style: ktitleText.copyWith(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
