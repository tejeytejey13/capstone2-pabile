import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class Singlestall extends StatefulWidget {
  const Singlestall({Key? key}) : super(key: key);

  @override
  State<Singlestall> createState() => _SinglestallState();
}

class _SinglestallState extends State<Singlestall> {
  late final InfiniteScrollController _controller = InfiniteScrollController();
  int selectedItemIndex = 0;

  List<String> itemList = [
    'Gravy',
    'Toppings',
    'Tacos',
  ];

  Map<int, String> imagePaths = {
    0: 'assets/images/gravy.jpg',
    1: 'assets/images/toppings.jpg',
    2: 'assets/images/tacos.jpg',
  };

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final itemCount = itemList.length;
      final middleIndex = itemCount ~/ 2;
      final middleScrollPosition = middleIndex * 80;

      int newIndex =
          ((middleScrollPosition - _controller.offset) / 80.0).round();
      newIndex = newIndex.clamp(0, itemCount - 1);

      if (selectedItemIndex != newIndex) {
        setState(() {
          selectedItemIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    final sizeHeight = MediaQuery.of(context).size.height;

    final itemExtent = 500 / itemList.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        splashColor: Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF2C74B3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: sizeWidth / 10,
                ),
                Text(
                  "Stall 4".toUpperCase(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C74B3),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: InfiniteCarousel.builder(
                      itemCount: itemList.length,
                      itemExtent: itemExtent,
                      center: true,
                      anchor: 10,
                      velocityFactor: .2,
                      onIndexChanged: (index) {
                        setState(() {
                          selectedItemIndex = index;
                        });
                      },
                      controller: _controller,
                      axisDirection: Axis.vertical,
                      loop: true,
                      itemBuilder: (context, itemIndex, realIndex) {
                        return buildMiniPic(
                            realIndex, realIndex == selectedItemIndex);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: sizeHeight,
                      child: buildSelectedOrder(context),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text(''),
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C74B3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        minimumSize: const Size(0, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(""),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C74B3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        minimumSize: const Size(0, 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C74B3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "40",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: ((context) => const CartPage())));
                        },
                        icon: Text(
                          "Add To Cart",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2C74B3),
                            ),
                          ),
                        ),
                        label: const Icon(Icons.shopping_bag_rounded,
                            color: Color(0xFF2C74B3)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMiniPic(int index, bool isSelected) {
    final imagePath = imagePaths[index];
    if (imagePath != null && imagePath.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            if (isSelected)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color:
                        Colors.blue.withOpacity(0.5), // Transparent blue color
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return const Text('');
    }
  }

  Widget buildSelectedOrder(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                border: Border.all(
                  color: const Color(0xFF2C74B3),
                  width: 2.0,
                ),
              ),
              child: Image.asset(
                'assets/images/${itemList[selectedItemIndex].toLowerCase()}.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Spicy Toppings".toUpperCase(),
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color(0xFF2C74b3)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Wrap(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amberAccent,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "1",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C74B3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Text(
                "Savor the exquisite symphony of flavors in our signature Chicken Rice topping gravy – a delightful fusion of savory soy sauce, fragrant ginger essence, and a subtle garlic infusion, enhancing every bite of tender chicken and aromatic rice to perfection.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2C74B3),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
