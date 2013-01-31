ChatterUI.namespace('ChatterUI.Templates');
if (!ChatterUI.Templates) {
    ChatterUI.Templates = {};
}

ChatterUI.Templates = (function($, templates) {

    return ChatterUI.addTemplates(templates, {
        'profileWrapper':   '<div id="profile-#{id}" data-user-id="#{id}" class="profile-container clearfix"></div>',
        'profileItem':      '<li class="item">#{{contentHtml}}</li>',
        'editProfile':      '<div class="edit-profile-container edit-container clearfix">' +
                                '<a id="close-edit-profile" class="icon-close" href="javascript:void(0);"></a>' +
                                '<div class="photo-container clearfix">' +
                                    '<h1>Edit profile</h1>' +
                                    '<img class="border-1" src="#{profilePhoto}"/>' +
                                    '#{{editFormHtml}}' +
                                '</div>' +
                                '<div class="form-container edit-profile-form">' +
                                    '<div class="fields-container">' +
                                        '<form>' +
                                            '<div class="clearfix">' +
                                                '<div class="fields-bucket">' +
                                                    '<label>Job Title</label>' +
                                                    '<input type="text" class="job-title border-1" value="#{title}" placeholder="Enter your job title" /><br />' +
                                                    '<label>Mobile Phone</label>' +
                                                    '<input type="tel" pattern="[\\+]?[\\d\\s]*" class="mobile-phone border-1" value="#{mobilePhone}" placeholder="Enter your mobile phone" /><br />' +
                                                '</div>' +
                                                '<div class="fields-bucket">' +
                                                    '<label>Work Phone</label>' +
                                                    '<input type="tel" pattern="[\+]?[\\d\\s]*" class="work-phone border-1" value="#{workPhone}" placeholder="Enter your work phone" /><br />' +
                                                '</div>' +
                                            '</div>' +
                                            '<div>' +
                                                '<label>About Me</label>' +
                                                '<textarea class="about-me border-1" rows="9" placeholder="Enter a short description about yourself" >#{aboutMe}</textarea>' +
                                            '</div>' +
                                        '</form>' +
                                    '</div>' +
                                    '#{{ieEditFormHtml}}' +
                                '</div>' +
                                '<div class="actions">' +
                                    '<a class="f-left meta-text margin-top-10 block" href="/_ui/core/userprofile/UserProfilePage">Advanced Edit</a>' +
                                    '#{{actionButtonHtml}}' +
                                '</div>' +
                            '</div>',
        'saveProfile':      '<a class="cta bg-gradient-4 border-button radius-1 save-profile" data-method="edit" data-id="#{userId}">Save</a>',
        'editProfileButton':'<a class="cta bg-gradient-5 edit-group-btn action-edit-profile edit" href="#"><span class="icon-edit"></span>Edit</a>',
        'profileSummary':   '<div class="detail-container clearfix">' +
                                '<div class="foto border-1">' +
                                    '<img alt="User Photo" src="#{src}"/>' +
                                '</div>' +
                                '<div class="actions">' +
                                    '<a class="call-to-action border-1 #{followClass}" data-id="#{followId}" data-user-id="#{userId}" data-follow="#{follow}" href="#"><span class="text hide-under-480">#{followText}</span></a>' +
                                    '<a class="call-to-action border-1 create-contact display-none" href="#"><span class="text hide-under-480">Create Contact</span></a>' +
                                '</div>' +
                                '<div class="user-name">' +
                                    '<h1>#{name}</h1>' +
                                    '<h2>#{title}</h2>' +
                                    '<h3>#{companyName}</h3>' +
                                '</div>' +
                                '<div class="user-details">' +
                                    '<ul class="user-info">' +
                                        '<li class="item first">' +
                                            '<a class="icons-profile iconEmail" href="mailto:#{email}">#{email}</a>' +
                                        '</li>' +
                                        '#{{workPhoneHtml}}' +
                                        '#{{cellPhoneHtml}}' +
                                    '</ul>' +
                                    '<div class="user-about-container clearfix">' +
                                        '#{{aboutMeHtml}}' +
                                    '</div>' +
                                '</div>' +
                            '</div>',
        'profileActions':  '<div class="chatter-info-bar clearfix">' +
                                '<div class="info-item-container">' +
                                    '<a class="info-item feeds selected" href="#"><span>&nbsp;</span>Feed</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '<a class="info-item follower-total" href="#">#{{followersCountHtml}}</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '<a class="info-item following-total" href="#">#{{followingCountHtml}}</a>' +
                                '</div>' +
                                '<div class="info-item-container">' +
                                    '<a class="info-item last group-total" href="#">#{{groupCountHtml}}</a>' +
                                '</div>' +
                            '</div>'
    });

})(jQuery, ChatterUI.Templates);
