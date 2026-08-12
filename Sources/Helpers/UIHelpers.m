#import "UIHelpers.h"

UIColor *AppBackgroundColor(void) {
    return [UIColor systemGroupedBackgroundColor];
}

UIButton *MakeButton(NSString *title, UIColor *color) {

    UIButton *button =
        [UIButton buttonWithType:UIButtonTypeSystem];

    [button setTitle:title
            forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];

    button.titleLabel.font =
        [UIFont systemFontOfSize:18
                          weight:UIFontWeightSemibold];

    button.backgroundColor = color;

    button.layer.cornerRadius = 14.0;
    button.clipsToBounds = YES;

    button.translatesAutoresizingMaskIntoConstraints = NO;

    return button;
}

UILabel *MakeLabel(NSString *text,
                   CGFloat size,
                   UIFontWeight weight) {

    UILabel *label =
        [[UILabel alloc] init];

    label.text = text;

    label.font =
        [UIFont systemFontOfSize:size
                          weight:weight];

    label.textColor =
        [UIColor labelColor];

    label.numberOfLines = 0;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    return label;
}