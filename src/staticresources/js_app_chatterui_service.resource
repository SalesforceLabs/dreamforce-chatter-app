ChatterUI.namespace('ChatterUI.Service');
ChatterUI.Service = (function($) {

    var URL_PROTOCOL = document.location.protocol,
        HOST = document.location.hostname,
        INSTANCE_PREFIX = getInstancePrefix(),
        BASE_URL = URL_PROTOCOL + '//' + INSTANCE_PREFIX + '.salesforce.com',
        BASE_CHATTER_URL = BASE_URL + '/services/data/v25.0/chatter',
        // proxy url needs to match the current domain, not the Chatter url domain
        PROXY_URL = URL_PROTOCOL + '//' + HOST + '/services/proxy',
        PEOPLE_PAGE_SIZE = 1000,
        DEFAULT_FEED_SORT = 'sort=LastModifiedDateDesc',

        feedApi = {
            currentUserFeed: '/feeds/news/me/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            feedsAtMe: '/feeds/to/me/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            myGroupsFeed: '/feeds/groups/me/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            userProfileFeed: '/feeds/user-profile/{0}/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            myPeopleFeed: '/feeds/people/me/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            myFilesFeed: '/feeds/files/me/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            myBigFilesFeed: '/feeds/files/me/feed-items?pageSize=100&'+DEFAULT_FEED_SORT,
            feedComments: '/feed-items/{0}/comments',
            feedSearch: '/feed-items?q={0}',
            myObjectFeed: '/feeds/filter/me/{0}/feed-items?pageSize=15&'+DEFAULT_FEED_SORT,
            companyFeed: '/feeds/company/feed-items?'+DEFAULT_FEED_SORT,
            sortedRecordFeed: '/feeds/record/{0}/feed-items?'+DEFAULT_FEED_SORT,

            // POST
            follow: '/users/me/following?subjectId={0}',
            // represents the feed for a group or record
            recordFeed: '/feeds/record/{0}/feed-items',
            feedLike: '/feed-items/{0}/likes',
            commentLike: '/comments/{0}/likes',

            // DELETE
            feedItem: '/feed-items/{0}',
            comment: '/comments/{0}',
            unfollow: '/subscriptions/{0}',
            // used for unliking
            like: '/likes/{0}'
        },
        peopleApi = {
            usersFollowing: '/users/{0}/following?pageSize='+PEOPLE_PAGE_SIZE+'&filterType={1}',
            usersFollowers: '/users/{0}/followers?pageSize='+PEOPLE_PAGE_SIZE,
            userProfile: '/users/{0}',
            usernameSearch: '/users?pageSize=25&q={0}*',
            userPhoto: '/users/me/photo?fileId={0}',
            myPhoto: '/users/me/photo'
        },
        groupApi = {
            group: '/groups/{0}',
            groupMembers: '/groups/{0}/members?pageSize='+PEOPLE_PAGE_SIZE,
            joinGroup: '/groups/{0}/members?userId={1}',
            leaveGroup: '/group-memberships/{0}',
            groupPhoto: '/groups/{0}/photo?fileId={1}',
            currentGroupPhoto: '/groups/{0}/photo'
        },
        recordApi = {
            followers: '/records/{0}/followers'
        };

    /**
     * @return String with the Salesforce instance that is currently being run on, e.g. na12, cs5, etc.
     */
    function getInstancePrefix() {
        var instancePrefix = '',
            hostParts = HOST.split('.');

        // possible scenarios:
        // ion--test1--nexus.cs0.visual.force.com  --- 5 parts, instance is 2nd part
        // https://c.na1.visual.force.com -- 5 parts, instance is 2nd part
        // na12.salesforce.com      --- 3 parts, instance is 1st part
        // ion.my.salesforce.com    --- 4 parts, instance is indeterminable, return prefix ion.my

        if (hostParts.length == 3) {
            instancePrefix = hostParts[0];

        } else if (hostParts.length == 5) {
            instancePrefix = hostParts[1];

        } else {
            // return first 2 host parts
            instancePrefix = hostParts[0] + '.' + hostParts[1];
        }
        return instancePrefix;
    }

    /**
     * Makes a GET Chatter API request with the specified url endpoint
     * @param callback - the callback handler to invoke upon success or failure
     * @param chatterUrl - the endpoint
     */
    function doGet(chatterUrl, callback) {
        var settings = {
            type: 'GET',
            data: {
                bustCache: new Date().getTime()
            } // for IE9 - lame!
        };
        return doAjaxRequest(chatterUrl, callback, settings);
    }

    /**
     * Makes a POST Chatter API request with the specified url endpoint
     * @param chatterUrl - the endpoint
     * @param callback - the callback handler to invoke upon success or failure
     * @param requestBody - the request body
     */
    function doPost(chatterUrl, callback, requestBody) {
        var settings = {
            type: 'POST'
        };

        if (requestBody && requestBody.length > 0) {
            settings.contentType = 'application/json';
            settings.data = requestBody;
        }
        return doAjaxRequest(chatterUrl, callback, settings);
    }

    /**
     * Makes a DELETE Chatter API request with the specified url endpoint
     * @param chatterUrl - the endpoint
     * @param callback - the callback handler to invoke upon success or failure
     */
    function doDelete(chatterUrl, callback) {
        var settings = {
            type: 'DELETE'
        };
        return doAjaxRequest(chatterUrl, callback, settings);
    }

    /**
     * Makes a Chatter API request with the specified url endpoint and request settings
     * @param chatterUrl - the endpoint
     * @param callback - the callback handler to invoke upon success or failure
     * @param settings - object with properties for the request that may be dynamic, such as the type, contentType, data, etc.
     */
    function doAjaxRequest(chatterUrl, callback, settings) {
        var requestSettings = $.extend(
        {
            url: PROXY_URL, // for single origin policy
            accepts: 'application/json',
            contentType: 'application/x-www-form-urlencoded',
            dataType: 'json',
            headers: {
                'Authorization': 'OAuth ' + ChatterUI.UserContext.sessionId,
                'SalesforceProxy-Endpoint': chatterUrl,
                'X-Chatter-Entity-Encoding': 'false'
            },
            success: function(data, textStatus, jqXHR) {
                if (!data) {
                    data = {};
                }
                callback(data, getEventWrapper(textStatus, jqXHR));
            },
            error: function(jqXHR, textStatus, errorThrown) {
                callback({ status: textStatus }, getEventWrapper(textStatus, jqXHR));
            }
        }, settings);

        $.ajax(requestSettings);
    }

    /**
     * Mimics Salesforce's event object returned by JS Remoting
     * @param textStatus - success / error status as returned by an ajax call
     * @param jqXHR - the jQuery XMLHTTPRequest returned by an ajax call
     * @return an object with the status and message properties
     */
    function getEventWrapper(textStatus, jqXHR) {
        var responseJSON = jqXHR.responseText ? JSON.parse(jqXHR.responseText) : '';
        var message = responseJSON.length ? responseJSON[0].message : '';

        return {
            status: textStatus,
            message: message
        };
    }

    // FEEDS
    /**
     * Retrieves the Feed Item page with the feed-items for all actions by the logged-in user on
     *      all records that can be tracked in a feed.
     * @param userId - the Salesforce ID of the user to get the feed for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getUserProfileFeed(userId, callback) {
        var url = BASE_CHATTER_URL + feedApi.userProfileFeed.replace('{0}', userId);
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with all feed items from all groups the logged-in user
     *      either owns or is a member of, as well as all files, records, and all users the current user follows.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getCurrentUserFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.currentUserFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with the feed-items for all @mentions of the logged-in user,
     *      as well as all posts other users make to the user's feed.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getFeedsAtMe(callback) {
        var url = BASE_CHATTER_URL + feedApi.feedsAtMe;
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with all the feed items from all the people the current user follows.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getMyPeopleFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.myPeopleFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with all feed items from all groups the current user
     *      either owns or is a member of.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getMyGroupsFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.myGroupsFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with all feed items posted with files by people or groups
     *      that the logged-in user follows.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getMyFilesFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.myFilesFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the Comment Page with the comments for a specific feed item
     * @param feedItemId - the ID of the Feed Item for which to get the comments
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getFeedComments(feedItemId, callback) {
        var url = BASE_CHATTER_URL + feedApi.feedComments.replace('{0}', feedItemId);
        doGet(url, callback);
    }

    /**
     * Posts to the current user's News (My Chatter) feed.
     * The response returns the Feed Item that was posted.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function postNewsFeedItem(postBody, callback) {
        var url = BASE_CHATTER_URL + feedApi.currentUserFeed;
        doPost(url, callback, postBody);
    }

    /**
     * Posts to the specified Group.
     * The response returns the Feed Item that was posted.
     * @param groupId - the ID of the Group to post to
     * @param postBody - the post data
     * @param callback - the callback handler to invoke upon success or failure
     */
    function postGroupFeedItem(groupId, postBody, callback) {
        var url = BASE_CHATTER_URL + feedApi.recordFeed.replace('{0}', groupId);
        doPost(url, callback, postBody);
    }

    /**
     * Retrieves the Feed Item page with all feed items from the specified group
     * @param groupId - the ID of the Group to retrieve the feed for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getGroupFeed(groupId, callback) {
        var url = BASE_CHATTER_URL + feedApi.sortedRecordFeed.replace('{0}', groupId);
        doGet(url, callback);
    }

    /**
     * Posts to the specified Person.
     * The response returns the Feed Item that was posted.
     * @param personId - the ID of the Person to post to
     * @param postBody - the post data
     * @param callback - the callback handler to invoke upon success or failure
     */
    function postPersonFeedItem(personId, postBody, callback) {
        var url = BASE_CHATTER_URL + feedApi.recordFeed.replace('{0}', personId);
        doPost(url, callback, postBody);
    }

    /**
     * Posts a Comment to the specified Feed Item.
     * The response returns the Comment that was posted.
     * @param feedItemId - the ID of the Feed Item to post to
     * @param postBody - the post data
     * @param callback - the callback handler to invoke upon success or failure
     */
    function postComment(feedItemId, postBody, callback) {
        var url = BASE_CHATTER_URL + feedApi.feedComments.replace('{0}', feedItemId);
        doPost(url, callback, postBody);
    }

    /**
     * Likes the specified Feed Item
     * The response returns the Like
     * @param feedItemId - the ID of the Feed Item to like
     * @param callback - the callback handler to invoke upon success or failure
     */
    function likeFeed(feedItemId, callback) {
        var url = BASE_CHATTER_URL + feedApi.feedLike.replace('{0}', feedItemId);
        doPost(url, callback, null);
    }

    /**
     * Likes the specified Comment
     * The response returns the Like
     * @param commentId - the ID of the Comment to like
     * @param callback - the callback handler to invoke upon success or failure
     */
    function likeComment(commentId, callback) {
        var url = BASE_CHATTER_URL + feedApi.commentLike.replace('{0}', commentId);
        doPost(url, callback, null);
    }

    /**
     * Follows the specified record, whether it's a user, file, or object, but not a Group
     * The response returns the Subscription that was followed
     * @param recordId - the ID of the record to follow
     * @param callback - the callback handler to invoke upon success or failure
     */
    function follow(recordId, callback) {
        var url = BASE_CHATTER_URL + feedApi.follow.replace('{0}', recordId);
        doPost(url, callback, null);
    }

    /**
     * Unlikes the specified Like, whether it's for a Post or Comment
     * @param likeId - the ID of the Like associated to the Post or Comment that will be unliked
     * @param callback - the callback handler to invoke upon success or failure
     */
    function unlike(likeId, callback) {
        var url = BASE_CHATTER_URL + feedApi.like.replace('{0}', likeId);
        doDelete(url, callback);
    }

    /**
     * Unfollows the specified subscription
     * @param subscriptionId - the ID of the Subscription to unfollow
     * @param callback - the callback handler to invoke upon success or failure
     */
    function unfollow(subscriptionId, callback) {
        var url = BASE_CHATTER_URL + feedApi.unfollow.replace('{0}', subscriptionId);
        doDelete(url, callback);
    }

    /**
     * Deletes the specified Feed Item (Post)
     * @param feedItemId - the ID of the Feed Item to delete
     * @param callback - the callback handler to invoke upon success or failure
     */
    function deleteFeedItem(feedItemId, callback) {
        var url = BASE_CHATTER_URL + feedApi.feedItem.replace('{0}', feedItemId);
        doDelete(url, callback);
    }

    /**
     * Deletes the specified Comment
     * @param commentId - the ID of the Comment to delete
     * @param callback - the callback handler to invoke upon success or failure
     */
    function deleteComment(commentId, callback) {
        var url = BASE_CHATTER_URL + feedApi.comment.replace('{0}', commentId);
        doDelete(url, callback);
    }

    /**
     * Retrieves feed items with the hashtag text in the feed item body, as well as feed items that have comments that contain the hashtag text.
     * @param hashtagText - the hashtag text without the hashtag character to use for the search
     * @param callback - the callback handler to invoke upon success or failure
     */
    function searchFeedsByHashtag(hashtagText, callback) {
        var encodedHashtagText = encodeURIComponent('#' + hashtagText);
        var url = BASE_CHATTER_URL + feedApi.feedSearch.replace('{0}', encodedHashtagText);
        doGet(url, callback);
    }

    /**
     * Retrieves the current user's feed items filtered to only show feeds related to the user's feed object
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getMyObjectFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.myObjectFeed.replace('{0}', ChatterUI.UserContext.feedObjectPrefix);
        doGet(url, callback);
    }

    /**
     * Retrieves the entire company's feed items
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getAllChatterFeed(callback) {
        var url = BASE_CHATTER_URL + feedApi.companyFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the Feed Item page with all feed items from the specified session
     * @param sessionId {String} the ID of the feed object records to retrieve.
     * @param callback {Function} the callback handler to invoke upon success or failure
     */
    function getSessionFeed(sessionId, callback) {
        var url = BASE_CHATTER_URL + feedApi.sortedRecordFeed.replace('{0}', sessionId);
        doGet(url, callback);
    }

    /**
     * Posts to the specified Session.
     * The response returns the Feed Item that was posted.
     * @param groupId - the ID of the Session to post to
     * @param postBody - the post data
     * @param callback - the callback handler to invoke upon success or failure
     */
    function postSessionFeedItem(sessionId, postBody, callback) {
        var url = BASE_CHATTER_URL + feedApi.recordFeed.replace('{0}', sessionId);
        doPost(url, callback, postBody);
    }

    /**
     * Gets the file feed for the specified Session.
     * The response returns a JSON formatted String.
     *
     * @param seesionId - The Id of the session to retrieve the file feed for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getSessionFiles(sessionId, callback) {
        var url = BASE_CHATTER_URL + feedApi.myBigFilesFeed;
        doGet(url, callback);
    }

    /**
     * Retrieves the list of users that follow a session.
     * @param sessionId - the ID of the session to get the followers for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getSessionFollowers(sessionId, callback) {
        var url = BASE_CHATTER_URL + recordApi.followers.replace('{0}', sessionId);
        doGet(url, callback);
    }

    // PEOPLE

    /**
     * Retrieves the Following page with the list of follower users
     * @param userId - the ID of the user with the followers
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getFollowers(userId, callback) {
        var url = BASE_CHATTER_URL + peopleApi.usersFollowers.replace('{0}', userId);
        doGet(url, callback);
    }

    /**
     * Retrieves the Following page with the list of users who are following
     * @param userId - the ID of the user with the followers
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getFollowing(userId, callback) {
        var url = BASE_CHATTER_URL + peopleApi.usersFollowing.replace('{0}', userId).replace('{1}', ChatterUI.UserContext.userObjectPrefix);
        doGet(url, callback);
    }

    /**
     * Retrieves the Following page with the list of sessions who are being followed by the given user.
     * @param userId - the ID of the user to get the sessions for.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getFollowingFeedObjRecords(userId, callback) {
        var url = BASE_CHATTER_URL + peopleApi.usersFollowing.replace('{0}', userId).replace('{1}', ChatterUI.UserContext.feedObjectPrefix);
        doGet(url, callback);
    }

    /**
     * Retrieves the User page with the list of matching users
     * @param searchText - the text that will be used to perform a partial search on People's Name.
     *      The searchText will match the beginning of the Person's First or Last Name.
     * @param callback - the callback handler to invoke upon success or failure
     */
    function searchPeopleByName(searchText, callback) {
        var url = BASE_CHATTER_URL + peopleApi.usernameSearch.replace('{0}', searchText);
        doGet(url, callback);
    }

    /**
     * Retrieves the User Detail page with information about the specified user's Chatter profile.
     * @param userId - the Salesforce ID of the user to get the info for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getUserProfile(userId, callback) {
        var url = BASE_CHATTER_URL + peopleApi.userProfile.replace('{0}', userId);
        doGet(url, callback);
    }

    /**
     * Updates the current user's photo to the specified file
     * The response returns the Photo that was associated to the user
     * @param fileId - the ID of the file to associate to the user's profile
     * @param callback - the callback handler to invoke upon success or failure
     */
    function updateUserPhoto(fileId, callback) {
        var url = BASE_CHATTER_URL + peopleApi.userPhoto.replace('{0}', fileId);
        doPost(url, callback, null);
    }

    /**
     * Gets the current user's profile photo
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getMyPhoto(callback) {
        var url = BASE_CHATTER_URL + peopleApi.myPhoto;
        doGet(url, callback);
    }

    // GROUPS

    /**
     * Gets the specified Group. Returns a 404: Not Found if the group does not exist
     * @param groupId - The Id of the group to retrieve
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getGroup(groupId, callback) {
        var url = BASE_CHATTER_URL + groupApi.group.replace('{0}', groupId);
        doGet(url, callback);
    }

    /**
     * Gets the members of the specified Group.
     * The response returns the Group Member Page. An empty page will be
     * returned when there are no results. An error will be returned
     * with a statusDesc of 404 if no group exists with this Id.
     *
     * @param groupId - The Id of the group to retrieve the members for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getGroupMembers(groupId, callback) {
        var url = BASE_CHATTER_URL + groupApi.groupMembers.replace('{0}', groupId);
        doGet(url, callback);
    }

    /**
     * Gets the group's photo
     * @param groupId - the group for which to get the photo
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getGroupPhoto(groupId, callback) {
        var url = BASE_CHATTER_URL + groupApi.currentGroupPhoto.replace('{0}', groupId);
        doGet(url, callback);
    }

    /**
     * Join the specified Group.
     * The response returns the GroupMember that was created.
     * @param groupId - the Id of the Group to join
     * @param userId - the user joining the group
     * @param callback - the callback handler to invoke upon success or failure
     */
    function joinGroup(groupId, userId, callback) {
        var url = BASE_CHATTER_URL + groupApi.joinGroup.replace('{0}', groupId).replace('{1}', userId);
        doPost(url, callback, null);
    }

    /**
     * Leave the specified Group.
     * An error will be returned with a statusDesc of 400 for errors such as trying to remove
     *     the owner of the group's membership.
     * @param groupMemberId - the Id of the Group membership
     * @param callback - the callback handler to invoke upon success or failure
     */
    function leaveGroup(groupMemberId, callback) {
        var url = BASE_CHATTER_URL + groupApi.leaveGroup.replace('{0}', groupMemberId);
        doDelete(url, callback);
    }

    /**
     * Updates the group's photo to the specified file
     * The response returns the Photo that was associated
     * @param groupId - the ID of the group to associate the photo to
     * @param fileId - the ID of the file to associate
     * @param callback - the callback handler to invoke upon success or failure
     */
    function updateGroupPhoto(groupId, fileId, callback) {
        var url = BASE_CHATTER_URL + groupApi.groupPhoto.replace('{0}', groupId).replace('{1}', fileId);
        doPost(url, callback, null);
    }

    /**
     * Gets the file for the specified Group.
     * The response returns a JSON formatted String.
     *
     * @param groupId - The Id of the group to retrieve the members for
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getGroupFiles(groupId, callback) {
        var url = BASE_CHATTER_URL + feedApi.myBigFilesFeed;
        doGet(url, callback);
    }

    /**
     * Executes the requested API call with the specified URL, used for loading additional results,
     *      and retrieves an object with the requested result.
     * @param nextPageURL - the URL of the next page from the original Chatter API call, starting with /services/
     * @param callback - the callback handler to invoke upon success or failure
     */
    function getNextPage(nextPageURL, callback) {
        var url = BASE_URL + nextPageURL;
        doGet(url, callback);
    }

    return {
        // PEOPLE
        getFollowers         : getFollowers,
        getFollowing         : getFollowing,
        getFollowingFeedObjRecords : getFollowingFeedObjRecords,
        searchPeopleByName   : searchPeopleByName,
        getUserProfile       : getUserProfile,
        updateUserPhoto      : updateUserPhoto,
        getMyPhoto           : getMyPhoto,

        // GROUPS
        getGroup             : getGroup,
        getGroupMembers      : getGroupMembers,
        getGroupPhoto        : getGroupPhoto,
        joinGroup            : joinGroup,
        leaveGroup           : leaveGroup,
        updateGroupPhoto     : updateGroupPhoto,

        // FEEDS
        deleteComment        : deleteComment,
        deleteFeedItem       : deleteFeedItem,
        follow               : follow,
        getCurrentUserFeed   : getCurrentUserFeed,
        getFeedComments      : getFeedComments,
        getFeedsAtMe         : getFeedsAtMe,
        getGroupFeed         : getGroupFeed,
        getMyFilesFeed       : getMyFilesFeed,
        getGroupFiles        : getGroupFiles,
        getMyGroupsFeed      : getMyGroupsFeed,
        getMyPeopleFeed      : getMyPeopleFeed,
        getUserProfileFeed   : getUserProfileFeed,
        getAllChatterFeed	 : getAllChatterFeed,
        likeComment          : likeComment,
        likeFeed             : likeFeed,
        postComment          : postComment,
        postGroupFeedItem    : postGroupFeedItem,
        postNewsFeedItem     : postNewsFeedItem,
        postPersonFeedItem   : postPersonFeedItem,
        postSessionFeedItem  : postSessionFeedItem,
        unfollow             : unfollow,
        unlike               : unlike,
        searchFeedsByHashtag : searchFeedsByHashtag,

        //SESSIONS
        getMyObjectFeed    : getMyObjectFeed,
        getSessionFeed       : getSessionFeed,
        getSessionFollowers	 : getSessionFollowers,
        getSessionFiles      : getSessionFiles,

        // OTHER
        getNextPage         : getNextPage
    };

})(jQuery);
