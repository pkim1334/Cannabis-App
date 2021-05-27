import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/*
void main() {

  runApp(
      MaterialApp(
        title: "Project",
        home: HomePage(),
      )
  );
}

 */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.greenAccent,
      accentColor: Colors.black
    ),
      home: App()
  ));
}




class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return HomePage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("Waiting");
      },
    );
  }
}


class userData {
  final String name;
  final bool medCannabis;
  final double levelAnxiety;
  final double levelInsomnia;
  final double levelPain;
  final double levelAppLoss;
  final double levelFatigue;
  final double levelBadMood;

  userData(this.name, this.medCannabis, this.levelAnxiety, this.levelInsomnia, this.levelPain, this.levelAppLoss, this.levelFatigue, this.levelBadMood);

  userData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        medCannabis = json['medCannabis'],
        levelAnxiety = json['levelAnxiety'],
        levelInsomnia = json['levelInsomnia'],
        levelPain = json['levelPain'],
        levelAppLoss = json['levelAppLoss'],
        levelFatigue = json['levelFatigue'],
        levelBadMood = json['levelBadMood'];


  Map<String, dynamic> toJson() => {
    "name" : name,
    "medCannabis" : medCannabis,
    "levelAnxiety" : levelAnxiety,
    "levelInsomnia" : levelInsomnia,
    "levelPain" : levelPain,
    "levelAppLoss" : levelAppLoss,
    "levelFatigue" : levelFatigue,
    "levelBadMood" : levelBadMood,
  };


}

class strain {
  final String strain_name;
  final String best_for;
  final String description;

  strain(this.strain_name, this.best_for, this.description);

  strain.fromJson(Map<String, dynamic> json)
    : strain_name = json['strain_name'],
      best_for = json['best_for'],
      description = json['description'];

  Map<String, dynamic> toJson() => {
    "strain_name" : strain_name,
    "best_for" : best_for,
    "description" : description,
  };
}

List<strain> strain_list;


/*
Future<void> _getData() async{
  var url = Uri.parse("https://jsonplaceholder.typicode.com/todos");
  var response = await http.get(url);



  user_database =(convert.jsonDecode(response.body) as List).map((i) =>
      userData.fromJson(i)).toList();
  print("Got data");
  print(user_database[0]);
}

Future<void> saveJson() async{
  Directory documents = await getApplicationDocumentsDirectory();
  print(documents.path);
  File file = File('${documents.path}/example_2.json');
  try {
    String jsonString = convert.jsonEncode(user_database);
    await file.writeAsString(jsonString);
  } catch (e) {
    print("Problem saving! Error: $e");
  }
}

 */

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Cannabis'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/app_logo.png'),
            ElevatedButton(
              child: Text('New User'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                onPrimary: Colors.black87,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
              },
            ),
            ElevatedButton(
              child: Text('List of User'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                onPrimary: Colors.black87,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
              },
            ),
            ElevatedButton(
              child: Text('List of Strains'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                onPrimary: Colors.black87,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
              },
            ),
            ElevatedButton(
              child: Text('About Us(me)'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                onPrimary: Colors.black87,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
              },
            ),
          ]
        ),
      ),
    );

  }
}

class AboutMe extends StatefulWidget{
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {

  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us(me)'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: <Widget>[
                Text("""My name is Patrick Kim, and I am a college student at Muhlenberg College. This is my first app I've ever developed, and I decided to make a user-friendly interface for medical cannabis patients. The main goal for this is to be an app-like version of the Leafly website.
                Here is where the \"strains\" are sourced: """),
                Container(
                  child:  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child:   GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                    ),
                  )
                )
              ]
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Stack(
                    children: <Widget>[
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Colors.black
                        ),
                      ),
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, color: Colors.greenAccent),
                      )
                    ],
                  )
              ),
              Image.asset('assets/app_logo.png'),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                title: Text("New User"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
                },
              ),
              ListTile(
                title: Text("List of Users"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
                },
              ),
              ListTile(
                title: Text("List of Strains"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
                },
              ),
              ListTile(
                title: Text("About Us(me)"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
                },
              ),

            ]
        ),
      ),
    );

  }
}

class ProperForm extends StatefulWidget {
  @override
  _ProperFormState createState() => _ProperFormState();
}

class _ProperFormState extends State<ProperForm> {

  final GlobalKey<FormState> _key = GlobalKey();

  final Map<String, dynamic> _searchForm = <String, dynamic>{
    'name' : '',
    'medCannabis' : false
  };


  void setName(String val) {
    _searchForm['name'] = val;
  }

  Map<String, dynamic> personMap;


  bool medCannabis = false;
  String name = '';
  double levelAnxiety = 0;
  double levelInsomnia = 0;
  double levelPain = 0;
  double levelAppLoss = 0;
  double levelFatigue = 0;
  double levelBadMood = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New User Input"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _buildForm(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Stack(
                    children: <Widget>[
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Colors.black
                        ),
                      ),
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, color: Colors.greenAccent),
                      )
                    ],
                  )
              ),
              Image.asset('assets/app_logo.png'),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                title: Text("New User"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
                },
              ),
              ListTile(
                title: Text("List of Users"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
                },
              ),
              ListTile(
                title: Text("List of Strains"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
                },
              ),
              ListTile(
                title: Text("About Us(me)"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
                },
              ),

            ]
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildNameEntry(),
          _buildSliders(),
          _buildCheckBox(),
          _buildSubmitButton(),
        ],
      )
    );
  }

  Widget _buildNameEntry() {
    return TextFormField(
      initialValue: _searchForm['name'],
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      // On every keystroke, you can do something.
      onChanged: (String val) {
        setState(() => setName(val));
      },
      // When the user submits, you could do something
      // for this field
      onFieldSubmitted: (String val) {
        name = _searchForm['name'];
      },
      //Called when we "validate()". The val is the String
      // in the text box.
      //Note that it returns a String; null if validation passes
      // and an error message if it fails for some reason.
      validator: (String val) {
        if (val.isEmpty && RegExp('^[A-Za-z]+').hasMatch(val)) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }


  Widget _buildSliders() {
    return FormField<double>(

        builder: (FormFieldState<double> state) {
          return Column(
              children: <Widget>[
                Text(
                  'Anxiety Level',
                  textAlign: TextAlign.left,
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelAnxiety,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelAnxiety = value;
                    });
                  },
                  label: levelAnxiety.round().toString(),
                ),
                Text(
                  'Insomnia Level',
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelInsomnia,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelInsomnia = value;
                    });
                  },
                  label: levelInsomnia.round().toString(),
                ),
                Text(
                  'Muscle/Joint Pain Level',
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelPain,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelPain = value;
                    });
                  },
                  label: levelPain.round().toString(),
                ),
                Text(
                  'Hunger Level',
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelAppLoss,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelAppLoss = value;
                    });
                  },
                  label: levelAppLoss.round().toString(),
                ),
                Text(
                  'Fatigue Level',
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelFatigue,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelFatigue = value;
                    });
                  },
                  label: levelFatigue.round().toString(),
                ),Text(
                  'Mood Level(0 = good, 5 = bad)',
                  style: TextStyle(height: 5, fontSize: 20),
                ),
                Slider(
                  min: 0,
                  max: 5,
                  value: levelBadMood,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      levelBadMood = value;
                    });
                  },
                  label: levelBadMood.round().toString(),
                ),
              ]);
        }
    );
  }

  Widget _buildCheckBox() {
    return FormField<bool>(
        builder: (FormFieldState<bool> state) {
          return Row(
              children: <Widget>[
                Checkbox(
                    value: _searchForm['medCannabis'],
                    onChanged: (bool val) {
                      setState(() => _searchForm['medCannabis'] = val);
                    }
                ),
                const Text('I am a medical cannabis patient'),
              ]
          );
        }
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      child: const Text('Submit'),
      onPressed: (){
        if(_key.currentState.validate()){
          print('Successfully saved the state.');
        }
        userData newUser = new userData(name, medCannabis, levelAnxiety, levelInsomnia, levelPain, levelAppLoss, levelFatigue, levelBadMood);

        CollectionReference users = FirebaseFirestore.instance.collection('users'); //used to call the needed database

        users.doc().set(<String, dynamic>{ //adding new values to database, creating a new user
          "name" : name,
          "medCannabis" : medCannabis,
          "levelAnxiety" : levelAnxiety,
          "levelInsomnia" : levelInsomnia,
          "levelPain" : levelPain,
          "levelAppLoss" : levelAppLoss,
          "levelFatigue" : levelFatigue,
          "levelBadMood" : levelBadMood,
        }).then<void>((dynamic doc) {
          print("Document added: $doc");
          print(newUser);
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));

      },
    );
  }
}


class ProperForm2 extends StatefulWidget {
  @override
  _ProperFormState2 createState() => _ProperFormState2();
}

class _ProperFormState2 extends State<ProperForm2>{
  CollectionReference users = FirebaseFirestore.instance.collection('users'); //firebase

  final GlobalKey<FormState> _key = GlobalKey();

  String updateName = "";


  Future<void> _userOptions(userData temp, var _key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${temp.name}"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter new name"
                  ),
                  onChanged: (value){
                    updateName = value;
                  },
                )
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Modify"),
              onPressed: () {
                CollectionReference users = FirebaseFirestore.instance.collection('users');

                users.doc().set(<String, dynamic>{ //only changing name, keeping everything else as it is
                  "name" : updateName,
                  "medCannabis" : temp.medCannabis,
                  "levelAnxiety" : temp.levelAnxiety,
                  "levelInsomnia" : temp.levelInsomnia,
                  "levelPain" : temp.levelPain,
                  "levelAppLoss" : temp.levelAppLoss,
                  "levelFatigue" : temp.levelFatigue,
                  "levelBadMood" : temp.levelBadMood,
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Details"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(temp: temp)));

              }
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {

                CollectionReference users = FirebaseFirestore.instance.collection('users');
                users.doc(_key).delete();   //delete the bitch
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }


  // shows database of users as list of list tiles, basically copied from completeDatabase.dart
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("List of Users", textAlign: TextAlign.left,),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError)
                return new Text("Error: ${snapshot.error}");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text("Loading");
                default:
                  return new ListView(
                    children: snapshot.data.docs
                      .asMap()
                      .map((index, value) => MapEntry(
                      index,
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 90,
                            padding: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                userData temp = new userData(value["name"], value["medCannabis"], value["levelAnxiety"].toDouble(), value["levelInsomnia"].toDouble(), value["levelPain"].toDouble(), value["levelAppLoss"].toDouble(), value["levelFatigue"].toDouble(), value["levelBadMood"].toDouble());
                                print("- bottom clicked.");
                                print('Index of the item clicked: ${value.id}');
                                _userOptions(temp, _key);
                              },
                              child: ListTile(
                                title: new Text(value["name"]),
                              ),
                            ),
                          )

                        ],
                      )
                    )
                    ).values.toList()
                  );
              }
            },
          ),
          drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      child: Stack(
                        children: <Widget>[
                          Text(
                            "Menu",
                            style: TextStyle(fontSize: 40, foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5
                              ..color = Colors.black
                            ),
                          ),
                          Text(
                            "Menu",
                            style: TextStyle(fontSize: 40, color: Colors.greenAccent),
                          )
                        ],
                      )
                  ),
                  Image.asset('assets/app_logo.png'),
                  ListTile(
                    title: Text("Home"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                  ListTile(
                    title: Text("New User"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
                    },
                  ),
                  ListTile(
                    title: Text("List of Users"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
                    },
                  ),
                  ListTile(
                    title: Text("List of Strains"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
                    },
                  ),
                  ListTile(
                    title: Text("About Us(me)"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
                    },
                  ),

                ]
            ),
          ),
        )

    );
  }
}



class DetailScreen extends StatelessWidget {
  final userData temp;


  DetailScreen({Key key, @required this.temp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User: ${temp.name}"),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Medical Cannabis Patient: ${temp.medCannabis}", textAlign: TextAlign.start),
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Anxiety Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelAnxiety}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Insomnia Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelInsomnia}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Joint/Muscle Pain Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelPain}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Hunger Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelAppLoss}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Energy Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelFatigue}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Text(
                        "Mood Level: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "${temp.levelBadMood}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]
                ),
              ]
          ),
        ),
      ),


      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Stack(
                    children: <Widget>[
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Colors.black
                        ),
                      ),
                      Text(
                        "Menu",
                        style: TextStyle(fontSize: 40, color: Colors.greenAccent),
                      )
                    ],
                  )
              ),
              Image.asset('assets/app_logo.png'),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                title: Text("New User"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
                },
              ),
              ListTile(
                title: Text("List of Users"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
                },
              ),
              ListTile(
                title: Text("List of Strains"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
                },
              ),
              ListTile(
                title: Text("About Us(me)"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
                },
              ),

            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // double findMax (var list, int n) {
  //   if (n == 1)
  //     return list[0];
  //
  //   return Math.max(list[n-1], findMax(list, n-1));
  // }
  //
  // Widget strainPick(userData temp) {
  //   String strain_pick = "";
  //
  //   var numList = new List(6);
  //   numList[0] = temp.levelAnxiety;
  //   numList[1] = temp.levelInsomnia;
  //   numList[2] = temp.levelPain;
  //   numList[3] = temp.levelAppLoss;
  //   numList[4] = temp.levelFatigue;
  //   numList[5] = temp.levelBadMood;
  //
  //   double maxVal = findMax(numList, numList.length);
  //
  //   int maxIndex = numList.indexOf(maxVal);
  //
  //   if (maxIndex == 0) {
  //     strain_pick = 'strains/SLoX4YkdnTFcHpbIzlDA';
  //
  //   } else if (maxIndex == 1) {
  //     strain_pick = 'strains/zM6ZUJItGh7L9aGUzYUy';
  //
  //   } else if (maxIndex == 2) {
  //     strain_pick = 'strains/XEzympBnzH8tQvwrRRa0';
  //
  //   } else if (maxIndex == 3) {
  //     strain_pick = 'strains/7wTzb8sq1acTo0X8LXCg';
  //
  //   } else if (maxIndex == 4) {
  //     strain_pick = 'strains/EFAH02A7FO2fSdzhZkmE';
  //
  //   } else if (maxIndex == 5) {
  //     strain_pick = 'strains/CsHNfQ66TBNs59Yz7A3Q';
  //
  //   } else {
  //     strain_pick = 'strains/PLeDEZG1hBcNi5QBA3Zb';
  //
  //   }
  //
  //   // print(strain_pick);
  //
  //   return new StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection(strain_pick).snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if(!snapshot.hasData) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //         return ListView(
  //           children: snapshot.data.docs.map((document) {
  //             return Container(
  //               child: Column(
  //                 children: <Widget> [
  //                   Text(
  //                     'Recommended Strain: '
  //                   )
  //                 ]
  //               )
  //             );
  //           })
  //         );
  //       });
  // }
}

class StrainDatabase extends StatefulWidget {
  @override
  _StrainDatabaseState2 createState() => _StrainDatabaseState2();
}

class _StrainDatabaseState2 extends State<StrainDatabase>{
  CollectionReference users = FirebaseFirestore.instance.collection('strains'); //firebase

  final GlobalKey<FormState> _key = GlobalKey();


  Future<void> _displayStrain(strain temp, var _key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${temp.strain_name}"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Best for: ${temp.best_for}"
                  ),
                  Text(
                    "Description: ${temp.description}"
                  )
                ],
              ),
            ),

            actions: <Widget>[
              TextButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
        }
    );
  }


  // shows database of users as list of list tiles, basically copied from completeDatabase.dart
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("List of Strains", textAlign: TextAlign.left,),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError)
                return new Text("Error: ${snapshot.error}");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text("Loading");
                default:
                  return new ListView(
                      children: snapshot.data.docs
                          .asMap()
                          .map((index, value) => MapEntry(
                          index,
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: 90,
                                padding: EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    strain temp = new strain(value["strain_name"], value["best_for"], value["description"]);
                                    print("- bottom clicked.");
                                    print('Index of the item clicked: ${value.id}');
                                    _displayStrain(temp, _key);
                                  },
                                  child: ListTile(
                                    title: new Text(value["strain_name"]),
                                  ),
                                ),
                              )

                            ],
                          )
                      )
                      ).values.toList()
                  );
              }
            },
          ),
          drawer: Drawer(
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      child: Stack(
                        children: <Widget>[
                          Text(
                            "Menu",
                            style: TextStyle(fontSize: 40, foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5
                              ..color = Colors.black
                            ),
                          ),
                          Text(
                            "Menu",
                            style: TextStyle(fontSize: 40, color: Colors.greenAccent),
                          )
                        ],
                      )
                  ),
                  Image.asset('assets/app_logo.png'),
                  ListTile(
                    title: Text("Home"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                  ListTile(
                    title: Text("New User"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm()));
                    },
                  ),
                  ListTile(
                    title: Text("List of Users"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProperForm2()));
                    },
                  ),
                  ListTile(
                    title: Text("List of Strains"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StrainDatabase()));
                    },
                  ),
                  ListTile(
                    title: Text("About Us(me)"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
                    },
                  ),

                ]
            ),
          ),
        )

    );
  }
}


