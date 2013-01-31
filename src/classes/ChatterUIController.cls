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
/**
 * Controller for the custom Chatter app
 */
public with sharing class ChatterUIController {
	
	public PageReference init() {
		// If nav element is not configured, redirect user to config page.
        if (NavigationElement__c.getAll().isEmpty()) {
            return Page.ChatterConfig;
        }
        return null;
	}
	
    /**
     * Returns whether the user is accessing the app on iOS or Android through Phonegap
     */
    public Boolean getUsingMobile() {
    	return ControllerUtil.isUsingIosPhonegap() || ControllerUtil.isUsingAndroidPhonegap();
    }

    /**
     * Returns the three letter object prefix for the object, for which Chatter feeds need to be retrieved.
     */
    public String getFeedObjectPrefix() {
    	String feedObjApiName = CustomChatterConfig.getFeedObjectApiName();
    	Schema.SObjectType feedObjType = null;
    	if (feedObjApiName != null) {
    	    feedObjType = Schema.getGlobalDescribe().get(feedObjApiName);
    	}
    	if (feedObjType == null) {
    		return Schema.SObjectType.Account.getKeyPrefix();
    	}
    	else {
    		return feedObjType.getDescribe().getKeyPrefix();
    	}
    }

    //// PEOPLE

    /**
     * Returns the three letter object prefix for the User object, used to retrieve Following / Follower User feed items only
     */
    public String getUserObjectPrefix() {
        return Schema.SObjectType.User.getKeyPrefix();
    }

 	/**
     * Updates the specified User fields for the current User
     * @param updatedFields - Stringified JSON with key value pairs representing the fields and values to update.
     *      Valid fields for update are Title, Phone, MobilePhone, CompanyName, and AboutMe
     * @return String representing a JSON status object, where the status property will be "success" or "error"
     */
    @RemoteAction
    public static String updateUserInfo(String updatedFields) {
        return ChatterUIPeopleService.updateUserInfo(UserInfo.getUserId(), updatedFields);
    }

    //// GROUPS

    /**
     * Remove a user from a group. This method should be used instead of
     * ChatterUI.Service.leaveGroup only when you do not have the membership Id.
     * @param groupId - the Id of the group to remove the user from
     * @param userId - the Id of the user to remove
     * @return a String containing any errors that occured
     */
    @RemoteAction
    public static String removeUserFromGroup(String groupId, String userId) {

        try {
        	ChatterUIGroupService.removeUserFromGroup(groupId, userId);
        } catch(DMLException de) {
        	return getStringifiedError(de);
        }

        return '{}';
    }

    /**
     * Create a group
     * @param name - the name of the group
     * @param description - the description of the group
     * @param userId - the user creating the group
     * @param isPublic - Boolean for public groups
     * @return String - the created group
     */
    @RemoteAction
    public static String createGroup(String name, String description, String userId, Boolean isPublic) {
        CollaborationGroup collabGroup;

        try {
        	collabGroup = ChatterUIGroupService.createGroup(name, description, userId, isPublic);
        } catch(DMLException de) {
        	return getStringifiedError(de);
        }

        return JSON.serialize(collabGroup);
    }

    /**
     * Edit a group
     * @param groupId - the Id of the group to edit
     * @param name - the name of the group
     * @param description - the description of the group
     * @param isPublic - indicate if this is a public group
     * @return String - the updated group
     */
    @RemoteAction
    public static String editGroup(String groupId, String name, String description, Boolean isPublic) {
        CollaborationGroup collabGroup;

        try {
        	collabGroup = ChatterUIGroupService.editGroup(groupId, name, description, isPublic);
        } catch(DMLException de) {
        	return getStringifiedError(de);
        }

    	return JSON.serialize(collabGroup);
    }

    /**
     * Searches for groups whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     * @param searchText - the name of the group to search for
     * @param pageNumber - The page number to return.
     * @return String - the page of group results that match targetName
     */
    @RemoteAction
    public static ChatterUIGroupService.GroupPage searchGroupsByName(String searchText) {
        return ChatterUIGroupService.searchGroupsByName(searchText, 1);
    }

    /**
     * get all groups for which a user is a member
     * @param memberId - id of the user
     * @param pageNumber - The page number to return.
     * @return GroupPage object - the page of group results that match targetName
     */
    @RemoteAction
    public static ChatterUIGroupService.GroupPage getGroupsForUser(String memberId) {
        return ChatterUIGroupService.getGroupsForUser(memberId);
    }

	/**
     * Searches for users whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     * @param searchText - the name of the user to search for
     * @return GroupPage object - JSON object of user results that match searchText
     */
    @RemoteAction
    public static List<User> searchUsersByName(String searchText) {
        return ChatterUIPeopleService.searchUsersByName(searchText);
    }

    /**
     * Get pending join requests
     * @param groupId - the Id of the group to retrieve pending requests for
     * @return  List<ChatterUIGroupService.GroupRequest> - the list of pending group requests
     */
    @RemoteAction
    public static List<ChatterUIGroupService.GroupRequest> getPendingGroupRequests(String groupId) {
        return ChatterUIGroupService.getPendingGroupRequests(groupId);
    }

    /**
     * Request to join a private group
     * @param groupId - id of the group
     * @return String - String representing the CollaborationGroupMemberRequest
     */
    @RemoteAction
    public static String requestToJoinPrivateGroup(String groupId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.createGroupMemberRequest(groupId, UserInfo.getUserId());
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    /**
     * Approve a request to join a group
     * @param requestId - the GroupMemberRequest Id to approve
     * @return String - String representing the GroupMemberRequest
     */
    @RemoteAction
    public static String approveGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.approveGroupMemberRequest(requestId);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    /**
     * Deny a request to join a group
     * @param requestId - the GroupMemberRequest Id to deny
     * @throws DMLException
     * @return String - String representing the GroupMemberRequest
     */
    @RemoteAction
    public static String denyGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest;
        try {
            groupRequest = ChatterUIGroupService.denyGroupMemberRequest(requestId);
        } catch(DMLException de) {
            return getStringifiedError(de);
        }
        return JSON.serialize(groupRequest);
    }

    //// FILE UPLOAD

    /**
     * Upload file using the specified blob value
     * @param base64BlobValue - String of the encoded base 64 string with the file contents
     * @return Map containing the results of the upload with the following keys: fileId, status, message
     */
    @RemoteAction
    public static Map<String, String> uploadAttachment(String base64BlobValue) {
    	return ChatterUIFileUpload.uploadAttachment(base64BlobValue, null);
    }

    //// UTILITIES


    /**
     * @param Exception
     * @return String representing a JSON status error object, where the status property will "error"
     *      and statusDesc will contain the error message
     */
    public static String getStringifiedError(Exception e) {
        return getStringifiedStatus('error', e.getMessage());
    }

    /**
     * @param status - "success" or "error"
     * @param statusDesc - the description of the error message if any
     * @return String representing a JSON status object
     */
    public static String getStringifiedStatus(String status, String statusDesc) {
        Map<String, String> result = new Map<String, String> {
            'status' => status,
            'statusDesc' => statusDesc
        };
        return JSON.serialize(result);
    }

    private static testMethod void testGetUsingMobile() {
        ChatterUIController controller = new ChatterUIController();

        PageReference testPage = new PageReference('/apex/test');
        testPage.getHeaders().put('User-Agent', 'Desktop');
        Test.setCurrentPage(testPage);
        System.assertEquals(false, controller.getUsingMobile());
    }
    
    private static testMethod void testGetObjectPrefix() {
        ChatterUIController controller = new ChatterUIController();
        System.assertEquals(Schema.SObjectType.Account.getKeyPrefix(), controller.getFeedObjectPrefix());
        System.assertEquals(Schema.SObjectType.User.getKeyPrefix(), controller.getUserObjectPrefix());
    }
	
    private static testMethod void testUploadAttachment() {
        ChatterUIController controller = new ChatterUIController();
        String base64BlobValue = EncodingUtil.base64Encode(Blob.valueOf('test string'));
        Map<String, String>  resultsMap = ChatterUIController.uploadAttachment(base64BlobValue);
        System.assertNotEquals(null, resultsMap.get(ChatterUIFileUpload.PARAM_UPLOAD_STATUS));      
    }
    
    private static testMethod void testSearchUsersByName() {
    	List<User> users = ChatterUIController.searchUsersByName(UserInfo.getName());
    	System.assert(!users.isEmpty());
    }

    private static testMethod void testGetGroupsForUser() {
        ChatterUIGroupService.GroupPage groupPage = ChatterUIController.getGroupsForUser(UserInfo.getUserId());
        System.assertNotEquals(null, groupPage);
    }
}