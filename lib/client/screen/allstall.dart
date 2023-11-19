import 'package:capstone_project_pabile/client/screen/specificstall.dart';
import 'package:capstone_project_pabile/widgets/historywidget.dart';
import 'package:capstone_project_pabile/widgets/stallwidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';

class AllStalls extends StatefulWidget {
  const AllStalls({Key? key}) : super(key: key);

  @override
  State<AllStalls> createState() => _AllStallsState();
}

class _AllStallsState extends State<AllStalls> {
  Query dbRef = FirebaseDatabase.instance.ref().child('users');
  // final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('users');
  // String specificValue = "stallowner";

  // List<Map<String, dynamic>> data = [];

  // // Function to fetch data where a child contains a specific value
  // void fetchData() {
  //   _databaseRef.once().then((BuildContext context, DataSnapshot snapshot) {
  //     Map values = snapshot.value as Map;
  //     values.forEach((key, value) {
  //       // Check if the child contains the specific value
  //       if (value['role'] == specificValue) {
  //         data.add(value);
  //       }
  //     });
  //     setState(() {});
  //   } as FutureOr Function(DatabaseEvent value));
  // }

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

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
                    'All Stalls',
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
                    child:
                        // ListView.builder(
                        //   itemCount: data.length,
                        //   itemBuilder: (context, index){
                        //     // return _buildStallContainer(width, data[index]);
                        //     print(data);

                        //     return null;
                        //   }
                        // )
                        FirebaseAnimatedList(
                            query: dbRef,
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              Map allstalls = snapshot.value as Map;
                              // allstalls['key'] = snapshot.key;

                              if (allstalls['role'] == 'stallowner') {
                                return _buildStallContainer(width, allstalls);
                              } else {
                                return const SizedBox();
                              }
                            })),
                // Expanded(
                //   child:
                //   ListView(
                //     scrollDirection: Axis.vertical,
                //     padding: const EdgeInsets.all(8),
                //     children:

                //       // for (final stall in stallData)
                //       //   // Generate stall containers dynamically
                //       //   _buildStallContainer(width, stall),

                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStallContainer(width, allstalls) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SpecificStalls(allstalls: allstalls)));
          },
          child: SizedBox(
            width: width,
            child: Row(
              children: [
                Container(
                  width: width * 0.45,
                  height: width * 0.27,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                        allstalls['stallbanner'] ?? 'No Image Attach',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        allstalls['name'].toString().toCapitalized(),
                        // stall['name'].toString(),
                        style: const TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
