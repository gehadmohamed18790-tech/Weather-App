import 'package:flutter/material.dart';
import 'package:flutter_application_6/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).init();
    });
  }

  String _getDayName(DateTime date) {
    return DateFormat('EEE').format(date); 
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : provider.error.isNotEmpty
                  ? Center(child: Text(provider.error, style: const TextStyle(color: Colors.white, fontSize: 18)))
                  : Stack(
                      children: [
                        
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            key: ValueKey(provider.backgroundImage),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(provider.backgroundImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(color: Colors.black.withOpacity(0.3)),
                          ),
                        ),

                        SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _cityController,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Search city...',
                                            hintStyle: const TextStyle(color: Colors.white70),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.2),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) provider.fetchWeather(value);
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.search, color: Colors.white, size: 30),
                                        onPressed: () {
                                          if (_cityController.text.isNotEmpty) {
                                            provider.fetchWeather(_cityController.text);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                if (provider.weather != null) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    provider.weather!.cityName,
                                    style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${provider.weather!.temp.round()}°C',
                                    style: const TextStyle(fontSize: 110, color: Colors.white, fontWeight: FontWeight.w200, height: 0.9),
                                  ),
                                  Text(
                                    provider.weather!.description.toUpperCase(),
                                    style: const TextStyle(fontSize: 24, color: Colors.white70),
                                  ),

                                  const SizedBox(height: 30),

                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Feels like ${provider.weather!.feelsLike.round()}°C',
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                      const SizedBox(width: 40),
                                      Text(
                                        'Humidity ${provider.weather!.humidity}%',
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 40),

                                  
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "5-DAY FORECAST",
                                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      itemCount: provider.forecast.length,
                                      itemBuilder: (context, index) {
                                        final day = provider.forecast[index];
                                        return Container(
                                          width: 110,
                                          margin: const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(22),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _getDayName(day.date),
                                                style: const TextStyle(color: Colors.white, fontSize: 17),
                                              ),
                                              const SizedBox(height: 8),
                                              Image.network(
                                                'https://openweathermap.org/img/wn/${day.icon}@2x.png',
                                                height: 55,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '${day.temp.round()}°C',
                                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
