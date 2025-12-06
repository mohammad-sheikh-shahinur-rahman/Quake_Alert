import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ব্যবহারের শর্তাবলী'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ভূমিকম্প অ্যালার্ট অ্যাপ ব্যবহারের শর্তাবলী',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ভূমিকম্প অ্যালার্ট অ্যাপ ("অ্যাপ") ব্যবহার করার আগে অনুগ্রহ করে এই শর্তাবলী ("শর্তাবলী") সাবধানে পড়ুন। এই শর্তাবলী আপনার অ্যাপ ব্যবহারের ক্ষেত্রে প্রযোজ্য হবে।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '১. অ্যাপের ব্যবহার',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'এই অ্যাপটি শুধুমাত্র তথ্যগত উদ্দেশ্যে তৈরি করা হয়েছে এবং এটি কোনো পেশাদার পরামর্শ বা জরুরি পরিষেবার বিকল্প নয়। ভূমিকম্পের সতর্কতা এবং তথ্য নির্ভুল নাও হতে পারে এবং আমরা এর নির্ভুলতার জন্য কোনো গ্যারান্টি দিই না।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '২. ডেটা নির্ভুলতা',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'অ্যাপে প্রদর্শিত ভূমিকম্পের ডেটা বিভিন্ন তৃতীয় পক্ষের উৎস (যেমন - USGS) থেকে সংগ্রহ করা হয়। এই ডেটা বিলম্বিত বা অসম্পূর্ণ হতে পারে। জরুরি পরিস্থিতিতে সর্বদা স্থানীয় কর্তৃপক্ষের নির্দেশাবলী অনুসরণ করুন।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৩. দায়বদ্ধতার সীমাবদ্ধতা',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'এই অ্যাপটি ব্যবহারের ফলে সৃষ্ট কোনো ক্ষতি বা অসুবিধার জন্য আমরা দায়ী থাকব না। অ্যাপটি "যেমন আছে" ভিত্তিতে সরবরাহ করা হয় এবং আমরা এর কার্যকারিতা বা নির্ভরযোগ্যতা সম্পর্কে কোনো ওয়ারেন্টি দিই না।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৪. তৃতীয় পক্ষের লিঙ্ক',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'অ্যাপটিতে তৃতীয় পক্ষের ওয়েবসাইট বা পরিষেবার লিঙ্ক থাকতে পারে। এই লিঙ্কগুলি শুধুমাত্র আপনার সুবিধার জন্য সরবরাহ করা হয় এবং আমরা তাদের বিষয়বস্তু বা গোপনীয়তা অনুশীলনের জন্য দায়ী নই।',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '৫. শর্তাবলীর পরিবর্তন',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'আমরা যেকোনো সময় এই শর্তাবলী পরিবর্তন বা আপডেট করার অধিকার রাখি। পরিবর্তিত শর্তাবলী অ্যাপে পোস্ট করার সাথে সাথে কার্যকর হবে। অ্যাপটি ব্যবহার চালিয়ে যাওয়ার মাধ্যমে আপনি পরিবর্তিত শর্তাবলী মেনে নিতে সম্মত হন।',
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
              'এই শর্তাবলী সম্পর্কে আপনার কোনো প্রশ্ন থাকলে, অনুগ্রহ করে আমাদের সাথে যোগাযোগ করুন: shahinurrahman.com',
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