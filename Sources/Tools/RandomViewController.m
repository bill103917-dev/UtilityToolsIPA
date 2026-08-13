#import "RandomViewController.h"
#import "../Helpers/UIHelpers.h"

@interface RandomViewController ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UITextField *minField;
@property (nonatomic, strong) UITextField *maxField;

@property (nonatomic, strong) UIButton *copyButton;
@property (nonatomic, strong) NSString *currentResult;

@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"隨機數字";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *title =
        MakeLabel(@"🎲 隨機數字產生器",
                  28,
                  UIFontWeightBold);

    title.textAlignment = NSTextAlignmentCenter;

    self.minField = [[UITextField alloc] init];
    self.maxField = [[UITextField alloc] init];

    self.minField.placeholder = @"最小值";
    self.maxField.placeholder = @"最大值";

    self.minField.borderStyle =
        UITextBorderStyleRoundedRect;

    self.maxField.borderStyle =
        UITextBorderStyleRoundedRect;

    self.minField.keyboardType =
        UIKeyboardTypeNumbersAndPunctuation;

    self.maxField.keyboardType =
        UIKeyboardTypeNumbersAndPunctuation;

    self.minField.font =
        [UIFont systemFontOfSize:18];

    self.maxField.font =
        [UIFont systemFontOfSize:18];

    self.minField.translatesAutoresizingMaskIntoConstraints = NO;
    self.maxField.translatesAutoresizingMaskIntoConstraints = NO;

    self.resultLabel =
        MakeLabel(@"結果：—",
                  32,
                  UIFontWeightBold);

    self.resultLabel.textAlignment =
        NSTextAlignmentCenter;

    UIButton *generateButton =
        MakeButton(@"🎲 產生隨機數字",
                   [UIColor systemPurpleColor]);

    [generateButton addTarget:self
                       action:@selector(generateRandomNumber)
             forControlEvents:UIControlEventTouchUpInside];

    // MARK: - 複製結果按鈕

    self.copyButton =
        MakeButton(@"📋 複製結果",
                   [UIColor systemBlueColor]);

    [self.copyButton addTarget:self
                        action:@selector(copyResult)
              forControlEvents:UIControlEventTouchUpInside];

    // 一開始沒有結果，所以不能複製
    self.copyButton.enabled = NO;
    self.copyButton.alpha = 0.45;

    [self.view addSubview:title];
    [self.view addSubview:self.minField];
    [self.view addSubview:self.maxField];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:generateButton];
    [self.view addSubview:self.copyButton];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:35],

        [title.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [title.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [self.minField.topAnchor
         constraintEqualToAnchor:
         title.bottomAnchor
         constant:30],

        [self.minField.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [self.minField.trailingAnchor
         constraintEqualToAnchor:
         self.view.centerXAnchor
         constant:-8],

        [self.minField.heightAnchor
         constraintEqualToConstant:52],

        [self.maxField.topAnchor
         constraintEqualToAnchor:
         title.bottomAnchor
         constant:30],

        [self.maxField.leadingAnchor
         constraintEqualToAnchor:
         self.view.centerXAnchor
         constant:8],

        [self.maxField.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [self.maxField.heightAnchor
         constraintEqualToConstant:52],

        [self.resultLabel.topAnchor
         constraintEqualToAnchor:
         self.minField.bottomAnchor
         constant:50],

        [self.resultLabel.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [self.resultLabel.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [generateButton.topAnchor
         constraintEqualToAnchor:
         self.resultLabel.bottomAnchor
         constant:40],

        [generateButton.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [generateButton.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [generateButton.heightAnchor
         constraintEqualToConstant:60],

        // 複製按鈕
        [self.copyButton.topAnchor
         constraintEqualToAnchor:
         generateButton.bottomAnchor
         constant:15],

        [self.copyButton.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [self.copyButton.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [self.copyButton.heightAnchor
         constraintEqualToConstant:52]
    ]];
}

#pragma mark - Generate

- (void)generateRandomNumber {

    [self.view endEditing:YES];

    NSString *minText =
        [self.minField.text
         stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *maxText =
        [self.maxField.text
         stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (minText.length == 0 ||
        maxText.length == 0) {

        self.resultLabel.text = @"請輸入完整範圍";

        [self clearResult];

        return;
    }

    NSScanner *minScanner =
        [NSScanner scannerWithString:minText];

    NSScanner *maxScanner =
        [NSScanner scannerWithString:maxText];

    NSInteger minValue = 0;
    NSInteger maxValue = 0;

    BOOL minValid =
        [minScanner scanInteger:&minValue] &&
        minScanner.isAtEnd;

    BOOL maxValid =
        [maxScanner scanInteger:&maxValue] &&
        maxScanner.isAtEnd;

    if (!minValid || !maxValid) {

        self.resultLabel.text =
            @"只能輸入整數";

        [self clearResult];

        return;
    }

    if (maxValue < minValue) {

        self.resultLabel.text =
            @"最大值不能小於最小值";

        [self clearResult];

        return;
    }

    unsigned long long range =
        (unsigned long long)maxValue -
        (unsigned long long)minValue +
        1ULL;

    if (range == 0 ||
        range > UINT32_MAX) {

        self.resultLabel.text =
            @"數字範圍太大";

        [self clearResult];

        return;
    }

    uint32_t randomValue =
        arc4random_uniform((uint32_t)range);

    NSInteger result =
        minValue + (NSInteger)randomValue;

    // 儲存真正的結果
    self.currentResult =
        [NSString stringWithFormat:@"%ld",
         (long)result];

    self.resultLabel.text =
        [NSString stringWithFormat:
            @"結果：%ld",
            (long)result];

    // 啟用複製按鈕
    self.copyButton.enabled = YES;
    self.copyButton.alpha = 1.0;

    [self.copyButton setTitle:@"📋 複製結果"
                      forState:UIControlStateNormal];

    [self animateResult];
}

#pragma mark - Clear Result

- (void)clearResult {

    self.currentResult = nil;

    self.copyButton.enabled = NO;
    self.copyButton.alpha = 0.45;

    [self.copyButton setTitle:@"📋 複製結果"
                      forState:UIControlStateNormal];
}

#pragma mark - Copy

- (void)copyResult {

    if (self.currentResult.length == 0) {
        return;
    }

    // 複製純數字
    UIPasteboard *pasteboard =
        [UIPasteboard generalPasteboard];

    pasteboard.string = self.currentResult;

    // 按鈕動畫
    [UIView animateWithDuration:0.1
                     animations:^{

        self.copyButton.transform =
            CGAffineTransformMakeScale(0.92, 0.92);

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.18
                         animations:^{

            self.copyButton.transform =
                CGAffineTransformIdentity;
        }];
    }];

    // 修改按鈕文字
    [self.copyButton setTitle:@"✓ 已複製"
                      forState:UIControlStateNormal];

    // 讓按鈕稍微淡一下再恢復
    [UIView animateWithDuration:0.15
                     animations:^{

        self.copyButton.alpha = 0.7;

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.2
                         animations:^{

            self.copyButton.alpha = 1.0;
        }];
    }];

    // 1 秒後恢復
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(resetCopyButton)
                                               object:nil];

    [self performSelector:@selector(resetCopyButton)
               withObject:nil
               afterDelay:1.0];
}

#pragma mark - Reset Copy Button

- (void)resetCopyButton {

    if (self.currentResult.length == 0) {
        return;
    }

    [UIView transitionWithView:self.copyButton
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{

        [self.copyButton setTitle:@"📋 複製結果"
                          forState:UIControlStateNormal];

    } completion:nil];
}

#pragma mark - Animation

- (void)animateResult {

    self.resultLabel.transform =
        CGAffineTransformMakeScale(0.7, 0.7);

    self.resultLabel.alpha = 0.2;

    [UIView animateWithDuration:0.25
                     animations:^{

        self.resultLabel.transform =
            CGAffineTransformIdentity;

        self.resultLabel.alpha = 1.0;
    }];
}

@end
