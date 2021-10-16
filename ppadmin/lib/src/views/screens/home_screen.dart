import 'package:flutter/material.dart';
import 'package:ppadmin/src/views/graphs/crimes_graph.dart';
import 'package:ppadmin/src/views/graphs/graphs.dart';
import 'package:ppadmin/src/views/views.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pune Gramin Police Patil App"),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Row(
                children: const [CrimesGraph(), MissingGraph()],
              ),
              Row(
                children: const [MovementGraph()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
