//
//  notifit-ios-sdkTests.m
//  notifit-ios-sdkTests
//
//  Created by Lukáš Hromadník on 03/26/2015.
//  Copyright (c) 2014 Lukáš Hromadník. All rights reserved.
//

SpecBegin(InitialSpecs)

describe(@"these will fail", ^{

    it(@"can do maths", ^{
        expect(1).to.equal(2);
    });

    it(@"can read", ^{
        expect(@"number").to.equal(@"string");
    });
    
    it(@"will wait for 10 seconds and fail", ^{
        waitUntil(^(DoneCallback done) {
        
        });
    });
});

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^AsyncBlock {
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd
