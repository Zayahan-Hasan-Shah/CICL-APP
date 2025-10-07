import 'package:cicl_app/src/core/constants/dummy_data.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/widgets/home_widget/greeting_widget.dart';
import 'package:cicl_app/src/widgets/home_widget/info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? name;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final storedName = await StorageService().getName();
    setState(() {
      name = storedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 6.h),
            GreetingWidget(name: name),
            SizedBox(height: 2.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                alignment: Alignment.center,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 16,
                      // childAspectRatio: 1.0,
                    ),
                    itemCount: dummyInfoCardData.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final info = dummyInfoCardData[index];
                      return InfoCardWidget(
                        icon: info["icon"],
                        title: info["title"],
                        onTap: info["onTap"],
                        iconBgColor: info["iconBgColor"],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
