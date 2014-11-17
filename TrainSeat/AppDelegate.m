//
//  AppDelegate.m
//  TrainSeat
//
//  Created by Jin Sasaki on 2014/10/27.
//  Copyright (c) 2014年 Jin Sasaki. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud dictionaryForKey:@"stationName"]) {
        return YES;
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSMutableDictionary *metroStationNameDict =  [NSMutableDictionary dictionaryWithDictionary:[self dictionaryFromJSONFileWithFilePath:[bundle pathForResource:@"metro_stationDict" ofType:@"json"]]];
    
    NSDictionary *otherStationNameDict =  [self dictionaryFromJSONFileWithFilePath:[bundle pathForResource:@"other_stationDict" ofType:@"json"]];
    
    [metroStationNameDict addEntriesFromDictionary:otherStationNameDict];

    [ud setObject:metroStationNameDict forKey:@"stationName"];    
    [ud synchronize];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:18.0f]];
    
    return YES;
    
}

- (NSDictionary *)dictionaryFromJSONFileWithFilePath:(NSString *)filePath {

    NSError *error0 = nil;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error0];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    if(error0){
        NSLog(@"load error");
        return nil;
    }
    
    //------------------------------
    // NSArray に変換
    //------------------------------
    NSError *error1 = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error1];
    
    if(error1){
        NSLog(@"parse error");
        return nil;
    }
    return dict;

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
