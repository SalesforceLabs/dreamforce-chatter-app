/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
@isTest
public with sharing class ChatterUIGroupServiceTest {

    static testMethod void testApproveGroupMemberRequest() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser) {
            groupRequest = new CollaborationGroupMemberRequest();
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();

            ChatterUIGroupService.approveGroupMemberRequest(groupRequest.Id);

        Test.stopTest();

        CollaborationGroupMemberRequest updatedRequest = [SELECT Id, Status FROM CollaborationGroupMemberRequest WHERE Id = :groupRequest.Id ];
        System.assertEquals('Accepted', updatedRequest.Status, 'The status should be updated to accepted.');
    }

    static testMethod void testDenyGroupMemberRequest() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser) {
            groupRequest = new CollaborationGroupMemberRequest();
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();

            ChatterUIGroupService.denyGroupMemberRequest(groupRequest.Id);

        Test.stopTest();

        CollaborationGroupMemberRequest updatedRequest = [SELECT Id, Status FROM CollaborationGroupMemberRequest WHERE Id = :groupRequest.Id ];
        System.assertEquals('Declined', updatedRequest.Status, 'The status should be updated to accepted.');
    }

    static testMethod void testCreatePublicGroupSuccess() {
        String expectedName = 'Private Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        Test.startTest();

            CollaborationGroup returnedGroup = ChatterUIGroupService.createGroup(expectedName, expectedDescription, expectedOwner, false);

        Test.stopTest();

        System.assertNotEquals(null, returnedGroup.Id, 'The group should be inserted');
        System.assertEquals(expectedName, returnedGroup.Name);
        System.assertEquals(expectedDescription, returnedGroup.Description);
        System.assertEquals(expectedOwner, returnedGroup.OwnerId);
        System.assertEquals('Private', returnedGroup.CollaborationType, 'The group type should be set to public.');
    }

    static testMethod void testCreatePrivateGroupSuccess() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        Test.startTest();

            CollaborationGroup returnedGroup = ChatterUIGroupService.createGroup(expectedName, expectedDescription, expectedOwner, true);

        Test.stopTest();

        System.assertNotEquals(null, returnedGroup.Id, 'The group should be inserted');
        System.assertEquals(expectedName, returnedGroup.Name);
        System.assertEquals(expectedDescription, returnedGroup.Description);
        System.assertEquals(expectedOwner, returnedGroup.OwnerId);
        System.assertEquals('Public', returnedGroup.CollaborationType, 'The group type should be set to public.');
    }

    static testMethod void testCreatePublicGroupFailure() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();
        ChatterUIGroupService.createGroup(expectedName, expectedDescription, expectedOwner, true);

        Test.startTest();
            Boolean exceptionThrown = false;
            try {
                ChatterUIGroupService.createGroup(expectedName, expectedDescription, expectedOwner, true);
            }
            catch( DMLException de) {
            	exceptionThrown = true;
            }

        Test.stopTest();
        System.assert(exceptionThrown, 'An exception should be thrown when inserting a group with a already existing name.');
    }

    static testMethod void testCreateGroupMemberRequest() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();

            System.runAs(requestingUser) {
                ChatterUIGroupService.createGroupMemberRequest(newGroup.Id, requestingUser.Id);
            }

        Test.stopTest();

        CollaborationGroupMemberRequest createdRequest = [SELECT Id, CollaborationGroupId, RequesterId, Status
												             FROM CollaborationGroupMemberRequest
												              WHERE CollaborationGroupId = :newGroup.Id];

        System.assertEquals(requestingUser.Id, createdRequest.RequesterId, 'The requesting user should be set to the user making the request.');
        System.assertEquals(ChatterUIGroupService.REQUEST_STATUS_PENDING, createdRequest.Status, 'The status should be set to pending.');
    }

    static testMethod void testGetPendingGroupRequestsWithNoResults() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest();
        System.runAs(requestingUser) {
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }
        groupRequest.Status = ChatterUIGroupService.REQUEST_STATUS_ACCEPTED;
        update groupRequest;

        Test.startTest();

                List<ChatterUIGroupService.GroupRequest> pendingRequests = ChatterUIGroupService.getPendingGroupRequests(newGroup.Id);

        Test.stopTest();

        System.assert(pendingRequests.isEmpty(), 'No group requests should be returned when there are no requests with a pending status.');
    }

    static testMethod void testGetPendingGroupRequests() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;

        final Integer NUM_TEST_USERS = 3;
        List<User> requestingUsers = UserTestUtil.getTestStandardUsers(NUM_TEST_USERS);
        Map<String, String> expectedUserToRequest = new Map<String, String>();
        for(User user : requestingUsers) {
            System.runAs(user) {
	            CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest();
	            groupRequest.CollaborationGroupId = newGroup.Id;
	            groupRequest.RequesterId = user.Id;

	            insert groupRequest;
	            expectedUserToRequest.put(user.Id, groupRequest.Id);
            }
        }

        Test.startTest();

                List<ChatterUIGroupService.GroupRequest> pendingRequests = ChatterUIGroupService.getPendingGroupRequests(newGroup.Id);

        Test.stopTest();

        System.assertEquals(NUM_TEST_USERS, pendingRequests.size(), 'All pending requests should be returned');
        for(ChatterUIGroupService.GroupRequest request : pendingRequests) {
        	String originalRequestId =  expectedUserToRequest.get(request.requester.Id);
        	System.assertEquals(originalRequestId, request.requestId, 'The request should be matched to the appropriate requester.');
        }
    }

    static testMethod void testCreateGroupMemberRequestFailure() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();

            Boolean exceptionThrown = false;
            try {
	            ChatterUIGroupService.createGroupMemberRequest(newGroup.Id, requestingUser.Id);
            }
            catch(DMLException de) {
                exceptionThrown = true;
            }

        Test.stopTest();

        System.assert(exceptionThrown, 'An exception should be thrown when requesting access to a public group.');
    }

    static testMethod void testEditGroupSuccess() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = expectedOwner;
        newGroup.CollaborationType = 'Public';
        insert newGroup;

        Test.startTest();

            CollaborationGroup returnedGroup = ChatterUIGroupService.editGroup(newGroup.Id, expectedName, expectedDescription, false);

        Test.stopTest();

        CollaborationGroup updatedGroup = [SELECT Name, Description, CollaborationType FROM CollaborationGroup WHERE Id = :newGroup.Id];

        System.assertEquals(expectedName, updatedGroup.Name);
        System.assertEquals(expectedDescription, updatedGroup.Description);
        System.assertEquals('Private', updatedGroup.CollaborationType);
    }

    static testMethod void testEditGroupFailure() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = expectedOwner;
        newGroup.CollaborationType = 'Public';

        CollaborationGroup newGroup2 = new CollaborationGroup(Name='A chatter group2');
        newGroup2.OwnerId = expectedOwner;
        newGroup2.CollaborationType = 'Public';
        insert new List<CollaborationGroup> {newGroup, newGroup2};
        Test.startTest();
            Boolean exceptionThrown = false;
            try {
                ChatterUIGroupService.editGroup(newGroup.Id, newGroup2.Name, expectedDescription, true);
            }
            catch( DMLException de) {
            	exceptionThrown = true;
            }

        Test.stopTest();
        System.assert(exceptionThrown, 'An exception should be thrown when changing a group name to an already existing name.');
    }

    static testMethod void testGetExistingGroupMember() {
        Id currentUserId = UserInfo.getUserId();
        User groupUser = UserTestUtil.getTestStandardUser();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = currentUserId;
        newGroup.CollaborationType = 'Public';
        insert newGroup;

        CollaborationGroupMember expectedGroupMember = new CollaborationGroupMember();
        expectedGroupMember.CollaborationGroupId = newGroup.Id;
        expectedGroupMember.MemberId = groupUser.Id;
        insert expectedGroupMember;

        Test.startTest();
                CollaborationGroupMember returnedMember = ChatterUIGroupService.getGroupMember(newGroup.Id, groupUser.Id);
        Test.stopTest();

        System.assertEquals(expectedGroupMember.Id, returnedMember.Id,  'Get group should return the target group member.');
    }

    static testMethod void testGetGroupMemberNoMatch() {
        Id currentUserId = UserInfo.getUserId();
        User groupUser = UserTestUtil.getTestStandardUser();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = currentUserId;
        newGroup.CollaborationType = 'Public';
        insert newGroup;

        Test.startTest();
                CollaborationGroupMember returnedMember = ChatterUIGroupService.getGroupMember(newGroup.Id, groupUser.Id);
        Test.stopTest();

        System.assertEquals(null, returnedMember,  'Get group should null when no matching user exists');
    }

    static testMethod void testSearchGroupsByNameWithNoResults() {
        CollaborationGroup nonMatchingGroup1 = new CollaborationGroup(CollaborationType='Public',Name='Alpha Group');
        CollaborationGroup nonMatchingGroup2 = new CollaborationGroup(CollaborationType='Public',Name='Beta Group');
        insert new List<CollaborationGroup>{ nonMatchingGroup1, nonMatchingGroup2};

        final Integer EXPECTED_GROUP_COUNT = 1;

        Test.startTest();

           ChatterUIGroupService.GroupPage groupPageResult = ChatterUIGroupService.searchGroupsByName('noresults', null);

        Test.stopTest();

        System.assertEquals(0, groupPageResult.totalGroupCount, 'The number of matching groups should be stored in totalGroupCount');
        System.assert(groupPageResult.groups.isEmpty());
        System.assertEquals( null, groupPageResult.nextPage, 'nextPage should not be populated when there are no more pages.' );
        System.assert( !groupPageResult.hasMore);
    }

    static testMethod void testSearchGroupsByNameWithInvalidSearchString() {
        CollaborationGroup nonMatchingGroup1 = new CollaborationGroup(CollaborationType='Public',Name='Alpha Group');
        CollaborationGroup nonMatchingGroup2 = new CollaborationGroup(CollaborationType='Public',Name='Beta Group');
        insert new List<CollaborationGroup>{ nonMatchingGroup1, nonMatchingGroup2};

        Test.startTest();

           ChatterUIGroupService.GroupPage nullSearchTextResult = ChatterUIGroupService.searchGroupsByName(null, null);
           ChatterUIGroupService.GroupPage emptySearchTextResult = ChatterUIGroupService.searchGroupsByName('', null);
           ChatterUIGroupService.GroupPage singleCharTextResult = ChatterUIGroupService.searchGroupsByName('a', null);

        Test.stopTest();

        System.assert(nullSearchTextResult.groups.isEmpty(), 'null search strings should return an empty result.');
        System.assert(emptySearchTextResult.groups.isEmpty(), 'empty search strings should return an empty result.');
        System.assert(singleCharTextResult.groups.isEmpty(), 'search strings with less than 2 characters should return an empty result.');
    }

    static testMethod void testSearchGroupsByNameWithOnePage() {
    	CollaborationGroup matchingGroup = new CollaborationGroup(CollaborationType='Public',Name='Alpha Group');
    	CollaborationGroup nonMatchingGroup = new CollaborationGroup(CollaborationType='Public',Name='Beta Group');

    	insert new List<CollaborationGroup>{ nonMatchingGroup, matchingGroup};

    	final Integer EXPECTED_GROUP_COUNT = 1;

    	Test.startTest();

    	   ChatterUIGroupService.GroupPage groupPageResult = ChatterUIGroupService.searchGroupsByName('pha', null);

    	Test.stopTest();

    	System.assertEquals(EXPECTED_GROUP_COUNT, groupPageResult.totalGroupCount, 'The number of matching groups should be stored in totalGroupCount');
    	System.assertEquals(EXPECTED_GROUP_COUNT, groupPageResult.groups.size());
    	System.assertEquals( matchingGroup.Id, groupPageResult.groups[0].Id, 'Only matching groups should be returned');
    	System.assertEquals( null, groupPageResult.nextPage, 'nextPage should not be populated when there are no more pages.');
    	System.assert( !groupPageResult.hasMore);
    }

    static testMethod void testGetGroupsForUser() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        Test.startTest();

            CollaborationGroup returnedGroup = ChatterUIGroupService.createGroup(expectedName, expectedDescription, expectedOwner, true);

            ChatterUIGroupService.GroupPage groupPage = ChatterUIGroupService.getGroupsForUser(expectedOwner);

        Test.stopTest();

        System.assertNotEquals(null, groupPage);
        System.assertEquals(groupPage.groups.size(), groupPage.totalGroupCount);
        System.assert(groupPage.mappedGroups.size() > 0);
    }

    static testMethod void testRemoveUser() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        CollaborationGroupMember groupMember = new CollaborationGroupMember();
        System.runAs(requestingUser) {
            groupMember.CollaborationGroupId = newGroup.Id;
            groupMember.MemberId = requestingUser.Id;

            insert groupMember;
        }
        Test.startTest();

            ChatterUIGroupService.removeUserFromGroup(newGroup.Id, requestingUser.Id);

        Test.stopTest();

        List<CollaborationGroupMember> groupMembers = [SELECT Id FROM CollaborationGroupMember WHERE Id = :groupMember.Id];
        System.assert(groupMembers.isEmpty(), 'The group member should have been deleted');
    }
}