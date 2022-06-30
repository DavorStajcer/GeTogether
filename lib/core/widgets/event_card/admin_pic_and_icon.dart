import "package:flutter/material.dart";
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

class AdminPicAndIcon extends StatelessWidget {
  final String imageUrl;
  final EventType eventType;
  const AdminPicAndIcon({
    Key? key,
    required this.imageUrl,
    required this.eventType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 5, top: 5, bottom: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                ),
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 15),
          child: Image.asset(
            eventType == EventType.coffe
                ? "lib/assets/images/coffe.png"
                : eventType == EventType.food
                    ? "lib/assets/images/food.png"
                    : "lib/assets/images/game.png",
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
