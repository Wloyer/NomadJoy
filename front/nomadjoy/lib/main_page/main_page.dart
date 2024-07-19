import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/api/api.dart';
import 'package:nomadjoy/common_widget/general_card.dart';
import 'package:nomadjoy/main_page/search_page.dart';
import 'package:nomadjoy/main_page/top5_page.dart';
import 'package:nomadjoy/main_page/add_loidir_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _futureActivities;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _futureActivities = ApiService.fetchActivities();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomadjoy'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tous les loisirs'),
            Tab(text: 'Recherche'),
            Tab(text: 'Top 5'),
            Tab(text: 'Ajouter un loisir'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllLoisirsView(),
          SearchPage(),
          Top5Page(),
          AddLoisirPage(),
        ],
      ),
    );
  }

  Widget _buildAllLoisirsView() {
    return FutureBuilder<List<dynamic>>(
      future: _futureActivities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No activities found'));
        } else {
          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return GeneralCard(
                id: activity['id'],
                imagePath: 'images/placeholder.jpg', // Remplacez par le chemin réel de l'image si disponible
                title: activity['title'],
                subtitle: activity['description'],
                ratings: List<int>.from(activity['ratings']),
              );
            },
          );
        }
      },
    );
  }
}