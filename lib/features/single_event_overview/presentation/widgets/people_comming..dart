import 'package:flutter/material.dart';

class PoepleComming extends StatelessWidget {
  final Map<String, dynamic> peopleImageUrls;
  const PoepleComming(this.peopleImageUrls, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            height: double.infinity,
            alignment: Alignment.topLeft,
            child: Text(
              "People",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 13,
                child: Column(
                  children: [
                    Expanded(
                      child: peopleImageUrls.length == 0
                          ? Text(
                              "Currently admin is the only person in the event.")
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: peopleImageUrls.length,
                              itemBuilder: (ctx, index) => Container(
                                width: 35,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        peopleImageUrls.values.toList()[index]),
                                  ),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
