import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class FlutterWebViewPluginTesting extends StatefulWidget {
  @override
  _FlutterWebViewPluginTestingState createState() => _FlutterWebViewPluginTestingState();
}

class _FlutterWebViewPluginTestingState extends State<FlutterWebViewPluginTesting> {

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  void dispose(){
    super.dispose();
    flutterWebViewPlugin.close();
  }

  bool goAhead = true;

  @override
  void initState() {
    super.initState();

    var username = "121710317055";
    var password = "9912736754";
    
    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) async{
      // if (mounted) {
      //   print("\n\nState Changed\n\n");
      // }

      if(state.type == WebViewState.finishLoad && goAhead){
        print("\n\n${state.type}\n\n");
        await flutterWebViewPlugin.evalJavascript(
          "javascript:  document.getElementById('txtusername').value = '" + username + "';" +
                          " document.getElementById('password').value = '" + password + "';" +
                          "var z = document.getElementById('Submit').click();"
            ).then((value) => goAhead = false);
      }
    });

    flutterWebViewPlugin.onUrlChanged.listen((url) async {
      print("CHANGED URL IS : $url");
      if(url == "https://gstudent.gitam.edu/Welcome"){
        print("GOING TO CLICK ATTENDANCE");
        await flutterWebViewPlugin.evalJavascript(
          // "javascript: var attendanceClick = document.getElementBy('MainContent_ad').click();"
          "javascript: var aList = document.getElementsByTagName('a');" +
                        "var i, max = aList.length;"+
                        "for(i=0;i<max;i++) {"+
                        "if(aList[i].href == 'https://gstudent.gitam.edu/Attendance_new.aspx'){"+
                          "aList[i].click();"+
                          "}"+
                        "}"
        ).then((value) => print("ATTENDANCE CLICKED"));
      }
     });
      // flutterWebViewPlugin.onUrlChanged.listen((url) async {
      //   if(goAhead) {
      //     var attendance;
      //     var loadThisURL = "https://gstudent.gitam.edu/Attendance_new.aspx";
      //     await flutterWebViewPlugin.reloadUrl(loadThisURL).then((value) => setState(()=>goAhead = false));
      //     flutterWebViewPlugin.evalJavascript(
      //       "javascript: document.getElementById('circle').value"
      //     ).then((value) => print("DONE WITH RESPONSE $value"));
      //   }
      // });
      

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
              child: Container(
                child: RaisedButton(
                  child: Text("Fetch Attendance"),
                  onPressed: () => flutterWebViewPlugin.launch(
                    "https://login.gitam.edu/Login.aspx",
                    // hidden: true,
                    rect: Rect.fromLTWH(0.0, 50.0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.75),
                    ignoreSSLErrors: true,
                    ),
                ),
              ),
            ),
            RaisedButton(
              child: Text("Logout & Close"),
              onPressed: () {
                flutterWebViewPlugin.close();
                // flutterWebViewPlugin.cleanCookies();
                setState(() {
                  goAhead = true;                  
                });
              } 
            ),
          ],
        ),
      ),
    );
  }
}