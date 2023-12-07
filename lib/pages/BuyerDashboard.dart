import 'package:flutter/material.dart';
import 'package:mobile/components/listing_form.dart';

class BuyerDashboard extends StatelessWidget {
  BuyerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListingForm(),
    );
  }
}
