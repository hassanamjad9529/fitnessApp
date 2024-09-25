import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1B1E2E),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool showDailyStats = true;
  late AnimationController _iconRotationController;

  @override
  void initState() {
    super.initState();

    // Simulate a delay for the loading animation
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    // Initialize the icon rotation animation
    _iconRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _iconRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Dashboard'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      floatingActionButton: _buildCustomFAB(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sliding stat banner with user's progress
            _buildSlidingStatBanner(),
            const SizedBox(height: 20),
            // Toggle between daily and weekly stats
            _buildStatToggle(),
            const SizedBox(height: 10),
            const Text(
              "Quick Stats",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Animated card grid with shimmer loading effect
            Expanded(
              child: isLoading
                  ? _buildShimmerGrid()
                  : AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child:
                                            FitnessDetailScreen(index: index),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'card_$index',
                                    child: _buildFitnessCard(
                                      index: index, // Passing index here
                                      title: 'Metric ${index + 1}',
                                      icon: Icons.fitness_center,
                                      color: index.isEven
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent,
                                      value: index.isEven ? '1500' : '2300',
                                      unit: index.isEven ? 'Steps' : 'Calories',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Sliding banner with user daily/weekly stats
  Widget _buildSlidingStatBanner() {
    return AnimatedTextKit(
      animatedTexts: [
        FadeAnimatedText(
          'Today: 7500 Steps • 600 kcal • 60 min Workout',
          textStyle: const TextStyle(
            fontSize: 18.0,
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
          duration: const Duration(seconds: 5),
        ),
        FadeAnimatedText(
          'This Week: 50,000 Steps • 4200 kcal • 4 hr Workout',
          textStyle: const TextStyle(
            fontSize: 18.0,
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
          duration: const Duration(seconds: 5),
        ),
      ],
      repeatForever: true,
    );
  }

  // Toggle between daily and weekly stats
  Widget _buildStatToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              showDailyStats = true;
            });
          },
          child: Text(
            "Daily Stats",
            style: TextStyle(
              fontSize: 18,
              color: showDailyStats ? Colors.cyanAccent : Colors.white54,
            ),
          ),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            setState(() {
              showDailyStats = false;
            });
          },
          child: Text(
            "Weekly Stats",
            style: TextStyle(
              fontSize: 18,
              color: !showDailyStats ? Colors.orangeAccent : Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  // Custom Floating Action Button with ripple animation
  Widget _buildCustomFAB() {
    return GestureDetector(
      onTap: () {
        // Perform some action (e.g., navigate to a different page)
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.cyanAccent, Colors.purpleAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  // Neon-style card widget for fitness metrics
  Widget _buildFitnessCard({
    required int index, // Add index parameter
    required String title,
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262A40),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$value $unit',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar for each metric
          LinearProgressIndicator(
            value: index.isEven ? 0.7 : 0.5, // Now we can access the index
            backgroundColor: Colors.grey[700],
            color: color,
          ),
        ],
      ),
    );
  }
}

class FitnessDetailScreen extends StatelessWidget {
  final int index;
  const FitnessDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness Progress'),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 400),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  const SizedBox(height: 20),
                  _buildHeaderText('Weekly Progress'),
                  const SizedBox(height: 20),
                  _buildLineChart(),
                  const SizedBox(height: 30),
                  _buildGoalIndicators(),
                  const SizedBox(height: 30),
                  _buildAnimatedStepCounter(),
                  const SizedBox(height: 30),
                  _buildMotivationalText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build the header text
  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.cyanAccent,
      ),
    );
  }

  // Animated line chart for fitness progress
  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 1.5),
                FlSpot(2, 1.7),
                FlSpot(3, 2.5),
                FlSpot(4, 3.0),
                FlSpot(5, 4.5),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: Colors.greenAccent,
              barWidth: 5,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  // Circular progress indicators for goals
  Widget _buildGoalIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildGoalIndicator(
          label: 'Steps',
          percent: 0.75,
          progressColor: Colors.greenAccent,
        ),
        _buildGoalIndicator(
          label: 'Calories',
          percent: 0.65,
          progressColor: Colors.orangeAccent,
        ),
      ],
    );
  }

  // Circular goal progress indicators
  Widget _buildGoalIndicator({
    required String label,
    required double percent,
    required Color progressColor,
  }) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 10.0,
      animation: true,
      percent: percent,
      center: Text(
        '${(percent * 100).toInt()}%',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: progressColor,
      backgroundColor: Colors.white24,
      footer: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Animated counter for total steps
  Widget _buildAnimatedStepCounter() {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: 12000),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return Column(
          children: [
            Text(
              '$value Steps',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Keep up the great work!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        );
      },
    );
  }

  // Motivational text using animated text kit
  Widget _buildMotivationalText() {
    return SizedBox(
      height: 50,
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            'You are doing amazing!',
            textStyle: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
            speed: const Duration(milliseconds: 200),
          ),
          TypewriterAnimatedText(
            'Keep pushing your limits!',
            textStyle: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
            speed: const Duration(milliseconds: 200),
          ),
        ],
        repeatForever: true,
      ),
    );
  }
}
// first commit 
