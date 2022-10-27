import 'dart:async';
import 'dart:developer';
import 'package:dynamiclinknewdemo/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


/* there are two ways that your app will handle a deep link:

Cold start: A cold start is starting the app anew if the app was terminated (not running in the background).
 In this case, _initURIHandler will be invoked and have the initial link Coming back to the foreground:
 If the app is running in the background and you need to bring it back to the foreground, the Stream will produce the link.
  The initial link can either be null or be the link with which the app started
The _initURIHandler should be handled only once in your app’s lifecycle, as it is used to start the app and not to change throughout the app journey.
 So, create a global variable _initialURILinkHandled as false anywhere in your main.dart:*/

bool _initialURILinkHandled = false;

void main() {

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /*In your main.dart file, clean your MyHomePage widget by removing the existing code and creating new variables as below:*/

  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  /* Here you are declaring:

  Two Uri variables to identify the initial and active/current URI,
      An Object to store the error in case of link parsing malfunctions
  A StreamSubscription object to listen to incoming links when the app is in the foreground*/

  String? userName;
  String? userID;




  /* Next, create the _initURIHandler method as below:*/



  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2
      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          debugPrint("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          //split uri for getting data from uri
          final allParamsList = initialURI.toString().split("/");

          //logic for getting the particular key data
          for (int i = 0; i < allParamsList.length; i++) {
            if (allParamsList[i].contains("username")) {
              final usernameVariable = allParamsList[i];
              userName = usernameVariable.split("username=").last;
            } else if (allParamsList[i].contains("userID")) {
              final usernameVariable = allParamsList[i];
              userID = usernameVariable.split("userID=").last;
            }
          }
          if(initialURI.toString().contains("profileDetails")){
            String profilePictureLink="";
            String username="";
            String emailId="";
            String firstname="";
            String lastName="";
            String phoneNumber="";
            String userId="";
            final forprofilepicture=initialURI.toString().split("/profilePictureLink=").last;
            print(forprofilepicture);
            final allParamsList = initialURI.toString().split("/?");


            print(allParamsList);

            for (int i = 0; i < allParamsList.length; i++) {
              if (allParamsList[i].contains("username")) {
                final usernameVariable = allParamsList[i];
                username = usernameVariable.split("username=").last;
              } else if (allParamsList[i].contains("userID")) {
                final usernameVariable = allParamsList[i];
                userId = usernameVariable.split("userID=").last;
              }
              else if (allParamsList[i].contains("emailID")) {
                final usernameVariable = allParamsList[i];
                emailId = usernameVariable.split("emailID=").last;
              }
              else if (allParamsList[i].contains("firstName")) {
                final usernameVariable = allParamsList[i];
                firstname = usernameVariable.split("firstName=").last;
              }
              else if (allParamsList[i].contains("lastname")) {
                final usernameVariable = allParamsList[i];
                lastName = usernameVariable.split("lastname=").last;
              }
              else if (allParamsList[i].contains("phoneNumber")) {
                final usernameVariable = allParamsList[i];
                phoneNumber = usernameVariable.split("phoneNumber=").last;
              }
              else if (allParamsList[i].contains("profilePictureLink")) {
                final usernameVariable = allParamsList[i];
                print("usernameVariable $usernameVariable");
                profilePictureLink = usernameVariable.split("profilePictureLink=").last;

              }
            }
//for open a specific page or product page in app
            //use get navigate for easy navigation
            Get.to(()=>ProfilePage(profilePictureLink: profilePictureLink, username: username, emailId: emailId, firstname: firstname, lastName: lastName, phoneNumber: phoneNumber, userId: userId));
          }
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          debugPrint("Null Initial URI received");
        }
      } on PlatformException { // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) { // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }


/*  In the above code, you have done the following:

  Used a check here so that the _initURIHandler will only be called once even in case of a widget being disposed of
  Displayed a toast using the fluttertoast package when this method was invoked
  Used the getInitialUri method to parse and return the link as a new URI in initialURI variable
  Checked whether the initialURI is null or not. If not null, set up the _initialURI value w.r.t initialURI
  Handled the platform messages fail using PlatformException
  Handled the FormatException if the link is not valid as a URI
  Next, create the _incomingLinkHandler method used to receive links while the app is already started:*/


  void _incomingLinkHandler() {
    // 1
    if (!kIsWeb) {
      // 2
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
//split uri for getting data from uri
        final allParamsList = uri.toString().split("/");

        //logic for getting the particular key data
        for (int i = 0; i < allParamsList.length; i++) {
          if (allParamsList[i].contains("username")) {
            final usernameVariable = allParamsList[i];
            userName = usernameVariable.split("username=").last;
          } else if (allParamsList[i].contains("userID")) {
            final usernameVariable = allParamsList[i];
            userID = usernameVariable.split("userID=").last;
          }
        }
        if(uri.toString().contains("profileDetails")){
          String profilePictureLink="";
          String username="";
          String emailId="";
          String firstname="";
          String lastName="";
          String phoneNumber="";
          String userId="";
          final forprofilepicture=uri.toString().split("/profilePictureLink=").last;
          print(forprofilepicture);
          final allParamsList = uri.toString().split("/?");


          print(allParamsList);

          for (int i = 0; i < allParamsList.length; i++) {
            if (allParamsList[i].contains("username")) {
              final usernameVariable = allParamsList[i];
              username = usernameVariable.split("username=").last;
            } else if (allParamsList[i].contains("userID")) {
              final usernameVariable = allParamsList[i];
              userId = usernameVariable.split("userID=").last;
            }
            else if (allParamsList[i].contains("emailID")) {
              final usernameVariable = allParamsList[i];
              emailId = usernameVariable.split("emailID=").last;
            }
            else if (allParamsList[i].contains("firstName")) {
              final usernameVariable = allParamsList[i];
              firstname = usernameVariable.split("firstName=").last;
            }
            else if (allParamsList[i].contains("lastname")) {
              final usernameVariable = allParamsList[i];
              lastName = usernameVariable.split("lastname=").last;
            }
            else if (allParamsList[i].contains("phoneNumber")) {
              final usernameVariable = allParamsList[i];
              phoneNumber = usernameVariable.split("phoneNumber=").last;
            }
            else if (allParamsList[i].contains("profilePictureLink")) {
              final usernameVariable = allParamsList[i];
              print("usernameVariable $usernameVariable");
              profilePictureLink = usernameVariable.split("profilePictureLink=").last;

            }
          }

          Get.to(()=>ProfilePage(profilePictureLink: profilePictureLink, username: username, emailId: emailId, firstname: firstname, lastName: lastName, phoneNumber: phoneNumber, userId: userId));
        }

        setState(() {
          _currentURI = uri;
          _err = null;
        });
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }



  /* This code did the following:

  Added a condition to check the platform, as the web platform will handle the link as an initial link only
  Listen to the stream of incoming links and update the _currentURI and _err variables
  Handled errors using the onError event and updated the _currentURI and _err variables
  After creating these methods to listen to the incoming links, you need to call them before the Widget tree is rendered. Call these methods in the initState of the MyHomePage widget:*/




  @override
  void initState() {
    super.initState();
    //initDynamicLinks();
    _initURIHandler();
    _incomingLinkHandler();
  }


  /*Similarly, to let go of the resources when the app is terminated,
  close the StreamSubscription object in the dispose method:*/

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }


  /*Here, you have done the following:

  Displayed the Initial Link if received using the _initialURI variable
  Added a check to display the incoming links only on mobile platforms
  Displayed the host of the incoming link. We have already defined the host earlier
  Similar to host, displayed the scheme of the incoming link configured earlier
  Displayed the current or active incoming link using the _currentURI variable
  Displayed the path coming along with the host and scheme
  Displayed the error if it is not null*/





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic link demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            // 1
            ListTile(
              title: const Text("Initial Link"),
              subtitle: Text(_initialURI.toString()),
            ),
            // 2
            if (!kIsWeb) ...[
              // 3
              ListTile(
                title: const Text("Current Link Host"),
                subtitle: Text('${_currentURI?.host}'),
              ),
              // 4
              ListTile(
                title: const Text("Current Link Scheme"),
                subtitle: Text('${_currentURI?.scheme}'),
              ),
              // 5
              ListTile(
                title: const Text("Current Link"),
                subtitle: Text(_currentURI.toString()),
              ),
              // 6
              ListTile(
                title: const Text("Current Link Path"),
                subtitle: Text('${_currentURI?.path}'),
              )
            ],
            // 7
            if (_err != null)
              ListTile(
                title:
                const Text('Error', style: TextStyle(color: Colors.red)),
                subtitle: Text(_err.toString()),
              ),
            userName!=null?Text(
              "username $userName",
            ):Container(),
            const SizedBox(height: 50,),
            userID!=null?Text("userId $userID"):Container()
          ],
        ),
      ),

    );
  }
}
