import 'package:flutter/material.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;
import 'package:reclaim/features/dashboard/presentation/screens/donating_screen.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/donation_box.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/category.dart';
import 'package:reclaim/features/dashboard/presentation/widgets/main_balance_card.dart';

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
      imagePath: 'assets/images/Recycling-bins-side.png',
      title: "Street Cleanup Program",
      progressText: "MYR. 20,000 / MYR. 30,000",
      progressValue: 0.7,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/items-recycling-centre.png',
      title: "Global Recycling Day 2024!",
      progressText: "MYR. 4,000 / MYR. 5,000",
      progressValue: 0.9,
      category: "Recycling",
    ),
    const DonationBox(
      imagePath: 'assets/images/GettyImages-1353301481-scaled.png',
      title: "Beach Cleaning Fundraising",
      progressText: "MYR. 2,000 / MYR. 5,000",
      progressValue: 0.4,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/24EPBS_ENVIRONMENT.png',
      title: "Global Recycling Day 2024!",
      progressText: "MYR. 2,000 / MYR. 5,000",
      progressValue: 0.4,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/environmental-education.png',
      title: "Green Foundation Fundraising",
      progressText: "MYR. 4,000 / MYR. 5,000",
      progressValue: 0.9,
      category: "Green\nTechnology",
    ),
    const DonationBox(
      imagePath: 'assets/images/items-recycling-centre.png',
      title: "Global Recycling Day 2024!",
      progressText: "MYR. 14,000 / MYR. 35,000",
      progressValue: 0.4,
      category: "Green\nTechnology",
    ),
    const DonationBox(
      imagePath: 'assets/images/why-is-recycling-important-1587135431361.png',
      title: "Community Recycling Programs",
      progressText: "MYR. 1,000 / MYR. 3,000",
      progressValue: 0.3,
      category: "Education",
    ),
    const DonationBox(
      imagePath: 'assets/images/GettyImages-1353301481-scaled.png',
      title: "Beach and River Cleanups",
      progressText: "MYR. 3,000 / MYR. 5,000",
      progressValue: 0.6,
      category: "Waste\nManagement",
    ),
    const DonationBox(
      imagePath: 'assets/images/ADAS-25-1-2.png',
      title: "Waste Management Fundraiser",
      progressText: "MYR. 4,000 / MYR. 5,000",
      progressValue: 0.9,
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
              const SizedBox(height: 40),
              Text(
                "$greetingMessage, Good People!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
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
