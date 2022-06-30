import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_together_app/features/make_event/presentation/blocs/event_card_order_cubit/event_card_order_cubit.dart';

class EventTypeCard extends StatelessWidget {
  final EventType eventType;

  const EventTypeCard({
    Key? key,
    required this.eventType,
  }) : super(key: key);

  String get _imageAsset {
    if (eventType == EventType.coffe)
      return "lib/assets/images/coffe.png";
    else if (eventType == EventType.food)
      return "lib/assets/images/food.png";
    else
      return "lib/assets/images/game.png";
  }

  double _getLeftMargin(double screenWidth, double cardWidth) {
    if (eventType == EventType.games)
      return screenWidth * 0.11;
    else if (eventType == EventType.coffe)
      return screenWidth * 0.11 + cardWidth * 0.8;
    else
      return screenWidth * 0.11 + cardWidth * 0.8 * 2;
  }

  String get _cardText {
    if (eventType == EventType.games)
      return "Games";
    else if (eventType == EventType.coffe)
      return "Coffe";
    else
      return "Food";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.3;
    return Positioned(
      left: _getLeftMargin(screenSize.width, cardWidth),
      child: BlocBuilder<EventCardOrderCubit, EventCardOrderState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => BlocProvider.of<EventCardOrderCubit>(context)
                .putToTop(eventType),
            child: Container(
              // duration: Duration(milliseconds: 600),
              width: cardWidth,
              height: state.eventTypeOrder[0] == eventType
                  ? cardWidth * 2 * 1.1
                  : cardWidth * 2,
              margin: state.eventTypeOrder[0] == eventType
                  ? EdgeInsets.only(bottom: cardWidth * 2 * 1.1 - cardWidth * 2)
                  : null,
              child: Card(
                elevation: 5,
                shadowColor: Colors.black,
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(_imageAsset),
                    )),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _cardText,
                            style: TextStyle(
                                color: Color.fromRGBO(144, 144, 144, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
