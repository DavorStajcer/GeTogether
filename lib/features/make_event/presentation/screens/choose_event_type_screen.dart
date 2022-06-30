import 'package:flutter/material.dart';

import 'package:get_together_app/features/make_event/presentation/widgets/event_button.dart';

import 'package:get_together_app/features/make_event/presentation/widgets/event_type_browser.dart';

class ChooseEventTypeScreen extends StatelessWidget {
  final void Function() goFowards;
  final void Function() goBack;
  const ChooseEventTypeScreen(
      {Key? key, required this.goFowards, required this.goBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Flexible(
          flex: 7,
          child: EvenTypeBrowser(),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.11),
            width: double.infinity,
            height: double.infinity,
            child: EventButton(text: "Choose location", navigate: goFowards),
          ),
        ),
      ],
    );
  }
}
