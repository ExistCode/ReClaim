import 'package:flutter/material.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;
import 'package:reclaim/features/donation/presentation/screens/donating_screen.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/category.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/main_balance_card.dart';

import '../widgets/donation_box.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int selectedCategoryIndex = 0;

  void onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  final List<DonationBox> donationBoxes = [
    const DonationBox(
      imagePath: 'assets/images/StreetCleaning.png',
      title: "Street Cleanup Program",
      progressText: "RCLM. 2,000 / RCLM. 3,000",
      progressValue: 0.7,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/Recycling-bins-side.png',
      title: "Neighborhood Recycling Initiative",
      progressText: "RCLM. 1,500 / RCLM. 2,000",
      progressValue: 0.75,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/items-recycling-centre.png',
      title: "Global Recycling Day 2024!",
      progressText: "RCLM. 400 / RCLM. 500",
      progressValue: 0.8,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/SaveForest.png',
      title: "Save the Forest Education Fund",
      progressText: "RCLM. 200 / RCLM. 500",
      progressValue: 0.4,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/24EPBS_ENVIRONMENT.png',
      title: "Recycling Education for Kids",
      progressText: "RCLM. 60 / RCLM. 200",
      progressValue: 0.3,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/thumbnail_environment-education.png',
      title: "Environmental Education Campaign",
      progressText: "RCLM. 150 / RCLM. 500",
      progressValue: 0.3,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/environmental-education.png',
      title: "Green Energy Awareness Campaign",
      progressText: "RCLM. 750 / RCLM. 1,000",
      progressValue: 0.75,
      category: "Green\nTechnology",
    ),
    const DonationBox(
      imagePath: 'assets/images/SolarPanel.png',
      title: "Solar Panel Installation Project",
      progressText: "RCLM. 1,000 / RCLM. 2,500",
      progressValue: 0.4,
      category: "Green\nTechnology",
    ),
    const DonationBox(
      imagePath: 'assets/images/why-is-recycling-important-1587135431361.png',
      title: "Community Recycling Programs",
      progressText: "RCLM. 100 / RCLM. 300",
      progressValue: 0.33,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/river_cleaning.png',
      title: "River Cleanups Technology",
      progressText: "RCLM. 3000 / RCLM. 5000",
      progressValue: 0.6,
      category: "Green\nTechnology",
    ),
    const DonationBox(
      imagePath: 'assets/images/ADAS-25-1-2.png',
      title: "Waste Management Fundraiser",
      progressText: "RCLM. 400 / RCLM. 500",
      progressValue: 0.8,
      category: "Waste\nManagement",
    ),
    const DonationBox(
      imagePath: 'assets/images/GettyImages-1353301481-scaled.png',
      title: "Community Beach Cleanup Fund",
      progressText: "RCLM. 250 / RCLM. 400",
      progressValue: 0.625,
      category: "Waste\nManagement",
    ),
  ];

  String getGreetingMessage() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    String greetingMessage = getGreetingMessage();

    final filteredDonationBoxes = donationBoxes.where((box) {
      final selectedCategory = categoryData[selectedCategoryIndex].name;
      return box.category == selectedCategory || selectedCategory == "All";
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          color: custom_colors.primaryBackground,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "$greetingMessage, Good People!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              MainBalanceCard(),
              const SizedBox(height: 20),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryData.length,
                  itemBuilder: (context, index) {
                    final category = categoryData[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () => onCategorySelected(index),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 90,
                            width: 100,
                            decoration: BoxDecoration(
                              color: selectedCategoryIndex == index
                                  ? custom_colors.accentGreen
                                  : custom_colors.accentGreenVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedCategoryIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: custom_colors.darkGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: filteredDonationBoxes.map((box) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonatingScreen(
                              imagePath: box.imagePath,
                              title: box.title,
                              progressText: box.progressText,
                              progressValue: box.progressValue,
                            ),
                          ),
                        );
                      },
                      child: box,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
