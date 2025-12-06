import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ভূমিকম্পে করণীয়'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSafetySection(
              context,
              title: 'ভূমিকম্পের আগে করণীয়',
              tips: [
                'জরুরী কিট তৈরি রাখুন (জল, খাবার, প্রাথমিক চিকিৎসা, টর্চলাইট, ব্যাটারি)।',
                'ভারী আসবাবপত্র, যেমন আলমারি বা শেলফ, দেয়ালে ভালোভাবে আটকে রাখুন।',
                'পরিবারের সবার সাথে একটি আপদকালীন পরিকল্পনা তৈরি করুন এবং মিলিত হওয়ার স্থান নির্ধারণ করুন।',
                'আপনার বাড়ি এবং কর্মক্ষেত্রের নিরাপদ স্থানগুলো (যেমন, শক্ত টেবিলের নিচে) চিহ্নিত করুন।',
                'গ্যাস এবং বিদ্যুতের মেইন সুইচ কোথায় এবং কীভাবে বন্ধ করতে হয় তা জেনে রাখুন।',
              ],
            ),
            const SizedBox(height: 24),
            _buildSafetySection(
              context,
              title: 'ভূমিকম্পের সময় করণীয়',
              tips: [
                'মাথা ঠান্ডা রাখুন, আতঙ্কিত হবেন না এবং দৌড়াদৌড়ি করবেন না।',
                'উন্মুক্ত স্থানে থাকলে সেখানেই থাকুন এবং ভবন, গাছ ও বিদ্যুতের খুঁটি থেকে দূরে থাকুন।',
                'ভবনের ভেতরে থাকলে, ড্রপ, কভার এবং হোল্ড অন নীতি অনুসরণ করুন: নিচে বসে পড়ুন, শক্ত টেবিল বা ডেস্কের নিচে আশ্রয় নিন এবং সেটি ধরে রাখুন।',
                'লিফট ব্যবহার করবেন না, সিঁড়ি ব্যবহার করুন।',
                'জানালার কাঁচ, күзгү, আলমারি এবং অন্যান্য ভারী বস্তু থেকে দূরে থাকুন।',
                'গাড়ি চালালে, গাড়ি থামিয়ে একটি খোলা জায়গায় পার্ক করুন এবং কম্পন না থামা পর্যন্ত গাড়ির ভেতরেই থাকুন।',
              ],
            ),
            const SizedBox(height: 24),
            _buildSafetySection(
              context,
              title: 'ভূমিকম্পের পরে করণীয়',
              tips: [
                'নিজের এবং অন্যদের আঘাত পরীক্ষা করুন এবং প্রয়োজনে প্রাথমিক চিকিৎসা দিন।',
                'গ্যাস, জল এবং বিদ্যুতের লাইন পরীক্ষা করুন। কোনো লিকেজ বা ক্ষতি দেখলে মেইন সুইচ বন্ধ করে দিন।',
                'বিপদের আশঙ্কা থাকলে ভবন থেকে সাবধানে বেরিয়ে আসুন এবং খোলা জায়গায় আশ্রয় নিন।',
                'শুধুমাত্র জরুরি প্রয়োজনে ফোন ব্যবহার করুন যাতে নেটওয়ার্ক ব্যস্ত না হয়ে পড়ে।',
                'ক্ষতিগ্রস্ত ভবন বা দেয়ালের কাছ থেকে দূরে থাকুন।',
                'সঠিক তথ্যের জন্য সরকারি নির্দেশনা এবং নির্ভরযোগ্য সংবাদ মাধ্যম অনুসরণ করুন।',
                'আফটারশকের জন্য প্রস্তুত থাকুন।',
              ],
            ),
            const SizedBox(height: 24),
            _buildSafetySection(
              context,
              title: 'সাধারণ ভুল যা এড়িয়ে চলবেন',
              tips: [
                'ভূমিকম্পের সময় দরজার নিচে দাঁড়াবেন না, কারণ এটি নিরাপদ নয়।',
                'কম্পন চলাকালীন ভবন থেকে দৌড়ে বের হওয়ার চেষ্টা করবেন না।',
                'গুজবে কান দেবেন না বা ছড়াবেন না।',
              ],
              icon: Icons.dangerous,
              iconColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetySection(
    BuildContext context, {
    required String title,
    required List<String> tips,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.green,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(tip)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}