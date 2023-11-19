// ignore_for_file: avoid_print

import 'package:capstone_project_pabile/client/screen/specfoodreco.dart';
import 'package:capstone_project_pabile/client/screen/specificfood.dart';
import 'package:capstone_project_pabile/widgets/historywidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  late var userid = user!;
  bool isFavorite = false;

  Query dbRef = FirebaseDatabase.instance.ref().child('users');
  Query dbItems = FirebaseDatabase.instance.ref('menuItems');
  Query dbMenu = FirebaseDatabase.instance.ref('menuItems');
  Query dbFave = FirebaseDatabase.instance.ref('fave');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Future<List<Map<String, dynamic>>> fetchData() async {
      DataSnapshot faveSnapshot = (await dbFave.once()).snapshot;
      DataSnapshot menuItemsSnapshot = (await dbItems.once()).snapshot;

      Map<dynamic, dynamic>? faveMap =
          faveSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? menuItemsMap =
          menuItemsSnapshot.value as Map<dynamic, dynamic>?;

      if (faveMap == null || menuItemsMap == null) {
        return [];
      }

      List<Map<String, dynamic>> combinedData = [];

      faveMap.forEach((faveKey, faveItem) {
        var matchingMenuItem = menuItemsMap[faveItem?['itemID']];
        if (matchingMenuItem != null) {
          Map<String, dynamic> combinedItem = {
            'fave': Map<String, dynamic>.from(faveItem),
            'menuItems': Map<String, dynamic>.from(matchingMenuItem),
          };
          combinedData.add(combinedItem);
        }
      });

      return combinedData;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: SafeArea(
        child: Column(
          children: [
            const HistoryWidget(),
            const SizedBox(height: 30),
            SizedBox(
              height: height / 1.8,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  todayMenus(),
                  TopRatedFoods(),
                  SizedBox(
                    height: 280,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<Map<String, dynamic>>? combinedData =
                              snapshot.data;

                          return combinedData != null && combinedData.isNotEmpty
                              ? FirebaseAnimatedList(
                                  scrollDirection: Axis.horizontal,
                                  query: dbFave,
                                  itemBuilder: (BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index) {
                                    Map? faveData = snapshot.value as Map?;
                                    faveData ??= {};
                                    faveData['key'] = snapshot.key;
                                    if (faveData['userID'] == user) {
                                      Map? correspondingMenuItem = combinedData
                                          .firstWhereOrNull((item) =>
                                              item['fave']['itemID'] ==
                                              faveData?['itemID']);

                                      return correspondingMenuItem != null
                                          ? recommendations(
                                              faveData, correspondingMenuItem)
                                          : const SizedBox();
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                )
                              : const SizedBox(); // Handle empty state
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget todayMenus() {
    double itemHeight = MediaQuery.of(context).size.height * 0.24;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: itemHeight,
            child: FirebaseAnimatedList(
                scrollDirection: Axis.horizontal,
                query: dbItems,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map todaymenu = snapshot.value as Map;
                  todaymenu['key'] = snapshot.key;
                  if (todaymenu.isNotEmpty) {
                    return TodayMenu(todaymenu);
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget TodayMenu(Map todayMenu) {
    double itemWidth = MediaQuery.of(context).size.width * .8;
    double itemHeight = MediaQuery.of(context).size.height * 0.24;

    int ratesLength =
        todayMenu['rates'] != null ? todayMenu['rates'].length : 0;
    var rated = todayMenu['rates'].values.reduce((a, b) => a + b) / ratesLength;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecificFood(
              todayMenu: todayMenu,
              onFavoriteChanged: (isFavorite) {
                setState(() {
                  this.isFavorite = isFavorite;
                });
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(
                todayMenu['itemImg'],
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'TODAY MENU',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      todayMenu['itemName'],
                      style: const TextStyle(
                        color: Color(0xFF2E2E2E),
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    Text(
                      todayMenu['itemDescription'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: 10,
                        ),
                        Text(
                          rated.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '₱ ${todayMenu['itemPrice'].toString()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget recommendations(recommended, correspondingMenuItem) {
    double itemWidth = MediaQuery.of(context).size.width * .9;
    double itemHeight = MediaQuery.of(context).size.height * 0.24;
    print("Corresponding Menu Item: $correspondingMenuItem");

    int ratings = (correspondingMenuItem['menuItems'] ?? {})['rates'].length;

    var rated = ratings > 0
        ? (correspondingMenuItem['menuItems'] ?? {})['rates']
                .values
                .reduce((a, b) => a + b) /
            ratings
        : 0.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended for you",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF3876BF),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(
                width: 180,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See All",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF858585),
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpecificFoodReco(
                  todayMenu: correspondingMenuItem,
                  onFavoriteChanged: (isFavorite) {
                    setState(() {
                      this.isFavorite = isFavorite;
                    });
                  },
                ),
              ),
            );
          },
          child: Container(
            width: itemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(
                  (correspondingMenuItem['menuItems'] ?? {})['itemImg'] ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemName'] ??
                            'No item name',
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      Text(
                        (correspondingMenuItem['menuItems'] ??
                                {})['itemDescription'] ??
                            'No item description',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 10,
                          ),
                          Text(
                            rated.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '₱ ${(correspondingMenuItem['menuItems'] ?? {})['itemPrice'] ?? 'No item price'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget TopRatedFoods() {
    double itemHeight = MediaQuery.of(context).size.height * 0.24;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Rated Foods",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF3876BF),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See All",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF858585),
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: itemHeight,
            child: FirebaseAnimatedList(
              scrollDirection: Axis.horizontal,
              query: dbMenu,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map toprated = snapshot.value as Map;
                toprated['key'] = snapshot.key;

                return topRate(toprated);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget topRate(toprated) {
    double itemWidth = MediaQuery.of(context).size.width * 0.5;
    double itemHeight = MediaQuery.of(context).size.height * 0.24;

    int ratesLength = toprated['rates'] != null ? toprated['rates'].length : 0;

    var rated = ratesLength > 0
        ? toprated['rates'].values.reduce((a, b) => a + b) / ratesLength
        : 0.0;

    print('Rates: ${toprated['itemImg']}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecificFood(
                todayMenu: toprated,
                onFavoriteChanged: (isFavorite) {
                  setState(() {
                    this.isFavorite = isFavorite;
                  });
                },
              ),
            ),
          );
        },
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(toprated['itemImg'] ??
                  CircularProgressIndicator().toString()),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toprated['itemName'].toString(),
                      style: const TextStyle(
                        color: Color(0xFF2E2E2E),
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    Text(
                      toprated['itemDescription'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: 10,
                        ),
                        Text(
                          rated.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '₱ ${toprated['itemPrice']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
