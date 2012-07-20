//
//  AppDelegate.m
//  CoreDataParent
//
//  Created by Carl Jahn on 19.07.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#import "AppDelegate.h"
#import "ModelFactory.h"
#import "Entity.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
  [_window release];
  [_viewController release];
  [super dealloc];
}

-(NSString *)getRandomName
{
  NSArray *nameList = [NSArray arrayWithObjects:@"Norm", @"Jim", @"Jason", @"Zach", @"Matt", @"Glenn", @"Will", @"Wade", @"Trevor", @"Jeremy", @"Ryan", @"Matty", @"Steve", @"Pavel", nil];
  int     name1     = arc4random() % [nameList count];
  
  return [nameList objectAtIndex:name1];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  SEL selector = @selector(timerCalledYou:); //a selector is required to introduce the method to our Invocation
  
  NSMethodSignature *signature = [self methodSignatureForSelector:selector]; //a method signature is required, this signature is usually created by the methodSignatureForSelector: for the class containing our method, in this case sayHelloWorld is declared in the current class, so self is the class containing it
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature]; //here we create our instance of NSInvocation
  
  [invocation setSelector: selector];//we should set the selector of our sayHelloWorld method
  [invocation setTarget: self];  
  [NSTimer scheduledTimerWithTimeInterval:1.0f invocation:invocation repeats:YES];
  
  ModelFactory *factory = [ModelFactory sharedInstance];
  
    NSManagedObjectContext *newPrivate = [factory newPrivateManagedObjectContext];
  //NSManagedObjectContext *write = [factory writeManagedObjectContext];
  //NSManagedObjectContext *main = [factory mainManagedObjectContext];

    [newPrivate performBlock:^{
      NSUInteger count = 0;
      for (int i = 0; i <= 10000; i++) {
        [Entity entityWithName: [self getRandomName] inContext:newPrivate];

        
        if (count >= 100) {
          [factory saveContext: newPrivate];
          count = 0;
        }
        count += 1;

      }
      [newPrivate performBlock:^{
        [newPrivate save:nil];
      
        [factory writeToDisk];
        
      }];
    }];


  
  return YES;
}

- (void)timerCalledYou:(id)sender {
  NSLog(@"timer");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{  
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
