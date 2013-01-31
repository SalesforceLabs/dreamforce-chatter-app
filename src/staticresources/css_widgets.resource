/**!
 * css_widgets.css
 *
 * Used for UI widgets: tabs, carousels, etc.
 *
 */

.paginator {
    float: right;
    cursor: pointer;
}

.paginator .current {
    color: #333;
}
.paginator .current:hover {
    cursor: text;
}

.inline-select {
    width:auto;
    background-color:#FFFFFF;
    color:#000000;
    border: none;
}


/* =============================================================================
   Action Buttons
   ========================================================================== */
.actionBookmark {
    right: 4.25em;
}
.actionFindLocation {
    right: 8.5em;
}


/* =============================================================================
    Pull to refresh
    ========================================================================== */
#pullDown {
    display: none;
    line-height: 40px;
    background: #fff;
    font-weight: bold;
    color: #888;
    border-bottom: 1px solid #ccc;
}

.pullDownLabel {
    font-size: 0.813em;
}

/*
 *	Using rotate transforms in CSS or translateZ(0) was crashing iPhone 4S, so
 *	we are allowing to set a 'noRotate' class on the pullDown div which will just swap an image.
 */
#pullDown .pullDownIcon {
    display: block;
    float: right;
    width: 40px;
    height: 40px;
    background-position: 0 0;
    background-repeat: no-repeat;
    /* Don't use base64 here. This one causes security popup in IE7 for some reason. */
    background-image: url('media_image_icons_png8_pullToRefresh');
    -moz-background-size: 40px 40px;
    -o-background-size: 40px 40px;
    -webkit-background-size: 40px 40px;
    background-size: 40px 40px;
}

#pullDown.noRotate.flip .pullDownIcon {
    background-image: url('media_image_icons_png8_pullToRefreshRelease');
}

#pullDown.loading .pullDownIcon {
    background: none;
}
