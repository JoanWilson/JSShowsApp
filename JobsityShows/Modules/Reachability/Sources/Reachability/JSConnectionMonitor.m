//
//  JSConnectionMonitor.m
//  Reachability
//
//  Created by Joan Wilson Oliveira on 28/10/26.
//

#import "JSConnectionMonitor.h"
#import <Network/Network.h>

@interface JSConnectionMonitor ()

@property (nonatomic, readwrite) JSConnectionStatus status;
@property (nonatomic, strong, nullable) nw_path_monitor_t monitor;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation JSConnectionMonitor

+ (JSConnectionMonitor *)sharedMonitor {
    static JSConnectionMonitor *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[JSConnectionMonitor alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _status = JSConnectionStatusUnknown;
        _queue = dispatch_queue_create("com.joanwilson.jobsityshows.reachability", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (BOOL)isConnected {
    return self.status == JSConnectionStatusConnected;
}

- (void)start {
    if (self.monitor) {
        return;
    }

    nw_path_monitor_t monitor = nw_path_monitor_create();
    nw_path_monitor_set_queue(monitor, self.queue);

    __weak typeof(self) weakSelf = self;
    nw_path_monitor_set_update_handler(monitor, ^(nw_path_t path) {
        JSConnectionStatus status = nw_path_get_status(path) == nw_path_status_satisfied
            ? JSConnectionStatusConnected
            : JSConnectionStatusDisconnected;

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateStatus:status];
        });
    });

    nw_path_monitor_start(monitor);
    self.monitor = monitor;
}

- (void)stop {
    if (!self.monitor) {
        return;
    }
    nw_path_monitor_cancel(self.monitor);
    self.monitor = nil;
}

- (void)updateStatus:(JSConnectionStatus)status {
    if (status == self.status) {
        return;
    }
    self.status = status;

    if (self.statusDidChange) {
        self.statusDidChange(status);
    }
}

@end
