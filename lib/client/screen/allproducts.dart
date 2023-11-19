import 'package:capstone_project_pabile/widgets/historywidget.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Container(
            height: height,
            width: width,
            color: const Color(0xFFE6E6E6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HistoryWidget(),
                const SizedBox(
                  height: 12,
                ),
                const Center(
                  child: Text(
                    'All Products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3876BF),
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 0,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProductContainer(width),
                          _buildProductContainer(width),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildProductContainer(width),
                          _buildProductContainer(width),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductContainer(width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: SizedBox(
        width: width / 2.8,
        child: Container(
          height: width * .5,
          decoration: ShapeDecoration(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Food Name',
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
                      'Short food description',
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
                          '₱99.9',
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
}
