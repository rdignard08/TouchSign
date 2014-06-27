/* Copyright (c) 6/10/14, Ryan Dignard
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

#import <Foundation/Foundation.h>

#ifdef _COREDATADEFINES_H
    #import <CoreData/CoreData.h>
#endif

@protocol RestGoateeSerialization <NSObject>

@optional
/**
 @abstract Provide any overrides for default mapping behavior here.  The returned dictionary should have keys and values of type NSString and should be read left-to-right JSON source to target key.  Any unspecified key(s) will use the default behavior for mapping.
 
  Instance mappings will override class mappings if both are implemented.
 */
+ (NSDictionary*) overrideKeysForMapping;

/**
 @abstract Provide any overrides for default mapping behavior here.  The returned dictionary should have keys and values of type NSString and should be read left-to-right JSON source to target key.  Any unspecified key(s) will use the default behavior for mapping.  You are highly encouraged to implement this with a `dispatch_once()` block.
 
 Instance mappings will override class mappings if both are implemented.
 */
- (NSDictionary*) overrideKeysForMapping;

/**
 @abstract Provide a custom date format for use with the given property `key`.  See documentation for NSDate for proper formats.
 
 Instance mappings will override class mappings if both are implemented.
 */
+ (NSString*) dateFormatForKey:(NSString*)key;

/**
 @abstract Provide a custom date format for use with the given property `key`.  See documentation for NSDate for proper formats.
 
 Instance mappings will override class mappings if both are implemented.
 */
- (NSString*) dateFormatForKey:(NSString*)key;

@end

@interface NSObject (RG_Deserialization)

/**
 @abstract returns the property or instance variable of the name given by `key`.
 */
- (id) objectForKeyedSubscript:(id<NSCopying, NSObject>)key;

/**
 @abstract set the value of the particular property or instance variable specified by `key`.
 */
- (void) setObject:(id)obj forKeyedSubscript:(id<NSCopying, NSObject>)key;


/**
 @abstract subclasses of `NSManagedObject` must use this method since they cannot be initialized without a context.
 */
#ifdef _COREDATADEFINES_H
+ (instancetype) objectFromJSON:(NSDictionary*)json inContext:(NSManagedObjectContext*)context;
#else
+ (instancetype) objectFromJSON:(NSDictionary*)json inContext:(id)context;
#endif

/**
 @abstract the receiver (the Class object) which receives this method will attempt to initialize an instance of this class with properties assigned from json.
 */
+ (instancetype) objectFromJSON:(NSDictionary*)json;

/**
 @abstract returns the receiver represented as a dictionary with its property names as keys and the values are the values of that property.
 */
- (NSDictionary*) dictionaryRepresentation;

/**
 @abstract returns the recevier serialized to JSON.
 */
- (NSData*) JsonRepresentation;

/**
 @abstract merges two objects into a single object.  The return value is not a new object, but rather is the receiver augmented with the values in `object`.  
 @return the receiving object extended with `object`; any conflicts will take `object`'s value as precedent.
 */
- (id) extendWith:(id)object;

@end
