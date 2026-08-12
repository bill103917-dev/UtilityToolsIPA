#import <UIKit/UIKit.h>

#pragma mark - Helpers

static UIColor *AppBackgroundColor(void) {
    return [UIColor systemGroupedBackgroundColor];
}

static UIButton *MakeButton(NSString *title, UIColor *color) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont systemFontOfSize:18
                                                 weight:UIFontWeightSemibold];

    button.backgroundColor = color;
    button.layer.cornerRadius = 14;
    button.clipsToBounds = YES;

    button.translatesAutoresizingMaskIntoConstraints = NO;

    return button;
}

static UILabel *MakeLabel(NSString *text,
                          CGFloat size,
                          UIFontWeight weight) {

    UILabel *label = [[UILabel alloc] init];

    label.text = text;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.textColor = [UIColor labelColor];
    label.numberOfLines = 0;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    return label;
}

#pragma mark - Calculator

@interface CalculatorViewController : UIViewController
@property(nonatomic,strong) UILabel *display;
@property(nonatomic,strong) NSString *current;
@property(nonatomic,strong) NSString *operation;
@property(nonatomic,strong) NSDecimalNumber *firstNumber;
@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"計算機";
    self.view.backgroundColor = AppBackgroundColor();

    self.current = @"0";

    self.display = MakeLabel(@"0", 42, UIFontWeightBold);
    self.display.textAlignment = NSTextAlignmentRight;
    self.display.adjustsFontSizeToFitWidth = YES;

    [self.view addSubview:self.display];

    NSArray *buttons = @[
        @"7",@"8",@"9",@"÷",
        @"4",@"5",@"6",@"×",
        @"1",@"2",@"3",@"−",
        @"0",@"C",@"=",@"+"
    ];

    UIStackView *grid =
    [[UIStackView alloc] initWithArrangedSubviews:@[]];

    grid.axis = UILayoutConstraintAxisVertical;
    grid.spacing = 10;
    grid.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:grid];

    for (NSInteger row = 0; row < 4; row++) {

        UIStackView *line =
        [[UIStackView alloc] initWithArrangedSubviews:@[]];

        line.axis = UILayoutConstraintAxisHorizontal;
        line.spacing = 10;
        line.distribution = UIStackViewDistributionFillEqually;

        for (NSInteger col = 0; col < 4; col++) {

            NSInteger index = row * 4 + col;
            NSString *title = buttons[index];

            UIColor *color = [UIColor systemBlueColor];

            if ([title isEqualToString:@"C"]) {
                color = [UIColor systemRedColor];
            } else if ([title isEqualToString:@"="]) {
                color = [UIColor systemGreenColor];
            } else if ([title isEqualToString:@"+"] ||
                       [title isEqualToString:@"−"] ||
                       [title isEqualToString:@"×"] ||
                       [title isEqualToString:@"÷"]) {
                color = [UIColor systemOrangeColor];
            } else {
                color = [UIColor systemIndigoColor];
            }

            UIButton *button = MakeButton(title, color);

            [button addTarget:self
                       action:@selector(buttonPressed:)
             forControlEvents:UIControlEventTouchUpInside];

            [line addArrangedSubview:button];
        }

        [grid addArrangedSubview:line];

        [line.heightAnchor constraintEqualToConstant:64].active = YES;
    }

    [NSLayoutConstraint activateConstraints:@[
        [self.display.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [self.display.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.display.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [self.display.heightAnchor constraintEqualToConstant:80],

        [grid.topAnchor constraintEqualToAnchor:self.display.bottomAnchor constant:30],
        [grid.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [grid.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
}

- (void)buttonPressed:(UIButton *)sender {

    NSString *value = sender.currentTitle;

    if ([value isEqualToString:@"C"]) {
        self.current = @"0";
        self.operation = nil;
        self.firstNumber = nil;
        self.display.text = @"0";
        return;
    }

    if ([value isEqualToString:@"+"] ||
        [value isEqualToString:@"−"] ||
        [value isEqualToString:@"×"] ||
        [value isEqualToString:@"÷"]) {

        self.firstNumber =
        [NSDecimalNumber decimalNumberWithString:self.current];

        self.operation = value;
        self.current = @"0";

        return;
    }

    if ([value isEqualToString:@"="]) {

        if (!self.operation || !self.firstNumber) {
            return;
        }

        NSDecimalNumber *second =
        [NSDecimalNumber decimalNumberWithString:self.current];

        NSDecimalNumber *result = nil;

        if ([self.operation isEqualToString:@"+"]) {
            result = [self.firstNumber decimalNumberByAdding:second];
        }
        else if ([self.operation isEqualToString:@"−"]) {
            result = [self.firstNumber decimalNumberBySubtracting:second];
        }
        else if ([self.operation isEqualToString:@"×"]) {
            result = [self.firstNumber decimalNumberByMultiplyingBy:second];
        }
        else if ([self.operation isEqualToString:@"÷"]) {

            if ([second isEqualToNumber:[NSDecimalNumber zero]]) {

                self.display.text = @"不能除以 0";
                self.current = @"0";
                self.operation = nil;
                self.firstNumber = nil;

                return;
            }

            result = [self.firstNumber decimalNumberByDividingBy:second];
        }

        self.current = result.stringValue;
        self.display.text = self.current;

        self.operation = nil;
        self.firstNumber = nil;

        return;
    }

    if ([self.current isEqualToString:@"0"]) {
        self.current = value;
    } else {
        self.current = [self.current stringByAppendingString:value];
    }

    self.display.text = self.current;
}

@end

#pragma mark - Random

@interface RandomViewController : UIViewController
@property(nonatomic,strong) UILabel *resultLabel;
@property(nonatomic,strong) UITextField *minField;
@property(nonatomic,strong) UITextField *maxField;
@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"隨機數字";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *title =
    MakeLabel(@"🎲 隨機數字產生器", 28, UIFontWeightBold);

    self.minField = [[UITextField alloc] init];
    self.maxField = [[UITextField alloc] init];

    self.minField.placeholder = @"最小值";
    self.maxField.placeholder = @"最大值";

    self.minField.keyboardType = UIKeyboardTypeNumberPad;
    self.maxField.keyboardType = UIKeyboardTypeNumberPad;

    self.minField.borderStyle = UITextBorderStyleRoundedRect;
    self.maxField.borderStyle = UITextBorderStyleRoundedRect;

    self.minField.translatesAutoresizingMaskIntoConstraints = NO;
    self.maxField.translatesAutoresizingMaskIntoConstraints = NO;

    self.resultLabel =
    MakeLabel(@"結果：—", 32, UIFontWeightBold);

    self.resultLabel.textAlignment = NSTextAlignmentCenter;

    UIButton *button =
    MakeButton(@"🎲 產生隨機數字",
               [UIColor systemPurpleColor]);

    [button addTarget:self
               action:@selector(generate)
     forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:title];
    [self.view addSubview:self.minField];
    [self.view addSubview:self.maxField];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:button];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:40],
        [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [self.minField.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:30],
        [self.minField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [self.minField.widthAnchor constraintEqualToConstant:140],
        [self.minField.heightAnchor constraintEqualToConstant:50],

        [self.maxField.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:30],
        [self.maxField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [self.maxField.widthAnchor constraintEqualToConstant:140],
        [self.maxField.heightAnchor constraintEqualToConstant:50],

        [self.resultLabel.topAnchor constraintEqualToAnchor:self.minField.bottomAnchor constant:50],
        [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],

        [button.topAnchor constraintEqualToAnchor:self.resultLabel.bottomAnchor constant:40],
        [button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [button.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (void)generate {

    NSInteger min =
    [self.minField.text integerValue];

    NSInteger max =
    [self.maxField.text integerValue];

    if (self.minField.text.length == 0 ||
        self.maxField.text.length == 0 ||
        max < min) {

        self.resultLabel.text = @"請輸入正確範圍";
        return;
    }

    uint32_t range =
    (uint32_t)(max - min + 1);

    NSInteger result =
    min + (NSInteger)arc4random_uniform(range);

    self.resultLabel.text =
    [NSString stringWithFormat:@"結果：%ld",
     (long)result];
}

@end

#pragma mark - Timer

@interface TimerViewController : UIViewController
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger seconds;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"計時器";
    self.view.backgroundColor = AppBackgroundColor();

    self.seconds = 0;

    self.timeLabel =
    MakeLabel(@"00:00", 54, UIFontWeightBold);

    self.timeLabel.textAlignment = NSTextAlignmentCenter;

    UIButton *start =
    MakeButton(@"▶️ 開始",
               [UIColor systemGreenColor]);

    UIButton *stop =
    MakeButton(@"⏸️ 暫停",
               [UIColor systemOrangeColor]);

    UIButton *reset =
    MakeButton(@"🔄 歸零",
               [UIColor systemRedColor]);

    [start addTarget:self
              action:@selector(startTimer)
    forControlEvents:UIControlEventTouchUpInside];

    [stop addTarget:self
             action:@selector(stopTimer)
   forControlEvents:UIControlEventTouchUpInside];

    [reset addTarget:self
              action:@selector(resetTimer)
    forControlEvents:UIControlEventTouchUpInside];

    UIStackView *stack =
    [[UIStackView alloc] initWithArrangedSubviews:@[
        self.timeLabel,
        start,
        stop,
        reset
    ]];

    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 16;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30]
    ]];

    [start.heightAnchor constraintEqualToConstant:58].active = YES;
    [stop.heightAnchor constraintEqualToConstant:58].active = YES;
    [reset.heightAnchor constraintEqualToConstant:58].active = YES;
}

- (void)startTimer {

    if (self.timer) {
        return;
    }

    self.timer =
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(tick)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)stopTimer {

    [self.timer invalidate];
    self.timer = nil;
}

- (void)resetTimer {

    [self stopTimer];

    self.seconds = 0;

    [self updateLabel];
}

- (void)tick {

    self.seconds++;

    [self updateLabel];
}

- (void)updateLabel {

    NSInteger minutes = self.seconds / 60;
    NSInteger seconds = self.seconds % 60;

    self.timeLabel.text =
    [NSString stringWithFormat:@"%02ld:%02ld",
     (long)minutes,
     (long)seconds];
}

- (void)dealloc {

    [self.timer invalidate];
}

@end

#pragma mark - Text Tool

@interface TextViewController : UIViewController
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UILabel *countLabel;
@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"文字工具";
    self.view.backgroundColor = AppBackgroundColor();

    self.textView = [[UITextView alloc] init];

    self.textView.font =
    [UIFont systemFontOfSize:18];

    self.textView.backgroundColor =
    [UIColor secondarySystemBackgroundColor];

    self.textView.layer.cornerRadius = 14;

    self.textView.translatesAutoresizingMaskIntoConstraints = NO;

    self.countLabel =
    MakeLabel(@"字數：0", 18, UIFontWeightMedium);

    UIButton *clear =
    MakeButton(@"🗑️ 清除",
               [UIColor systemRedColor]);

    UIButton *copy =
    MakeButton(@"📋 複製",
               [UIColor systemBlueColor]);

    [clear addTarget:self
              action:@selector(clearText)
    forControlEvents:UIControlEventTouchUpInside];

    [copy addTarget:self
             action:@selector(copyText)
   forControlEvents:UIControlEventTouchUpInside];

    [self.textView addTarget:self
                       action:@selector(textChanged)
             forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:clear];
    [self.view addSubview:copy];

    [NSLayoutConstraint activateConstraints:@[
        [self.textView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.textView.heightAnchor constraintEqualToConstant:300],

        [self.countLabel.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:15],
        [self.countLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor],

        [clear.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor constant:20],
        [clear.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [clear.widthAnchor constraintEqualToConstant:150],
        [clear.heightAnchor constraintEqualToConstant:55],

        [copy.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor constant:20],
        [copy.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [copy.widthAnchor constraintEqualToConstant:150],
        [copy.heightAnchor constraintEqualToConstant:55]
    ]];
}

- (void)textChanged {

    self.countLabel.text =
    [NSString stringWithFormat:@"字數：%lu",
     (unsigned long)self.textView.text.length];
}

- (void)clearText {

    self.textView.text = @"";
    [self textChanged];
}

- (void)copyText {

    [UIPasteboard generalPasteboard].string =
    self.textView.text;

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"完成"
                                        message:@"文字已複製到剪貼簿。"
                                 preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:
     [UIAlertAction actionWithTitle:@"好的"
                              style:UIAlertActionStyleDefault
                            handler:nil]];

    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end

#pragma mark - Password

@interface PasswordViewController : UIViewController
@property(nonatomic,strong) UILabel *resultLabel;
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"隨機密碼";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *title =
    MakeLabel(@"🔐 隨機字串產生器", 28, UIFontWeightBold);

    self.resultLabel =
    MakeLabel(@"點擊按鈕產生", 20, UIFontWeightMedium);

    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.numberOfLines = 0;

    UIButton *button =
    MakeButton(@"🔐 產生隨機字串",
               [UIColor systemIndigoColor]);

    [button addTarget:self
               action:@selector(generatePassword)
     forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:title];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:button];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50],
        [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],

        [self.resultLabel.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:60],
        [self.resultLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [self.resultLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25],

        [button.topAnchor constraintEqualToAnchor:self.resultLabel.bottomAnchor constant:50],
        [button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [button.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (void)generatePassword {

    NSString *characters =
    @"ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";

    NSMutableString *result =
    [NSMutableString string];

    for (NSInteger i = 0; i < 16; i++) {

        uint32_t index =
        arc4random_uniform((uint32_t)characters.length);

        unichar character =
        [characters characterAtIndex:index];

        [result appendFormat:@"%C", character];
    }

    self.resultLabel.text = result;

    [UIPasteboard generalPasteboard].string = result;
}

@end

#pragma mark - Device Info

@interface DeviceViewController : UIViewController
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"裝置資訊";
    self.view.backgroundColor = AppBackgroundColor();

    UIDevice *device = [UIDevice currentDevice];

    NSString *info =
    [NSString stringWithFormat:
     @"裝置：%@\n\n系統：%@\n\n系統版本：%@\n\n裝置名稱：%@\n\nApp 版本：1.0",
     device.model,
     device.systemName,
     device.systemVersion,
     device.name];

    UILabel *label =
    MakeLabel(info, 20, UIFontWeightMedium);

    label.textAlignment = NSTextAlignmentLeft;

    [self.view addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25]
    ]];
}

@end

#pragma mark - About

@interface AboutViewController : UIViewController
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"關於";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *label =
    MakeLabel(@"🧰 Utility Tools\n\n一個簡單、快速的 iOS 工具箱。\n\n版本 1.0\n\nBuilt with UIKit + Objective-C",
              21,
              UIFontWeightMedium);

    label.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30]
    ]];
}

@end

#pragma mark - Home

@interface HomeViewController : UIViewController
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"工具箱";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *header =
    MakeLabel(@"🧰 Utility Tools", 32, UIFontWeightBold);

    UILabel *subtitle =
    MakeLabel(@"你的日常實用工具箱", 17, UIFontWeightRegular);

    UIStackView *stack =
    [[UIStackView alloc] initWithArrangedSubviews:@[
        [self button:@"🧮  計算機"
               color:[UIColor systemBlueColor]
              action:@selector(openCalculator)],

        [self button:@"🎲  隨機數字"
               color:[UIColor systemPurpleColor]
              action:@selector(openRandom)],

        [self button:@"⏱️  計時器"
               color:[UIColor systemGreenColor]
              action:@selector(openTimer)],

        [self button:@"🔤  文字工具"
               color:[UIColor systemOrangeColor]
              action:@selector(openText)],

        [self button:@"🔐  隨機字串"
               color:[UIColor systemIndigoColor]
              action:@selector(openPassword)],

        [self button:@"📱  裝置資訊"
               color:[UIColor systemTealColor]
              action:@selector(openDevice)],

        [self button:@"ℹ️  關於"
               color:[UIColor systemGrayColor]
              action:@selector(openAbout)]
    ]];

    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:header];
    [self.view addSubview:subtitle];
    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [header.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:25],
        [header.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],

        [subtitle.topAnchor constraintEqualToAnchor:header.bottomAnchor constant:5],
        [subtitle.leadingAnchor constraintEqualToAnchor:header.leadingAnchor],

        [stack.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:25],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25]
    ]];
}

- (UIButton *)button:(NSString *)title
               color:(UIColor *)color
              action:(SEL)action {

    UIButton *button = MakeButton(title, color);

    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];

    [button.heightAnchor constraintEqualToConstant:55].active = YES;

    return button;
}

- (void)openCalculator {

    [self.navigationController pushViewController:
     [[CalculatorViewController alloc] init]
                                       animated:YES];
}

- (void)openRandom {

    [self.navigationController pushViewController:
     [[RandomViewController alloc] init]
                                       animated:YES];
}

- (void)openTimer {

    [self.navigationController pushViewController:
     [[TimerViewController alloc] init]
                                       animated:YES];
}

- (void)openText {

    [self.navigationController pushViewController:
     [[TextViewController alloc] init]
                                       animated:YES];
}

- (void)openPassword {

    [self.navigationController pushViewController:
     [[PasswordViewController alloc] init]
                                       animated:YES];
}

- (void)openDevice {

    [self.navigationController pushViewController:
     [[DeviceViewController alloc] init]
                                       animated:YES];
}

- (void)openAbout {

    [self.navigationController pushViewController:
     [[AboutViewController alloc] init]
                                       animated:YES];
}

@end

#pragma mark - App Delegate

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic,strong) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window =
    [[UIWindow alloc] initWithFrame:
     [UIScreen mainScreen].bounds];

    HomeViewController *home =
    [[HomeViewController alloc] init];

    UINavigationController *navigation =
    [[UINavigationController alloc]
     initWithRootViewController:home];

    self.window.rootViewController = navigation;

    [self.window makeKeyAndVisible];

    return YES;
}

@end

#pragma mark - Main

int main(int argc, char *argv[]) {

    @autoreleasepool {

        return UIApplicationMain(
            argc,
            argv,
            nil,
            NSStringFromClass([AppDelegate class])
        );
    }
}
