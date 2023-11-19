import 'package:capstone_project_pabile/client/screen/specificfood.dart';
import 'package:capstone_project_pabile/component/botnavbar.dart';
import 'package:capstone_project_pabile/widgets/specificwidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificStalls extends StatefulWidget {
  const SpecificStalls({super.key, required this.allstalls});
  final Map allstalls;

  @override
  State<SpecificStalls> createState() => _SpecificStallsState();
}

class _SpecificStallsState extends State<SpecificStalls> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3876BF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            double reswidth = MediaQuery.of(context).size.width;
            double resheight = MediaQuery.of(context).size.height;
            Map allstalls = widget.allstalls;

            var stallid = allstalls['id'];

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: resheight / 3,
                      width: reswidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            allstalls['stallbanner'] ?? 'No Image Attach',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BotNavBar(),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 165,
                  left: 80,
                  right: 80,
                  child: Container(
                    width: width / 2,
                    height: height / 6.5,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            allstalls['name'],
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: 0.10,
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 2,
                            color: Color(0xFF848484),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 380,
                  left: 10,
                  right: 0,
                  child: FeaturedFoods(stallid),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget FeaturedFoods(stallid) {
    double itemHeight = MediaQuery.of(context).size.height * 1;

    Query dbRef = FirebaseDatabase.instance.ref().child('menuItems');

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Foods",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: itemHeight,
            child: FirebaseAnimatedList(
                scrollDirection: Axis.vertical,
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map specificstall = snapshot.value as Map;
                  specificstall['key'] = snapshot.key;

                  if (specificstall['stallID'] == stallid) {
                    return featuredItems(specificstall);
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget featuredItems(specificstall) {
    double itemWidth = MediaQuery.of(context).size.width * 0.5;
    double itemHeight = MediaQuery.of(context).size.height * 0.2;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecificFood(
              todayMenu: specificstall,
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
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(
                specificstall['itemImg'],
              ),
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      specificstall['itemName'],
                      style: TextStyle(
                        color: Color(0xFF2E2E2E),
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    Text(
                      specificstall['itemDescription'],
                      style: TextStyle(
                        color: Color(0xFF848484),
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFF848484),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: 10,
                        ),
                        Text(
                          ' 4.5',
                          style: TextStyle(
                            color: Color(0xFF848484),
                            fontSize: 8,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          specificstall['itemPrice'],
                          style: TextStyle(
                            color: Color(0xFF848484),
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

  Widget AddOns() {
    double itemWidth = MediaQuery.of(context).size.width * 0.5;
    double itemHeight = MediaQuery.of(context).size.height * 0.2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add ons",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                      child: Container(
                        width: itemWidth / 3,
                        height: itemHeight / 3,
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add ons Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                        Text(
                          'Short food description',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.10,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                              size: 10,
                            ),
                            Text(
                              ' 4.5',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 8,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                letterSpacing: 0.10,
                              ),
                            ),
                            SizedBox(width: 30),
                          ],
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFF848484),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    const Text(
                      '₱99.9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.10,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
