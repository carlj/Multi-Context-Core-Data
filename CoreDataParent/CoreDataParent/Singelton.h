//
//  Singelton.h
//  qontact
//
//  Created by Carl Jahn on 18.06.12.
//  Copyright (c) 2012 NIDAG. All rights reserved.
//

#ifndef qontact_Singelton_h
#define qontact_Singelton_h

//http://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/nsobject_Class/Reference/Reference.html#//apple_ref/occ/clm/NSObject/initialize

#define SingletonInterface(Class) \
+ (Class *)sharedInstance;


#define SingletonImplementation(Class) \
static Class *__ ## sharedSingleton; \
\
\
+ (void)initialize \
{ \
static BOOL initialized = NO; \
if(!initialized) \
{ \
initialized = YES; \
__ ## sharedSingleton = [[Class alloc] init]; \
} \
} \
\
\
+ (Class *)sharedInstance \
{ \
return __ ## sharedSingleton; \
} \
\
- (oneway void)release \
{ \
  return; \
} \
\
- (id)retain \
{ \
  return [Class sharedInstance]; \
} \
\
- (id)autorelease \
{ \
  return [Class sharedInstance]; \
} \


#endif
