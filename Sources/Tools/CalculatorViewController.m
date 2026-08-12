#import "CalculatorViewController.h"
#import "../Helpers/UIHelpers.h"

@interface CalculatorViewController ()

@property (nonatomic, strong) UILabel *display;

@property (nonatomic, copy) NSString *currentInput;

@property (nonatomic, copy) NSString *pendingOperation;

@property (nonatomic, strong) NSDecimalNumber *firstNumber;

@property (nonatomic, assign) BOOL waitingForNewNumber;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"計算機";
    self.view.backgroundColor = AppBackgroundColor();

    self.currentInput = @"0";
    self.waitingForNewNumber = NO;

    self.display =
        MakeLabel(@"0",
                  42,
                  UIFontWeightBold);

    self.display.textAlignment =
        NSTextAlignmentRight;

    self.display.adjustsFontSizeToFitWidth = YES;

    self.display.minimumScaleFactor = 0.5;

    [self.view addSubview:self.display];

    NSArray *buttons = @[
        @"7", @"8", @"9", @"÷",
        @"4", @"5", @"6", @"×",
        @"1", @"2", @"3", @"−",
        @"0", @".", @"C", @"+",
        @"="
    ];

    UIStackView *grid =
        [[UIStackView alloc]
         initWithArrangedSubviews:@[]];

    grid.axis =
        UILayoutConstraintAxisVertical;

    grid.spacing = 10;

    grid.distribution =
        UIStackViewDistributionFillEqually;

    grid.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:grid];

    for (NSInteger index = 0;
         index < buttons.count;
         index += 4) {

        UIStackView *row =
            [[UIStackView alloc]
             initWithArrangedSubviews:@[]];

        row.axis =
            UILayoutConstraintAxisHorizontal;

        row.spacing = 10;

        row.distribution =
            UIStackViewDistributionFillEqually;

        for (NSInteger column = 0;
             column < 4;
             column++) {

            NSInteger buttonIndex =
                index + column;

            UIButton *button = nil;

            if (buttonIndex < buttons.count) {

                NSString *title =
                    buttons[buttonIndex];

                UIColor *color =
                    [self colorForButton:title];

                button =
                    MakeButton(title, color);

                [button addTarget:self
                           action:@selector(buttonPressed:)
                 forControlEvents:
                    UIControlEventTouchUpInside];

            } else {

                button =
                    MakeButton(@"", [UIColor clearColor]);

                button.enabled = NO;
            }

            [row addArrangedSubview:button];
        }

        [grid addArrangedSubview:row];

        [row.heightAnchor
         constraintEqualToConstant:64].active = YES;
    }

    [NSLayoutConstraint activateConstraints:@[

        [self.display.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:25],

        [self.display.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:24],

        [self.display.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-24],

        [self.display.heightAnchor
         constraintEqualToConstant:80],

        [grid.topAnchor
         constraintEqualToAnchor:
         self.display.bottomAnchor
         constant:20],

        [grid.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [grid.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20]
    ]];
}

#pragma mark - Button Color

- (UIColor *)colorForButton:(NSString *)title {

    if ([title isEqualToString:@"C"]) {
        return [UIColor systemRedColor];
    }

    if ([title isEqualToString:@"="]) {
        return [UIColor systemGreenColor];
    }

    if ([title isEqualToString:@"+"] ||
        [title isEqualToString:@"−"] ||
        [title isEqualToString:@"×"] ||
        [title isEqualToString:@"÷"]) {

        return [UIColor systemOrangeColor];
    }

    if ([title isEqualToString:@"."]) {
        return [UIColor systemGrayColor];
    }

    return [UIColor systemIndigoColor];
}

#pragma mark - Button Pressed

- (void)buttonPressed:(UIButton *)sender {

    NSString *value =
        sender.currentTitle;

    if (value.length == 0) {
        return;
    }

    if ([value isEqualToString:@"C"]) {

        [self clearCalculator];

        return;
    }

    if ([value isEqualToString:@"+"] ||
        [value isEqualToString:@"−"] ||
        [value isEqualToString:@"×"] ||
        [value isEqualToString:@"÷"]) {

        [self selectOperation:value];

        return;
    }

    if ([value isEqualToString:@"="]) {

        [self calculateResult];

        return;
    }

    [self enterNumber:value];
}

#pragma mark - Number

- (void)enterNumber:(NSString *)number {

    if (self.waitingForNewNumber) {

        self.currentInput = @"0";

        self.waitingForNewNumber = NO;
    }

    if ([number isEqualToString:@"."]) {

        if ([self.currentInput containsString:@"."]) {
            return;
        }

        if (self.currentInput.length == 0) {
            self.currentInput = @"0";
        }

        self.currentInput =
            [self.currentInput stringByAppendingString:@"."];
    }

    else {

        if ([self.currentInput isEqualToString:@"0"]) {

            self.currentInput = number;

        } else {

            self.currentInput =
                [self.currentInput stringByAppendingString:number];
        }
    }

    self.display.text =
        self.currentInput;
}

#pragma mark - Operation

- (void)selectOperation:(NSString *)operation {

    NSDecimalNumber *number =
        [NSDecimalNumber decimalNumberWithString:
            self.currentInput];

    if (self.pendingOperation != nil &&
        self.firstNumber != nil &&
        !self.waitingForNewNumber) {

        NSDecimalNumber *result =
            [self performCalculationWithFirstNumber:
                self.firstNumber
                                      secondNumber:number
                                          operation:
                                              self.pendingOperation];

        if (result == nil) {
            return;
        }

        self.firstNumber = result;

        self.currentInput =
            result.stringValue;

        self.display.text =
            self.currentInput;
    }

    else {

        self.firstNumber = number;
    }

    self.pendingOperation = operation;

    self.waitingForNewNumber = YES;
}

#pragma mark - Calculate

- (void)calculateResult {

    if (self.pendingOperation == nil ||
        self.firstNumber == nil) {

        return;
    }

    if (self.waitingForNewNumber) {
        return;
    }

    NSDecimalNumber *secondNumber =
        [NSDecimalNumber decimalNumberWithString:
            self.currentInput];

    NSDecimalNumber *result =
        [self performCalculationWithFirstNumber:
            self.firstNumber
                                  secondNumber:secondNumber
                                      operation:
                                          self.pendingOperation];

    if (result == nil) {
        return;
    }

    self.currentInput =
        result.stringValue;

    self.display.text =
        self.currentInput;

    self.firstNumber = nil;

    self.pendingOperation = nil;

    self.waitingForNewNumber = YES;
}

#pragma mark - Calculation Engine

- (NSDecimalNumber *)performCalculationWithFirstNumber:
    (NSDecimalNumber *)firstNumber
    secondNumber:(NSDecimalNumber *)secondNumber
    operation:(NSString *)operation {

    if ([operation isEqualToString:@"+"]) {

        return [firstNumber
                decimalNumberByAdding:secondNumber];
    }

    if ([operation isEqualToString:@"−"]) {

        return [firstNumber
                decimalNumberBySubtracting:secondNumber];
    }

    if ([operation isEqualToString:@"×"]) {

        return [firstNumber
                decimalNumberByMultiplyingBy:secondNumber];
    }

    if ([operation isEqualToString:@"÷"]) {

        if ([secondNumber
             isEqualToNumber:
                 [NSDecimalNumber zero]]) {

            [self showError:@"不能除以 0"];

            return nil;
        }

        return [firstNumber
                decimalNumberByDividingBy:secondNumber];
    }

    return nil;
}

#pragma mark - Clear

- (void)clearCalculator {

    self.currentInput = @"0";

    self.pendingOperation = nil;

    self.firstNumber = nil;

    self.waitingForNewNumber = NO;

    self.display.text = @"0";
}

#pragma mark - Error

- (void)showError:(NSString *)message {

    self.currentInput = @"0";

    self.pendingOperation = nil;

    self.firstNumber = nil;

    self.waitingForNewNumber = NO;

    self.display.text = message;
}

@end