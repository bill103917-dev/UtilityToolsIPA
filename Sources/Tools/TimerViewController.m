#import "TimerViewController.h"
#import "../Helpers/UIHelpers.h"

@interface TimerViewController ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextView *lapTextView;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *lapButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger lapCount;

@property (nonatomic, assign) BOOL running;

@property (nonatomic, strong) NSMutableArray<NSString *> *lapTimes;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"計時器";
    self.view.backgroundColor = AppBackgroundColor();

    self.seconds = 0;
    self.lapCount = 0;
    self.running = NO;

    self.lapTimes =
        [NSMutableArray array];

    // =========================================================
    // 時間
    // =========================================================

    self.timeLabel =
        MakeLabel(@"00:00",
                  54,
                  UIFontWeightBold);

    self.timeLabel.textAlignment =
        NSTextAlignmentCenter;

    self.timeLabel.adjustsFontSizeToFitWidth = YES;

    // =========================================================
    // 分圈紀錄
    // =========================================================

    self.lapTextView =
        [[UITextView alloc] init];

    self.lapTextView.translatesAutoresizingMaskIntoConstraints = NO;

    self.lapTextView.editable = NO;
    self.lapTextView.selectable = NO;

    self.lapTextView.scrollEnabled = YES;

    self.lapTextView.showsVerticalScrollIndicator = YES;

    self.lapTextView.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    self.lapTextView.layer.cornerRadius = 14;
    self.lapTextView.clipsToBounds = YES;

    self.lapTextView.font =
        [UIFont systemFontOfSize:17
                          weight:UIFontWeightMedium];

    self.lapTextView.textColor =
        [UIColor secondaryLabelColor];

    self.lapTextView.textAlignment =
        NSTextAlignmentCenter;

    self.lapTextView.text =
        @"尚未分圈";

    // =========================================================
    // 開始
    // =========================================================

    self.startButton =
        MakeButton(@"▶️ 開始",
                   [UIColor systemGreenColor]);

    // =========================================================
    // 分圈 / 歸零
    // =========================================================

    self.lapButton =
        MakeButton(@"🔄 歸零",
                   [UIColor systemRedColor]);

    // =========================================================
    // 暫停
    // =========================================================

    UIButton *pauseButton =
        MakeButton(@"⏸️ 暫停",
                   [UIColor systemOrangeColor]);

    // =========================================================
    // Button Actions
    // =========================================================

    [self.startButton addTarget:self
                         action:@selector(startTimer)
               forControlEvents:UIControlEventTouchUpInside];

    [pauseButton addTarget:self
                    action:@selector(pauseTimer)
          forControlEvents:UIControlEventTouchUpInside];

    [self.lapButton addTarget:self
                       action:@selector(lapOrReset)
             forControlEvents:UIControlEventTouchUpInside];

    // =========================================================
    // Stack
    // =========================================================

    UIStackView *stack =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            self.timeLabel,
            self.lapTextView,
            self.startButton,
            pauseButton,
            self.lapButton
         ]];

    stack.axis =
        UILayoutConstraintAxisVertical;

    stack.spacing = 16;

    stack.alignment =
        UIStackViewAlignmentFill;

    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stack];

    // =========================================================
    // Layout
    // =========================================================

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor
         constraintGreaterThanOrEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:30],

        [stack.bottomAnchor
         constraintLessThanOrEqualToAnchor:
         self.view.safeAreaLayoutGuide.bottomAnchor
         constant:-30],

        [stack.centerYAnchor
         constraintEqualToAnchor:
         self.view.centerYAnchor],

        [stack.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:30],

        [stack.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-30],

        // 分圈紀錄區高度
        [self.lapTextView.heightAnchor
         constraintEqualToConstant:160],

        // 按鈕高度
        [self.startButton.heightAnchor
         constraintEqualToConstant:58],

        [pauseButton.heightAnchor
         constraintEqualToConstant:58],

        [self.lapButton.heightAnchor
         constraintEqualToConstant:58]
    ]];
}

#pragma mark - Start

- (void)startTimer {

    if (self.running) {
        return;
    }

    self.running = YES;

    self.timer =
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(tick)
                                       userInfo:nil
                                        repeats:YES];

    self.startButton.enabled = NO;

    self.startButton.alpha = 0.5;

    [self.lapButton setTitle:@"⭕ 分圈"
                    forState:UIControlStateNormal];
}

#pragma mark - Pause

- (void)pauseTimer {

    if (!self.running) {
        return;
    }

    [self.timer invalidate];

    self.timer = nil;

    self.running = NO;

    self.startButton.enabled = YES;

    self.startButton.alpha = 1.0;

    [self.startButton setTitle:@"▶️ 繼續"
                      forState:UIControlStateNormal];
}

#pragma mark - Lap / Reset

- (void)lapOrReset {

    if (self.running) {

        self.lapCount++;

        NSString *lapTime =
            [NSString stringWithFormat:
                @"第 %ld 圈：%@",
                (long)self.lapCount,
                self.timeLabel.text];

        // =====================================================
        // 保存這一圈
        // =====================================================

        [self.lapTimes addObject:lapTime];

        // =====================================================
        // 顯示全部圈數
        // =====================================================

        self.lapTextView.text =
            [self.lapTimes componentsJoinedByString:@"\n"];

        // 捲到最下面
        if (self.lapTextView.text.length > 0) {

            [self.lapTextView scrollRangeToVisible:
                NSMakeRange(
                    self.lapTextView.text.length - 1,
                    1)];
        }

        [self animateLap];

    } else {

        [self resetTimer];
    }
}

#pragma mark - Tick

- (void)tick {

    self.seconds++;

    [self updateTimeLabel];
}

#pragma mark - Update

- (void)updateTimeLabel {

    NSInteger minutes =
        self.seconds / 60;

    NSInteger seconds =
        self.seconds % 60;

    self.timeLabel.text =
        [NSString stringWithFormat:
            @"%02ld:%02ld",
            (long)minutes,
            (long)seconds];
}

#pragma mark - Reset

- (void)resetTimer {

    [self.timer invalidate];

    self.timer = nil;

    self.seconds = 0;

    self.lapCount = 0;

    self.running = NO;

    // 清除所有圈數
    [self.lapTimes removeAllObjects];

    self.startButton.enabled = YES;

    self.startButton.alpha = 1.0;

    [self.startButton setTitle:@"▶️ 開始"
                      forState:UIControlStateNormal];

    [self.lapButton setTitle:@"🔄 歸零"
                     forState:UIControlStateNormal];

    self.lapTextView.text =
        @"尚未分圈";

    [self updateTimeLabel];
}

#pragma mark - Animation

- (void)animateLap {

    [UIView animateWithDuration:0.15
                     animations:^{

        self.lapTextView.transform =
            CGAffineTransformMakeScale(1.03, 1.03);
    }
                     completion:^(BOOL finished) {

        [UIView animateWithDuration:0.15
                         animations:^{

            self.lapTextView.transform =
                CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark - Dealloc

- (void)dealloc {

    [self.timer invalidate];
}

@end
