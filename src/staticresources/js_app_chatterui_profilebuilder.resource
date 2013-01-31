ChatterUI.namespace('ChatterUI.ProfileBuilder');
ChatterUI.ProfileBuilder = (function($) {
    var templates = ChatterUI.Templates,
        $container,
        tabsCache = {},
        PHOTO_UPLOADING_CLASS = ChatterUI.FileManager.UPLOADING_CLASS,
        MAX_ABOUTME_LENGTH = 1000,
        MAX_PHONE_LENGTH = 40,
        MAX_TITLE_LENGTH = 80;
   
    /**
     * Builds a profile page with profile details, at me feed, followers,
     * following and groups.
     * @param container {HTMLElement, String} A DOM element or CSS Selector to contain the profile component.
     * @param id {String} The ID of the user to build the component.
     * @param options {object} A set of options to further refine the profile component.
     *  Valid options are:
     *      headerContainer {HTMLElement, String} A DOM element or CSS Selector, to contain the header for this component.
     *      useFeed {boolean} Flag marking if a feed is going to be used on this profile.
     *      feed {String} Method to retrieve the feed. @see ChatterUI.feeds.
     */
    function buildProfile(container, id, options) {
        options = options || {};
        ChatterUI.Service.getUserProfile(id, function(result, event) {
            var isError = false;
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                var userProfileResult = result,
                    $container,
                    $el;

                $container = $(container);
                $container.append($.tmpl(templates['profileWrapper'], {
                    id: id
                }));
                $el = $container.children('#profile-' + id);

                setupHeader(userProfileResult, options.headerContainer);
                
                var userAndContact = {
                        user: userProfileResult,
                        contact: {
                            anonEmail: ''
                        }
                    };
                if (ChatterUI.getEl('profile-' + id)) {
                    // Inject profile info
                    addProfile($el, userAndContact, options.updatedPhoto, options.originalPhotoInfo);
                    wireUI($el, userProfileResult, userAndContact.contact);
                }

                if (options.useFeed) {
                    ChatterUI.FeedBuilder.create('.profile-content-container', {feed: options.feed, postMethod: options.postMethod, feedParam: userProfileResult.id});
                    $('form.feed-post textarea.share').attr('placeholder', ChatterUI.defaults.profilePostFieldValue.replace('{user}', userProfileResult.name));
                }

            } else {
               isError = true;
            }
        });
    }

    function setupHeader(user, headerContainer) {
        if (headerContainer) {
            var pageTitle = (user.id == ChatterUI.UserContext.userId ? 'My' : 'User') + ' Profile';
            document.title = pageTitle;
            headerContainer.empty();
            headerContainer.html('<h3 class="flush truncate">' + pageTitle + '</h3>');

            if (user.id == ChatterUI.UserContext.userId){
                headerContainer.siblings('.bRight').append($.tmpl(templates['editProfileButton']));
            }
        }
    };

    function addProfile($el, profileInfo, updatedPhoto, originalPhotoInfo) {
        var user = profileInfo.user,
            contact = profileInfo.contact,
            markup = $.tmpl(templates['profileSummary'], {
                src:            user.photo.smallPhotoUrl,
                followText:     user.mySubscription === null ? 'Follow' : 'Following',
                followClass:    'follow-profile ' + (user.mySubscription === null ? 'follow-link' : 'unfollow-link'),
                follow:         user.mySubscription === null ? 'false' : 'true',
                followId:       user.mySubscription === null ? user.id : user.mySubscription.id,
                userId:         user.id,
                name:           user.name,
                title:          (user.title === null) ? '' : user.title,
                companyName:    (user.companyName === null) ? '' : user.companyName,
                email:          user.email,
                workPhoneHtml:      constructPhoneTemplate(user, 'Work'),
                cellPhoneHtml:      constructPhoneTemplate(user, 'Mobile'),
                aboutMeHtml:             getAboutMeHtml(user)
            });

        markup += $.tmpl(templates['profileActions'], {
            followersCountHtml: ChatterUI.formatTotal(user.followersCount + '', 'Follower', false, true),
            followingCountHtml: ChatterUI.formatTotal(user.followingCounts.people + '', 'Following', true, true),
            groupCountHtml:     ChatterUI.formatTotal(user.groupCount + '', 'Group', false, true)
        });

        $el.append(markup);
        configureActionItems(user);
        $el.append('<div class="profile-content-container"></div>');
        $container = $('div.profile-content-container');

        // check if the profile photo was updated and needs to be refreshed
        if (updatedPhoto && originalPhotoInfo.photoVersionId == user.photo.photoVersionId) {
            // the photo was updated but the new version isn't available yet
            var $imageEl = $el.find('div.detail-container div.foto img');
            $imageEl.parent().append('<span class="foto-refreshing"></span>');
            setTimeout(function() {
                refreshMyPhoto($imageEl, originalPhotoInfo.photoVersionId, 3);
            }, 500);
        }
    };

    function refreshMyPhoto($imageEl, oldPhotoVersionId, retries) {
        ChatterUI.Service.getMyPhoto(function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                var thisPhotoVersionId = result.photoVersionId,
                    isUpdatedPhoto = (thisPhotoVersionId != oldPhotoVersionId);

                if (isUpdatedPhoto) {
                    // got the new photo, update the src
                    $imageEl.attr('src', result.smallPhotoUrl);
                    $imageEl.parent().find('span.foto-refreshing').remove();

                } else if (retries > 0) {
                    retries--;
                    setTimeout(function() {
                        refreshMyPhoto($imageEl, oldPhotoVersionId, retries)
                    }, 500);

                } else {
                    // done trying to update the photo, remove the pending icon
                    $imageEl.parent().find('span.foto-refreshing').remove();
                }
            }
        });
    }

    function configureActionItems(user) {

        if (user.id == ChatterUI.UserContext.userId) {
            $('.actions .follow-link, .actions .unfollow-link, .actions .email').remove();
        } else {
            if(ChatterUI.UserContext.usingMobile) {
                checkIfUserIsAlreadyAContact(user);
            }
            $('.action-edit-profile.edit').remove();
        }
    }

    function checkIfUserIsAlreadyAContact(user) {
        var options = new ContactFindOptions();
        options.filter = user.name;
        var fields = ["name", "displayName"];
        navigator.contacts.find(fields, onFindSuccess, $Cloud.phonegapOnError, options);

         function onFindSuccess(contacts) {
            if (contacts.length == 0) {
                $('a.create-contact').show();
            }
        };
    }

    function constructPhoneTemplate(user, type) {
        var phone = getPhone(user, type, false);
        if (!phone) {
            return '';
        }
        return $.tmpl(templates['profileItem'], {
            contentHtml:   	'<span class="icons-profile icon' + type + '">'+phone+'</span>'
        });
    };

    function getPhone(user, type, textOnly) {
        var phoneNumbers = user.phoneNumbers,
            size = user.phoneNumbers.length;

        if(size === 0) {
            return '';
        }

        for(var i=0; i < size; ++i) {
            if (phoneNumbers[i].type === type) {
                return textOnly ? phoneNumbers[i].number : $.tmpl(templates['chatterLink'], {
                    className:  '',
                    target:     '',
                    link:       'tel:' + phoneNumbers[i].number,
                    text:       phoneNumbers[i].number
                });
            }
        }
        return '';
    };
         
    function getAboutMeHtml(user) {
        var aboutMe = user.aboutMe || '',
            defaultText,
            moreText,
            spacePos,
            maxChars = 400;

        if (!aboutMe || aboutMe.length <= maxChars) {
            aboutMe = ChatterUI.nl2p(ChatterUI.htmlEncode(aboutMe));
            return aboutMe;
        }

        defaultText = aboutMe.substring(0, maxChars);
        moreText = aboutMe.substring(maxChars);

        // only break on words...
        if (defaultText.charAt(maxChars) != ' ') {
            spacePos = defaultText.lastIndexOf(' ');
            moreText = defaultText.substring(spacePos) + moreText;
            defaultText = defaultText.substring(0, spacePos);
        }

        defaultText = ChatterUI.nl2p(ChatterUI.htmlEncode(defaultText));
        return defaultText + '<span class="user-about-more">' + moreText + '</span><span class="ellipse">...&nbsp;</span><a href="#" class="user-about-more-a">more</a>';
    };

    function wireUI($el, user, contact) {
        $('form.feed-post textarea.share').attr('placeholder', ChatterUI.defaults.profilePostFieldValue.replace('{user}', user.name));

        $('div.profile-container').on('click', 'a.create-contact', function(evt) {
            evt.preventDefault();

            var contact = navigator.contacts.create();
            contact.displayName = user.name;
            contact.nickname = user.name;

            // populate some fields
            var name = new ContactName();
            name.givenName = user.firstName;
            name.familyName = user.lastName;
            contact.name = name;

            var emails = [];
            emails[0] = new ContactField('work', user.email, true);
            contact.emails = emails;

            var photos = [];
            photos[0] = new ContactField('url', user.photo.largePhotoUrl, true);
            contact.photos = photos;

            // store contact phone numbers in ContactField[]
            var phoneNumbers = [];
            phoneNumbers[0] = new ContactField('work', getPhone(user, 'Work', true), false);
            phoneNumbers[1] = new ContactField('mobile', getPhone(user, 'Mobile', true), true); // preferred number
            contact.phoneNumbers = phoneNumbers;

            contact.save($Cloud.phonegapOnSuccess, $Cloud.phonegapOnError);
            $(this).hide();

        });

        // More link
        $('div.profile-container').on('click', 'a.user-about-more-a', function(){

            var $toggle = $el.find('span.user-about-more'),
                $this = $(this);
            if ($toggle.hasClass('expanded')){
                $toggle.removeClass('expanded');
                $toggle.hide('medium');
                $this.html('more');
                $this.siblings('span.ellipse').show();
            } else {
                $toggle.addClass('expanded');
                $toggle.show('medium');
                $this.html(' less');
                $this.siblings('span.ellipse').hide();
            }

            return false;
        });

        $('div.profile-container').on('click', 'a.feeds', function() {
            var $this = $(this),
                params = {
                    feed:       'getUserProfileFeed',
                    feedParam:  $el.attr('data-user-id'),
                    postMethod: 'postPersonFeedItem'
                };

            if ($this.hasClass('selected')) {
                return false;
            } else {
                $el.find('a.info-item').removeClass('selected');
                $this.addClass('selected');
            }
            ChatterUI.showLoadingMask();
            $('.profile-content-container').empty();
            ChatterUI.FeedBuilder.create('.profile-content-container', params);

            return false;
        });

        function handleFollowingTabs(element) {
            $this = $(element);
            if ($this.hasClass('selected')) {
                return false;
            }
            $('div.chatter-info-bar div.info-item-container a').removeClass('selected');
            $this.addClass('selected');

            $container.empty();
            if ($this.find('.total').text() != '0') {
                ChatterUI.showLoadingMask();
                var $list = $el.find('ul.people-list'),
                    filter = $this.hasClass('follower-total') ? 'followers' : 'following';
                if ($list.length > 0) {
                    $list.empty();
                } else {
                    $container.html(templates['peopleList']);
                    $list = $container.find('ul.people-list');
                }

                ChatterUI.PeopleListBuilder.buildList($container, $list, { user:$el.attr('data-user-id'), filter:filter, page:'profile' });
            }

            return false;
        }

        // build follower / following lists
        $('div.profile-container').on('click', 'a.following-total', function (evt) {
            evt.preventDefault();
            handleFollowingTabs(this);
        });
        $('div.profile-container').on('click', 'a.follower-total', function (evt) {
            evt.preventDefault();
            handleFollowingTabs(this);
        });

        // build group lists
        $('div.profile-container').on('click', 'a.group-total', function() {
            if ($(this).hasClass('selected')) {
                return false;
            }

            $('div.chatter-info-bar div.info-item-container a.info-item').removeClass('selected');
            $(this).addClass('selected');
            $('div#wrapper-main-chatter-feed').remove();
            if ($(this).find('.total').text() != '0') {
                ChatterUI.showLoadingMask();
                $container.empty();

                var $list = $container.find('div.list-container');

                if ($list.length > 0) {
                    $list.empty();
                }

                ChatterUI.GroupBuilder.buildGroup($container, null, {user: user.id, type: ChatterUI.GroupBuilder.TYPE_LIST, showSearch: false});
            }

            return false;
        });

        $('div.bBody').on('click', 'a.action-edit-profile.edit', function(evt) {
            $Cloud.scrollTop('panelScroller');
            var $editContainer = $('div.edit-profile-container');
            if (!$editContainer.length) {
                var fileUploadEnabled = ChatterUI.FileManager.isFileUploadEnabled(),
                    ieLt9 = ChatterUI.env.isIELt9(),
                    editForm = '';

                if (fileUploadEnabled) {
                    editForm = $.tmpl(templates['editPhotoWrapper'], {
                        className: 	'profile-img-upload ' + (ieLt9 ? 'clearfix' : 'form-post-container'),
                        photoFormHtml:	ieLt9 ? templates['ieEditPhotoForm'] : templates['editPhotoForm']
                    });
                }

                $el.prepend($.tmpl(templates['editProfile'], {
                    profilePhoto:	user.photo.smallPhotoUrl,
                    name:			user.name || '',
                    title:			user.title || '',
                    workPhone:		getPhone(user, 'Work', true),
                    mobilePhone:	getPhone(user, 'Mobile', true),
                    aboutMe:		user.aboutMe || '',
                    actionButtonHtml:	$.tmpl(templates['saveProfile'], {userId : user.id}),
                    editFormHtml:		ieLt9 ? '' : editForm,
                    ieEditFormHtml:		ieLt9 ? editForm : ''
                 }));
                $editContainer = $('div.edit-profile-container');
            }


            // save button
            $editContainer.on('click', 'a.save-profile', function() {
                saveProfile($(this), user.photo);
            });

            wirePhotoUploadContainer();
            $editContainer.slideDown();
            $('div.detail-container').slideUp(400, ChatterUI.refreshScroller);
            evt.preventDefault();
        });

        $('div.profile-container').on('click', '#close-edit-profile', function() {
            $('div.edit-profile-container').slideUp();
            $('div.detail-container').slideDown(400, ChatterUI.refreshScroller);
        });

        wireFollowLinks($('div.detail-container'));
    }

    function saveProfile($saveBtn, userPhotoInfo) {

        if ($saveBtn.hasClass('savingProfile')) {
            // wait for the original save to finish
            return false;
        }

        ChatterUI.showLoadingMask();

        $saveBtn.addClass('savingProfile');

        // gather values from the form to save
        var dataToSave = {
            Title:			$('input.job-title').val(),
            Phone: 			$('input.work-phone').val(),
            MobilePhone: 	$('input.mobile-phone').val(),
            AboutMe: 		$('textarea.about-me').val(),
            AnonEmail:      $('input.checkbox').is(':checked')
        };

        ChatterUIController.updateUserInfo(JSON.stringify(dataToSave), function(result, event) {
            if (event.status) {
                var resultJSON = JSON.parse(result);

                if (ChatterUI.isValidResponseEvent(resultJSON)) {
                    // check if the photo needs to be uploaded
                    var startedPhotoUpload = initPhotoUpload($saveBtn, userPhotoInfo);
                    if (!startedPhotoUpload) {
                        refreshProfileAfterSave(false);
                    }
                    ChatterUI.track('', 'edit-profile');
                }
                else if(resultJSON.statusDesc && resultJSON.statusDesc.indexOf('STRING_TOO_LONG') != -1){
                    ChatterUI.hideLoadingMask();
                    if(resultJSON.statusDesc.indexOf('[Title]') != -1) {
                        ChatterUI.showLengthErrorMessage('profile', 'Job Title', MAX_TITLE_LENGTH);
                    }
                    else if(resultJSON.statusDesc.indexOf('[Phone]') != -1) {
                        ChatterUI.showLengthErrorMessage('profile', 'Work Phone', MAX_PHONE_LENGTH);
                    }
                    else if(resultJSON.statusDesc.indexOf('[MobilePhone]') != -1) {
                        ChatterUI.showLengthErrorMessage('profile', 'Mobile Phone', MAX_PHONE_LENGTH);
                    }
                    else if(resultJSON.statusDesc.indexOf('[AboutMe]') != -1) {
                        ChatterUI.showLengthErrorMessage('profile', 'About Me', MAX_ABOUTME_LENGTH);
                    }
                    else {
                        ChatterUI.showGenericError();
                    }
                }
                else {
                    $Cloud.newModal({type: 'error', message: 'Error saving profile: '+resultJSON.statusDesc});
                }
            }
            $saveBtn.removeClass('savingProfile');

        }, {escape: false});
    }

    function refreshProfileAfterSave(updatedPhoto, originalPhotoInfo) {
        ChatterUI.hideLoadingMask();
        var $content = $('div.chatter-page');
        $content.empty();
        
        $('.edit-group-btn, .create-group-icon').remove();
        buildProfile($content, ChatterUI.UserContext.userId, {
                headerContainer: $('div.panelHeaderBar .bBody'),
                useFeed: true,
                feed: 'getUserProfileFeed',
                updatedPhoto: updatedPhoto,
                originalPhotoInfo: originalPhotoInfo});
    }

    function initPhotoUpload($actionBtn, originalPhotoInfo) {
        if ($actionBtn.hasClass(PHOTO_UPLOADING_CLASS) || ChatterUI.FileManager.validForUpload() == false) {
            // either the photo is already being uploaded and we need to wait for it to finish
            // or there's no file data specified for upload
            return false;
        }

        // file data was specified, start the upload
        if (ChatterUI.UserContext.usingMobile) {
            $actionBtn.addClass(PHOTO_UPLOADING_CLASS);

            ChatterUI.FileManager.uploadAttachmentForMobile(function(result, event) {
                if (ChatterUI.isValidResponseEvent(result)) {
                    // upload succeeded, associate the photo to the user
                    var photoId = result.fileId;
                    associatePhotoToUser(photoId, $actionBtn, originalPhotoInfo);

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
            ChatterUI.FileManager.setHandlers('ChatterUI.ProfileBuilder.associatePhotoToUser', 'ChatterUI.FileManager.handlePhotoUploadError');

            // this will be used in the callback function associatePhotoToGroup
            ChatterUI.FileManager.submitAfterUploadInfo = {
                actionBtn: $actionBtn,
                originalPhotoInfo: originalPhotoInfo
            };

            // start the upload, once done the iframe upload page will call the submit post function
            ChatterUI.FileManager.uploadAttachment();
            return true;
        }
        return false;
    }

    function associatePhotoToUser(photoId, $actionBtn, originalPhotoInfo) {
        var $actionBtn = $actionBtn || ChatterUI.FileManager.submitAfterUploadInfo.actionBtn,
            originalPhotoInfo = originalPhotoInfo || ChatterUI.FileManager.submitAfterUploadInfo.originalPhotoInfo;

        ChatterUI.Service.updateUserPhoto(photoId, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                // done with upload, refresh the page
                refreshProfileAfterSave(true, originalPhotoInfo);

            } else {
                // show error message
                $Cloud.newModal({type: 'error', message: 'Error updating photo: '+event.message});
            }

            ChatterUI.FileManager.resetUploadInfo($actionBtn);
        });
    }

    function wirePhotoUploadContainer() {
        var actionsContainer = $('div.profile-img-upload div.actions-bucket.' + (ChatterUI.UserContext.usingMobile ? 'mobile' : 'desktop')),
            iframeContainer = $('div.profile-img-upload'),
            section = 'profile';

        ChatterUI.FileManager.wirePhotoUploadContainer(actionsContainer, iframeContainer, section);
    }

    function wireFollowLinks($container) {

        $container.on('click', 'a.follow-link', handleFollowLinks);
        $container.on('click', 'a.unfollow-link', handleFollowLinks);

        function handleFollowLinks() {
            var $this = $(this),
                method = $this.attr('data-follow') == 'true' ? 'unfollow' : 'follow';

            if ($this.hasClass('pending')) {
                return false;
            } else {
                $this.addClass('pending');
            }

            ChatterUI.Service[method]($this.attr('data-id'), function(result, event) {
                var isError = false;
                if (event.status && ChatterUI.isValidResponseEvent(event)) {
                    var $total,
                        newTotal,
                        label,
                        skipPlural,
                        userId = $this.attr('data-user-id'),
                        currentHash = ChatterUI.getHash();

                    if (currentHash.page == 'people' || (currentHash.page == 'profile' && (currentHash.user == ChatterUI.UserContext.userId || !currentHash.user))) {
                        // my profile page; I can't follow myself or add followers for myself; must be following
                        // or people page; lists are mine; I can only add/remove following
                        label = 'Following';
                        $total = $('a.following-total');
                        skipPlural = true;
                    } else if (currentHash.page == 'profile' && currentHash.user == userId) {
                        // follow/unfollow someone via their profile page, so update their follower count
                        label = 'Follower';
                        $total = $('a.follower-total');
                        skipPlural = false;
                        if($total.hasClass('selected')) {
                            ChatterUI.PeopleListBuilder.buildList('', $('ul.people-list'), { user:userId, filter:'followers', page:'profile' });
                        }
                    } else {
                        // someone else's profile page, one of their followers/following, so do nothing
                        // or group page, which has no counts, so do nothing
                        label = '';
                    }
                    if ($total) {
                        newTotal = parseInt($total.find('span.total').html()) || 0;
                    }

                    if (result.id) {
                        // follow
                        $this.attr('data-follow', 'true').attr('data-id', result.id);

                        if ($this.hasClass('follow-profile')) {
                            $this.find('.text').text('Following');
                            $this.removeClass('follow-link').addClass('unfollow-link');
                        } else {
                            $this.removeClass('follow').addClass('following');
                        }
                        newTotal++;
                        ChatterUI.track('', 'follow');
                    } else {
                        // unfollow
                        $this.attr('data-follow', 'false').attr('data-id', $this.attr('data-user-id'))

                        if ($this.hasClass('follow-profile')) {
                            $this.find('.text').text('Follow');
                            $this.removeClass('unfollow-link').addClass('follow-link');
                        } else {
                            $this.removeClass('following').addClass('follow');
                        }
                        newTotal--;
                        ChatterUI.track('', 'unfollow');
                    }
                    if ($total) {
                        $total.html(ChatterUI.formatTotal(newTotal + '', label, skipPlural, true));
                    }
                    $this.removeClass('pending');
                } else {
                    isError = true;
                }

                if (isError) {
                    $Cloud.newModal({type: 'error', message: ChatterUI.escapeHtml($Cloud.GC.labels.genericRequestFailure)});
                }
            });

            return false;
        }
    }

    return {
        buildProfile                : buildProfile,
        wireFollowLinks             : wireFollowLinks,
        associatePhotoToUser        : associatePhotoToUser
    }
           
})(jQuery);
