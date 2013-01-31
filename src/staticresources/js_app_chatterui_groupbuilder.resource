ChatterUI.namespace('ChatterUI.GroupBuilder');
ChatterUI.GroupBuilder = (function($) {
    var templates = ChatterUI.Templates,
        currentGroup,
        groupMemberIds = [],
        photoStatus = {
            resetStatus: true
        },
        TYPE_PROFILE = 'profile',
        TYPE_LIST = 'list',
        PHOTO_UPLOADING_CLASS = ChatterUI.FileManager.UPLOADING_CLASS,
        ACTION_CREATE = 'create',
        ACTION_EDIT = 'edit',
        MAX_NAME_LENGTH = 40,
        MAX_DESCRIPTION_LENGTH = 1000;

    /**
     *   @param groupId - the groupId
     */
    function buildGroup(container, groupId, options) {

        var $container = $(container);
        options = options || {};
        setupHeader(options);
        if (photoStatus.resetStatus) {
            photoStatus = {
                updatedPhoto: false,
                newPhotoVersionId: null,
                currentPhotoVersionId: null,
                resetStatus: true
            };
        }

        if (options.type == TYPE_LIST) {
            showGroupsForUser(options.user, $container, options);
            ChatterUI.GroupBuilder.initEventHandlers();
            //group search nav
            $('div.group-search-container').on('click', 'a.info-item', function(evt) {
                evt.preventDefault();
                $(this).addClass('selected');
                ChatterUIController.getGroupsForUser(options.user, function (result, event) {
                    showGroupsHandler(result, event);
                    ChatterUI.GroupBuilder.initEventHandlers();
                }, {escape: false});
            });
        } else {
            ChatterUI.Service.getGroup(groupId, function(result, event) {
                if (event.status) {
                    if (ChatterUI.isValidResponseEvent(event)) {
                        $('div.group-container').remove();
                        showGroup(result, $container);
                        ChatterUI.GroupBuilder.initEventHandlers();
                    } else {
                       ChatterUI.showGenericError();
                    }
                }
            });
        }
    }

    /*
    * Setup the header bar.
    * @param Boolean - if true the create button will be shown - optional
    */
    function setupHeader(options) {
        var $topBar = $(options.headerContainer);
        if ($topBar) {
            $topBar.empty();
            document.title = 'Groups';
            $topBar.html('<h3 class="flush truncate bLeft">Groups</h3>');

            if(options.showCreate) {
                $topBar.siblings('.bRight').append($.tmpl(templates['addGroupBtn']));
            }else if (options.showEdit){
                $topBar.siblings('.bRight').append($.tmpl(templates['editGroupBtn']));
            }
        }
    };

    /**
    *   @param group - the Group
    */
    function showGroup(group, $container) {
        var groupHTML,
            groupActionHTML = '',
            actionButtonHTML,
            addRemoveButtonHTML = $.tmpl(templates['groupInfoBarBlankItem']),
            groupId = group.id || group.Id,
            isRestricted = !isGroupVisible(group);
        //store the current group so that we have access to it when switching views (feed, members, add/remove members)
        currentGroup = group;

        if (isGroupOwner(group)) {
            addRemoveButtonHTML = $.tmpl(templates['groupInfoBarAddMembers'], {groupId : groupId});
            setupHeader({
                headerContainer: $('div.panelHeaderBar .bBody'),
                showEdit : true
            });
            actionButtonHTML = '';
        }
        else if(hasRequestPending(group)) {
            actionButtonHTML = $.tmpl(templates['requestPending']);
        }
        else if (isRestricted) {
             actionButtonHTML = $.tmpl(templates['joinRequestGroupBtn'], {groupId : groupId});
        }
        else if (group.mySubscription === null) {
             actionButtonHTML = $.tmpl(templates['joinGroupBtn'], {groupId : groupId});
        }
        else {
            var memberId = (group.mySubscription) ? group.mySubscription.id : '';
            actionButtonHTML = $.tmpl(templates['leaveGroupBtn'], {memberId : memberId});
        }

        if(!isRestricted) {
            groupActionHTML += $.tmpl(templates['groupInfoBar'], {
                memberCountHtml : ChatterUI.formatTotal((group.memberCount || 1), 'Member'),
                groupId: groupId,
                addRemoveMembersHtml: addRemoveButtonHTML
            });
        }

        var groupDescHtml = ChatterUI.nl2p(ChatterUI.htmlEncode(group.description || group.Description || ''));
        groupHTML = $.tmpl(templates['groupSummary'], {groupPhotoURL : getPhoto(group),
            groupName : group.name || group.Name,
            groupDescHtml : (isRestricted) ? $.tmpl(templates['privateGroupDesc']) : groupDescHtml,
            groupActionButtonHtml : actionButtonHTML});

        $container.append($.tmpl(templates['group'], {
            groupSummaryHtml: groupHTML,
            groupInfoBarHtml: groupActionHTML,
            groupListContainerHtml: $.tmpl(templates['groupsList'])
        }));
        $('div.group-container').data('group', group);

        // check if the group photo was edited and needs to be refreshed
        checkGroupPhoto(groupId, group, $container);

        if(!isRestricted) {
            showGroupFeed(groupId);
        } else {
            ChatterUI.hideLoadingMask();
        }
    }

    function checkGroupPhoto(groupId, group, $container) {
        // set the current photo version from the group we're in
        photoStatus.currentPhotoVersionId = group.photo.photoVersionId;

        if (photoStatus.updatedPhoto && photoStatus.currentPhotoVersionId != photoStatus.newPhotoVersionId) {
            // the photo was just updated from group edit, but we're not showing the updated photo
            // refresh the photo
            var $imageEl = $container.find('div.detail-container div.foto img');
            $imageEl.parent().append('<span class="foto-refreshing"></span>');

            setTimeout(function() {
                refreshGroupPhoto(groupId, group, $imageEl, 3);
            }, 500);
        } else {
            photoStatus.resetStatus = true;
        }
    }

   /**
    *   @param group - the Group
    */
    function showGroupFeed(groupId) {
        $('div.group-container .list-container').empty();
        ChatterUI.FeedBuilder.create($('div.group-container .list-container'), { feed: 'getGroupFeed', postMethod: 'postGroupFeedItem', feedParam: groupId });

        if (currentGroup && currentGroup.name) {
            //placeholder text needs to be updated within this method so it happens whenever the group feed tab is selected.
            $('form.feed-post textarea.share').attr('placeholder', ChatterUI.defaults.groupPostFieldValue.replace('{group}', currentGroup.name));
        }
    }

    function showGroupFiles(groupId) {
        $('div.group-container .list-container').empty();
        ChatterUI.FeedBuilder.create($('div.group-container .list-container'), { feed: 'getGroupFiles', postMethod: 'postGroupFeedItem', feedParam: groupId, moreText: 'Show More Files...' });

        if (currentGroup && currentGroup.name) {
            //placeholder text needs to be updated within this method so it happens whenever the group feed tab is selected.
            $('form.feed-post textarea.share').attr('placeholder', ChatterUI.defaults.groupPostFieldValue.replace('{group}', currentGroup.name));
        }
    }

    function showGrouping(group, container) {
        var groupHTML, actionButtonHTML,
            groupId = group.Id || group.id,
            groupVisibilityIndicatorHTML = '';

        if(isGroupPrivate(group)) {
            groupVisibilityIndicatorHTML += $.tmpl(templates['groupPrivateIndicator']);
        }

        if (isGroupOwner(group)) {
            actionButtonHTML = '';
            groupVisibilityIndicatorHTML += $.tmpl(templates['groupOwnerIndicator'], {groupId : groupId});
        }
        else if(!isGroupVisible(group)) {
            actionButtonHTML = $.tmpl(templates['listJoinRequestBtn'], {groupId : groupId});
        }
        else if (group.mySubscription === null || !group.GroupMembers) {
             actionButtonHTML = $.tmpl(templates['listJoinGroupBtn'], {groupId : groupId});
        }
        else {
            var memberId = (group.GroupMembers) ? group.GroupMembers[0].Id : '';
            actionButtonHTML = $.tmpl(templates['listLeaveGroupBtn'], {memberId : memberId,
                 groupId : groupId,
                 isPrivate : "" + isGroupPrivate(group)});
        }

        groupHTML = $.tmpl(templates['groupListItem'], {groupPhotoURL : getPhoto(group),
            groupId : groupId,
            groupName : (group.name || group.Name),
            groupDesc : ChatterUI.ellipsify((group.description || group.Description || ''), 95),
            visibilityIndicatorsHtml : groupVisibilityIndicatorHTML,
            groupActionButtonHtml : actionButtonHTML});

        container.append(groupHTML);
    }

    function showGroupingHeader(headerText) {
        var $groupContainer = $('div.list-container');
        $listRow = $groupContainer.find('.list').last();

        if (!$listRow.length) {
            $groupContainer.append(templates['groupsListRow']);
            $listRow = $groupContainer.find('.list').last();
        }

        ChatterUI.PeopleListBuilder.showCategoryHeader(headerText, $listRow);
        return $listRow;
    }

    /**
    * Renders the Group members section.
    */
    function displayMemberSection() {
        var $groupContainer = $('div.group-container'),
            $groupListContainer = $groupContainer.find('div.list-container'),
            $groupMemberList,
            group = $groupContainer.data('group');

        $groupListContainer.show().empty();
        $groupContainer.find('div.list-container').replaceWith($.tmpl(templates['peopleList']));
        $groupMemberList = $groupListContainer.find('ul.list');

        var $groupMembersContainer;
        if(isGroupOwner(group) && isGroupPrivate(group)) {
            showPendingRequests(group.id);
        }
        else {
            showGroupMembers(group.id, $groupMemberList);
        }
    }

    /**
     * Displays the add / remove group members section
     * @param groupId - the id of the current group
     */
    function showAddRemoveMembers(groupId) {
        var $listRow,
            $searchResultsList,
            $groupListContainer = $('div.group-container div.list-container');

        $groupListContainer.html($.tmpl(templates['peopleSearch'], {
            listHtml: templates['peopleList']
        }));

        $searchResultsList = $groupListContainer.find('div.search-results-container');
        $groupListContainer.find('div.people-search-container').append($.tmpl(templates['addRemoveSubTab'], {memberCount : (currentGroup.memberCount || 1)}));
        $groupListContainer.find('.add-member-nav a').addClass('selected');

        $listRow = $('ul.list').last();

        $groupListContainer.on('click', '.add-member-nav a', function(){
            var $target = $(this);
            if($target.hasClass('selected')) {
                return false;
            }

            var $listRow = $('ul.list').last();
            $listRow.empty();
            $groupListContainer.find('div.search-results-header').empty();
            showGroupMembers(groupId, $listRow, {'showRemove': true});
            $target.addClass('selected');

            $('ul.people-list').off('click', 'a.follow-link').on('click', 'a.follow-link', handleAddRemoveLinks);
               $('ul.people-list').off('click', 'a.unfollow-link').on('click', 'a.unfollow-link', handleAddRemoveLinks);

            return false;
        });

        ChatterUI.SearchManager.wireSearch($groupListContainer.find('.people-search-container'), $('ul.people-list'), ChatterUI.Service.searchPeopleByName, ChatterUI.PeopleListBuilder.wireSearchResults, {
            listProp: 			'users',
            hideTypeAhead:		true,
            leaveTabsSelected:	true,
            clickHandler:		function($input, $results) {
                showAddRemoveLinks($searchResultsList);
                $groupListContainer.find('.add-member-nav a').removeClass('selected');
            }
        });

        showGroupMembers(groupId, $listRow, {'showRemove': true});

           //rebind join group handlers to add/remove.
           $('ul.people-list').off('click', 'a.follow-link').on('click', 'a.follow-link', handleAddRemoveLinks);
           $('ul.people-list').off('click', 'a.unfollow-link').on('click', 'a.unfollow-link', handleAddRemoveLinks);
    }

    function showAddRemoveLinks($container) {
        $container = $container || $('ul.people-list');
        $container.find('a.follow-link').each( function(index) {
            if ($.inArray($(this).attr('data-user-id'), groupMemberIds) != -1) {
                $(this).addClass('remove-from-group').attr('data-group-id', currentGroup.id);
            } else {
                $(this).addClass('add-to-group').attr('data-group-id', currentGroup.id);
            }

            $(this).off('click').on('click', handleAddRemoveLinks);
        });

    }

    function handleAddRemoveLinks() {
        var $target = $(this);

        if($target.hasClass('remove-from-group')) {
            ChatterUIController.removeUserFromGroup(currentGroup.id, $target.attr('data-user-id'), function (result, event) {
                if (ChatterUI.isValidResponseEvent(event)) {
                    updateMemberTotal($('div.add-member-nav'), -1);

                    $target.removeClass('remove-from-group').addClass('add-to-group');
                }
                else {
                    $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml(event.message)});
                }
            }, {escape: false});
        } else if($target.hasClass('add-to-group')) {
            ChatterUI.Service.joinGroup(currentGroup.id, $target.attr('data-user-id'), function(result, event) {
                if (event.status) {
                    if (ChatterUI.isValidResponseEvent(event)) {
                        updateMemberTotal($('div.add-member-nav'), 1);

                        $target.removeClass('add-to-group').addClass('remove-from-group');
                    }
                    else {
                      ChatterUI.showGenericError();
                    }
                }
            });
        }

        return false;
    }

    function updateMemberTotal($container, additionalMemberCount) {
       var $total = $container.find('span.total'),
           newTotal;
       newTotal = (parseInt($total.text()) || 1) + additionalMemberCount;
       if (currentGroup) {
           currentGroup.memberCount = newTotal;
       }
       $total.html(newTotal);
       $('#show-group-members').html(ChatterUI.formatTotal(newTotal, 'Member'));
    }

    /**
     * Requests the group members and adds them to the page
     * @param groupId - the id of the current group
     * @param $listContainer - The container to add the group members to
     * @param options {object} Optional set of options to further refine the member component.
     *  Valid options are:
     *      showRemove {boolean} Flag indicating to show the remove member action.
     */
    function showGroupMembers(groupId, $listContainer, options) {
        options = options || {};
        ChatterUI.Service.getGroupMembers(groupId, function(result, event) {
            ChatterUI.hideLoadingMask();
            if (event.status) {
                var handler, ownerId;
                $listContainer.show();
                if (ChatterUI.isValidResponseEvent(event)) {
                    groupMemberIds = [];
                    ownerId = (currentGroup.owner) ? currentGroup.owner.id : '';
                    for(var i = 0; i < result.members.length; i++) {
                        if (result.members[i].user.id == ownerId) {
                            result.members[i].user.isGroupOwner = true;
                        }
                        groupMemberIds.push(result.members[i].user.id);
                    }
                    if(options.showRemove) {
                        handler = showAddRemoveLinks;
                    }
                    ChatterUI.PeopleListBuilder.showGroupMembers($('ul.people-list'), result, handler);

                    if(!options.showRemove) {
                        ChatterUI.ProfileBuilder.wireFollowLinks($('ul.people-list'));
                    }

                    ChatterUI.refreshScroller();
                }
                else {
                    ChatterUI.showGenericError();
                }
            }
        });
    }

    /**
    * Requests pending members for the current group and adds them to the page
    * @param groupId - the id of the current group
    */
    function showPendingRequests(groupId) {
        ChatterUIController.getPendingGroupRequests(groupId, function(result, event) {
            ChatterUI.hideLoadingMask();
            if (event.status) {
                if (ChatterUI.isValidResponseEvent(event)) {
                    var pendingRequests = result,
                        $listRow;

                    if(pendingRequests.length > 0) {
                        $listRow = showGroupingHeader("Pending Requests");

                        for (var i = 0; i < pendingRequests.length; i++) {
                            ChatterUI.PeopleListBuilder.addPersonWithPendingRequest($listRow, pendingRequests[i].requester, pendingRequests[i].requestId);
                        }
                        $listRow = showGroupingHeader("Members");
                    }
                    else {
                        var $groupListContainer = $('div.group-container div.list-container');
                        $listRow = $groupListContainer.find('.list').last();
                    }
                    showGroupMembers(groupId, $listRow);
                    wireRequestApproval();
                }
                else {
                    ChatterUI.showGenericError();
                }
            }
        });
    }

    function wireGroupMenuBar() {
        $('div.group-info-bar').on('click', 'a.info-item', function(evt) {
            evt.preventDefault();
            var $target = $(this),
                groupId = $target.attr('data-group-id'),
                method = $target.attr('data-method');

            if($target.hasClass('selected')) {
                return;
            }
            ChatterUI.showLoadingMask();
            $target.closest('.group-info-bar').find('.selected').removeClass('selected');
            $target.addClass('selected');

            if (ChatterUI.GroupBuilder[method]) {
                ChatterUI.GroupBuilder[method](groupId);
            }
        });
    }

    /**
    * Displays the groups that a user belongs to
    * @param userId  (optional) the target user. Defaults to the current user.
    */
    function showGroupsForUser(userId, $container, options) {
        userId = userId || ChatterUI.UserContext.userId;

        ChatterUIController.getGroupsForUser(userId, function (result, event) {
            showGroupsHandler(result, event);
        }, {escape: false});

        $container.append($.tmpl(templates['groupsSearchWrapper'], {
            listHtml: templates['groupsList']
        }));

        var $searchContainer = $container.find('div.group-search-container');
        if (!options.showSearch) {
                $searchContainer.remove();
        } else {
            ChatterUI.SearchManager.wireSearch(
                $searchContainer, $('ul.list'), 
                function(searchTerm, callback) {
                    // Need this layer of indirection to set escape to false for apex remote calls.
                    ChatterUIController.searchGroupsByName(searchTerm, callback, {escape: false});
                },
                ChatterUI.GroupBuilder.buildGroupList, {listProp: 'groups'}
            );
            ChatterUI.SearchManager.showResultSummary();
        }
    }

    function buildGroupList($groupList, $resultList, resultJSON, options) {
        var groupContainer,
            groupHeaders = [];

        if ($resultList) {
            for (var i=0; i<resultJSON.groups.length; i++) {
                var group = resultJSON.groups[i];
                $resultList.append($.tmpl(templates['searchResult'], {
                    className:  i == 0 ? 'selected' : '',
                    id:     	group.Id,
                    user:   	ChatterUI.escapeHtml(group.Name),
                    url:    	'#page=groups&group=' + group.Id,
                    text:   	group.Name,
                    src:    	getPhoto(group)
                }));
            }
        }

        $('div.list-container ul').empty();

        $.each(resultJSON.mappedGroups, function(grouping) {
            groupHeaders.push(grouping);
        });
        groupHeaders.sort();

        for(var i = 0; i < groupHeaders.length; i++) {
            var grouping = groupHeaders[i];
            groupContainer = showGroupingHeader(grouping);

            $.each(resultJSON.mappedGroups[grouping], function(group) {
                showGrouping(resultJSON.mappedGroups[grouping][group], groupContainer);
            });
        }

        ChatterUI.refreshScroller();
        ChatterUI.hideLoadingMask();
    }

    function showGroupsHandler(result, event) {
        if (event.status && ChatterUI.isValidResponseEvent(event)) {
            buildGroupList('', '', result, {});
        } else {
            ChatterUI.showGenericError();
        }
    }

    /**
    * Sets up event handler for the join group button
    */
    function wireJoin() {
        //Detail page buttons
        $('div.group-container').off('click', '.join-group').on('click', '.join-group', function(evt) {
            var groupId = $(this).attr('data-group-id');

            ChatterUI.Service.joinGroup(groupId, ChatterUI.UserContext.userId, function(result, event) {
                joinHandler(result, event);
            });
            evt.preventDefault();
        });
        //List view buttons
        $('div.list-container').off('click', '.join-group').on('click', '.join-group', function(evt) {
            var $target = $(this),
                groupId = $target.attr('data-group-id');

            ChatterUI.Service.joinGroup(groupId, ChatterUI.UserContext.userId, function(result, event) {
                listItemJoinHandler(result, event, $target);
            });
            evt.preventDefault();
        });

        function handleJoinRequest(element) {
            var $target = $(element),
                groupId = $target.attr('data-group-id');

            ChatterUIController.requestToJoinPrivateGroup(groupId, function(result, event) {
                joinRequestHandler(result, event, $target);
            });
        };

        //request buttons
        $('div.group-container').on('click', '.join-request-group', function(evt) {
            evt.preventDefault();
            handleJoinRequest(this);
        });
        $('.list-container').on('click', '.join-request-group',  function(evt) {
            evt.preventDefault();
            handleJoinRequest(this);
        });
    }

    /**
    * Sets up event handler for the leave group button
    */
    function wireLeave() {
        //Detail page buttons
        $('div.group-container').off('click', '.leave-group').on('click', '.leave-group', function(evt) {
            var groupMemberId = $(this).attr('data-member-id');

            ChatterUI.Service.leaveGroup(groupMemberId, function(result, event) {
                leaveHandler(result, event);
            });
            evt.preventDefault();
        });
        //List view buttons
        $('div.list-container').off('click', '.leave-group').on('click', '.leave-group', function(evt) {
            var $target = $(this),
                groupMemberId = $target.attr('data-member-id');

            ChatterUI.Service.leaveGroup(groupMemberId, function(result, event) {
                listItemLeaveHandler(result, event, $target);
            });
            evt.preventDefault();
        });
    }

    /**
    * Sets up event handler for the add group button
    */
    function wireAdd() {
        $(document).on('click', '#create-group-btn', function(evt) {
            $Cloud.scrollTop('panelScroller');
            var $groupContainer = $('div.create-group-container'),
                ieLt9 = ChatterUI.env.isIELt9(),
                editPhotoForm = getEditPhotoForm();
            if (!$groupContainer.length) {
                $('div.chatter-page').prepend($.tmpl(templates['createGroup'], { defaultGroupImage : '/profilephoto/0F9/F',
                    action:			'Create ',
                    actionButtonHtml:	$.tmpl(templates['createGroupBtn']),
                    name:			'',
                    description:	'',
                    type:			'Public',
                    className:		'',
                    classicLink:    'display-none',
                    editFormHtml:		ieLt9 ? '' : editPhotoForm,
                    ieEditForm:		ieLt9 ? editPhotoForm : ''
                }));
                $groupContainer = $('div.create-group-container');
            }

            wireCreate();
            wirePhotoUploadContainer();

            $groupContainer.slideDown(400, ChatterUI.refreshScroller);
            evt.preventDefault();
        });
    }

    function wirePhotoUploadContainer() {
        var actionsContainer = $('div.group-img-upload div.actions-bucket.' + (ChatterUI.UserContext.usingMobile ? 'mobile' : 'desktop')),
            iframeContainer = $('div.group-img-upload'),
            section = 'group';

        ChatterUI.FileManager.wirePhotoUploadContainer(actionsContainer, iframeContainer, section);
    }

    function refreshGroupPhoto(groupId, group, $imageEl, retries) {
        var oldPhotoVersionId = photoStatus.currentPhotoVersionId;

        ChatterUI.Service.getGroupPhoto(groupId, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                var thisPhotoVersionId = result.photoVersionId,
                    isUpdatedPhoto = (thisPhotoVersionId != oldPhotoVersionId);

                if (isUpdatedPhoto) {
                    // got the new photo, update the src
                    $imageEl.attr('src', result.smallPhotoUrl);
                    $imageEl.parent().find('span.foto-refreshing').remove();

                    // reset the photo object on the group, this will be used to refresh the photo in the Edit container if the user clicks Edit again
                    group.photo = result;
                    photoStatus.newPhotoVersionId = result.photoVersionId;
                    photoStatus.currentPhotoVersionId = result.photoVersionId;

                    // indicates the photoStatus will be reset next time the group markup is built
                    photoStatus.resetStatus = true;

                } else if (retries > 0) {
                    retries--;
                    setTimeout(function() {
                        refreshGroupPhoto(groupId, group, $imageEl, retries)
                    }, 500);

                } else {
                    // done trying to update the photo, remove the pending icon
                    $imageEl.parent().find('span.foto-refreshing').remove();
                }
            }
        });
    }

    /**
    * Sets up event handler for the edit group button
    */
    function wireEdit() {
        $('div.bBody').on('click', 'a.action-edit-group', function(evt) {
            $Cloud.scrollTop('panelScroller');
            var $groupContainer = $('div.create-group-container'),
                group = currentGroup,
                isPrivate =  isGroupPrivate(group),
                ieLt9 = ChatterUI.env.isIELt9(),
                editPhotoForm = getEditPhotoForm();

            if (!$groupContainer.length) {
                $('div.chatter-page').prepend($.tmpl(templates['createGroup'], { defaultGroupImage : getPhoto(group),
                    action:			'Edit',
                    actionButtonHtml:	$.tmpl(templates['saveGroupBtn'], {groupId : group.id}),
                    name:			group.name || '',
                    groupId:        group.id || '',
                    description:	group.description || '',
                    type:			isPrivate ? 'Private' : 'Public',
                    className:		isPrivate ? 'on' : '',
                    classicLink:    '',
                    editFormHtml:		ieLt9 ? '' : editPhotoForm,
                    ieEditForm:		ieLt9 ? editPhotoForm : ''
                }));
                $groupContainer = $('div.create-group-container');

            } else {
                // refresh the group photo in case it changed
                $groupContainer.find('div.photo-container img').attr('src', getPhoto(group));
            }

            wireCreate();
            wirePhotoUploadContainer();

            $groupContainer.slideDown();
            $('div.detail-container').slideUp(400, ChatterUI.refreshScroller);
            evt.preventDefault();
        });
    }

    /**
    * Sets up event handler for the create / edit group button
    */
    function wireCreate() {
        wireSliders();
        $('div.create-group-container').on('click', 'a.create-group', function() {
            var $createGroupContainer = $('form.create-group-form'),
                $groupNameEl = $createGroupContainer.find('.group-name'),
                $groupDescEl = $createGroupContainer.find('.group-desc'),
                groupName = $groupNameEl.val(),
                groupDesc = $groupDescEl.val(),
                isPublic = !$('div.create-group-container .slider-cta').hasClass('on'),
                $createBtn = $(this);

            if ($createBtn.hasClass('savingGroup')) {
                // wait for the original save to finish
                return false;
            }
            ChatterUI.showLoadingMask();
            $createBtn.addClass('savingGroup');
            $groupNameEl.val(groupName);
            $groupDescEl.val(groupDesc);

            if($(this).attr('data-method') == 'create') {
                ChatterUIController.createGroup(groupName, groupDesc, ChatterUI.UserContext.userId, isPublic, function (result, event) {
                    createHandler(result, event, $createBtn);
                }, {escape: false});

            } else {
                ChatterUIController.editGroup($(this).attr('data-id'), groupName, groupDesc, isPublic, function (result, event) {
                    editHandler(result, event, $createBtn);
                }, {escape: false});
            }
        });
    }

    function wireSliders() {
        $('span.slider-cta').off('click').on('click', function(){
            var $this = $(this);
            if($this.hasClass('on')) {
                $this.removeClass('on').html('Public');
            } else {
                $this.addClass('on').html('Private');
            }
        });
    }

    function wireRequestApproval() {
        $('div.list-container a.request-link').on('click', function(evt) {
            var requestId = $(this).attr('data-id'),
                requestType = $(this).attr('data-request');

            $selectedListItem = $(this).closest('.list-item');

            if(requestType == 'approve') {
                ChatterUIController.approveGroupMemberRequest(requestId, function (result, event) {
                    var resultJSON = JSON.parse(result);
                    if (ChatterUI.isValidResponseEvent(resultJSON)) {
                        updateMemberTotal($('div.group-info-bar'), 1);
                        displayMemberSection();
                    }
                    else {
                        ChatterUI.showGenericError();
                    }
                }, {escape: false});
            }
            else if (requestType == 'deny') {
                ChatterUIController.denyGroupMemberRequest(requestId, function (result, event) {
                    var resultJSON = JSON.parse(result);
                    if (ChatterUI.isValidResponseEvent(resultJSON)) {
                        $selectedListItem.fadeOut().remove();
                    }
                    else {
                        ChatterUI.showGenericError();
                    }
                }, {escape: false});
            }
            evt.preventDefault();
        });
    }

    function joinHandler(result, event) {
        if (event.status) {
            if (ChatterUI.isValidResponseEvent(event)) {
                $('div.group-container .actions').html($.tmpl(templates['leaveGroupBtn'], {memberId : result.id}));
                updateMemberTotal($('div.group-info-bar'), 1);

                if ($('#show-group-members').hasClass('selected')) {
                    displayMemberSection();
                }

                ChatterUI.track('', 'join-group');
            }
            else {
                ChatterUI.showGenericError();
            }
        }
    }

    function joinRequestHandler(result, event, $target) {
        if (event.status) {
            if (ChatterUI.isValidResponseEvent(event)) {
                $target.replaceWith($.tmpl(templates['requestPending']));
                ChatterUI.track('', 'join-group-request');
            }
            else {
                ChatterUI.showGenericError();
            }
        }
    }

    function listItemJoinHandler(result, event, $target) {
        if (event.status) {
            if (ChatterUI.isValidResponseEvent(event)) {
                $target.replaceWith($.tmpl(templates['listLeaveGroupBtn'], {
                    memberId : result.id,
                    groupId : $target.attr('data-group-id'),
                    isPrivate : false
                }));
                ChatterUI.track('', 'join-group');
            }
            else {
              ChatterUI.showGenericError();
            }
        }
    }

    function listItemLeaveHandler(result, event, $target) {
        if (ChatterUI.isValidResponseEvent(event)) {
            if ($target.attr('data-group-private') == "true") {
                $target.replaceWith($.tmpl(templates['listJoinRequestBtn'], {groupId : $target.attr('data-group-id')}));
            } else {
                $target.replaceWith($.tmpl(templates['listJoinGroupBtn'], {groupId : $target.attr('data-group-id')}));
            }

            ChatterUI.track('', 'leave-group');
        }
        else {
            $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml(event.message)});
        }
    }

    function leaveHandler(result, event) {
        if (ChatterUI.isValidResponseEvent(event)) {
            var params = ChatterUI.getHash();
            if (isGroupPrivate(currentGroup)) {
                buildGroup($('div.chatter-page'), params.group);
            } else {
                $('div.group-container .actions').html($.tmpl(templates['joinGroupBtn'], {groupId : params.group}));
                updateMemberTotal($('div.group-info-bar'), -1);
                if ($('#show-group-members').hasClass('selected')) {
                    displayMemberSection();
                }
            }
            ChatterUI.track('', 'leave-group');
        }
        else {
            $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml(event.message)});
        }
    }

    function closeCreateGroupSection() {
       $('div.create-group-container').slideUp();
       $('div.detail-container').slideDown(400, ChatterUI.refreshScroller);
    }

    function initPhotoUpload(groupId, $actionBtn, action) {
        if ($actionBtn.hasClass(PHOTO_UPLOADING_CLASS) || ChatterUI.FileManager.validForUpload() == false) {
            // either the photo is already being uploaded and we need to wait for it to finish
            // or there's no file data specified for upload
            photoStatus.updatedPhoto = false;
            return false;
        }

        // file data was specified, start the upload
        if (ChatterUI.UserContext.usingMobile) {
            $actionBtn.addClass(PHOTO_UPLOADING_CLASS);

            ChatterUI.FileManager.uploadAttachmentForMobile(function(result, event) {
                if (ChatterUI.isValidResponseEvent(result)) {
                    // upload succeeded, associate the photo to the group
                    var photoId = result.fileId;
                    associatePhotoToGroup(photoId, groupId, action, $actionBtn);

                } else {
                    // show error, reset the file data
                    ChatterUI.FileManager.handleUploadError(event.message, ChatterUI.FileManager.TYPE_PHOTO, $actionBtn);
                }
            });
            return true;

        } else {
            // photo upload for desktop
            $actionBtn.addClass(PHOTO_UPLOADING_CLASS);

            // set the callback handlers
            ChatterUI.FileManager.setHandlers('ChatterUI.GroupBuilder.associatePhotoToGroup', 'ChatterUI.FileManager.handlePhotoUploadError');

            // this will be used in the callback function associatePhotoToGroup
            ChatterUI.FileManager.submitAfterUploadInfo = {
                groupId: groupId,
                action: action,
                actionBtn: $actionBtn
            };

            // start the upload, once done the iframe upload page will call the submit post function
            ChatterUI.FileManager.uploadAttachment();
            return true;
        }
        return false;
    }

    /**
     * Associates the specified photo to the specified group. Called after creating or editing a group.
     * @param photoId - the id of the photo that was uploaded
     * @param groupId - the id of the group to associate the photo to
     * @param $actionBtn - the button element that invoked the save action for creating/editing
     */
    function associatePhotoToGroup(photoId, groupId, actionType, $actionBtn) {
        var groupId = groupId || ChatterUI.FileManager.submitAfterUploadInfo.groupId,
            action = actionType || ChatterUI.FileManager.submitAfterUploadInfo.action,
            $actionBtn = $actionBtn || ChatterUI.FileManager.submitAfterUploadInfo.actionBtn;

        ChatterUI.Service.updateGroupPhoto(groupId, photoId, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                // done with upload, take the next action for showing the new or edited group

                photoStatus.resetStatus = false;
                photoStatus.updatedPhoto = true;
                photoStatus.newPhotoVersionId = result.photoVersionId;

                if (action == ACTION_CREATE) {
                    navigateToNewGroup(groupId);
                } else {
                    navigateToEditedGroup(groupId);
                }

            } else {
                // show error message
                $Cloud.newModal({type: 'error', message: 'Error updating photo: '+event.message});
            }

            ChatterUI.FileManager.resetUploadInfo($actionBtn);
        });
    }

    /**
     * Navigates to the new group that was just created
     * @param groupId - the id of the group that was created
     */
    function navigateToNewGroup(groupId) {
        closeCreateGroupSection();
        ChatterUI.hideLoadingMask();
        document.location.hash = '#page=groups&group='+ groupId;
    }

    /**
     * Navigates to the group that was just edited
     * @param groupId - the id of the group that was edited
     */
    function navigateToEditedGroup(groupId) {
        closeCreateGroupSection();
        ChatterUI.hideLoadingMask();
        var options = {
            feed: 'getGroupFeed',
            type: TYPE_PROFILE
        }
        $('.edit-group-btn, .create-group-icon').remove();
        buildGroup($('div.chatter-page'), groupId, options);
    }

    function createHandler(result, event, $actionBtn) {
        if (event.status) {
            var resultJSON = JSON.parse(result);
            if (ChatterUI.isValidResponseEvent(resultJSON)) {
                var groupId = resultJSON.Id;

                // check if the photo needs to be uploaded
                var startedPhotoUpload = initPhotoUpload(groupId, $actionBtn, ACTION_CREATE);
                if (!startedPhotoUpload) {
                    navigateToNewGroup(groupId);
                }
                ChatterUI.track('', 'create-group');
            }
            else {
                handleGroupUpsertError(resultJSON);
                ChatterUI.hideLoadingMask();
            }

            $actionBtn.removeClass('savingGroup');
        }
    }

    function editHandler(result, event, $actionBtn) {
        if (event.status) {
            var resultJSON = JSON.parse(result);

            if (ChatterUI.isValidResponseEvent(resultJSON)) {
                var groupId = resultJSON.Id;

                // check if the photo needs to be uploaded
                var startedPhotoUpload = initPhotoUpload(groupId, $actionBtn, ACTION_EDIT);
                if (!startedPhotoUpload) {
                    navigateToEditedGroup(groupId);
                }
                ChatterUI.track('', 'edit-group');
            }
            else {
                handleGroupUpsertError(resultJSON);
                ChatterUI.hideLoadingMask();
            }

            $actionBtn.removeClass('savingGroup');
        }
    }

    function handleGroupUpsertError(resultJSON) {
        if(resultJSON.statusDesc && resultJSON.statusDesc.indexOf('DUPLICATE_VALUE') != -1) {
            $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml('Error: Group name is already taken. Choose a unique group name.')});
        }
        else if(resultJSON.statusDesc && resultJSON.statusDesc.indexOf('STRING_TOO_LONG') != -1 && resultJSON.statusDesc.indexOf('[Name]') != -1) {
            ChatterUI.showLengthErrorMessage('group', 'Name', MAX_NAME_LENGTH);
        }
        else if(resultJSON.statusDesc && resultJSON.statusDesc.indexOf('STRING_TOO_LONG') != -1 && resultJSON.statusDesc.indexOf('[Description]') != -1) {
            ChatterUI.showLengthErrorMessage('group', 'Description', MAX_DESCRIPTION_LENGTH);
        }
        else if(resultJSON.statusDesc && resultJSON.statusDesc.indexOf('field is required') != -1) {
            $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml('Missing required field')});
        }
        else {
            ChatterUI.showGenericError();
        }
    }

    function initEventHandlers() {
        $(document).on('click', '#close-create-group-btn', closeCreateGroupSection);

        wireGroupMenuBar();
        wireAdd();
        wireEdit();
        wireJoin();
        wireLeave();
        wireRequestApproval();
    }

    function getPhoto(group) {
        return (group.photo) ? group.photo.smallPhotoUrl : (group.SmallPhotoUrl || '/profilephoto/0F9/T')
    }

    function getEditPhotoForm() {
        if (ChatterUI.FileManager.isFileUploadEnabled()) {
            var ieLt9 = ChatterUI.env.isIELt9();

            return $.tmpl(templates['editPhotoWrapper'], {
                className: 	'group-img-upload ' + (ieLt9 ? 'clearfix' : 'form-post-container'),
                photoFormHtml:	ieLt9 ? templates['ieEditPhotoForm'] : templates['editPhotoForm']
            });
        }
        return '';
    }

    /**
    * Determines if the current user is the group owner
    * @param - the group
    * @return - Boolean
    */
    function isGroupOwner(group) {
        return (group.myRole == "GroupOwner" || group.OwnerId == ChatterUI.UserContext.userId);
    }

    /**
    * Determines if the the group is private
    * @param - the group
    * @return - Boolean
    */
    function isGroupPrivate(group) {
        return (group.visibility == "PrivateAccess" || group.CollaborationType == 'Private');
    }

    /**
    * Determines if the current user has a pending request to join the group
    * @param - the group
    * @return - Boolean
    */
    function hasRequestPending(group) {
        return (group.myRole == "NotAMemberPrivateRequested");
    }

    /**
    * Determines if the the group is visible to the current user
    * @param - the group
    * @return - Boolean
    */
    function isGroupVisible(group) {
        return  (!isGroupPrivate(group) || group.mySubscription || group.GroupMembers);
    }

    return {
        initEventHandlers       : initEventHandlers,
        buildGroup              : buildGroup,
        buildGroupList			: buildGroupList,
        showGroup               : showGroup,
        showAddRemoveMembers	: showAddRemoveMembers,
        displayMemberSection    : displayMemberSection,
        showGroupFeed           : showGroupFeed,
        showGroupFiles          : showGroupFiles,
        showGroupsForUser       : showGroupsForUser,
        associatePhotoToGroup   : associatePhotoToGroup,
        TYPE_PROFILE            : TYPE_PROFILE,
        TYPE_LIST               : TYPE_LIST
    };

})(jQuery);
