#import "TextViewController.h"
#import "../Helpers/UIHelpers.h"

@interface TextViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"文字工具";
    self.view.backgroundColor = AppBackgroundColor();

    self.textView =
        [[UITextView alloc] init];

    self.textView.font =
        [UIFont systemFontOfSize:18];

    self.textView.textColor =
        [UIColor labelColor];

    self.textView.backgroundColor =
        [UIColor secondarySystemBackgroundColor];

    self.textView.layer.cornerRadius = 14;

    self.textView.delegate = self;

    self.textView.textContainerInset =
        UIEdgeInsetsMake(15, 15, 15, 15);

    self.textView.translatesAutoresizingMaskIntoConstraints = NO;

    self.countLabel =
        MakeLabel(@"字數：0",
                  17,
                  UIFontWeightMedium);

    UIButton *clearButton =
        MakeButton(@"🗑️ 清除",
                   [UIColor systemRedColor]);

    UIButton *copyButton =
        MakeButton(@"📋 複製",
                   [UIColor systemBlueColor]);

    [clearButton addTarget:self
                    action:@selector(clearText)
          forControlEvents:UIControlEventTouchUpInside];

    [copyButton addTarget:self
                   action:@selector(copyText)
         forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:clearButton];
    [self.view addSubview:copyButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.textView.topAnchor
         constraintEqualToAnchor:
         self.view.safeAreaLayoutGuide.topAnchor
         constant:20],

        [self.textView.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [self.textView.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [self.textView.heightAnchor
         constraintEqualToConstant:300],

        [self.countLabel.topAnchor
         constraintEqualToAnchor:
         self.textView.bottomAnchor
         constant:12],

        [self.countLabel.leadingAnchor
         constraintEqualToAnchor:
         self.textView.leadingAnchor],

        [clearButton.topAnchor
         constraintEqualToAnchor:
         self.countLabel.bottomAnchor
         constant:20],

        [clearButton.leadingAnchor
         constraintEqualToAnchor:
         self.view.leadingAnchor
         constant:20],

        [clearButton.widthAnchor
         constraintEqualToConstant:150],

        [clearButton.heightAnchor
         constraintEqualToConstant:55],

        [copyButton.topAnchor
         constraintEqualToAnchor:
         self.countLabel.bottomAnchor
         constant:20],

        [copyButton.trailingAnchor
         constraintEqualToAnchor:
         self.view.trailingAnchor
         constant:-20],

        [copyButton.widthAnchor
         constraintEqualToConstant:150],

        [copyButton.heightAnchor
         constraintEqualToConstant:55]
    ]];
}

#pragma mark - Text Change

- (void)textViewDidChange:(UITextView *)textView {

    /*
     iOS 注音 / 中文輸入法在選字前會處於
     「組字中」狀態。

     此時 textView 可能包含 marked text，
     如果直接使用 text.length，
     字數就會暫時被組字內容影響。

     所以組字中的期間先不要更新字數。
     等使用者選字完成後，iOS 會再次觸發
     textViewDidChange，再重新計算。
     */

    if (textView.markedTextRange != nil) {
        return;
    }

    [self updateCharacterCount];
}

#pragma mark - Character Count

- (void)updateCharacterCount {

    NSString *text = self.textView.text ?: @"";

    __block NSUInteger count = 0;

    /*
     使用「Unicode 組合字元」計算。

     比起 NSString.length，
     這種方式對 Emoji、特殊 Unicode 字元
     會比較準確。
     */

    [text enumerateSubstringsInRange:
              NSMakeRange(0, text.length)
             options:NSStringEnumerationByComposedCharacterSequences
          usingBlock:^(NSString *substring,
                       NSRange substringRange,
                       NSRange enclosingRange,
                       BOOL *stop) {

        count++;
    }];

    self.countLabel.text =
        [NSString stringWithFormat:
            @"字數：%lu",
            (unsigned long)count];
}

#pragma mark - Clear

- (void)clearText {

    self.textView.text = @"";

    [self updateCharacterCount];

    [self.textView becomeFirstResponder];
}

#pragma mark - Copy

- (void)copyText {

    NSString *text =
        self.textView.text;

    if (text.length == 0) {

        [self showMessage:@"沒有可以複製的文字"];

        return;
    }

    [UIPasteboard generalPasteboard].string = text;

    [self showCopyAnimation];
}

#pragma mark - Message

- (void)showMessage:(NSString *)message {

    UIAlertController *alert =
        [UIAlertController
         alertControllerWithTitle:@"提示"
         message:message
         preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:
        [UIAlertAction
         actionWithTitle:@"好的"
         style:UIAlertActionStyleDefault
         handler:nil]];

    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Copy Animation

- (void)showCopyAnimation {

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
         constant:-25],

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

            toast.transform =
                CGAffineTransformMakeScale(0.7, 0.7);

        } completion:^(BOOL finished) {

            [toast removeFromSuperview];
        }];
    }];
}

@end
