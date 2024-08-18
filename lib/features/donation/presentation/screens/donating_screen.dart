import 'package:flutter/material.dart';
import 'package:reclaim/core/theme/colors.dart' as custom_colors;

class DonatingScreen extends StatefulWidget {
  final String imagePath;
  final String title;
  final double progressValue;
  final String progressText;

  const DonatingScreen({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.progressValue,
    required this.progressText,
  }) : super(key: key);

  @override
  _DonatingScreenState createState() => _DonatingScreenState();
}

class _DonatingScreenState extends State<DonatingScreen> {
  String? selectedAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_colors.primaryBackground,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: widget.progressValue,
                backgroundColor: Colors.grey[300],
                color: custom_colors.accentGreen,
              ),
              const SizedBox(height: 20),
              Text(
                widget.progressText,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),
              Container(
                height: 500,
                width: double.infinity,
                padding: EdgeInsets.only(top: 25, right: 20, left: 20),
                decoration: BoxDecoration(
                    color: custom_colors.darkGray,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      "Donation Amount",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DonationAmountOption(
                      amount: "1 RCLM",
                      isSelected: selectedAmount == "1 RCLM",
                      onTap: () {
                        setState(() {
                          selectedAmount = "1 RCLM";
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DonationAmountOption(
                      amount: "5 RCLM",
                      isSelected: selectedAmount == "5 RCLM",
                      onTap: () {
                        setState(() {
                          selectedAmount = "5 RCLM";
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DonationAmountOption(
                      amount: "10 RCLM",
                      isSelected: selectedAmount == "10 RCLM",
                      onTap: () {
                        setState(() {
                          selectedAmount = "10 RCLM";
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DonationAmountOption(
                      amount: "20 RCLM",
                      isSelected: selectedAmount == "20 RCLM",
                      onTap: () {
                        setState(() {
                          selectedAmount = "20 RCLM";
                        });
                      },
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Donate Now",
                          style: TextStyle(
                              color: custom_colors.accentGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationAmountOption extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final VoidCallback onTap;

  const DonationAmountOption({
    Key? key,
    required this.amount,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 10), // Add spacing between options
        decoration: BoxDecoration(
            color: isSelected
                ? custom_colors.accentGreenVariant
                : const Color.fromARGB(255, 54, 54, 55),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : custom_colors.accentGreenVariant,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
