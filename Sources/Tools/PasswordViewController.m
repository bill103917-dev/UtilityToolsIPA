#import "PasswordViewController.h"
#import "../Helpers/UIHelpers.h"

@interface PasswordViewController ()

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UISlider *lengthSlider;
@property (nonatomic, strong) UILabel *lengthLabel;

@property (nonatomic, assign) BOOL includeNumbers;
@property (nonatomic, assign) BOOL includeSymbols;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"隨機字串";
    self.view.backgroundColor = AppBackgroundColor();

    self.includeNumbers = YES;
    self.includeSymbols = YES;

    UILabel *title =
        MakeLabel(@"🔐 隨機字串產生器",
                  28,
                  UIFontWeightBold);

    title.textAlignment = NSTextAlignmentCenter;

    self.resultLabel =
        MakeLabel(@"點擊按鈕產生",
                  20,
                  UIFontWeightSemibold);

    self.resultLabel.textAlignment =
        NSTextAlignmentCenter;

    self.resultLabel.numberOfLines = 0;

    self.resultLabel.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    self.resultLabel.layer.cornerRadius = 14;
    self.resultLabel.clipsToBounds = YES;

    self.lengthLabel =
        MakeLabel(@"長度：16",
                  17,
                  UIFontWeightMedium);

    self.lengthLabel.textAlignment =
        NSTextAlignmentCenter;

    self.lengthSlider =
        [[UISlider alloc] init];

    self.lengthSlider.minimumValue = 4;
    self.lengthSlider.maximumValue = 32;
    self.lengthSlider.value = 16;

    [self.lengthSlider addTarget:self
                          action:@selector(lengthChanged:)
                forControlEvents:UIControlEventValueChanged];

    UISwitch *numberSwitch =
        [[UISwitch alloc] init];

    numberSwitch.on = YES;

    [numberSwitch addTarget:self
                     action:@selector(numbersChanged:)
           forControlEvents:UIControlEventValueChanged];

    UILabel *numberLabel =
        MakeLabel(@"包含數字",
                  17,
                  UIFontWeightMedium);

    UIStackView *numberRow =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            numberLabel,
            numberSwitch
         ]];

    numberRow.axis =
        UILayoutConstraintAxisHorizontal;

    numberRow.distribution =
        UIStackViewDistributionEqualSpacing;

    numberRow.translatesAutoresizingMaskIntoConstraints = NO;

    UISwitch *symbolSwitch =
        [[UISwitch alloc] init];

    symbolSwitch.on = YES;

    [symbolSwitch addTarget:self
                     action:@selector(symbolsChanged:)
           forControlEvents:UIControlEventValueChanged];

    UILabel *symbolLabel =
        MakeLabel(@"包含特殊符號",
                  17,
                  UIFontWeightMedium);

    UIStackView *symbolRow =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            symbolLabel,
            symbolSwitch
         ]];

    symbolRow.axis =
        UILayoutConstraintAxisHorizontal;

    symbolRow.distribution =
        UIStackViewDistributionEqualSpacing;

    symbolRow.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *generateButton =
        MakeButton(@"🔐 產生隨機字串",
                   [UIColor systemIndigoColor]);

    [generateButton addTarget:self
                       action:@selector(generatePassword)
             forControlEvents:UIControlEventTouchUpInside];

    UIButton *copyButton =
        MakeButton(@"📋 複製結果",
                   [UIColor systemGreenColor]);

    [copyButton addTarget:self
                   action:@selector(copyPassword)
         forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:title];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.lengthLabel];
    [self.view addSubview:self.lengthSlider];
    [self.view addSubview:numberRow];
    [self.view addSubview:symbolRow];
    [self.view addSubview:generateButton];
    [self.view addSubview:copyButton];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:30],

        [title.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [title.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [self.resultLabel.topAnchor
         constraintEqualToAnchor:
         title.bottomAnchor
         constant:30],

        [self.resultLabel.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [self.resultLabel.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [self.resultLabel.heightAnchor
         constraintGreaterThanOrEqualToConstant:70],

        [self.lengthLabel.topAnchor
         constraintEqualToAnchor:
         self.resultLabel.bottomAnchor
         constant:25],

        [self.lengthLabel.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [self.lengthLabel.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [self.lengthSlider.topAnchor
         constraintEqualToAnchor:
         self.lengthLabel.bottomAnchor
         constant:8],

        [self.lengthSlider.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [self.lengthSlider.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [numberRow.topAnchor
         constraintEqualToAnchor:
         self.lengthSlider.bottomAnchor
         constant:20],

        [numberRow.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [numberRow.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [symbolRow.topAnchor
         constraintEqualToAnchor:
         numberRow.bottomAnchor
         constant:15],

        [symbolRow.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [symbolRow.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [generateButton.topAnchor
         constraintEqualToAnchor:
         symbolRow.bottomAnchor
         constant:25],

        [generateButton.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [generateButton.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [generateButton.heightAnchor
         constraintEqualToConstant:55],

        [copyButton.topAnchor
         constraintEqualToAnchor:
         generateButton.bottomAnchor
         constant:12],

        [copyButton.leadingAnchor
         constraintEqualToAnchor:
         generateButton.leadingAnchor],

        [copyButton.trailingAnchor
         constraintEqualToAnchor:
         generateButton.trailingAnchor],

        [copyButton.heightAnchor
         constraintEqualToConstant:55]
    ]];
}

#pragma mark - Length

- (void)lengthChanged:(UISlider *)slider {

    NSInteger length =
        (NSInteger)round(slider.value);

    self.lengthLabel.text =
        [NSString stringWithFormat:
            @"長度：%ld",
            (long)length];
}

#pragma mark - Options

- (void)numbersChanged:(UISwitch *)sender {

    self.includeNumbers = sender.isOn;
}

- (void)symbolsChanged:(UISwitch *)sender {

    self.includeSymbols = sender.isOn;
}

#pragma mark - Generate

- (void)generatePassword {

    NSString *letters =
        @"ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

    NSString *numbers =
        @"23456789";

    NSString *symbols =
        @"!@#$%^&*_-+=?";

    NSMutableString *characters =
        [NSMutableString stringWithString:letters];

    if (self.includeNumbers) {
        [characters appendString:numbers];
    }

    if (self.includeSymbols) {
        [characters appendString:symbols];
    }

    if (characters.length == 0) {
        self.resultLabel.text = @"請至少選擇一種字元";
        return;
    }

    NSInteger length =
        (NSInteger)round(self.lengthSlider.value);

    NSMutableString *result =
        [NSMutableString string];

    for (NSInteger i = 0; i < length; i++) {

        uint32_t index =
            arc4random_uniform(
                (uint32_t)characters.length);

        unichar character =
            [characters characterAtIndex:index];

        [result appendFormat:@"%C", character];
    }

    self.resultLabel.text = result;

    [self animateResult];
}

#pragma mark - Copy

- (void)copyPassword {

    NSString *password =
        self.resultLabel.text;

    if (password.length == 0 ||
        [password isEqualToString:@"點擊按鈕產生"]) {

        return;
    }

    [UIPasteboard generalPasteboard].string =
        password;

    [self showCopyToast];
}

#pragma mark - Animation

- (void)animateResult {

    self.resultLabel.alpha = 0.2;

    self.resultLabel.transform =
        CGAffineTransformMakeScale(0.85, 0.85);

    [UIView animateWithDuration:0.25
                     animations:^{

        self.resultLabel.alpha = 1.0;

        self.resultLabel.transform =
            CGAffineTransformIdentity;
    }];
}

#pragma mark - Toast

- (void)showCopyToast {

    UILabel *toast =
        MakeLabel(@"✓ 已複製",
                  17,
                  UIFontWeightBold);

    toast.textAlignment =
        NSTextAlignmentCenter;

    toast.textColor =
        [UIColor whiteColor];

    toast.backgroundColor =
        [UIColor systemGreenColor];

    toast.layer.cornerRadius = 20;
    toast.clipsToBounds = YES;

    toast.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:toast];

    [NSLayoutConstraint activateConstraints:@[
        [toast.centerXAnchor
         constraintEqualToAnchor:
         self.view.centerXAnchor],

        [toast.bottomAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.bottomAnchor
         constant:-20],

        [toast.widthAnchor
         constraintEqualToConstant:120],

        [toast.heightAnchor
         constraintEqualToConstant:42]
    ]];

    toast.alpha = 0;
    toast.transform =
        CGAffineTransformMakeScale(0.7, 0.7);

    [UIView animateWithDuration:0.2
                     animations:^{

        toast.alpha = 1;
        toast.transform =
            CGAffineTransformIdentity;

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.25
                              delay:1.0
                            options:0
                         animations:^{

            toast.alpha = 0;

        } completion:^(BOOL finished) {

            [toast removeFromSuperview];
        }];
    }];
}

@end