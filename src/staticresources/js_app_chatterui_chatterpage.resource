ChatterUI.namespace('ChatterUI.ChatterPage');
ChatterUI.ChatterPage = (function($) {
    var templates = ChatterUI.Templates,
        lastHash,
        $content;

    $Cloud.pullToRefresh = function() {
        $Cloud.showLoadingMask();
        findState(true);
    };

    /**
     * configure a Chatter page w/ correct event handlers
     */
    function configPage() {
        $(document).on('ready', function() {
            var $sidebar = $('.sidebarRegList');
            $sidebar.find('a').first().addClass('current');

            $sidebar.on('click', 'a', function() {
                $sidebar.find('a.current').removeClass('current');
                $(this).addClass('current');
            });

            // only wire the history if this page is part of the Chatter UI
            $content = $('div.chatter-page');
            if ($content.length > 0) {
                // get current user profile
                ChatterUI.UserContext.userProfile = ChatterUI.getCurrentUserProfile();

                findState();
            }

            $('#refreshButton').on('click', $Cloud.pullToRefresh);

            $(window).hashchange(function() {
                findState();
            });
        });
    };

    function setupSidebar(section) {
        var $sidebar = $('ul.sidebarRegList'),
            selector = 'a[title="' + section + '"]';
        $sidebar.find('a.current').removeClass('current');
        $sidebar.find(selector).addClass('current');
    };

    function setupHeader(params) {
        var $topBar = $('div.panelHeaderBar .bBody');

        if (params.feed == 'getFeedsAtMe') {
            $topBar.html('<h3 class="flush truncate">@Me</h3>');
            document.title = '@Me';
        } else if (params.feed == 'getMyFilesFeed') {
            $topBar.html('<h3 class="flush truncate">Files Feed</h3>');
            document.title = 'Files Feed';
        } else if (params.feed == 'getAllChatterFeed') {
            $topBar.html('<h3 class="flush truncate">All Chatter</h3>');
            document.title = 'All Chatter';
        } else if (params.feed == 'searchFeedsByHashtag') {
            $topBar.html('<h3 class="flush truncate">Hashtag Feed</h3>');
            document.title = params.hashtag;
        } else if (params.feed == 'getMyObjectFeed') {
            $topBar.html('<h3 class="flush truncate">Object Feed</h3>');
            document.title = 'Object Feed';
        } else if (params.page == 'feeds') {
            $topBar.html('<h3 class="flush truncate">My Chatter</h3>');
            document.title = 'My Chatter';
        }

    };

    function findState(forceRefresh) {
        var params = ChatterUI.getHash(),
            currentHash = getCurrentHash(),
            options = {},
            $topBar = $('div.panelHeaderBar .bBody');

        $Cloud.showLoadingMask();
        $Cloud.scrollTop('panelScroller');

        if (forceRefresh || lastHash !== currentHash) {
            lastHash = currentHash;
            ChatterUI.FileManager.resetGlobalState();
            $('.edit-group-btn, .create-group-icon').remove();
            // get page settings
            switch (params.page) {
                case 'profile':
                    if (!params.user) {
                        params.user = ChatterUI.UserContext.userId;
                    }

                    $content.empty();
                    ChatterUI.ProfileBuilder.buildProfile($content, params.user, {
                        headerContainer:    $topBar,
                        useFeed:            true,
                        feed:               'getUserProfileFeed',
                        postMethod:         'postPersonFeedItem'
                    });
                    break;
                case 'people':
                    setupSidebar('People');
                    if (params.filter != 'followers') {
                        params.filter = 'following';
                    }
                    params.headerContainer = $topBar;
                    $content.empty().append($.tmpl(templates['peopleWrapper'], {
                        bodyHtml:  $.tmpl(templates['peopleSearch'], { listHtml: templates['peopleList'] })
                    }));
                    ChatterUI.PeopleListBuilder.buildList($('div.people-container'), $('ul.people-list'), params);
                    break;
                case 'groups':
                    setupSidebar('Groups');
                    params.page = 'groups';
                    var options = {headerContainer: $topBar}
                    $content.empty();
                    if (params.group) {
                        options.type = ChatterUI.GroupBuilder.TYPE_PROFILE;
                    } else {
                        options.type = ChatterUI.GroupBuilder.TYPE_LIST;
                        options.user = ChatterUI.UserContext.userId;
                        options.showCreate = true;
                        options.showSearch = true;
                    }
                    ChatterUI.GroupBuilder.buildGroup($content, params.group, options);
                    break;
                case 'files':
                    setupSidebar('Files Feed');
                    params.page = 'files';
                    params.feed = 'getMyFilesFeed';
                    $content.empty();
                    break;
                case 'objfeed':
                    setupSidebar('Object Feed');
                    params.page = 'objfeed';
                    params.feed = 'getMyObjectFeed';
                    $content.empty();
                    break;
                case 'feeds':
                default:
                    params.page = 'feeds';
                    $content.empty();
                    if (!params.feed) {
                        params.feed = 'getCurrentUserFeed';
                    }
                    if (params.feed == 'getCurrentUserFeed' || params.feed == 'getFeedsAtMe' || params.feed == 'getAllChatterFeed') {
                        params.postMethod = 'postNewsFeedItem';
                    }

                    if (params.feed == 'searchFeedsByHashtag') {
                        params.feedParam = params.hashtag;
                    }
                    if (params.feed == 'getFeedsAtMe') {
                        setupSidebar('@Me');
                    }
                    break;
            }

            setupHeader(params);
            if (params.feed) {
                ChatterUI.FeedBuilder.create($content, params);
            }

            ChatterUI.track(params);
        }
    }

    function getCurrentHash() {
        return (document.location.href.split("#")[1] || '');
    }

    configPage();

    return {
        lastHash       : lastHash,
        $content       : $content
    };

})(jQuery);
