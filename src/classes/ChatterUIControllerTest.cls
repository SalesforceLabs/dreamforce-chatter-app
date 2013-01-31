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
public with sharing class ChatterUIControllerTest {

    static testMethod void testSearchGroupsByName() {
        CollaborationGroup matchingGroup = new CollaborationGroup(CollaborationType='Public',Name='Alpha Group');
        insert matchingGroup;

        Test.startTest();

           ChatterUIGroupService.GroupPage groupPage = ChatterUIController.searchGroupsByName('Alpha');

        Test.stopTest();

        System.assertEquals(1, groupPage.totalGroupCount, 'The matching groups should be returned in the JSON object');
        System.assertEquals(matchingGroup.Id, groupPage.groups[0].Id, 'The matching groups should be returned in the JSON String');
    }

    static testMethod void testCreatePublicGroupSucess() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';

        Test.startTest();

            String groupResponse = ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);

        Test.stopTest();

        CollaborationGroupMember createdMember = [SELECT Id FROM CollaborationGroupMember
                                                     WHERE MemberId = :UserInfo.getUserId()
                                                      AND CollaborationGroup.Name = :expectedName];

        System.assert(groupResponse.indexOf(expectedName) > -1, 'The created group should be returned in the JSON String');
        System.assert(groupResponse.indexOf(expectedDescription) > -1, 'The created group should be returned in the JSON String');
    }

    static testMethod void testApproveGroupMemberRequest() {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser) {
            groupRequest = new CollaborationGroupMemberRequest();
	        groupRequest.CollaborationGroupId = newGroup.Id;
	        groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();

            String response = ChatterUIController.approveGroupMemberRequest(groupRequest.Id);

        Test.stopTest();

        System.assert(response.indexOf(ChatterUIGroupService.REQUEST_STATUS_ACCEPTED) > -1, 'The approved status should be returned in the response String');
    }

     static testMethod void testDenyGroupMemberRequest() {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser) {
            groupRequest = new CollaborationGroupMemberRequest();
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();

            String response = ChatterUIController.denyGroupMemberRequest(groupRequest.Id);

        Test.stopTest();

        System.assert(response.indexOf(ChatterUIGroupService.REQUEST_STATUS_DECLINED) > -1, 'The Declined status should be returned in the response String');
    }

    static testMethod void testCreatePublicGroupFailure() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        //create group with same name to force error
        ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);

        Test.startTest();

            String groupResponse = ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);

        Test.stopTest();

        Map<String, String> parsedResponse = (Map<String, String>)JSON.deserialize(groupResponse, Map<String, String>.class);
        System.assertEquals('error', parsedResponse.get('status'), 'An error response should be returned.');
    }

    static testMethod void testRequestToJoinPrivateGroup() {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();

            String response;
            System.runAs(requestingUser) {
                response = ChatterUIController.requestToJoinPrivateGroup(newGroup.Id);
            }

        Test.stopTest();

        System.assert(response.indexOf(newGroup.Id) > -1, 'The group that is being requested  to join should be returned in the response String');
        System.assert(response.indexOf(requestingUser.Id) > -1, 'The requesting user Id should be returned in the response String');
    }

    static testMethod void testRequestToJoinPrivateGroupFailure() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();

            String response;
            System.runAs(requestingUser) {
                response = ChatterUIController.requestToJoinPrivateGroup(newGroup.Id);
            }

        Test.stopTest();

        Map<String, String> parsedResponse = (Map<String, String>)JSON.deserialize(response, Map<String, String>.class);
        System.assertEquals('error', parsedResponse.get('status'), 'An error response should be returned when trying to rquest to joina public group.');
    }

    static testMethod void testGetPendingGroupRequests() {
    	CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();

        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest();
        System.runAs(requestingUser) {
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();

            List<ChatterUIGroupService.GroupRequest> pendingRequests = ChatterUIController.getPendingGroupRequests(newGroup.Id);

        Test.stopTest();

        System.assertEquals(1, pendingRequests.size(), '1 request should have been returned.');
        System.assertEquals(requestingUser.Id, pendingRequests[0].requester.Id, 'The requesting user should be set tot the user making the request');
        System.assertEquals(groupRequest.Id, pendingRequests[0].requestId, 'The group request Id should be set.');
    }

    static testMethod void testEditGroup() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = expectedOwner;
        newGroup.CollaborationType = 'Public';
        insert newGroup;

        Test.startTest();

            String groupResponse = ChatterUIController.editGroup(newGroup.Id, expectedName, expectedDescription, false);

        Test.stopTest();
        System.assertNotEquals(-1, groupResponse.indexOf(expectedDescription), 'The description should be updated.');
        System.assertNotEquals(-1, groupResponse.indexOf(expectedName), 'The name should be updated.');
        System.assertNotEquals(-1, groupResponse.indexOf('Private'), 'The visibility of the group should be updatd.');
    }

    static testMethod void testUpdateUser() {
        Map<String, String> fieldsToUpdate = new Map<String, String> {
            'Phone' => '111-111-1111',
            'Title' => 'new title',
            'AboutMe' => 'new about me',
            'CompanyName' => 'myCompany',
            'MobilePhone' => '1234567890'
        };

        try {
            String updateStatus = ChatterUIController.updateUserInfo(JSON.serialize(fieldsToUpdate));
            Map<String, String> updateStatusMap = (Map<String, String>)JSON.deserialize(updateStatus, Map<String, String>.class);

            System.assert(updateStatusMap.get('status') == 'success');
            System.assert(updateStatusMap.get('statusDesc') == '');

        } catch (Exception e) {
            // catch errors in case the user running the test doesn't have Update permissions on User
            System.debug('error updating user in testUpdateUser: '+e.getMessage());
        }
    }

    static CollaborationGroup createPrivateGroup() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;
        return newGroup;
    }
}