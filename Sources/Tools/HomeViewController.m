#import "HomeViewController.h"

#import "../Helpers/UIHelpers.h"

#import "CalculatorViewController.h"
#import "RandomViewController.h"
#import "TimerViewController.h"
#import "TextViewController.h"
#import "PasswordViewController.h"
#import "DeviceViewController.h"
#import "AboutViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"工具箱";

    self.view.backgroundColor =
        AppBackgroundColor();

    [self setupInterface];
}

#pragma mark - Interface

- (void)setupInterface {

    self.scrollView =
        [[UIScrollView alloc] init];

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    self.scrollView.alwaysBounceVertical = YES;

    [self.view addSubview:self.scrollView];

    self.stackView =
        [[UIStackView alloc] init];

    self.stackView.axis =
        UILayoutConstraintAxisVertical;

    self.stackView.spacing = 14;

    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.scrollView addSubview:self.stackView];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor],

        [self.scrollView.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor],

        [self.scrollView.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor],

        [self.scrollView.bottomAnchor
         constraintEqualToAnchor:
         self.view.bottomAnchor],

        [self.stackView.topAnchor
         constraintEqualToAnchor:
         self.scrollView.contentLayoutGuide.topAnchor
         constant:20],

        [self.stackView.leadingAnchor
         constraintEqualToAnchor:
         self.scrollView.contentLayoutGuide.leadingAnchor
         constant:20],

        [self.stackView.trailingAnchor
         constraintEqualToAnchor:
         self.scrollView.contentLayoutGuide.trailingAnchor
         constant:-20],

        [self.stackView.bottomAnchor
         constraintEqualToAnchor:
         self.scrollView.contentLayoutGuide.bottomAnchor
         constant:-30],

        [self.stackView.widthAnchor
         constraintEqualToAnchor:
         self.scrollView.frameLayoutGuide.widthAnchor
         constant:-40]
    ]];

    [self addHeader];

    [self addCategoryTitle:@"🧮 基本工具"];

    [self addToolButton:@"計算機"
                   emoji:@"🧮"
                   color:[UIColor systemBlueColor]
                  action:@selector(openCalculator)];

    [self addToolButton:@"計時器"
                   emoji:@"⏱️"
                   color:[UIColor systemGreenColor]
                  action:@selector(openTimer)];

    [self addCategoryTitle:@"🎲 隨機工具"];

    [self addToolButton:@"隨機數字"
                   emoji:@"🎲"
                   color:[UIColor systemPurpleColor]
                  action:@selector(openRandom)];

    [self addToolButton:@"隨機字串"
                   emoji:@"🔐"
                   color:[UIColor systemIndigoColor]
                  action:@selector(openPassword)];

    [self addCategoryTitle:@"🔤 文字與裝置"];

    [self addToolButton:@"文字工具"
                   emoji:@"🔤"
                   color:[UIColor systemOrangeColor]
                  action:@selector(openText)];

    [self addToolButton:@"裝置資訊"
                   emoji:@"📱"
                   color:[UIColor systemTealColor]
                  action:@selector(openDevice)];

    [self addCategoryTitle:@"ℹ️ 其他"];

    [self addToolButton:@"關於 Utility Tools"
                   emoji:@"ℹ️"
                   color:[UIColor systemGrayColor]
                  action:@selector(openAbout)];
}

#pragma mark - Header

- (void)addHeader {

    UIView *header =
        [[UIView alloc] init];

    header.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    header.layer.cornerRadius = 22;

    header.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *icon =
        MakeLabel(@"🧰",
                  42,
                  UIFontWeightRegular);

    icon.textAlignment =
        NSTextAlignmentCenter;

    UILabel *title =
        MakeLabel(@"Utility Tools",
                  28,
                  UIFontWeightBold);

    UILabel *subtitle =
        MakeLabel(@"你的日常實用工具箱",
                  16,
                  UIFontWeightRegular);

    subtitle.textColor =
        [UIColor secondaryLabelColor];

    UIStackView *textStack =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            title,
            subtitle
         ]];

    textStack.axis =
        UILayoutConstraintAxisVertical;

    textStack.spacing = 3;

    textStack.translatesAutoresizingMaskIntoConstraints = NO;

    [header addSubview:icon];
    [header addSubview:textStack];

    [NSLayoutConstraint activateConstraints:@[
        [header.heightAnchor
         constraintEqualToConstant:100],

        [icon.leadingAnchor
         constraintEqualToAnchor:
         header.leadingAnchor
         constant:18],

        [icon.centerYAnchor
         constraintEqualToAnchor:
         header.centerYAnchor],

        [icon.widthAnchor
         constraintEqualToConstant:60],

        [textStack.leadingAnchor
         constraintEqualToAnchor:
         icon.trailingAnchor
         constant:12],

        [textStack.trailingAnchor
         constraintEqualToAnchor:
         header.trailingAnchor
         constant:-15],

        [textStack.centerYAnchor
         constraintEqualToAnchor:
         header.centerYAnchor]
    ]];

    [self.stackView addArrangedSubview:header];
}

#pragma mark - Category

- (void)addCategoryTitle:(NSString *)title {

    UILabel *label =
        MakeLabel(title,
                  19,
                  UIFontWeightBold);

    label.textColor =
        [UIColor secondaryLabelColor];

    label.translatesAutoresizingMaskIntoConstraints = NO;

    [self.stackView addArrangedSubview:label];

    [label.heightAnchor
     constraintEqualToConstant:30].active = YES;
}

#pragma mark - Tool Button

- (void)addToolButton:(NSString *)title
                emoji:(NSString *)emoji
                color:(UIColor *)color
               action:(SEL)action {

    UIButton *button =
        MakeButton(
            [NSString stringWithFormat:@"%@  %@",
                                       emoji,
                                       title],
            color);

    button.contentHorizontalAlignment =
        UIControlContentHorizontalAlignmentLeft;

    button.contentEdgeInsets =
        UIEdgeInsetsMake(0, 20, 0, 20);

    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];

    [self.stackView addArrangedSubview:button];

    [button.heightAnchor
     constraintEqualToConstant:60].active = YES;
}

#pragma mark - Open Tools

- (void)openCalculator {

    [self.navigationController
     pushViewController:
     [[CalculatorViewController alloc] init]
     animated:YES];
}

- (void)openRandom {

    [self.navigationController
     pushViewController:
     [[RandomViewController alloc] init]
     animated:YES];
}

- (void)openTimer {

    [self.navigationController
     pushViewController:
     [[TimerViewController alloc] init]
     animated:YES];
}

- (void)openText {

    [self.navigationController
     pushViewController:
     [[TextViewController alloc] init]
     animated:YES];
}

- (void)openPassword {

    [self.navigationController
     pushViewController:
     [[PasswordViewController alloc] init]
     animated:YES];
}

- (void)openDevice {

    [self.navigationController
     pushViewController:
     [[DeviceViewController alloc] init]
     animated:YES];
}

- (void)openAbout {

    [self.navigationController
     pushViewController:
     [[AboutViewController alloc] init]
     animated:YES];
}

@end