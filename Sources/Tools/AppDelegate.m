#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window =
        [[UIWindow alloc]
         initWithFrame:
         [UIScreen mainScreen].bounds];

    HomeViewController *home =
        [[HomeViewController alloc] init];

    UINavigationController *navigationController =
        [[UINavigationController alloc]
         initWithRootViewController:home];

    navigationController.navigationBar.prefersLargeTitles = YES;

    self.window.rootViewController =
        navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end