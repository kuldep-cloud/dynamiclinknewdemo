
# dynamiclinkdemo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [UniLink ](https://pub.dev/packages/uni_links)
- [get: ](https://pub.dev/packages/get)
- [fluttertoast: ](https://pub.dev/packages/fluttertoast)
- [firebase: ](https://console.firebase.google.com/)


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Firebase config

    Firebase Dynamic Links provides a rich feature for handling deep linking for applications and websites.
    The best part is that Firebase deep linking is free, for any scale.
    Dynamic Links instead of redirecting the user to the playstore bring-in Optimal User Experience by also navigating him to the Intended Equivalvent content in web/app apparently contributing to building ,improving and growing application for multiple platform domains.



Setup & Initial Configuration

      In order to send Firebase Dynamic Links, We need to create a firebase project for the Firebase Dynamic Links from firebase.google.com by logging in with your Google account

     1.Click on Add Project Button (+) initiating firebase project creation process.
     2.Select the appropriate name for the project entering continue further
     3.You can either select the firebase analytics and then clicking on Continue Project. Firebase Project is now created and ready to use .

This Progress indicator will show before the dashboard indicating success.

In the project overview page, click the android  icon to launch the setup workflow as we now needs to register your flutter project for the android and iOS application.


Integration with android App

    In the project overview page, select the android icon to launch the setup flow. If you have already added the app to your project provide click on add app to provide details of your application.


Register your app with Firebase :

        a. Provide with your app package name ex(com.example.app).
           Find this package name from your open project in android folder. Select the top-level app in the project navigator, then access src>main>AndroidManifest.xml. package  name  package="com.example.dynamiclinknewdemo
        b. You may also provide optional details like App Nick Name and Sha key.
        c. Register your app.


Make sure you enter the package name As this can’t be edited further at the moment .


Next step, We need to download the config file named Google-service.json file  & repeating a similar process to registering your ios app there saving the GoogleService-info.plist file. Keep those configuration files in ready-to-use with Flutter app later.

After that copy that downloaded folder to your:

      Your app name > android > app

After successfully adding google-services.json file to your app folder, you need to add Firebase SDK to the build.gradle folder.

Now we have successfully initial configuration and adding Firebase to our existing project. Then we will move on to the next step.

Setting up Firebase

       1. On the right side of the Firebase console, select “Dynamic Links” after redirecting to your firebase flutter dynamic link project. Then click “Get started”.
       2. Selecting a domain under the given modal “Add URL prefix”. Here they will provide automatically some domains. If you need to customize it you can enter the domain you preferred. Then click “Continue” button.

Create a dynamic link inside the Firebase Console

      1. Click “New Dynamic Link”. 
      2. Set up a short URL link and click “Next”.
      3. Then you need to set up your dynamic link URL, under “Set up your Dynamic Link”. There is a deep link to your application and if a specific user has not installed the app where that user should redirect. As an example, you can provide app play store link as the dynamic link. Link name can be given as any meaningful short name about your dynamic link that you prefer. Click “Next”.
      4. Choose “Open the deep link URL in a browser” option. In that option, if the specific app is not installed in your app the link will open through the browser. If not you can choose “Open the deep link in your iOS App” but if so you need to have an iOS app. Then click “Next”.
      5. Here we define behavior for Android. Select “Open the deep link in your Android App” and choose your android app. Then click “Next”.
      6. Additionally, you can customize some advanced options. Then click “Create”.
      7. Under the URL, you will get your created dynamic link.

Android Config

Deep link

Deep Links: This link doesn’t require a host, a hoster file, or any custom scheme.
It provides a way to utilize your app using URL: your_scheme://any_host. Here’s the Deep Link intent filter that you need to add to your AndroidManifest.xml.
You can also change the scheme and host:

<!-- Deep Links --> 

           <!-- Deep linking -->
            <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="http" android:host="dynamiclinknewdemo.page.link" />
                <data android:scheme="https" />
            </intent-filter>


IOS CONFIG

custom url schemas

Custom URL: This URL doesn’t require a host, entitlements, a hosted file, or any custom scheme.
Similar to a Deep Link in Android, you need to add the host and scheme in the ios/Runner/Info.plist file as below:

    <key>CFBundleURLTypes</key>
     <array>
      <dict>
          <key>CFBundleTypeRole</key>
          <string>Editor</string>
          <key>CFBundleURLName</key>
          <string>dynamiclinknewdemo.page.link</string>
          <key>CFBundleURLSchemes</key>
          <array>
              <string>https</string>
          </array>
      </dict>
     </array>

StreamSubscription

            StreamSubscription? _streamSubscription;

A StreamSubscription object to listen to incoming links when the app is in the foreground.
With the help of addlistner predefine function we can detect any link changes in the app.


             _streamSubscription = uriLinkStream.listen((Uri? uri) {
                 //your code
                  }

Similarly, to let go of the resources when the app is terminated,
close the StreamSubscription object in the dispose method.

           @override
        void dispose() {
       _streamSubscription?.cancel(); 
        super.dispose();
           }

6.how to get url data in app?

split uri for getting data from uri

        final allParamsList = uri.toString().split("/");


logic for getting the particular key data from split variable

        final userName,userId;
        for (int i = 0; i < allParamsList.length; i++) {
          if (allParamsList[i].contains("username")) {
            final usernameVariable = allParamsList[i];
            userName = usernameVariable.split("username=").last;
          } else if (allParamsList[i].contains("userID")) {
            final usernameVariable = allParamsList[i];
            userID = usernameVariable.split("userID=").last;
          }
        }

7.How to navigate to a particular screen in ui?

    if(uri.toString().contains("profileDetails")){
      //get key vale code here
      //navigation code here of specific screen with arguments
      }

