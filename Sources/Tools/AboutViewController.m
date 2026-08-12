#import "AboutViewController.h"
#import "../Helpers/UIHelpers.h"

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"關於";
    self.view.backgroundColor = AppBackgroundColor();

    UILabel *icon =
        MakeLabel(@"🧰",
                  64,
                  UIFontWeightRegular);

    icon.textAlignment =
        NSTextAlignmentCenter;

    UILabel *title =
        MakeLabel(@"Utility Tools",
                  30,
                  UIFontWeightBold);

    title.textAlignment =
        NSTextAlignmentCenter;

    UILabel *subtitle =
        MakeLabel(
            @"你的日常實用工具箱",
            18,
            UIFontWeightMedium);

    subtitle.textAlignment =
        NSTextAlignmentCenter;

    UILabel *version =
        MakeLabel(
            @"版本 2.0",
            16,
            UIFontWeightRegular);

    version.textAlignment =
        NSTextAlignmentCenter;

    UILabel *description =
        MakeLabel(
            @"集合計算、隨機工具、計時器、文字工具、隨機字串與裝置資訊等實用功能。\n\n"
             "簡單、快速、好用。",
            17,
            UIFontWeightRegular);

    description.textAlignment =
        NSTextAlignmentCenter;

    description.textColor =
        [UIColor secondaryLabelColor];

    description.numberOfLines = 0;

    UIStackView *stack =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[
            icon,
            title,
            subtitle,
            version,
            description
         ]];

    stack.axis =
        UILayoutConstraintAxisVertical;

    stack.spacing = 14;

    stack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.centerXAnchor
         constraintEqualToAnchor:
         self.view.centerXAnchor],

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
}

@end