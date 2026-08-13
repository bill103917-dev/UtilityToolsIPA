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

    // =========================================================
    // Scroll View
    // =========================================================

    UIScrollView *scrollView =
        [[UIScrollView alloc] init];

    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:scrollView];

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor],

        [scrollView.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor],

        [scrollView.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor],

        [scrollView.bottomAnchor
         constraintEqualToAnchor:
         self.view.bottomAnchor]
    ]];

    // =========================================================
    // Content View
    // =========================================================

    UIView *contentView =
        [[UIView alloc] init];

    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    [scrollView addSubview:contentView];

    [NSLayoutConstraint activateConstraints:@[
        [contentView.topAnchor
         constraintEqualToAnchor:
         scrollView.contentLayoutGuide.topAnchor],

        [contentView.leadingAnchor
         constraintEqualToAnchor:
         scrollView.contentLayoutGuide.leadingAnchor],

        [contentView.trailingAnchor
         constraintEqualToAnchor:
         scrollView.contentLayoutGuide.trailingAnchor],

        [contentView.bottomAnchor
         constraintEqualToAnchor:
         scrollView.contentLayoutGuide.bottomAnchor],

        // 讓內容寬度跟螢幕一樣
        [contentView.widthAnchor
         constraintEqualToAnchor:
         scrollView.frameLayoutGuide.widthAnchor]
    ]];

    // =========================================================
    // 主 Stack
    // =========================================================

    UIStackView *stack =
        [[UIStackView alloc] init];

    stack.axis =
        UILayoutConstraintAxisVertical;

    stack.alignment =
        UIStackViewAlignmentFill;

    stack.distribution =
        UIStackViewDistributionFill;

    stack.spacing = 18;

    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [contentView addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor
         constraintEqualToAnchor:
         contentView.topAnchor
         constant:25],

        [stack.leadingAnchor
         constraintEqualToAnchor:
         contentView.leadingAnchor
         constant:20],

        [stack.trailingAnchor
         constraintEqualToAnchor:
         contentView.trailingAnchor
         constant:-20],

        [stack.bottomAnchor
         constraintEqualToAnchor:
         contentView.bottomAnchor
         constant:-25]
    ]];

    // =========================================================
    // 標題
    // =========================================================

    UILabel *title =
        MakeLabel(@"🔐 隨機字串產生器",
                  28,
                  UIFontWeightBold);

    title.textAlignment =
        NSTextAlignmentCenter;

    [stack addArrangedSubview:title];

    // =========================================================
    // 結果區
    // =========================================================

    UIView *resultContainer =
        [[UIView alloc] init];

    resultContainer.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    resultContainer.layer.cornerRadius = 16;
    resultContainer.clipsToBounds = YES;

    resultContainer.translatesAutoresizingMaskIntoConstraints = NO;

    self.resultLabel =
        MakeLabel(@"點擊按鈕產生",
                  18,
                  UIFontWeightSemibold);

    self.resultLabel.textAlignment =
        NSTextAlignmentCenter;

    self.resultLabel.numberOfLines = 0;

    self.resultLabel.lineBreakMode =
        NSLineBreakByCharWrapping;

    self.resultLabel.adjustsFontSizeToFitWidth = NO;

    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [resultContainer addSubview:self.resultLabel];

    [NSLayoutConstraint activateConstraints:@[
        [resultContainer.heightAnchor
         constraintEqualToConstant:105],

        [self.resultLabel.leadingAnchor
         constraintEqualToAnchor:
         resultContainer.leadingAnchor
         constant:15],

        [self.resultLabel.trailingAnchor
         constraintEqualToAnchor:
         resultContainer.trailingAnchor
         constant:-15],

        [self.resultLabel.topAnchor
         constraintEqualToAnchor:
         resultContainer.topAnchor
         constant:10],

        [self.resultLabel.bottomAnchor
         constraintEqualToAnchor:
         resultContainer.bottomAnchor
         constant:-10]
    ]];

    [stack addArrangedSubview:resultContainer];

    // =========================================================
    // 長度
    // =========================================================

    self.lengthLabel =
        MakeLabel(@"長度：16",
                  17,
                  UIFontWeightMedium);

    self.lengthLabel.textAlignment =
        NSTextAlignmentCenter;

    [stack addArrangedSubview:self.lengthLabel];

    // =========================================================
    // Slider
    // =========================================================

    self.lengthSlider =
        [[UISlider alloc] init];

    self.lengthSlider.minimumValue = 4;
    self.lengthSlider.maximumValue = 32;
    self.lengthSlider.value = 16;

    [self.lengthSlider addTarget:self
                          action:@selector(lengthChanged:)
                forControlEvents:UIControlEventValueChanged];

    [stack addArrangedSubview:self.lengthSlider];

    // =========================================================
    // 數字開關
    // =========================================================

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

    numberRow.alignment =
        UIStackViewAlignmentCenter;

    numberRow.distribution =
        UIStackViewDistributionEqualSpacing;

    [stack addArrangedSubview:numberRow];

    // =========================================================
    // 特殊符號開關
    // =========================================================

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

    symbolRow.alignment =
        UIStackViewAlignmentCenter;

    symbolRow.distribution =
        UIStackViewDistributionEqualSpacing;

    [stack addArrangedSubview:symbolRow];

    // =========================================================
    // 產生按鈕
    // =========================================================

    UIButton *generateButton =
        MakeButton(@"🔐 產生隨機字串",
                   [UIColor systemIndigoColor]);

    [generateButton addTarget:self
                       action:@selector(generatePassword)
             forControlEvents:UIControlEventTouchUpInside];

    [generateButton.heightAnchor
        constraintEqualToConstant:55].active = YES;

    [stack addArrangedSubview:generateButton];

    // =========================================================
    // 複製按鈕
    // =========================================================

    UIButton *copyButton =
        MakeButton(@"📋 複製結果",
                   [UIColor systemGreenColor]);

    [copyButton addTarget:self
                   action:@selector(copyPassword)
         forControlEvents:UIControlEventTouchUpInside];

    [copyButton.heightAnchor
        constraintEqualToConstant:55].active = YES;

    [stack addArrangedSubview:copyButton];
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

    self.includeNumbers =
        sender.isOn;
}

- (void)symbolsChanged:(UISwitch *)sender {

    self.includeSymbols =
        sender.isOn;
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

        self.resultLabel.text =
            @"請至少選擇一種字元";

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

    self.resultLabel.text =
        result;

    [self animateResult];
}

#pragma mark - Copy

- (void)copyPassword {

    NSString *password =
        self.resultLabel.text;

    if (password.length == 0 ||
        [password isEqualToString:@"點擊按鈕產生"] ||
        [password isEqualToString:@"請至少選擇一種字元"]) {

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

        toast.alpha = 1.0;

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
