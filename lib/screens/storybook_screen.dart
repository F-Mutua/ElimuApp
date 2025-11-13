import 'package:flutter/material.dart';

class StorybookScreen extends StatefulWidget {
  const StorybookScreen({super.key});

  @override
  State<StorybookScreen> createState() => _StorybookScreenState();
}

class _StorybookScreenState extends State<StorybookScreen> {
  final List<Storybook> _storybooks = [
    Storybook(
      id: '1',
      title: 'The Lion and the Mouse',
      author: 'Aesop',
      coverColor: const Color(0xFFFFB74D),
      emoji: '🦁',
      description: 'A tale of kindness and friendship',
      content: '''
Once upon a time, a mighty lion was sleeping in the forest. A little mouse accidentally ran over the lion's nose, waking him up.

The angry lion grabbed the mouse and was about to eat him when the mouse begged, "Please let me go! I promise I will help you one day."

The lion laughed at the idea of a tiny mouse helping him, but he let the mouse go anyway.

A few days later, the lion got caught in a hunter's net. He roared for help, and the little mouse heard him.

The mouse quickly ran to the lion and gnawed through the ropes with his sharp teeth, setting the lion free.

"Thank you, little friend," said the lion. "I was wrong to laugh at you. Even the smallest friend can be the greatest friend indeed."

THE END

Moral: No act of kindness, no matter how small, is ever wasted.
      ''',
    ),
    Storybook(
      id: '2',
      title: 'The Clever Hare',
      author: 'African Folktale',
      coverColor: const Color(0xFF81C784),
      emoji: '🐰',
      description: 'A story of wit and wisdom',
      content: '''
In the African savanna, there lived a clever hare who was known for his quick thinking.

One day, all the animals gathered because the lion, the king of the jungle, declared that he would eat one animal every day.

The animals were terrified! They decided to send one animal to the lion each day to save the rest.

When it was the hare's turn, he had a plan. He arrived late to the lion's den.

"Why are you late?" roared the angry lion.

"Your Majesty," said the hare, "I met another lion on the way who claimed to be the real king of the jungle!"

The lion was furious! "Show me this lion!" he demanded.

The clever hare led the lion to a deep well. "He lives down there," said the hare.

The lion looked into the well and saw his own reflection. Thinking it was another lion, he roared. The echo roared back!

Enraged, the lion jumped into the well to fight his "rival" and was never seen again.

The clever hare saved all the animals with his wit!

THE END

Moral: Intelligence is more powerful than strength.
      ''',
    ),
    Storybook(
      id: '3',
      title: 'The Rainbow Fish',
      author: 'Ocean Tales',
      coverColor: const Color(0xFF64B5F6),
      emoji: '🐠',
      description: 'Learning to share and make friends',
      content: '''
Deep in the ocean lived a beautiful fish with shimmering, colorful scales. He was the most beautiful fish in the entire ocean, but he was also very proud.

The other fish wanted to play with him, but the Rainbow Fish always swam away. "I'm too beautiful to play with ordinary fish," he would say.

One day, a little blue fish asked, "Rainbow Fish, will you give me one of your shiny scales?"

"Certainly not!" said the Rainbow Fish. "These scales make me special!"

Soon, all the other fish stopped talking to the Rainbow Fish. He was beautiful but very lonely.

The Rainbow Fish went to the wise octopus for advice. "Give away your scales," said the octopus. "You will find happiness."

At first, the Rainbow Fish didn't want to, but he was so lonely. He gave one shiny scale to the little blue fish.

The little fish was so happy! Soon, other fish came, and the Rainbow Fish gave each one a shiny scale.

With each scale he gave away, the Rainbow Fish felt happier. Soon he had only one shiny scale left, but he had many friends.

"Now I am truly happy," said the Rainbow Fish, "because I have friends to share my life with!"

THE END

Moral: Sharing brings true happiness and friendship.
      ''',
    ),
    Storybook(
      id: '4',
      title: 'The Tortoise and the Hare',
      author: 'Aesop',
      coverColor: const Color(0xFFBA68C8),
      emoji: '🐢',
      description: 'Slow and steady wins the race',
      content: '''
Once upon a time, a hare was boasting about how fast he could run. He laughed at the tortoise for being so slow.

"I challenge you to a race!" said the tortoise bravely.

The hare laughed. "You? Race me? This will be easy!"

All the animals gathered to watch the race. When the race began, the hare zoomed ahead while the tortoise moved slowly but steadily.

The hare was so far ahead that he decided to take a nap. "I have plenty of time," he thought.

Meanwhile, the tortoise kept moving forward, one step at a time, never stopping.

When the hare woke up, he was shocked to see the tortoise near the finish line! He ran as fast as he could, but it was too late.

The tortoise crossed the finish line first!

"Slow and steady wins the race," said the tortoise with a smile.

The hare learned an important lesson that day about not being overconfident.

THE END

Moral: Slow and steady wins the race. Never underestimate others.
      ''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          'Storybook Corner',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Read Amazing Stories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enjoy these wonderful tales anytime, anywhere!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Storybook Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _storybooks.length,
                itemBuilder: (context, index) {
                  final storybook = _storybooks[index];
                  return StorybookCard(
                    storybook: storybook,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StorybookReaderScreen(storybook: storybook),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Storybook {
  final String id;
  final String title;
  final String author;
  final Color coverColor;
  final String emoji;
  final String description;
  final String content;

  Storybook({
    required this.id,
    required this.title,
    required this.author,
    required this.coverColor,
    required this.emoji,
    required this.description,
    required this.content,
  });
}

class StorybookCard extends StatelessWidget {
  final Storybook storybook;
  final VoidCallback onTap;

  const StorybookCard({
    super.key,
    required this.storybook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: storybook.coverColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: storybook.coverColor.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              storybook.emoji,
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                storybook.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'by ${storybook.author}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Read Now',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorybookReaderScreen extends StatelessWidget {
  final Storybook storybook;

  const StorybookReaderScreen({super.key, required this.storybook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE6),
      appBar: AppBar(
        title: Text(storybook.title),
        backgroundColor: storybook.coverColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                storybook.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                storybook.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'by ${storybook.author}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              storybook.content,
              style: const TextStyle(
                fontSize: 18,
                height: 1.8,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

