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
 * Service class for handling Chatter Groups
 */
public with sharing class ChatterUIGroupService {

	public static final Integer GROUP_PAGE_SIZE = 100;
	//maximum number of groups a user can belong to
	public static final Integer MAX_GROUPS = 100;
	public static final String REQUEST_STATUS_ACCEPTED = 'Accepted';
	public static final String REQUEST_STATUS_DECLINED = 'Declined';
	public static final String REQUEST_STATUS_PENDING = 'Pending';

    /**
     * Create a group
     * @param name - the name of the group
     * @param description - the description of the group
     * @param userId - the user creating the group
     * @param isPublic - indicate if this is a public group
     * @throws DMLException
     * @return CollaborationGroup - the created group
     */
    public static CollaborationGroup createGroup(String name, String description, String userId, Boolean isPublic) {
        CollaborationGroup newGroup = new CollaborationGroup(Name=name);
        newGroup.Description = description;
        newGroup.OwnerId = userId;
        newGroup.CollaborationType = (isPublic) ? 'Public' : 'Private';

        try {
        	insert newGroup;
        }
        catch(DMLException de) {
        	System.debug('Error creating Chatter group' + de);
        	//Let caller handle exception
        	throw de;
        }

        return newGroup;
    }

    /**
     * Create a Request to join a group
     * @param groupId - id of the group
     * @param userId - id of the user requesting to join
     * @throws DMLException
     * @return CollaborationGroupMemberRequest -  the created request
     */
    public static CollaborationGroupMemberRequest createGroupMemberRequest(String groupId, String userId) {
        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest();
        groupRequest.CollaborationGroupId = groupId;
        groupRequest.RequesterId = userId;

        try {
        	insert groupRequest;
        }
        catch(DMLException de) {
            System.debug('Error creating CollaborationGroupMemberRequest' + de);
            throw de;
        }
        return groupRequest;
    }

    /**
     * Approve a request to join a group
     * @param requestId - the CollaborationGroupMemberRequest Id to approve
     * @throws DMLException
     * @return the updated CollaborationGroupMemberRequest
     */
    public static CollaborationGroupMemberRequest approveGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest(Id=requestId);
        groupRequest.Status = REQUEST_STATUS_ACCEPTED;

        try {
            update groupRequest;
        }
        catch(DMLException de) {
            System.debug('Error updating CollaborationGroupMemberRequest' + de);
            throw de;
        }
        return groupRequest;
    }

    /**
     * Deny a request to join a group
     * @param requestId - the CollaborationGroupMemberRequest Id to deny
     * @throws DMLException
     * @return the updated CollaborationGroupMemberRequest
     */
    public static CollaborationGroupMemberRequest denyGroupMemberRequest(String requestId) {
        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest(Id=requestId);
        groupRequest.Status = REQUEST_STATUS_DECLINED;

        try {
            update groupRequest;
        }
        catch(DMLException de) {
            System.debug('Error updating CollaborationGroupMemberRequest' + de);
            throw de;
        }
        return groupRequest;
    }

    /**
     * Edit a group
     * @param groupId - the Id of the group to edit
     * @param name - the name of the group
     * @param description - the description of the group
     * @param isPublic - indicate if this is a public group
     * @throws DMLException
     * @return CollaborationGroup - the updated group
     */
    public static CollaborationGroup editGroup(String groupId, String name, String description, Boolean isPublic) {
        CollaborationGroup updatedGroup = new CollaborationGroup(Id=groupId);
        updatedGroup.Name = name;
        updatedGroup.Description = description;
        updatedGroup.CollaborationType = (isPublic) ? 'Public' : 'Private';

        try {
        	update updatedGroup;
        }
        catch(DMLException de) {
        	System.debug('Error updating Chatter group' + de);
        	//Let caller handle exception
        	throw de;
        }

        return updatedGroup;
    }

    /**
     * Retrieve a Group Member
     * @param groupId - the Id of the group to retrieve a member of
     * @param userId - the user who is a group member
     * @return CollaborationGroupMember - the found group member. null is returned if no groupmember is found
     */
    public static CollaborationGroupMember getGroupMember(String groupId, String userId) {
    	List<CollaborationGroupMember> members = [SELECT Id
										    	   FROM CollaborationGroupMember
										    	   WHERE MemberId = :userId
										    	    AND CollaborationGroupId = :groupId];

		if(members.isEmpty()) {
		  return null;
		}
		else {
			return members[0];
		}
    }

    /**
     * Get pending join requests
     * @param groupId - the Id of the group to retrieve pending requests for
     * @return List<GroupRequests> the pending requests
     */
    public static List<GroupRequest> getPendingGroupRequests(String groupId) {
        List<GroupRequest> pendingRequests = new List<GroupRequest>();
        Map<Id, Id> usersWithPendingRequests = new Map<Id, Id>();

        for(CollaborationGroupMemberRequest request : [SELECT Id, RequesterId
										    	           FROM CollaborationGroupMemberRequest
										    	           WHERE CollaborationGroupId = :groupId
										    	            AND Status = :REQUEST_STATUS_PENDING
										    	            LIMIT :GROUP_PAGE_SIZE]) {
            usersWithPendingRequests.put(request.RequesterId, request.Id);
        }

        for(User user : [SELECT Id, Name, SmallPhotoUrl, Title, CompanyName
				            FROM User
				            WHERE Id IN :usersWithPendingRequests.keySet()
				            ORDER BY Name]) {
            pendingRequests.add(new GroupRequest(usersWithPendingRequests.get(user.Id), user));
        }
        return pendingRequests;
    }


    /**
     * Remove a user from a group
     * @param groupId - the Id of the group to remove the user from
     * @param userId - the Id of the user to remove
     * @throws DmlException
     */
    public static void removeUserFromGroup(String groupId, String userId) {

        List<CollaborationGroupMember> members = [SELECT Id
                                                    FROM CollaborationGroupMember
                                                    WHERE CollaborationGroupId = :groupId
                                                    AND MemberId = :userId];
        if(!members.isEmpty()) {
        	delete members[0];
        }
    }

    /**
     * Searches for groups whose name contains searchText. Search Text must
     * contain at least 2 characters for results to be returned.
     *
     * @param searchText - The group name to search for.
     * @param pageNumber - The page number to return.
     * @return GroupPage - the page of group results
     */
    public static GroupPage searchGroupsByName(String searchText, Integer pageNumber) {
        //ignore searches with less than 2 characters
        if(searchText == null || searchText.length() < 2 ) {
            return new GroupPage(new List<CollaborationGroup>(), 0, 1);
        }

        if(pageNumber == null || pageNumber < 1) {
            pageNumber = 1;
        }

        String likeClause = '%' + EncodingUtil.urlDecode(searchText, 'UTF-8') +'%';

        Integer rowsLeft = Limits.getLimitQueryRows() - Limits.getQueryRows() - GROUP_PAGE_SIZE;
        Integer groupCount = [SELECT count() FROM CollaborationGroup WHERE Name LIKE :likeClause LIMIT :rowsLeft ];

        Integer offSet = (pageNumber - 1) * GROUP_PAGE_SIZE;

        List<CollaborationGroup> groups = [SELECT Id, Name, Description, SmallPhotoUrl, FullPhotoUrl, OwnerId, CollaborationType,
                                            (SELECT Id FROM GroupMembers WHERE MemberId = :UserInfo.getUserId())
								            FROM CollaborationGroup
								            WHERE Name LIKE :likeClause
								            ORDER BY Name
								            LIMIT :GROUP_PAGE_SIZE
								            OFFSET :offset];

	   return new GroupPage(groups, groupCount, pageNumber);
    }

    /**
     * Returns all groups for which a user is a member
     *
     * @param memberId - Id of the user.
     * @return GroupPage - the page of group results
     */
    public static GroupPage getGroupsForUser(String memberId) {
        //get the ids of the groups that this user is a member of.
        List<CollaborationGroupMember> cgms = [SELECT CollaborationGroupId, MemberId
            FROM CollaborationGroupMember
            WHERE MemberId = :memberId];

        List<Id> groupIds = new List<Id>();

        for (CollaborationGroupMember cgm : cgms) {
            groupIds.add(cgm.CollaborationGroupId);
        }

        //get a list of groups this user is a member of with their group subscription
        List<CollaborationGroup> groups = [SELECT Id, Name, Description, SmallPhotoUrl, FullPhotoUrl, OwnerId, CollaborationType,
                                            (SELECT Id FROM GroupMembers WHERE MemberId = :UserInfo.getUserId())
                                            FROM CollaborationGroup
                                            WHERE Id IN :groupIds
                                            ORDER BY Name
                                            LIMIT :MAX_GROUPS];

       return new GroupPage(groups, groups.size(), 1);
    }

    /**
    * A page of chatter group results.
    */
    public class GroupPage {

    	public List<CollaborationGroup> groups {get; private set;}
    	public Map<String, List<CollaborationGroup>> mappedGroups {get; private set;}
    	public Integer totalGroupCount  {get; private set;}
    	public Integer nextPage  {get; private set;}
    	public Boolean hasMore {get; private set;}

        /**
	    * Group page constructor
	    *
	    * @param groups - The groups in this page.
	    * @param totalGroupCount - the total number of groups that match the search criteria
	    * @param currentPageNumber - the current page number.
	    */
    	public GroupPage(List<CollaborationGroup> groups, Integer totalGroupCount, Integer currentPageNumber) {
    		this.groups = groups;
    		this.totalGroupCount = totalGroupCount;
    		this.hasMore =  (currentPageNumber * GROUP_PAGE_SIZE) < totalGroupCount;
    		if (hasMore) {
    		  this.nextPage = currentPageNumber + 1;
    		}

    		Map<String, List<CollaborationGroup>> alphaGroups = new Map<String, List<CollaborationGroup>>();

    		for (CollaborationGroup grp : groups) {
    			List<CollaborationGroup> aGroup = new List<CollaborationGroup>();
    			//create a map of groups categorized alphabetically.
    			String alphaKey = grp.Name.substring(0, 1).toUpperCase();

    			if (alphaGroups != null && alphaGroups.containsKey(alphaKey)) {
                    aGroup = alphaGroups.get(alphaKey);
    			}

    			aGroup.add(grp);

                alphaGroups.put(alphaKey, aGroup);
            }

            this.mappedGroups = alphaGroups;
    	}
    }

    /**
    * A simplified group request.
    */
    public class GroupRequest {

    	public String requestId {get; set;}
    	public User requester {get; set;}

        /**
        * @param requestId - Id of the CollaborationGroupMemberRequest
        * @param requester - the User who requested access to the group.
        */
    	public GroupRequest(String requestId, User requester) {
    		this.requestId = requestId;
    		this.requester = requester;
    	}
    }
}