import 'package:flutter/material.dart';


import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';


import 'package:latlong/latlong.dart';


/// makes big button that goes to mapbox maps
/// 
class FindMePlease extends StatefulWidget {

  
  
  
  const FindMePlease();

  @override
  _findMePlease createState() => _findMePlease();
}
class _findMePlease extends State<FindMePlease> {

  Position _currentPosition;
  String _currentAddress;
  
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;


  
  Future<void> _getCurrentLocation() async {
    

    geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      CircularProgressIndicator();
      print(e);
    }); 

  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.name} ${place.thoroughfare},\n${place.locality}, ${place.postalCode},\n${place.country}";
      });
    } catch (e) {
      CircularProgressIndicator();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    _getCurrentLocation();
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Center(
        child: Container(
          height: 300.0,
          width: 300.0,
        
          child: new ClipOval(
          
            child: Material(
            
              color: Colors.blue,
              child: InkWell(
                splashColor: Colors.red,
                child: SizedBox(

                  width: 56.0,
                  height: 56.0,
                  child: Center(
                    child: Text(
                      "Where am I?",
                      style: TextStyle(
                        fontSize: 50.0, 
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (_currentPosition != null && _currentAddress != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapTo(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude, addr: _currentAddress)),
                    );
                  }
                  else {
                    _getCurrentLocation();
                    
                  }
                
                },
              
              ),
            ),
          ),
        ),
      );
    }
    else {
      return Center(
        child: Container(
          height: 180.0,
          width: 400.0,
          
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Material(
            
              color: Colors.blue,
              child: InkWell(
                splashColor: Colors.red,
                child: SizedBox(

                  width: 56.0,
                  height: 56.0,
                  child: Center(
                    child: Text(
                      "Where am I?",
                      style: TextStyle(
                        fontSize: 50.0, 
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (_currentPosition != null && _currentAddress != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapTo(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude, addr: _currentAddress)),
                    );
                  }
                  else {
                    _getCurrentLocation();
                    
                  }                
                },
              
              ),
            ),
          ),
        ),
      );
    }
  
  }
  
}



class MapTo extends StatelessWidget {
  final latitude;
  final longitude;
  final addr;
  
  const MapTo({
    Key key,
    @required this.latitude,
    @required this.longitude,
    @required this.addr,
  })  : assert(latitude != null),
        assert(longitude != null),
        assert(addr != null),
        super(key: key);



  
  
  
  @override
  Widget build(BuildContext context) {
    //print("$_lat, $_long");
    Orientation devOrientationStart = MediaQuery.of(context).orientation;
    ///TODO if orientation changes after map is made, regenerate map
    
    //print("$_lat, $_long");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "There you are!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.close),
              onPressed: () { 
                Navigator.pop(context);
              },
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(latitude, longitude),
          zoom: 14.0,

        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}"
                  "@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken': 'pk.eyJ1IjoiYXRieXJvbiIsImEiOiJjazh4cmw5bGwxMTRtM21wa2lseWc3ZDAzIn0.0-m64CutTVp7EHP2zXJYHw',
              'id': 'mapbox.streets',
            },
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: new LatLng(latitude, longitude),
                builder: (context) => new Container(
                  child: new IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.blue,
                    iconSize: 40.0,
                    tooltip: 'What\'s your latitude and longitude?',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WhereAmI(latitude: latitude, longitude: longitude, addr: addr)),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhereAmI extends StatelessWidget {
  final latitude;
  final longitude;
  final addr;
  const WhereAmI({
    Key key,
    @required this.latitude,
    @required this.longitude,
    @required this.addr,
  })  : assert(latitude != null),
        assert(longitude != null),
        assert(addr != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation devOrientationStart = MediaQuery.of(context).orientation;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 10, width: 10),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 220,
                height: MediaQuery.of(context).orientation == Orientation.portrait 
                      ? MediaQuery.of(context).size.height/6 : MediaQuery.of(context).size.height/6,
                child:  new ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Material(
            
                    color: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.purple[200],
                      child: SizedBox(

                        width: 56.0,
                        height: 56.0,
                        child: Center(
                          child: Text(
                            "Latitude:\n$latitude\nLongitude:\n$longitude",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0, 
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10, width: 10),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 220,
                height: MediaQuery.of(context).orientation == Orientation.portrait 
                      ? MediaQuery.of(context).size.height/6 : MediaQuery.of(context).size.height/6,
                child:  new ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Material(
            
                    color: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      child: SizedBox(

                        width: 56.0,
                        height: 56.0,
                        child: Center(
                          child: Text(
                            "Current Location:\n$addr",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0, 
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              
                            ),
                          ),
                        ),
                      ),
                    onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10, height: 10),
            Align(
              alignment: Alignment.center,
              child: Container(
                    width: 220,
                    height: MediaQuery.of(context).orientation == Orientation.portrait 
                          ? MediaQuery.of(context).size.height/6 : MediaQuery.of(context).size.height/6,
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Material(
            
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.green[200],
                          child: SizedBox(

                            width: 56.0,
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Return to home?",
                                style: TextStyle(
                                  fontSize: 18.0, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        ),
                      ),
                    ),
                  ),
            ),
                  SizedBox(height: 10, width: 10),

                  
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 220,
                    height: MediaQuery.of(context).orientation == Orientation.portrait 
                          ? MediaQuery.of(context).size.height/6 : MediaQuery.of(context).size.height/6,
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Material(
            
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: SizedBox(

                            width: 56.0,
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Return to map?",
                                style: TextStyle(
                                  fontSize: 18.0, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        onTap: () {
                          if (devOrientationStart == MediaQuery.of(context).orientation) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                          else {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MapTo(latitude: latitude, longitude: longitude, addr: addr)));
                          }
                          
                        },
                        ),
                      ),
                    ),
                  ),
                ),
              
            
          ],

        ),
      ),
      appBar: AppBar(
        title: const Text(
          "You're right here!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 450,
          height: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: const Text(
              "Found you!    ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
              
            ),
          ),
        ),
        color: Colors.blue,
        elevation: 4.0,
      ),
    );
    }
    else {
      return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 10, width: 10),
            Center(
              //alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/2,
                child:  new ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Material(
            
                    color: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.purple[200],
                      child: SizedBox(

                        width: 56.0,
                        height: 56.0,
                        child: Center(
                          child: Text(
                            "Latitude:\n$latitude\n\nLongitude:\n$longitude",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0, 
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              
                            ),
                          ),
                        ),
                      ),
                    onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10, width: 10),
            Center(
              //alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/2,
                child:  new ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Material(
            
                    color: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      child: SizedBox(

                        width: 56.0,
                        height: 56.0,
                        child: Center(
                          child: Text(
                            "Current Location:\n$addr",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0, 
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              
                            ),
                          ),
                        ),
                      ),
                    onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10, height: 10),
            Center(
              //alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: MediaQuery.of(context).size.height/14, width: 10),
                  Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/4.25,
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Material(
            
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.green[200],
                          child: SizedBox(

                            width: 56.0,
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Return to home?",
                                style: TextStyle(
                                  fontSize: 18.0, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        ),
                      ),
                    ),
                  ),
                  ),
            
                  SizedBox(height: 10, width: 10),

                  
                Center(
                  //alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/4.25,
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Material(
            
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: SizedBox(

                            width: 56.0,
                            height: 56.0,
                            child: Center(
                              child: Text(
                                "Return to map?",
                                style: TextStyle(
                                  fontSize: 18.0, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        onTap: () {
                          if (devOrientationStart == MediaQuery.of(context).orientation) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                          else {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MapTo(latitude: latitude, longitude: longitude, addr: addr)));
                          }
                        },
                        ),
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
                
            
          ],

        ),
      ),
      appBar: AppBar(
        title: const Text(
          "You're right here!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 450,
          height: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: const Text(
              "Found you!    ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
              
            ),
          ),
        ),
        color: Colors.blue,
        elevation: 4.0,
      ),
    );
    }
  }
}

class NationalPark extends StatelessWidget {
  final latitude_old;
  final longitude_old;
  
  NationalPark({
    Key key,
    @required this.latitude_old,
    @required this.longitude_old,
  })  : assert(latitude_old != null),
        assert(longitude_old != null),
        super(key: key);
  Geolocator _geo;
  double yosemite_lat = 37.8651;
  double yosemite_long = 37.8651;
  double distance;
  Future<void> _dist() async {
    distance = await _geo.distanceBetween(
    latitude_old, longitude_old, yosemite_lat, yosemite_long);
  }
  
  @override
  Widget build(BuildContext context) {
    _dist();
    return Scaffold(
      body: Center(
                  child: Container(
                    width: 220,
                    height: MediaQuery.of(context).size.height/3,
                    child:  new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Material(
            
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: SizedBox(

                            width: 56.0,
                            height: 56.0,
                            child: Center(
                              child: Text(
                                
                                "Distance to Yosemite National Park: $distance",
                                style: TextStyle(
                                  fontSize: 18.0, 
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        ),
                      ),
                    ),
                  ),
                ),
      appBar: AppBar(
        title: const Text(
          "Wow!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 450,
          height: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: const Text(
              "Cool!    ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
              
            ),
          ),
        ),
        color: Colors.blue,
        elevation: 4.0,
      ),
    );
    
  }

}

void main() {
  runApp(MyMapsApp());
}


class MyMapsApp extends StatelessWidget {


    

  @override
  Widget build(BuildContext context) {

    //LocationStuff();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Where am I?',
      theme: ThemeData(
        
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
       
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.grey[800],
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: FindMePlease(),
        appBar: AppBar(
          title: const Text(
            "Find out where you are",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          backgroundColor: Colors.blue,

        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            width: 450,
            height: 60,
            child: Align(
              alignment: Alignment.centerRight,
              child: const Text(
                "Where are you?    ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
                
              ),
            ),
          ),
          color: Colors.blue,
          elevation: 4.0,
          
        ),
      ),
    );
  }
}

class LocationStuff extends StatefulWidget {
 
  const LocationStuff();

  @override
  _locationStuff createState() => _locationStuff();
  
}

class _locationStuff extends State<LocationStuff> {

  Position _currentPosition;

  
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;


  
  Future<void> _getCurrentLocation() async {
    

    geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        
      });
    
    }).catchError((e) {
      CircularProgressIndicator();
      print(e);
    }); 

    
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    setState(() {
      
      
    });

    return Scaffold(
      body: Container(
        
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.black,
          child: InkWell(
            splashColor: Colors.white,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FindMePlease()));
            },
          ),
        )

        
      ),
    );
  }
  
}