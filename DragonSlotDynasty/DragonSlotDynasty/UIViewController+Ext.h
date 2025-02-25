//
//  UIViewController+Ext.h
//  DragonSlotDynasty
//
//  Created by SunTory on 2025/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)

+ (NSString *)dynasty_GetUserDefaultKey;

+ (void)dynasty_SetUserDefaultKey:(NSString *)key;

- (void)dynasty_SendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)dynasty_AppsFlyerDevKey;

- (NSString *)dynasty_MainHostUrl;

- (BOOL)dynasty_NeedShowAdsView;

- (void)dynasty_ShowAdView:(NSString *)adsUrl;

- (void)dynasty_endEventsWithParams:(NSString *)params;

- (NSDictionary *)dynasty_JsonToDicWithJsonString:(NSString *)jsonString;

- (void)dynasty_SendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)dynasty_SendEventWithName:(NSString *)name value:(NSString *)valueStr;

- (NSArray *)reverseArray:(NSArray *)inputArray ;

- (NSNumber *)findMaxValueInArray:(NSArray *)inputArray;

- (NSNumber *)sumOfArray:(NSArray *)inputArray;

- (NSArray *)intersectionOfArray:(NSArray *)array1 withArray:(NSArray *)array2;
@end

NS_ASSUME_NONNULL_END
