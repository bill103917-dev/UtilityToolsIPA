#import "RandomViewController.h"
#import "../Helpers/UIHelpers.h"
#import <stdlib.h>

@interface RandomViewController ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UITextField *minField;
@property (nonatomic, strong) UITextField *maxField;

@property (nonatomic, strong) UIButton *resultActionButton;
@property (nonatomic, strong) NSString *currentResult;

@end

@implementation RandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"隨機數字";
    self.view.backgroundColor = AppBackgroundColor();

    // ============================================================
    // 標題
    // ============================================================

    UILabel *title =
        MakeLabel(@"🎲 隨機數字產生器",
                  28,
                  UIFontWeightBold);

    title.textAlignment =
        NSTextAlignmentCenter;


    // ============================================================
    // 最小值 / 最大值
    // ============================================================

    self.minField =
        [[UITextField alloc] init];

    self.maxField =
        [[UITextField alloc] init];

    self.minField.placeholder =
        @"最小值";

    self.maxField.placeholder =
        @"最大值";

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

    self.minField.translatesAutoresizingMaskIntoConstraints =
        NO;

    self.maxField.translatesAutoresizingMaskIntoConstraints =
        NO;


    // ============================================================
    // 結果
    // ============================================================

    self.resultLabel =
        MakeLabel(@"結果：—",
                  32,
                  UIFontWeightBold);

    self.resultLabel.textAlignment =
        NSTextAlignmentCenter;


    // ============================================================
    // 產生按鈕
    // ============================================================

    UIButton *generateButton =
        MakeButton(@"🎲 產生隨機數字",
                   [UIColor systemPurpleColor]);

    [generateButton addTarget:self
                       action:@selector(generateRandomNumber)
             forControlEvents:UIControlEventTouchUpInside];


    // ============================================================
    // 複製結果按鈕
    // ============================================================

    self.resultActionButton =
        MakeButton(@"📋 複製結果",
                   [UIColor systemBlueColor]);

    [self.resultActionButton addTarget:self
                                action:@selector(copyResult)
                      forControlEvents:UIControlEventTouchUpInside];

    // 一開始沒有結果
    self.resultActionButton.enabled = NO;
    self.resultActionButton.alpha = 0.45;


    // ============================================================
    // 加入畫面
    // ============================================================

    [self.view addSubview:title];

    [self.view addSubview:self.minField];

    [self.view addSubview:self.maxField];

    [self.view addSubview:self.resultLabel];

    [self.view addSubview:generateButton];

    [self.view addSubview:self.resultActionButton];


    // ============================================================
    // Auto Layout
    // ============================================================

    [NSLayoutConstraint activateConstraints:@[

        // --------------------------------------------------------
        // Title
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // Min Field
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // Max Field
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // Result
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // Generate Button
        // --------------------------------------------------------

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


        // --------------------------------------------------------
        // Result Action Button
        // --------------------------------------------------------

        [self.resultActionButton.topAnchor
         constraintEqualToAnchor:
         generateButton.bottomAnchor
         constant:15],

        [self.resultActionButton.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [self.resultActionButton.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [self.resultActionButton.heightAnchor
         constraintEqualToConstant:52]

    ]];
}


#pragma mark - Generate Random Number

- (void)generateRandomNumber {

    [self.view endEditing:YES];


    // ============================================================
    // 取得輸入
    // ============================================================

    NSString *minText =
        [self.minField.text
         stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *maxText =
        [self.maxField.text
         stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];


    // ============================================================
    // 檢查是否輸入
    // ============================================================

    if (minText.length == 0 ||
        maxText.length == 0) {

        self.resultLabel.text =
            @"請輸入完整範圍";

        [self clearResult];

        return;
    }


    // ============================================================
    // Scanner
    // ============================================================

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


    // ============================================================
    // 檢查整數
    // ============================================================

    if (!minValid ||
        !maxValid) {

        self.resultLabel.text =
            @"只能輸入整數";

        [self clearResult];

        return;
    }


    // ============================================================
    // 檢查大小
    // ============================================================

    if (maxValue < minValue) {

        self.resultLabel.text =
            @"最大值不能小於最小值";

        [self clearResult];

        return;
    }


    // ============================================================
    // 計算範圍
    // ============================================================

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


    // ============================================================
    // 產生隨機數字
    // ============================================================

    uint32_t randomValue =
        arc4random_uniform((uint32_t)range);

    NSInteger result =
        minValue +
        (NSInteger)randomValue;


    // ============================================================
    // 儲存結果
    // ============================================================

    self.currentResult =
        [NSString stringWithFormat:
         @"%ld",
         (long)result];


    // ============================================================
    // 顯示結果
    // ============================================================

    self.resultLabel.text =
        [NSString stringWithFormat:
         @"結果：%ld",
         (long)result];


    // ============================================================
    // 啟用按鈕
    // ============================================================

    self.resultActionButton.enabled = YES;

    self.resultActionButton.alpha = 1.0;

    [self.resultActionButton setTitle:@"📋 複製結果"
                              forState:UIControlStateNormal];


    // ============================================================
    // 動畫
    // ============================================================

    [self animateResult];
}


#pragma mark - Clear Result

- (void)clearResult {

    self.currentResult = nil;

    self.resultActionButton.enabled = NO;

    self.resultActionButton.alpha = 0.45;

    [self.resultActionButton setTitle:@"📋 複製結果"
                              forState:UIControlStateNormal];
}


#pragma mark - Copy Result

- (void)copyResult {

    if (self.currentResult.length == 0) {
        return;
    }


    // ============================================================
    // 複製到剪貼簿
    // ============================================================

    UIPasteboard *pasteboard =
        [UIPasteboard generalPasteboard];

    pasteboard.string =
        self.currentResult;


    // ============================================================
    // 按鈕縮放動畫
    // ============================================================

    [UIView animateWithDuration:0.1
                     animations:^{

        self.resultActionButton.transform =
            CGAffineTransformMakeScale(0.92, 0.92);

    }
                     completion:^(BOOL finished) {

        [UIView animateWithDuration:0.18
                         animations:^{

            self.resultActionButton.transform =
                CGAffineTransformIdentity;

        }];

    }];


    // ============================================================
    // 修改按鈕文字
    // ============================================================

    [self.resultActionButton setTitle:@"✓ 已複製"
                              forState:UIControlStateNormal];


    // ============================================================
    // 淡出再恢復
    // ============================================================

    [UIView animateWithDuration:0.15
                     animations:^{

        self.resultActionButton.alpha = 0.7;

    }
                     completion:^(BOOL finished) {

        [UIView animateWithDuration:0.2
                         animations:^{

            self.resultActionButton.alpha = 1.0;

        }];

    }];


    // ============================================================
    // 取消之前的恢復排程
    // ============================================================

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(resetCopyButton)
                                               object:nil];


    // ============================================================
    // 1 秒後恢復
    // ============================================================

    [self performSelector:@selector(resetCopyButton)
               withObject:nil
               afterDelay:1.0];
}


#pragma mark - Reset Button

- (void)resetCopyButton {

    if (self.currentResult.length == 0) {
        return;
    }


    [UIView transitionWithView:self.resultActionButton
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{

        [self.resultActionButton setTitle:@"📋 複製結果"
                                  forState:UIControlStateNormal];

    }
                    completion:nil];
}


#pragma mark - Result Animation

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
