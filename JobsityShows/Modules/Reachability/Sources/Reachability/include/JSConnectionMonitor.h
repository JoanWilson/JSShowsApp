//
//  JSConnectionMonitor.h
//  Reachability
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JSConnectionStatus) {
    JSConnectionStatusUnknown,
    JSConnectionStatusConnected,
    JSConnectionStatusDisconnected
} NS_SWIFT_NAME(ConnectionStatus);

NS_SWIFT_UI_ACTOR
NS_SWIFT_NAME(ConnectionMonitor)
@interface JSConnectionMonitor : NSObject

@property (class, nonatomic, readonly) JSConnectionMonitor *sharedMonitor NS_SWIFT_NAME(shared);
@property (nonatomic, readonly) JSConnectionStatus status;
@property (nonatomic, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, copy, nullable) void (^statusDidChange)(JSConnectionStatus status);

- (void)start;
- (void)stop;
- (void)updateStatus:(JSConnectionStatus)status NS_SWIFT_NAME(update(_:));

@end

NS_ASSUME_NONNULL_END
