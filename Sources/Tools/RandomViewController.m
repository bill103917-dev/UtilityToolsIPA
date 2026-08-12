#import "RandomViewController.h"
#import "../Helpers/UIHelpers.h"

@interface RandomViewController ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UITextField *minField;
@property (nonatomic, strong) UITextField *maxField;

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

    [self.view addSubview:title];
    [self.view addSubview:self.minField];
    [self.view addSubview:self.maxField];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:generateButton];

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
         constraintEqualToConstant:60]
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

        return;
    }

    if (maxValue < minValue) {

        self.resultLabel.text =
            @"最大值不能小於最小值";

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

        return;
    }

    uint32_t randomValue =
        arc4random_uniform((uint32_t)range);

    NSInteger result =
        minValue + (NSInteger)randomValue;

    self.resultLabel.text =
        [NSString stringWithFormat:
            @"結果：%ld",
            (long)result];

    [self animateResult];
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