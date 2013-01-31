ChatterUI.namespace('ChatterUI.FeedItemBuilder');
ChatterUI.FeedItemBuilder = (function($) {
    var maxComments = 3,
        templates = ChatterUI.Templates;

    function addItem(item, $el, reload) {
        reload = reload || false;
        var isGroup = ($el.attr('data-method') == 'getGroupFeed' || $el.attr('data-method') == 'getGroupFiles'),
        isSession = ($el.attr('data-method') == 'getSessionFiles');

        if ((isSession || isGroup) && ($el.attr('data-feed-param') != item.parent.id)) {
            return false;
        }

        var totalComments = parseInt(item.comments.total),
            markup = $.tmpl(templates['feedItem'], {
                id:                 item.id,
                className:          'feed-item',
                date:               formatDate(ChatterUI.sDate(item.createdDate)),
                time:               formatTime(ChatterUI.sDate(item.createdDate)),
                nameHtml:               getPostNameHtml(item, isGroup),
                src:                item.photoUrl,
                fotolink:           getPostLink(item, isGroup),
                metaHtml:               $.tmpl(templates['itemMeta'], {
                                        type:      'post',
                                        likesHtml:      ChatterUI.formatTotal(item.likes),
                                        likeId:     item.isLikedByCurrentUser ? item.myLike.id : '',
                                        itemId:     item.id,
                                        current:    item.isLikedByCurrentUser ? ' me' : '',
                                        deleteLinkHtml:	isDeletable(item) ? $.tmpl(templates['feedLinkIcon'], {
                                                        link:		'#',
                                                        className:	'action-item delete'
                                                    }) : ''
                                    }),
                msgHtml:                formatMsg(item.body.messageSegments, item.id),
                attachmentHtml:         formatAttachment(item),
                commentSummaryHtml:     $.tmpl(templates['commentSummary'], {
                                        current:    '',
                                        totalHtml:      ChatterUI.formatTotal(item.comments, 'Comment', false, true),
                                        allHtml:        (totalComments > maxComments || totalComments > item.comments.comments.length) ? $.tmpl(templates['chatterLink'], {
                                                        className:	'show-all meta-text',
                                                        link:      	'',
                                                        text:      	'Show all',
                                                        target:    	''
                                                    }) : ''
                                    }),
                commentsHtml:           formatComments(item, $el.attr('id'))

            });

        if (reload) {
            $el.prepend(markup);
        } else {
            $el.append(markup);
        }

        wireUI(item, totalComments);

        return true;
    }

    function addComment(item, $el, reload) {
        reload = reload || false;
        var $comments = $el.find('#item-' + item.feedItem.id + ' ul.comment-list'),
            markup = getCommentMarkup(item, 0);
        if (reload) {
            updateCommentTotal($el.find('#item-' + item.feedItem.id), 1);
        }
        $(markup).insertBefore($comments.find('li.add-comment'));

        // file
        wireAttachment(item, $('#item-' + item.id));

        ChatterUI.refreshScroller();
    }

    function isDeletable(item, parent) {
        if (item.isDeleteRestricted) {
            return false;
        } else {
            var feedItem = parent ? parent : item;
            if (feedItem.actor && feedItem.actor.id === ChatterUI.UserContext.userId) {
                // my post
                return true;
            } else if (feedItem.user && feedItem.user.id === ChatterUI.UserContext.userId) {
                // my comment
                return true;
            } else if (feedItem.parent.myRole && feedItem.parent.myRole === 'GroupOwner') {
                // my group
                return true;
            }
        }

        return false;
    }

    function isInternalLink(link) {
        if (link.indexOf(ChatterUI.env.baseUrl) > -1) {
            return true;
        }
        return false;
    }

    function wireUI(feedItem, total) {
        var id = feedItem.id,
            $item = $('#item-' + id),
            $comment = $item.find('li.add-comment'),
            $like = $item.find('div.like');

        // like button
        $item.on('click', 'div.like a', function() {
            var $this = $(this),
                prop = 'data-like-id',
                idParam = $this.attr(prop),
                method;
            if ($this.hasClass('liking')) {
                return false;
            } else {
                $this.addClass('liking');
            }
            if (idParam) {
                method = 'unlike';
            } else {
                idParam = $this.attr('data-item-id');
                method = $this.hasClass('comment') ? 'likeComment' : 'likeFeed';
            }
            likeItem(idParam, prop, method, $this);
            return false;
        });

        // link handling
        $item.on('click', '.msg-link', function(evt) {
            var href = $(this).attr('href');
            if (ChatterUI.UserContext.usingMobile && !isInternalLink(href)) {
                evt.preventDefault();
                javascript:ChatterUI.FileManager.openLinkForMobile(href);
            }
        });

        // delete
        $item.on('click', 'a.delete', function() {
            var method = 'deleteFeedItem',
                $comment = $(this).parents('li.comment-item'),
                isComment = $comment.length > 0,
                deleteId = id;

            if (confirm('Are you sure you want to delete this ' + (isComment ? 'comment' : 'post') + '?')) {
                if (isComment > 0) {
                    deleteId = $comment.attr('data-item-id');
                    method = 'deleteComment';
                }

                deleteItem(deleteId, method, $item, $comment);
            }
            return false;
        });

        if (total) {
            // show all comments
            $item.on('click', 'a.show-all', function(){
                var $this = $(this);
                if (!$this.hasClass('expanded')){
                    getAllComments($item);
                    $this.addClass('expanded').hide();
                    $this.parents('li.feed-item').find('li.comment-item').show('medium');
                }

                return false;
            });
        }

        // hide/show comment buttons
        $comment.on('focus', 'textarea.textarea-input', function(){
            $comment.find('div.item-foto').show();
            $comment.find('input.button').show();
        }).on('blur', 'textarea.textarea-input', function() {
            if (!$(this).val()) {
                ChatterUI.PostBuilder.blurCommentField($comment);
            }
        });

        // posting comments
        $comment.find('form.comment-post').each(function() {
            ChatterUI.PostBuilder.wireSubmit($(this), 'addComment');
        });

        // line wrapping on text areas
        ChatterUI.FeedBuilder.wireTextAreas($('#item-' + id).find('form.comment-post'));

        // file
        wireItemAttachments(feedItem, $item);
    }

    function wireItemAttachments(feedItem, $item) {
        // wire initial feed item attachment
        wireAttachment(feedItem, $item);

        var totalComments = parseInt(feedItem.comments.total);
        if (totalComments > 0) {
            for (var i=0; i<feedItem.comments.comments.length; i++) {
                var commentItem = feedItem.comments.comments[i];
                if (commentItem.attachment) {
                    wireAttachment(commentItem, $('#item-' + commentItem.id));
                }
            }
        }
    }

    function wireAttachment(feedItem, $item) {
        var att = feedItem.attachment;
        if (att) {
            if (ChatterUI.FileManager.isFileEligibleForPreview(att, ChatterUI.sDate(feedItem.createdDate))) {
                var $previewImg = $item.find('div.preview-image img'),
                    selector = '.large-preview';
                if (!$item.hasClass('comment-item')) {
                    selector += ':not(li.comment-item .large-preview)';
                }

                $previewImg.error(function() {
                    ChatterUI.FileManager.handleBadThumbnailImage($previewImg, att);
                });

                $previewImg.load(function() {
                    ChatterUI.FileManager.handleValidThumbnailImage($previewImg, att);
                });

                $item.on('click', selector, function() {
                    if (!ChatterUI.UserContext.usingMobile) {
                        // cloud model with large image
                        var largeImgMarkupHtml = $.tmpl(templates['viewLargeImage'], {
                            src: ChatterUI.FileManager.getLargeFilePreviewURL(att)
                        });

                        $Cloud.newModal({message: largeImgMarkupHtml, renderHTML: true, heading: att.title},true,function(){
                            $('#simplemodal-container .buttonContainer').css('position','absolute');
                        });

                        $('#simplemodal-container .buttonContainer').css('position','static');
                    }
                });
            }
            if (ChatterUI.UserContext.usingMobile) {
                // wire the download link
                $item.on('click', 'div.preview-image img', function(evt) {
                    evt.preventDefault();
                    ChatterUI.FileManager.openAttachmentForMobile(att);
                });

                $item.on('click', 'a.pg-dl', function(evt) {
                    evt.preventDefault();
                    ChatterUI.FileManager.openAttachmentForMobile(att);
                });
            }
        }
    }

    function likeItem(id, prop, method, $this) {
        ChatterUI.Service[method](id, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                $this.removeClass('liking');
                var $meta = $this.siblings('span.meta-text:first'),
                    total = parseInt($meta.find('span.total').html()) || 0,
                    isComment = $this.hasClass('comment');

                if ($this.hasClass('me')) {
                    $this.attr(prop, '');
                    $this.removeClass('me');
                    total--;
                    $meta.html(total == 0 ? '' : ChatterUI.formatTotal((total + '')));

                    ChatterUI.track('', 'unlike-' + (isComment ? 'comment' : 'post'));
                } else {
                    $this.attr(prop, result.id);
                    $this.addClass('me');
                    total++;
                    $meta.html(ChatterUI.formatTotal((total + '')));

                    ChatterUI.track('', 'like-' + (isComment ? 'comment' : 'post'));
                }
            } else {
                ChatterUI.showGenericError();
            }
        });
    }

    function deleteItem(id, method, $item, $comment) {
        ChatterUI.Service[method](id, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                var isComment = false;
                if ($comment.length > 0) {
                    updateCommentTotal($item, -1);
                    $comment.remove();
                    isComment = true;
                } else {
                    $item.remove();
                }

                ChatterUI.track('', 'delete-' + (isComment ? 'comment' : 'post'));
                ChatterUI.refreshScroller();
            } else {
                ChatterUI.showGenericError();
            }
        });
    }

    function getCommentMarkup(item, i, parent) {
        return $.tmpl(templates['feedItem'], {
            id:             item.id,
            date:      		formatDate(ChatterUI.sDate(item.createdDate)),
            time:      		formatTime(ChatterUI.sDate(item.createdDate)),
            className:      'comment-item' + (i >= maxComments ? ' display-none' : ''),
            src:            item.user.photo.smallPhotoUrl,
            fotolink:       '/apex/Chatter#page=profile&user=' + item.user.id,
            nameHtml:           $.tmpl(templates['chatterLink'], {
                                link:		'/apex/Chatter#page=profile&user=' + item.user.id,
                                className:	'',
                                text:		item.user.name,
                                target:		''
                            }),
            group:          '',
            metaHtml:           $.tmpl(templates['itemMeta'], {
                                date:       formatDate(ChatterUI.sDate(item.createdDate)),
                                type:		'comment',
                                time:      	formatTime(ChatterUI.sDate(item.createdDate)),
                                likesHtml:     	ChatterUI.formatTotal(item.likes),
                                likeId:    	item.myLike ? item.myLike.id : '',
                                itemId:    	item.id,
                                current:   	item.myLike ? ' me' : '',
                                deleteLinkHtml:	isDeletable(item, parent) ? $.tmpl(templates['feedLinkIcon'], {
                                                link:		'#',
                                                className:	'action-item delete'
                                            }) : ''
                            }),
            msgHtml:            formatMsg(item.body.messageSegments, item.id),
            attachmentHtml:     formatAttachment(item),
            commentSummaryHtml:	'',
            commentsHtml:       ''
        });
    }

    function getAllComments($item) {
        var id = $item.attr('data-item-id'),
            $el = $item.parents('ul.feed-list');

        ChatterUI.Service.getFeedComments(id, function(result, event) {
            if (event.status && ChatterUI.isValidResponseEvent(event)) {
                if (result.total > 0) {
                    $item.find('li').not('.add-comment').remove();
                    for (var i=0; i<result.total; i++) {
                        var comment = result.comments[i];
                        addComment(comment, $el, false);
                    }
                    ChatterUI.refreshScroller();
                }
            } else {
                ChatterUI.showGenericError();
            }
        });
    }

    function updateCommentTotal($item, update) {
        var $meta = $item.find('div.comment span.meta-text'),
            total = parseInt($meta.find('span.total').html()) || 0;
        $meta.html(ChatterUI.formatTotal((total + update + ''), 'comment', '', true));
    }

    /**
     * Constructs the post name/title
     * @param item {object} The post or comment we're naming.
     * @param isGroupFeed {boolean} whether it's being shown in a group feed or not (excludes group name from posts on a group feed)
     */
    function getPostNameHtml(item, isGroupFeed) {
        var name = '',
            poster = '',
            isExtended = (!isGroupFeed && (item.parent.owner || item.parent.type == 'CustomEntityDataTemplate'));

        if (!isGroupFeed && item.parent.type != 'User' && (item.parent.owner || item.parent.type == 'CustomEntityDataTemplate')) {
            // either object name link or a group name link, plus a user profile link
            name = constructLink(item, true, true) + ' &mdash; ' + constructLink(item, false, false);
        } else {
            // definitely needs a user profile link
            name = constructLink(item, false, true);
            if (item.parent.type == 'User' && (item.parent.id != item.actor.id)) {
                // also needs the direct-messaged user's profile link
                name += ' to ' + constructLink(item, true, false);
            }
        }

        return name;
    }

    /**
     * Constructs the post link
     * @param item {object} The post or comment we're creating a link for.
     * @param isGroupFeed {boolean} whether it's being shown in a group feed or not (excludes group name from posts on a group feed)
     */
    function getPostLink(item, isGroupFeed) {
        var link = '';

        if (!isGroupFeed && item.parent.type != 'User' && (item.parent.owner || item.parent.type == 'CustomEntityDataTemplate')) {
            // either session link or a group link
            link = constructLink(item, false, false, true);
        } else {
            // definitely needs a user profile link
            link = constructLink(item, false, true, true);
        }

        return link;
    }

    /**
     * Constructs the Profile link depending on the owner of the post or comment.
     * @param item {object} The post or comment to get the link for.
     * @param useParent {boolean} Whether to use the item's parent in building/naming the link
     * @param isFirst {boolean} Whether the link is the first (bold) or the second
     * @param returnUrl {boolean} Whether to return just the url instead of the full chatter link
     */
    function constructLink(item, useParent, isFirst, returnUrl) {
        var url = '',
            text = '',
            pageType = '',
            feed,
            owner;

        returnUrl = returnUrl || false;

        if (useParent) {
            if (item.parent.type == 'CustomEntityDataTemplate') {
                url = '/' + item.parent.id;
            } else if (item.parent.owner) {
                pageType = 'groups';
                owner = 'group';
            } else {
                pageType = 'profile';
                owner = 'user';
            }
            text = item.parent.name;
        } else {
            pageType = 'profile';
            owner = 'user';
            text = item.actor.name;
        }

        if (!url) {
            url = '/apex/Chatter#page=' + pageType + '&' + owner + '=' + (useParent ? item.parent.id : item.actor.id);
        }

        if (returnUrl) {
            return url;
        }

        return $.tmpl(templates['chatterLink'], {
            className:	isFirst ? '' : 'normal',
            link:   	url,
            text:   	text,
            target: 	''
        });
    }

    function formatMsg(msg, id) {
        var msgHtml = '';
        for (var i=0; i<msg.length; i++) {
            var params = null;
            switch(msg[i].type.toLowerCase()) {
                case 'entitylink':
                    params = {
                        text:   msg[i].text,
                        link:   '/apex/Chatter#page=groups&group=' + msg[i].reference.id,
                        target: ''
                    };
                    break;
                case 'hashtag':
                    params = {
                        text:   '#' + msg[i].tag,
                        link:   '/apex/Chatter#page=feeds&feed=searchFeedsByHashtag&hashtag=' + msg[i].tag,
                        target: ''
                    };
                    break;
                case 'link':
                    params = {
                        className: 'msg-link',
                        text:   	msg[i].url.replace('mailto:', ''),
                        link:   	msg[i].url,
                        target: 	(msg[i].url.indexOf('mailto:') > -1 || ChatterUI.UserContext.usingMobile || isInternalLink(msg[i].url)) ? '' : '_blank'
                    };
                    break;
                case 'mention':
                    params = {
                        text:   msg[i].text,
                        link:   '/apex/Chatter#page=profile&user=' + msg[i].user.id,
                        target: ''
                    };
                    break;
                case 'mention':
                    params = {
                        text:   msg[i].text,
                        link:   '/apex/Chatter#page=profile&user=' + msg[i].user.id,
                        target: ''
                    };
                    break;
                default:
                    msgHtml += ChatterUI.escapeHtml(msg[i].text);
                    break;
            }

            if (params)
                msgHtml += $.tmpl(templates['chatterLink'], $.extend({ className:'' }, params));
        }
        return ChatterUI.nl2p(msgHtml);
    }

    function formatAttachment(item) {
        if (!item.attachment) {
            return '';
        }

        var att = item.attachment,
            html = '',
            size = Math.round(parseInt(att.fileSize) / 1024);

        size = (size ? ' (' + size + ' KB)' : '');

        if (ChatterUI.FileManager.isFileEligibleForPreview(att, ChatterUI.sDate(item.createdDate))) {
            // this is a file with a preview, show the image preview
            html = $.tmpl(templates['image'], {
                className:	'',
                src:    	ChatterUI.FileManager.getFilePreviewURL(att)
            });

        } else if (att.downloadUrl) {
            // this is a file without a preview, show the file type icon
            var fileExt = ChatterUI.FileManager.getFileExtension(att.title),
                fileTypeClass = ChatterUI.FileManager.getFileTypeClassName(fileExt, att.mimeType);

            html = $.tmpl(templates['fileIconImage'], {fileTypeClass: fileTypeClass});
        }

        if (ChatterUI.FileManager.isEligibleForLargePreview(att) || ChatterUI.UserContext.usingMobile) {
            html += $.tmpl(templates['chatterLink'], {
                className:  ChatterUI.UserContext.usingMobile ? 'pg-dl' : 'large-preview',
                link:       'javascript:void(0);',
                text:       att.title + (ChatterUI.UserContext.usingMobile ? size : ''),
                target:     ''
            });
        } else {
            html += att.title;
        }


        html += '<br/>';
        if (att.url) {
            html += att.url;
        } else if (!ChatterUI.UserContext.usingMobile) {
            html += $.tmpl(templates['chatterLink'], {
                className:	'',
                link:      	ChatterUI.FileManager.getFileDownloadURL(att),
                text:   	'Download' + size,
                target:		ChatterUI.FileManager.isFileUploadEnabled() ? '' : '_blank'
            });
        }
        return html;
    }

    function formatComments(feedItem, id) {
        var comments = parseInt(feedItem.comments.total),
            markup = [];

        markup.push('<ul class="comment-list">');
        if (comments) {
            for (var i=0; i<feedItem.comments.comments.length; i++) {
                markup.push(getCommentMarkup(feedItem.comments.comments[i], i, feedItem));
            }
        }

        var profile = ChatterUI.UserContext.userProfile || {};
        markup.push($.tmpl(templates['commentForm'], {
            src:        	profile.smallPhotoUrl || feedItem.photoUrl,
            defaultValue:	ChatterUI.defaults.commentFieldValue,
            feedId:     	id,
            id:         	feedItem.id,
            listContainerHtml:	ChatterUI.env.isTouch ? '<select></select>' : '<ul></ul>'
        }));
        markup.push('</ul>');

        return markup.join('');
    }

    function formatDate(d) {
        var now        = new Date(),
            todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0),
            dStart     = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0),
            months     = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            friendly   = ['Today', 'Yesterday', 'Two days ago'],
            diff       = todayStart - dStart,
            msecs      = 1000 * 60 * 60 * 24;

        if (diff >= (msecs * friendly.length))
            return months[d.getMonth()] + ' ' + d.getDate() + ', ' + d.getFullYear();
        else {
            return friendly[Math.floor(diff / msecs)];
        }

    }

    function formatTime(d) {
        var hour = d.getHours(),
            ampm = d.getHours() > 12 ? 'PM' : 'AM';
        if (hour == 0)
            hour = 12;
        else if (hour > 12)
            hour = hour - 12;
        return hour + ':' + (d.getMinutes() < 10 ? '0' : '') + d.getMinutes() + ' ' + ampm;
    }

    return {
        addItem:        addItem,
        addComment:		addComment
    };

})(jQuery);
