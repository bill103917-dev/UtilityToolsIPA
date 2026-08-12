#import "TimerViewController.h"
#import "../Helpers/UIHelpers.h"

@interface TimerViewController ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *lapLabel;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *lapButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger lapCount;

@property (nonatomic, assign) BOOL running;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"計時器";
    self.view.backgroundColor = AppBackgroundColor();

    self.seconds = 0;
    self.lapCount = 0;
    self.running = NO;

    self.timeLabel =
        MakeLabel(@"00:00",
                  54,
                  UIFontWeightBold);

    self.timeLabel.textAlignment =
        NSTextAlignmentCenter;

    self.timeLabel.adjustsFontSizeToFitWidth = YES;

    self.lapLabel =
        MakeLabel(@"尚未分圈",
                  17,
                  UIFontWeightMedium);

    self.lapLabel.textAlignment =
        NSTextAlignmentCenter;

    self.lapLabel.textColor =
        [UIColor secondaryLabelColor];

    self.startButton =
        MakeButton(@"▶️ 開始",
                   [UIColor systemGreenColor]);

    self.lapButton =
        MakeButton(@"🔄 歸零",
                   [UIColor systemRedColor]);

    UIButton *pauseButton =
        MakeButton(@"⏸️ 暫停",
                   [UIColor systemOrangeColor]);

    [self.startButton addTarget:self
                         action:@selector(startTimer)
               forControlEvents:UIControlEventTouchUpInside];

    [pauseButton addTarget:self
                    action:@selector(pauseTimer)
          forControlEvents:UIControlEventTouchUpInside];

    [self.lapButton addTarget:self
                       action:@selector(lapOrReset)
             forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            self.timeLabel,
            self.lapLabel,
            self.startButton,
            pauseButton,
            self.lapButton
         ]];

    stack.axis =
        UILayoutConstraintAxisVertical;

    stack.spacing = 16;

    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
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
         constant:-30]
    ]];

    [self.startButton.heightAnchor
     constraintEqualToConstant:58].active = YES;

    [pauseButton.heightAnchor
     constraintEqualToConstant:58].active = YES;

    [self.lapButton.heightAnchor
     constraintEqualToConstant:58].active = YES;
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

        self.lapLabel.text =
            [NSString stringWithFormat:
                @"第 %ld 圈：%@",
                (long)self.lapCount,
                self.timeLabel.text];

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

    self.startButton.enabled = YES;
    self.startButton.alpha = 1.0;

    [self.startButton setTitle:@"▶️ 開始"
                      forState:UIControlStateNormal];

    [self.lapButton setTitle:@"🔄 歸零"
                     forState:UIControlStateNormal];

    self.lapLabel.text = @"尚未分圈";

    [self updateTimeLabel];
}

#pragma mark - Animation

- (void)animateLap {

    [UIView animateWithDuration:0.15
                     animations:^{

        self.lapLabel.transform =
            CGAffineTransformMakeScale(1.08, 1.08);
    }
                     completion:^(BOOL finished) {

        [UIView animateWithDuration:0.15
                         animations:^{

            self.lapLabel.transform =
                CGAffineTransformIdentity;
        }];
    }];
}

#pragma mark - Dealloc

- (void)dealloc {

    [self.timer invalidate];
}

@end