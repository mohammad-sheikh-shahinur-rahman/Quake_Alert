import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('গোপনীয়তা নীতি'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ভূমিকম্প অ্যালার্ট অ্যাপের গোপনীয়তা নীতি',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'এই গোপনীয়তা নীতিটি ব্যাখ্যা করে যে ভূমিকম্প অ্যালার্ট অ্যাপ (যা "আমরা", "আমাদের" বা "অ্যাপ" দ্বারা বোঝানো হয়েছে) ব্যবহারকারীদের কাছ থেকে কী ধরনের তথ্য সংগ্রহ করে, কীভাবে সেই তথ্য ব্যবহার করা হয় এবং সুরক্ষিত রাখা হয়।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '১. আমরা কোনো ব্যক্তিগত তথ্য সংগ্রহ করি না',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ভূমিকম্প অ্যালার্ট অ্যাপটি আপনার কোনো ব্যক্তিগতভাবে সনাক্তকরণযোগ্য তথ্য (যেমন - নাম, ইমেল ঠিকানা, ফোন নম্বর ইত্যাদি) সংগ্রহ করে না। অ্যাপটি ব্যবহার করার জন্য আপনার কোনো অ্যাকাউন্ট তৈরি করার প্রয়োজন নেই।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '২. অবস্থান তথ্য',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'অ্যাপটি আপনার বর্তমান অবস্থান (GPS ডেটা) ব্যবহার করে আপনার কাছাকাছি ভূমিকম্প সনাক্ত করতে এবং আপনাকে প্রাসঙ্গিক সতর্কতা প্রদান করতে পারে। এই অবস্থান তথ্য শুধুমাত্র আপনার ডিভাইসে প্রক্রিয়াজাত করা হয় এবং আমাদের সার্ভারে পাঠানো বা সংরক্ষণ করা হয় না। আপনি যেকোনো সময় আপনার ডিভাইসের সেটিংসে অবস্থান পরিষেবা বন্ধ করতে পারেন।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৩. অডিও এবং ভাইব্রেশন',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'জরুরি সাইরেন এবং ভূমিকম্প সতর্কতার জন্য অ্যাপটি অডিও এবং ভাইব্রেশন ফাংশন ব্যবহার করে। এই ফাংশনগুলি আপনার ডিভাইসের অডিও আউটপুট এবং ভাইব্রেটর অ্যাক্সেস করে, কিন্তু কোনো অডিও বা ভাইব্রেশন ডেটা সংগ্রহ বা সংরক্ষণ করে না।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৪. ডেটা সুরক্ষা',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'যেহেতু আমরা কোনো ব্যক্তিগত তথ্য সংগ্রহ করি না, তাই আপনার ব্যক্তিগত ডেটা সুরক্ষার ঝুঁকি নেই। অ্যাপটি আপনার ডিভাইসে স্থানীয়ভাবে কিছু সেটিংস (যেমন - অ্যালার্ট জোন, থ্রেশহোল্ড) সংরক্ষণ করতে পারে, যা শুধুমাত্র আপনার ব্যবহারের জন্য।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৫. তৃতীয় পক্ষের পরিষেবা',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'অ্যাপটি ভূমিকম্পের ডেটা পেতে তৃতীয় পক্ষের API (যেমন - USGS) ব্যবহার করে। এই পরিষেবাগুলির নিজস্ব গোপনীয়তা নীতি থাকতে পারে। আমরা তৃতীয় পক্ষের পরিষেবাগুলির ডেটা অনুশীলনগুলির জন্য দায়ী নই।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৬. এই নীতির পরিবর্তন',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'আমরা সময়ে সময়ে এই গোপনীয়তা নীতি আপডেট করতে পারি। কোনো পরিবর্তন হলে, আমরা অ্যাপের মধ্যে একটি বিজ্ঞপ্তি পোস্ট করব।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'যোগাযোগ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'এই গোপনীয়তা নীতি সম্পর্কে আপনার কোনো প্রশ্ন থাকলে, অনুগ্রহ করে আমাদের সাথে যোগাযোগ করুন: shahinurrahman.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'সর্বশেষ আপডেট: ৪ ডিসেম্বর, ২০২৪',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}