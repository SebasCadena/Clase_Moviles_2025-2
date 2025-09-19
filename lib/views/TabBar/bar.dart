import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Bar extends StatelessWidget {
  const Bar({super.key});

  void goToHome(BuildContext context) {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          title: const Text('T A B   B A R'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(onPressed: () => goToHome(context), icon: const Icon(Icons.arrow_back_rounded)),
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color: Colors.blue,
                    child: Center(child: Text('Car Tab')),
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('Transit Tab')),
                  ),
                  Container(
                    color: Colors.green,
                    child: Center(child: Text('Bike Tab')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
