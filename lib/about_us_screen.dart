import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTextStyles.appBarTitle,
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPaddings.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This application was developed by:',
              style: GoogleFonts.poppins(fontSize: 18,
                fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 16),
            const Text('• Hüseyin Eren Yıldız', style: AppTextStyles.bodyText),
            const Text('• Ahmet Ekrem Rüzgar', style: AppTextStyles.bodyText),
            const Text('• Liza Berfin İnce', style: AppTextStyles.bodyText),
            const Text('• Başar Erses', style: AppTextStyles.bodyText),
            const Text('• Deniz Özol', style: AppTextStyles.bodyText),
            const Text('• Petek Metin', style: AppTextStyles.bodyText),
          ],
        ),
      ),
    );
  }
}
