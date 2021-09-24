import 'package:flutter/material.dart';
import 'package:spicyguitaracademy_app/common.dart';
import 'package:accordion/accordion.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class HelpDetailsPage extends StatefulWidget {
  @override
  HelpDetailsPageState createState() => new HelpDetailsPageState();
}

class HelpDetailsPageState extends State<HelpDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  int? index;
  String? title;

  List<String> titles = [
    "Questions about learning the Guitar at Spicy Guitar Academy",
    "Questions about Spicy Guitar Academy Mobile Application",
    "Questions about playing the Guitar"
  ];

  final List<List<Map<dynamic, dynamic>>> faqs = [
    [
      {
        'question':
            'What does Spicy Guitar Academy offer as an Online Guitar Learning Platform?',
        'answer': """
Spicy Guitar Academy provides an effective online guitar learning platform and makes guitar learning easy with all her features.
• Experienced and passionate Tutors.
• Step-by-step and focused lessons from beginners through professional or advanced level.
• A user-friendly mobile application.
• Learning at your convenience and pace.
• Audio backing track with adjustable tempo for practice and mastery of each lesson.
• A forum where students are animated by the tutors, share ideas and get responses to questions.
• Assessment tests (assignments) for each course.
• Life-time access to featured courses which contains target-lessons or choice lessons when purchased.
• Get replies privately to private questions asked on any lesson.
• Get guitar tablature of our guitar lessons for easy understanding.
"""
      },
    ],
    [
      {
        'question': 'How do I become a student at Spicy Guitar Academy?',
        'answer':
            """Download the mobile application from Google Play Store and Apple Store (in progress), or through www.spicyguitaracademy.com. Sign up and register by filling the form with your correct details. Once that is done, you automatically become a student of the academy and you have access to many free videos and other amazing features.
""",
      },
      {
        'question': 'About Subscription plan',
        'answer': """
• Monthly (1 month)
• Quarterly (3 months)
• Bi-annually (6 months)
• Annual (12 months)

All subscription plans give you access to all the premium features of the app.
""",
      },
      {
        'question':
            'Can students have access to videos without paying for subscriptions?',
        'answer': """
Yes, all students have access to amazing free lessons.
""",
      },
      {
        'question':
            'Can Students buy Specific Courses that they are interested in?',
        'answer': """
Yes, there are target or specific courses (called FEATURED COURSES) that treat specific topics, themes, genres or areas in guitar playing. These courses contain various lessons and can be purchased by students regardless of their category or subscription.
""",
      },
      {
        'question': 'What are the benefits of purchasing “Featured Courses”?',
        'answer': """
• Life-time access to the purchased course; in other words, with or without subscription, you have access to courses purchased.
• Access to practice loop attached to the lessons.
• Access to guitar tablature attached to the lessons.
• Students have private portal to ask the tutor questions and get quick replies on every lesson.
• When there is an upgrade on the lessons of course, the new lessons will be automatically added.
"""
      },
      {
        'question': 'How do I graduate from one category to the next one?',
        'answer': """
• Step one: Complete all the assignments in all courses of your category.
• Step two: The tutor marks and rates all your assignments.
• Step three: If you qualify to progress then you can proceed to the Graduation course.
• Step four: Proceed to the category section to choose next category.
• Step five: When your request is approved by the tutor, you will be moved to the next category.
"""
      },
      {
        'question': 'How do I submit assignments?',
        'answer': """
• Assignments are submitted in text or/and video file.
• Some assignments will require that you submit only text, some will require only video, and others will require both.
• Submit text by writing down the answers in the given space for text.
• Submit video by clicking on the file icon, searching for the required video and uploading.
"""
      },
      {
        'question': 'How do I join the Student’s Chat Forum?',
        'answer': """
Only subscribed students have access to the Student’s Chat Forum.
"""
      },
      {
        'question': 'How can I ask questions on Spicy Guitar Academy App?',
        'answer': """
Students can ask questions privately to the tutors on every lesson, on the Student’s Chat Forum and on the Contact Us section of the App.
"""
      },
      {
        'question':
            'Can I reduce or increase the tempo of the video and the audio practice loop?',
        'answer': """
Yes! Videos and audio have a feature that reduces or increases the tempo of the lesson or audio (practice loop).
"""
      },
      {
        'question': 'What happens when my Subscription Expires?',
        'answer': """
When your subscription expires, your access to the courses will be paused till you renew your subscription. This pause also applies to access to the Student’s Chat forum, however you will have access to free lessons and already purchased featured courses.
"""
      },
      {
        'question':
            'Which should I Pick? Subscribing or buying Featured Courses?',
        'answer': """
• Subscription is for students that want to be guided all round.
• Subscription provides step by step lessons to students at every category.
• Subscription follows the academic curriculum of SPICY GUITAR ACADEMY.
• Subscription has added features of assignments for students, Graduation and certification for students.
• Featured Courses are for students who are interested in specific topics, themes, genres or areas in guitar playing.
"""
      },
    ],
    [
      {
        'question': 'How often should I practice the guitar?',
        'answer': """
It is good to practice at least 30mins or 1hr a day. Make this your practice habit:
• Practice your finger drill exercises.
• Practice chords changes on different positions using slow to higher tempo.
• Practice different guitar lines and rhythms, sequences and licks.
• Play these sequences and licks on metronome or backing track (or loop)
"""
      },
      {
        'question': 'Should I start with an acoustic or electric guitar?',
        'answer': """
As a beginner, SPICY GUITAR ACADEMY recommends that you use Acoustic Guitar with Nylon Strings. Here are some reasons:
• Acoustic guitar has a sound hole that amplifies the sound and this helps the beginner guitarist to notice errors in their play and help them to audibly hear/enjoy what they are playing.
• The acoustic guitar is convenient such that you don’t need to rely on guitar amp before you can practice and play.
• One of the reasons why people give up on learning the guitar is because steel strings hurt their fingers. If you have access to only steel strings, make sure that the tuning is reduced to at least 3 semitones (a standard tuning of EADGBE will now become C#F#BEG#C#).
• Nylon strings, on the other hand, are gentle on the fingers and the tension is less, such that guitarists do not need to apply much pressure before they hold note(s).
"""
      },
      {
        'question': 'What is the Guitar Tablature and why is it important?',
        'answer': """
Guitar tablature is a visual representation of music played on the guitar. It indicates the notes, chords, rhythm and techniques played in a guitar musical piece. It makes learning easy because it is easy to read and understand, and it can help players decipher and decode hard licks and play them with the correct timing.
"""
      },
    ]
  ];

  List<AccordionSection> accordionSection(index) {
    List<AccordionSection> list = [];
    faqs[index].forEach((element) {
      list.add(
        AccordionSection(
          isOpen: true,
          header: Text(
            element['question'],
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            element['answer'],
            style: TextStyle(fontFamily: "Poppins"),
          ),
          contentHorizontalPadding: 20,
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    index = args['index'];

    return new Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: IconThemeData(color: brown),
        backgroundColor: grey,
        centerTitle: true,
        title: Text(
          'FAQs',
          style: TextStyle(
              color: brown,
              fontSize: 30,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                titles[index!],
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal),
              )),
        ),
      ),
      body: Accordion(
          maxOpenSections: 1,
          initialOpeningSequenceDelay: 1,
          headerBorderRadius: 5,
          contentBorderRadius: 5,
          headerBackgroundColor: brown,
          contentBackgroundColor: Colors.white,
          contentBorderColor: brown,
          headerPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          children: accordionSection(index)),
    );
  }
}
