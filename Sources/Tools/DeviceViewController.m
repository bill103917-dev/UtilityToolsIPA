#import "DeviceViewController.h"
#import "../Helpers/UIHelpers.h"

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"裝置資訊";
    self.view.backgroundColor = AppBackgroundColor();

    UIDevice *device =
        [UIDevice currentDevice];

    NSString *deviceName =
        device.name.length > 0
        ? device.name
        : @"未知";

    NSString *model =
        device.model.length > 0
        ? device.model
        : @"未知";

    NSString *systemName =
        device.systemName.length > 0
        ? device.systemName
        : @"未知";

    NSString *systemVersion =
        device.systemVersion.length > 0
        ? device.systemVersion
        : @"未知";

    NSString *identifier =
        device.identifierForVendor.UUIDString;

    if (identifier.length == 0) {
        identifier = @"不可用";
    }

    NSString *info =
        [NSString stringWithFormat:
            @"📱 裝置資訊\n\n"
             "裝置名稱\n%@\n\n"
             "裝置型號\n%@\n\n"
             "系統\n%@\n\n"
             "系統版本\n%@\n\n"
             "App 版本\n2.0\n\n"
             "Identifier\n%@",
            deviceName,
            model,
            systemName,
            systemVersion,
            identifier];

    UITextView *textView =
        [[UITextView alloc] init];

    textView.text = info;

    textView.font =
        [UIFont systemFontOfSize:18
                           weight:UIFontWeightMedium];

    textView.textColor =
        [UIColor labelColor];

    textView.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    textView.layer.cornerRadius = 18;

    textView.editable = NO;
    textView.selectable = YES;

    textView.textContainerInset =
        UIEdgeInsetsMake(20, 20, 20, 20);

    textView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:textView];

    [NSLayoutConstraint activateConstraints:@[
        [textView.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:20],

        [textView.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [textView.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [textView.bottomAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.bottomAnchor
         constant:-20]
    ]];
}

@end