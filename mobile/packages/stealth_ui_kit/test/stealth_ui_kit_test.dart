import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

void main() {
  group('Stealth UI Kit Widgets', () {
    testWidgets('StealthTheme provides custom accents and dark colors',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StealthTheme(
            data: const StealthThemeData(accent: StealthAccent.emerald),
            child: Builder(
              builder: (context) {
                final theme = StealthTheme.of(context);
                return Container(
                  color: theme.outgoingBubble,
                  child: Text(theme.accent.name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Emerald'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, equals(const Color(0xFF059669)));
    });

    testWidgets(
        'GroupedBubble renders outgoing message with status ticks and reply',
        (tester) async {
      bool replyTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StealthTheme(
              data: const StealthThemeData(accent: StealthAccent.electricBlue),
              child: GroupedBubble(
                content: const Text('Incoming response'),
                isOutgoing: true,
                position: BubblePosition.middle,
                timestampText: '10:45 AM',
                status: MessageTickStatus.read,
                replyAuthor: 'Alice',
                replyText: 'Original question?',
                onReplyTap: () => replyTapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Incoming response'), findsOneWidget);
      expect(find.text('10:45 AM'), findsOneWidget);
      expect(find.text('Original question?'), findsOneWidget);
      expect(find.byType(MessageStatusTicks), findsOneWidget);

      await tester.tap(find.text('Original question?'));
      expect(replyTapped, isTrue);
    });

    testWidgets('SwipeToReply triggers onReply when dragged horizontally',
        (tester) async {
      bool replyTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StealthTheme(
              data: const StealthThemeData(),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: SwipeToReply(
                    onReply: () => replyTriggered = true,
                    child: Container(
                      color: Colors.blue,
                      child: const Text('Swipe me'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Drag 100 pixels to the right (past threshold)
      await tester.drag(find.text('Swipe me'), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(replyTriggered, isTrue);
    });

    testWidgets(
        'SwipeToReply handles rapid consecutive drags smoothly without error',
        (tester) async {
      int replyCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StealthTheme(
              data: const StealthThemeData(),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: SwipeToReply(
                    onReply: () => replyCount++,
                    child: Container(
                      color: Colors.blue,
                      child: const Text('Swipe rapid'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Start drag 1
      final gesture1 =
          await tester.startGesture(tester.getCenter(find.text('Swipe rapid')));
      await gesture1.moveBy(const Offset(100, 0));
      await gesture1.up();
      // Pump partially mid-spring
      await tester.pump(const Duration(milliseconds: 50));
      // Rapid drag 2 mid-animation
      final gesture2 =
          await tester.startGesture(tester.getCenter(find.text('Swipe rapid')));
      await gesture2.moveBy(const Offset(100, 0));
      await gesture2.up();
      await tester.pumpAndSettle();

      expect(replyCount, equals(2));
    });

    testWidgets('WaveformScrubber renders play button and triggers seek',
        (tester) async {
      bool playPauseCalled = false;
      double? seekProgress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StealthTheme(
              data: const StealthThemeData(),
              child: SizedBox(
                width: 250,
                height: 50,
                child: WaveformScrubber(
                  waveform: const [10, 30, 70, 90, 50, 40, 20, 80],
                  isPlaying: false,
                  progress: 0.25,
                  durationText: '0:14',
                  onPlayPause: () => playPauseCalled = true,
                  onSeek: (p) => seekProgress = p,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_circle_filled_rounded), findsOneWidget);
      expect(find.text('0:14'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.play_circle_filled_rounded));
      expect(playPauseCalled, isTrue);

      final waveformFinder = find
          .descendant(
            of: find.byType(WaveformScrubber),
            matching: find.byType(CustomPaint),
          )
          .last;
      await tester.tap(waveformFinder);
      expect(seekProgress, isNotNull);
    });

    testWidgets('ZeroFlickerKeyboardTray maintains tray height when open',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ZeroFlickerKeyboardTray(
              isTrayOpen: true,
              defaultTrayHeight: 250,
              trayContent: Text('Emoji Tray Content'),
              child: Text('Chat Messages'),
            ),
          ),
        ),
      );

      expect(find.text('Chat Messages'), findsOneWidget);
      expect(find.text('Emoji Tray Content'), findsOneWidget);
    });
  });
}
