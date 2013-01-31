ChatterUI.namespace('ChatterUI.Templates');
if (!ChatterUI.Templates) {
    ChatterUI.Templates = {};
}

ChatterUI.Templates = (function($, templates) {

    return ChatterUI.addTemplates(templates, {
        'feedsWrapper': '<div id="wrapper-#{id}" class="feed-component">#{{formHtml}}' +
                            '<div class="feed-container">' +
                                '<ul class="feed-list" id="#{id}" data-method="#{method}" data-feed-param="#{param}"></ul>' +
                                '<div class="more-container"><a id="more-#{id}" href="#" class="cta more-items bg-gradient-3" data-url="#{url}">#{moreText}</a></div>' +
                            '</div>' +
                        '</div>',
        'feedForm':     '<div class="form-post-container post-img-upload">' +
                            '<div class="post-actions-container">' +
                                '<div class="actions-bucket mobile display-none">' +
                                    '<a href="" class="icon-close">&nbsp;</a>' +
                                    '<a class="box bg-gradient-1 camera" href="" onclick="return false;"><span class="icon-camera"></span><span class="icon-label">Take A Picture</span></a>' +
                                    '<a class="box bg-gradient-1 gallery" href="" onclick="return false;"><span class="icon-gallery"></span><span class="icon-label">Use Existing</span></a>' +
                                '</div>' +
                                '<div class="actions-bucket desktop display-none">' +
                                    '<a href="" class="icon-close">&nbsp;</a>' +
                                    '<div class="inline-block iframeContainer">' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<form class="form-post feed-post" data-feed-id="#{id}" data-method="#{postMethod}" data-param="#{param}">' +
                                '<a href="#" class="post-menu border-1 #{hideFileUpload}"><span class="#{uploadIcon}"></span></a>' +
                                '<input type="button" value="Share" class="button radius-1 bg-gradient-4 border-3" tabindex="2" />' +
                                '<div class="form-post-input border-1">' +
                                    '<textarea maxlength="1000" class="textarea-input share" placeholder="" tabindex="1"></textarea>' +
                                    '<div class="mobilePhotoTitle"></div>' +
                                    '<div class="search-results">' +
                                        '#{{listContainerHtml}}' +
                                    '</div>' +
                                '</div>' +
                            '</form>' +
                        '</div>',
        'chatterLink':  '<a href="#{link}" target="#{target}" class="#{className}">#{text}</a>',
        'feedLinkIcon': '<a href="#{link}" class="#{className}"><span class="icon"></span></a>',
        'feedItem':     '<li id="item-#{id}" class="#{className} clearfix" data-item-id="#{id}">' +
                                '<div class="item-container clearfix">' +
                                    '<div class="item-foto">' +
                                        '<a href="#{fotolink}"><img alt="" src="#{src}"></a>' +
                                    '</div>#{{metaHtml}}' +
                                    '<div class="item-name">' +
                                        '<h2>#{{nameHtml}}</h2>' +
                                        '<div class="item-date"><span class="meta-text">#{date} at #{time}</span></div>' +
                                    '</div>' +
                                    '<div class="item-body">' +
                                            '#{{msgHtml}}' +
                                            '#{{attachmentHtml}}' +
                                    '</div>' +
                                '</div>' +
                                '#{{commentSummaryHtml}}' +
                                '#{{commentsHtml}}' +
                            '</li>',
        'itemMeta':        '<div class="action-items">' +
                                '<div class="action-item">' +
                                    '#{{deleteLinkHtml}}' +
                                '</div>' +
                                '<div class="action-item like radius-1">' +
                                    '<a href="#" data-like-id="#{likeId}" data-item-id="#{itemId}" class="#{type} #{current}"><span class="icon"></span></a>' +
                                    '<span class="meta-text">#{{likesHtml}}</span>' +
                                '</div>' +
                            '</div>',
        'commentSummary':  '<div class="clearfix action-items comments">' +
                                '<div class="action-item comment #{current}">' +
                                    '<span class="meta-text">#{{totalHtml}}</span>' +
                                '</div>' +
                                '<div class="action-item">#{{allHtml}}</div>' +
                            '</div>',
        'image':            '<div class="preview-image">' +
                                '<image src="#{src}" class="#{className}" />' +
                            '</div>',
        'viewLargeImage':	'<div align="center"><img src="#{src}"/></div>',
        'fileIconImage':    '<div class="fileTypeIcon #{fileTypeClass}"></div>',
        'commentForm':     '<li class="comment-item post add-comment clearfix">' +
                                '<div class="item-container clearfix">' +
                                    '<div class="item-foto comment">' +
                                        '<img alt="" src="#{src}">' +
                                    '</div>' +
                                    '<div class="form-post-container comment clearfix">' +
                                        '<form class="form-post feed-post comment-post" data-method="postComment" data-param="#{id}" data-feed-id="#{feedId}">' +
                                            '<div class="form-post-input radius-1">' +
                                                '<textarea maxlength="1000" class="textarea-input" placeholder="#{defaultValue}"></textarea>' +
                                                '<div class="search-results">' +
                                                    '#{{listContainerHtml}}' +
                                                '</div>' +
                                            '</div>' +
                                            '<input type="button" id="post-#{id}" class="button radius-1 bg-gradient-4 border-3" value="Comment"/>' +
                                        '</form>' +
                                    '</div>' +
                                '</div>' +
                            '</li>',
        'fileUploadIframe': '<iframe src="/apex/ChatterUIFileUpload?section=#{section}" id="ChatterUIFileIFrame" name="ChatterUIFileIFrame" frameborder="0" scrolling="no" height="#{height}" width="#{width}" allowTransparency="true"></iframe>',
        'editPhotoWrapper':	'<div class="#{className}">#{{photoFormHtml}}</div>',
        'editPhotoForm':	'<div class="post-actions-container">' +
                                  '<div class="actions-bucket mobile display-none">' +
                                      '<a class="box bg-gradient-1 camera" href="" onclick="return false;"><span class="icon-camera"></span></a>' +
                                      '<a class="box bg-gradient-1 gallery" href="" onclick="return false;"><span class="icon-gallery"></span></a>' +
                                    '<div class="mobilePhotoTitle"></div>' +
                                '</div>' +
                                '<div class="actions-bucket desktop display-none">' +
                                    '<div class="display-none iframeContainer"></div>' +
                                    '<div class="desktopPhotoTitle"></div>' +
                                '</div>' +
                            '</div>',
        'ieEditPhotoForm':	'<label>Upload photo</label><br/>' +
                            '<div class="display-none iframeContainer"></div>',
        'followButton':		'<div class="actions">' +
                                '<a class="call-to-action border-1 #{followClass}" data-id="#{followId}" data-record-id="#{recordId}" data-follow="#{follow}" href="#"><span class="text hide-under-480">#{followText}</span></a>' +
                            '</div>',
        'searchMessage':	'<li><span class="message">#{msg}</span></li>',
        'mobileSearchMessage': '<option>#{msg}</option>',
        'searchHeader':		'Results for <strong>#{term}</strong>#{noResults}',
        'longPostMessage':	'<div class="long-message">Your message must be under 1000 characters.</div>',
        'groupingHeader':   '<li class="list-header clearfix #{className}">#{headerText}</li>'
    });

})(jQuery, ChatterUI.Templates);
