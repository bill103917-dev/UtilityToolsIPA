#import "HomeViewController.h"
#import "Helpers/UIHelpers.h"

#import "Tools/CalculatorViewController.h"
#import "Tools/RandomViewController.h"
#import "Tools/TimerViewController.h"
#import "Tools/TextViewController.h"
#import "Tools/PasswordViewController.h"
#import "Tools/DeviceViewController.h"
#import "Tools/AboutViewController.h"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"工具箱";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *header =
        MakeLabel(@"🧰 Utility Tools",
                  32,
                  UIFontWeightBold);

    UILabel *subtitle =
        MakeLabel(@"你的日常實用工具箱",
                  17,
                  UIFontWeightRegular);

    UIStackView *stack =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
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
        [header.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:25],

        [header.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [header.trailingAnchor
         constraintLessThanOrEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [subtitle.topAnchor
         constraintEqualToAnchor:
         header.bottomAnchor
         constant:5],

        [subtitle.leadingAnchor
         constraintEqualToAnchor:
         header.leadingAnchor],

        [subtitle.trailingAnchor
         constraintLessThanOrEqualToAnchor:
         self.view.trailingAnchor
         constant:-25],

        [stack.topAnchor
         constraintEqualToAnchor:
         subtitle.bottomAnchor
         constant:25],

        [stack.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:25],

        [stack.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-25]
    ]];
}

- (UIButton *)button:(NSString *)title
               color:(UIColor *)color
              action:(SEL)action {

    UIButton *button =
        MakeButton(title, color);

    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];

    [button.heightAnchor
     constraintEqualToConstant:55].active = YES;

    return button;
}

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