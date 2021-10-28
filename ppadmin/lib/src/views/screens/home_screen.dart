import 'package:flutter/material.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/graphs/crimes_graph.dart';
import 'package:ppadmin/src/views/graphs/graphs.dart';
import 'package:ppadmin/src/views/views.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text("पोलीस पाटील ॲप"),
      //     automaticallyImplyLeading: false),
      body: SafeArea(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Responsive(
              desktop: Column(
                children: [
                  Row(
                    children: const [CrimesGraph(), MovementGraph()],
                  ),
                  Row(
                    children: const [DeathsGraph(), MissingGraph()],
                  ),
                  Row(
                    children: [IllegalLocMap()],
                  ),
                ],
              ),
              mobile: Column(
                children: const [
                  CrimesGraph(),
                  MovementGraph(),
                  DeathsGraph(),
                  MissingGraph()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
