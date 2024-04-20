import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';

class WeatherExample extends StatefulWidget {
  @override
  const WeatherExample({Key? key}) : super(key: key);

  State<WeatherExample> createState() => WeatherExampleState();
}

class WeatherExampleState extends State<WeatherExample> {
  String url = "https://api.openweathermap.org/data/2.5/forecast?q=";
  String appId = "&appid=3f257c93e1b3e37ba779e3e52ca40ccc&units=metric";
  String searchText = "Yamunanagar";
  String weatherIconUrl = "https://openweathermap.org/img/wn/";
  WeatherModel model = WeatherModel();
  bool isLoading = true;
  bool _isSearching = false;
  TextEditingController myController = TextEditingController();

  getWeather() async {
    var httpResponse = await http.get(Uri.parse(url + searchText + appId));
    if (httpResponse.statusCode == 200) {
      var _response = jsonDecode(httpResponse.body);
      print(_response);
      model = WeatherModel.fromJson(_response);
      isLoading = false;

      setState(() {
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text("Alert")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Enter City Not Found!"),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Back", style:TextStyle(color: Colors.black) ),

              ),
            ],
          ),
        ),
      );

      print("Server Error");
    }
  }

  @override
  void initState() {
    getWeather();
    super.initState();
  }

  void performSearch() {
    // Perform search logic here
    setState(() {
      _isSearching = true;
    });
  }

  void enableSearchField() {
    setState(() {
      _isSearching = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.black54,
        title: InkWell(
          onTap: () {
            setState(() {
              _isSearching = false;
            });
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              cursorColor: Colors.black45,
              controller: myController,
              enabled: !_isSearching,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search City",
                suffixIcon: GestureDetector(
                    onTap: () {
                      performSearch();
                      myController.clear();
                      getWeather();
                    },
                    child: Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.black45,
                    )),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  // Set border color to transparent
                ),
              ),
              onChanged: (v) {
                setState(() {
                  searchText = v;
                });
              },
              onFieldSubmitted: (v) {
                setState(() {
                  getWeather();
                });
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(2, 1),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: model.list!.length,
              itemBuilder: (context, index) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                    maxWidth: double.infinity,
                  ),
                  margin: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(2, 1),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    // gradient: LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomRight,
                    //
                    //   colors: [
                    //     Colors.white12.withOpacity(0.3),
                    //
                    //     Colors.black12.withOpacity(0.3),
                    //   ],
                    // ),
                  ),

                  //--------Decoration of Data Container End-------
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Rohit API Demo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${model.city!.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        //--------For Showing Date-------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Humidity ${model.list![index].main!.humidity}%",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50, right: 50),
                            ),
                            Text(
                              "Date ${model.list![index].dtTxt}",
                              style: TextStyle(
                                  // fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        //--------Date Coding End-------

                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "feelsLike - ${model.list![index].main!.feelsLike}",
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                  ),
                                  Image.network(weatherIconUrl +
                                      model.list![index].weather![0].icon! +
                                      ".png"),
                                  Text(
                                    "Clouds - ${model.list![index].clouds!.all}",
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Wind Speed - ${model.list![index].wind!.speed}/mph",
                                  ),

                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                  ),
                                  // Container(margin: EdgeInsets.only(left: 150, top: 90),),
                                  Text(
                                    "Wind Gust - ${model.list![index].wind!.gust}/mph",
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Min Temp - ${model.list![index].main!.tempMin}\u2103",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 40),
                                  ),
                                  Text(
                                    "Max Temp - ${model.list![index].main!.tempMax}\u2103",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text("\n\n"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
