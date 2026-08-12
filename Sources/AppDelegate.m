#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]
                   initWithFrame:[UIScreen mainScreen].bounds];

    HomeViewController *home =
        [[HomeViewController alloc] init];

    UINavigationController *navigation =
        [[UINavigationController alloc]
         initWithRootViewController:home];

    self.window.rootViewController = navigation;

    [self.window makeKeyAndVisible];

    return YES;
}

@end