ChatterUI.namespace('ChatterUI.Templates');
if (!ChatterUI.Templates) {
    ChatterUI.Templates = {};
}

ChatterUI.Templates = (function($, templates) {

    return ChatterUI.addTemplates(templates, {
        'addRemoveSubTab':	'<div class="add-member-nav">' +
                                '<a class="selected" data-method="members" href="#">Members (<span class="total">#{memberCount}</span>)</a>' +
                            '</div>',
        'createGroup':      '<div class="create-group-container edit-container">' +
                                '<a id="close-create-group-btn" class="icon-close" href="javascript:void(0);"></a>' +
                                '<div class="photo-container clearfix">' +
                                    '<h1>#{action} group</h1>' +
                                    '<img class="border-1" src="#{defaultGroupImage}"/>' +
                                    '#{{editFormHtml}}' +
                                '</div>' +
                                '<div class="form-container">' +
                                    '<div class="fields-container">' +
                                        '<form class="create-group-form">' +
                                            '<label>Group Name</label>' +
                                            '<input class="group-name radius-1 border-1" type="text" value="#{name}" placeholder="Enter a group name" /><br />' +
                                            '<label>Description</label>' +
                                            '<textarea class="group-desc radius-1 border-1" rows="9" placeholder="Enter a brief description" >#{description}</textarea>' +
                                        '</form>' +
                                    '</div>' +
                                    '#{ieEditForm}' +
                                '</div>' +
                                '<div class="actions clearfix">' +
                                    '<a class="f-left meta-text margin-top-10 block #{classicLink}" href="/_ui/core/chatter/groups/GroupProfilePage?g=#{groupId}">Advanced Edit</a>' +
                                    '#{{actionButtonHtml}}' +
                                    '<div class="slider-container border-button radius-1 bg-gradient-3">' +
                                        '<span class="slider-cta #{className}">#{type}</span>' +
                                    '</div>' +
                                    '<input type="hidden" id="slider" value="false">' +
                                '</div>' +
                            '</div>',

        'createGroupBtn': '<a class="cta bg-gradient-4 create-group" data-method="create">Save</a>',
        'saveGroupBtn': '<a class="cta bg-gradient-4 create-group" data-method="edit" data-id="#{groupId}">Save</a>',
        'editGroupBtn':   '<a class="cta bg-gradient-4 edit-group-btn action-edit-group bg-gradient-5"><span class="icon-edit"></span>Edit</a>',
        'groups':           '<div class="groups-container">' +
                                '<a id="create-group-btn" href="#">(Create Group Image)</a>' +
                            '</div>',
        'group':            '<div class="group-container">' +
                                '<div class="detail-container clearfix">#{{groupSummaryHtml}}</div>' +
                                '#{{groupInfoBarHtml}}' +
                                '#{{groupListContainerHtml}}' +
                            '</div>',
        'groupSummary':     '<div class="foto border-1">' +
                                '<img src="#{groupPhotoURL}"/>' +
                            '</div>' +
                            '<div class="actions">' +
                            '#{{groupActionButtonHtml}}' +
                            '</div>' +
                            '<div class="user-name">' +
                                '<h1>#{groupName}</h1>' +
                                '<h2>#{{groupDescHtml}}</h2>' +
                            '</div>',
        'privateGroupDesc': '<span class="icon-info"></span> This group is private, only members can view updates.',
        'groupInfoBar':     '<div class="chatter-info-bar group-info-bar clearfix">' +
                                '<div class="info-item-container">' +
                                    '<a id="show-group-feed" class="info-item selected" data-method="showGroupFeed" data-group-id="#{groupId}" href="#"><span>&nbsp;</span>Feed</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '<a id="show-group-members" class="info-item" data-method="displayMemberSection" data-group-id="#{groupId}" href="#">#{{memberCountHtml}}</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '<a id="show-group-files" class="info-item" data-method="showGroupFiles" data-group-id="#{groupId}" href="#"><span>&nbsp;</span>Files</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '#{{addRemoveMembersHtml}}' +
                                '</div>' +
                            '</div>',
        'groupInfoBarAddMembers':'<a id="add-remove-members" class="info-item last" data-method="showAddRemoveMembers" data-group-id="#{groupId}" href="#"><span class="line-break">Add/Remove</span> People</a>',
        'groupInfoBarBlankItem':'<span class="info-item last">&nbsp;</span>',
        'groupsSearchWrapper':    '<div class="group-search-container clearfix chatter-info-bar">' +
                                '<div class="search-container">' +
                                    '<form class="form-post group-search type-ahead">' +
                                        '<div class="form-post-input border-1 radius-1">' +
                                            '<input type="text" maxlength="1000" class="search-input" placeholder="Search groups..."/>' +
                                        '</div>' +
                                        '<div class="icon-mag-glass"></div>' +
                                        '<div class="icon-clear"></div>' +
                                    '</form>' +
                                    '<div class="search-results">' +
                                        '<ul></ul>' +
                                    '</div>' +
                                '</div>' +
                                '<div class="info-container">' +
                                    '<div class="info-item-container last">' +
                                        '<a href="#" class="info-item selected">My Groups</a>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '#{{listHtml}}',
        'groupsList':       '<div class="list-container">' +
                                '<div class="search-results-header"></div>' +
                                '<ul class="list clearfix"></ul>' +
                            '</div>',
        'groupsListRow':	'<ul class="list clearfix"></ul>',
        'groupListItem':    '<li class="list-item">' +
                                '<div class="list-foto border-1">' +
                                    '<a href="#page=groups&group=#{groupId}">' +
                                        '<img src="#{groupPhotoURL}"/>' +
                                    '</a>' +
                                    '#{{visibilityIndicatorsHtml}}' +
                                '</div>' +
                                '#{{groupActionButtonHtml}}' +
                                '<div class="list-name">' +
                                    '<a href="#page=groups&group=#{groupId}">' +
                                        '<h3>#{groupName}</h3>' +
                                        '<span class="title">#{groupDesc}</span>' +
                                    '</a>' +
                                '</div>' +
                            '</li>',
        'groupOwnerIndicator': '<span class="icon-owner"></span>',
        'groupPrivateIndicator': '<span class="icon-private"></span>',
        'listJoinGroupBtn':'<a data-member-id="#{memberId}" data-group-id="#{groupId}" class="follow-link display-none border-button radius-1 follow join-group" href="#"></a>',
        'listLeaveGroupBtn':'<a data-member-id="#{memberId}" data-group-id="#{groupId}" data-group-private="#{isPrivate}" class="follow-link display-none border-button radius-1 following leave-group" href="#"></a>',
        'listAddToGroupBtn':'<a data-user-id="#{userId}" data-group-id="#{groupId}" class="follow-link display-none border-button radius-1 follow add-to-group" href="#"></a>',
        'listRemoveFromGroupBtn':'<a data-user-id="#{userId}" data-group-id="#{groupId}" class="follow-link display-none border-button radius-1 following remove-from-group" href="#"></a>',
        'listJoinRequestBtn':'<a data-group-id="#{groupId}" class="cta bg-gradient-4 join-request-group cta-position"><span class="icon-plus"></span><span class="text hide-under-480">Ask to Join</span></a>',
        'groupingHeader':   '<li class="list-header clearfix#{className}">#{headerText}</li>',
        'addGroupBtn':   	'<a id="create-group-btn" class="cta create-group-icon bg-gradient-5" href="#"><span class="icon-group"></span>New</a>',
        'joinGroupBtn':     '<a data-group-id="#{groupId}" class="bg-gradient-4 join-group cta"><span class="icon-plus"></span><span class="text hide-under-480">Join Group</span></a>',
        'leaveGroupBtn':    '<a data-member-id="#{memberId}" class="bg-gradient-1 cta leave-group" href="#"><span class="icon-minus"></span><span class="text hide-under-480">Leave Group</span></a>',
        'joinRequestGroupBtn':     '<a data-group-id="#{groupId}" class="cta bg-gradient-4 join-request-group"><span class="icon-plus"></span><span class="text hide-under-480">Ask to Join</span></a>',
        'requestPending':    '<div class="request-pending"><span class="icon-pending" title="request pending"></span>Request Pending</div>'
    });

})(jQuery, ChatterUI.Templates);
