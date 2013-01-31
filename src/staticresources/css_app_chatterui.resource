body {
    margin: 0 auto;
    color: #515151;
    background-color:#fff;
}

a {
    color: #0092E7;
}

ul {
    list-style: none outside none;
}

.box-sizing-border {
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -ms-box-sizing: border-box;
    box-sizing: border-box;
}

label {
    color:#000;
    font-size:1em;
}

.panelHeaderBar h3 {
    display:inline-block;
}

/*workaround for simpleModal when viewing files larger than the container dims, to always keep the img inside the container and always have scrollbars*/
.simplemodal-wrap{ 
	overflow:auto !important;
}

/* global */
.border-button {
    border: solid 1px #555;
}

a.more-items {
    display: none;
}

.icon-minus{
    background:url("media_image_icons_png_minusSmall") no-repeat scroll 0 0 transparent;
    cursor: pointer;
    display: inline-block;
    height: 14px;
    margin-right: 0.75em;
    vertical-align: middle;
    width: 14px;
}

.icon-plus{
    background: url("media_image_icons_png_plusSmall") no-repeat scroll 0 0 transparent;
    cursor: pointer;
    display: inline-block;
    height: 16px;
    margin-right: 0.75em;
    vertical-align: middle;
    width: 16px;

}

.icon-edit {
    background-image: url("media_image_icons_png_white_pencil");
    display: inline-block;
    height: 15px;
    margin-right: 0.75em;
    vertical-align: middle;
    width: 15px;
}

.icon-info {
    background: url("media_image_icons_png_info") no-repeat scroll 0 0 transparent;
    cursor: pointer;
    display: inline-block;
    height: 18px;
    vertical-align: middle;
    width: 18px;
}

.icon-clear {
    background: url("media_image_icons_png_clear") no-repeat scroll 0 0 transparent;
    border: medium none;
    height: 16px;
    position: absolute;
    width: 18px;
    cursor: pointer;
}

.icon-mag-glass {
    background: url("media_image_icons_png_magGlass") no-repeat scroll 0 0 transparent;
    border: medium none;
    height: 17px;
    position: absolute;
    width: 19px;
}

.icon-close {
    background: url("media_image_icons_png_gray_x") no-repeat scroll 0 0 transparent;
    display: block;
    height: 25px;
    width: 25px;
    cursor: pointer;
}

.icon-clip {
    background: url("media_image_icons_png_clip") no-repeat scroll 0 0 transparent;
    display: block;
    height: 21px;
    width: 48px;
}

.icon-clip-large {
    background: url("media_image_icons_png_clipLarge") no-repeat scroll 2px 3px transparent;
    display: block;
    height: 37px;
    width: 86px;
}

.icon-post{
    background: url("media_image_icons_png_post") no-repeat scroll 0 0 transparent;
    display: inline-block;
    height: 22px;
    margin: 0 5px 0 0;
    vertical-align: middle;
    width: 26px;
}

.icon-camera {
    background: url("media_image_icons_png_cameraWhite") no-repeat scroll 0 0 transparent;
    height: 40px;
    width: 40px;
}

.icon-gallery {
    background: url("media_image_icons_png_photogalleryWhite") no-repeat scroll 0 0 transparent;
    height: 40px;
    width: 40px;
}

.meta-text {
    font-size: 0.750em;
    font-weight: normal;
    font-style: italic;
    white-space: nowrap;
}

.item-date .meta-text {
    vertical-align: middle;
    color: #8F8F8F;
}

.cta {
    font-size: .813em;
    font-weight: bold;
    padding: 0.75em 1em;
    text-decoration: none;
    width: auto;
    color: #fff;
    margin: 0;
    border: solid 1px #555;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    cursor:pointer;
    display:inline-block;
    text-shadow:1px 1px 2px rgba(0, 0, 0, 0.5);
}

.cta:hover {
    text-decoration: none;
    color: #fff;
}

.cta:visited {
    color: #fff;
}

.more-container {
    text-align: center;
    margin: 20px auto;
}

.more-container	.cta{
    color: #444444;
    font-weight: normal;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
}
/* end global */


/*object detail used in profile and group detail*/
.detail-container {
    background-color: #FFFFFF;
    padding: 10px 0;
    position: relative;
}

.detail-container .actions {
    float: right;
    margin-right:10px;
}

.detail-container .foto-refreshing {
    background: url("media_image_icons_png_pending") no-repeat scroll 1px 1px #FFFFFF;
    border: 1px solid #AFAFAF;
    height: 25px;
    width: 20px;
    position: absolute;
    left: 20px;
    top: 10px;
}

.detail-container .foto {
    border: 1px solid #C5C5C4;
    float: left;
    line-height: 0;
    margin: 0 20px 20px;
}

.detail-container .foto img {
    height: 64px;
    width: 64px;
}

.detail-container .user-name {
    padding-right: 10px;
    overflow: hidden;
}

.detail-container .user-details {
    padding-right: 10px;
    overflow: hidden;
    margin-left: 10px;
}
.detail-container .user-name h1,
.detail-container .user-name h2,
.detail-container .user-name h3 {
    word-wrap: break-word;
}

.detail-container .user-name h1 {
	color: #3F484F;
    display: inline-block;
    font-size: 2em;
    line-height: 1em;
    margin: 0 0.5em 0 0;
    padding: 0;
}

.detail-container .user-name h2 {
    color: #909090;
    display: inline-block;
    font-size: 1.3em;
    font-weight: normal;
    margin: 0;
}

.detail-container .user-name h3 {
    color: #909090;
    font-size: 1.1em;
    font-weight: normal;
    margin: 0;   
}
/*object detail*/


/*chatter-info-bar*/
.chatter-info-bar{
    border-bottom: 1px solid #E0E0E0;
    padding: 0 0 0 1.563em;
    background-color:#fff;
}

.chatter-info-bar .info-item-container {
    float:left;
}

.chatter-info-bar .info-item-container .info-item {
    color: #838383;
    display: block;
    font-size: 0.9em;
    font-weight: bold;
    padding: 0.875em;
    text-decoration: none;
}

.chatter-info-bar .info-item-container a span {
    font-weight:normal;
}

.chatter-info-bar .info-item-container a span.line-break{
    font-weight: bold;
} 

.chatter-info-bar .info-item.selected {
    background: #f8f8f8;
    color:#4e4e4f;
    border-bottom:solid 3px #f38c26;
}
/*end chatter-info-bar*/

/*edit container, used in profile edit and group edit/create*/
.edit-container	{
    background-color: #fff;
    padding: 1em;
    top: 0;
    width: 100%;
    z-index: 2;
}

.edit-container	.icon-close{
    float:right;
}

.edit-container .photo-container{
    float: left;
    margin: 0 1em 1em 0;
    min-width: 125px;
}

.edit-container .photo-container h1{
    font-size: 1.25em;
    margin-top: 0;
}

.edit-container .photo-container img {
    height: 64px;
    width: 64px;
}

.edit-container .form-container {
    overflow: hidden;
    padding-right: 20px;
}

.edit-container .form-container .fields-container{
    width: 100%;
}

.edit-container .form-container .fields-container .fields-bucket{
    float: left;
    margin-right: 10px;
    width: 45%;
}

.edit-container .form-container input, .edit-container .form-container textarea {
    color: #515151;
    font-size: 0.875em;
    height: 2.25em;
    line-height: 1.5em;
    margin: 0.313em 0 .626em 0;
    padding: 0.313em 0.625em 0.188em;
    resize: none;
    white-space: pre;
    width: 100%;
}

.edit-container .form-container textarea {
    height: 10em;
    overflow-y: auto;
}

.edit-container .actions{
    margin-right: 45px;
}

.edit-container .actions .cta {
    float: right;
    margin-left: 50px;
}
/*end edit container, used in profile edit and group edit/create*/

/* search-container used in groups/people */
.search-container{
    display: inline-block;
    float: right;
    border: medium none;
    margin: 7px 10px 0 5px;
    padding: 0;
    position: relative;
}

.search-container .icon-mag-glass {
    left: 8px;
    top: 7px;
}
.search-container .icon-clear {
    right: 8px;
    top: 7px;
}

.search-container .form-post-input {
    background: none repeat scroll 0 0 white;
    overflow: hidden;
    padding: 0 30px;
}

.search-container .form-post-input .search-input {
    border: medium none;
    color: #999999;
    font-size: 13px;
    height: 28px;
    line-height: 13px;
    resize: none;
    white-space: pre;
    width: 100%;
    min-width: 250px;
    padding: 3px 0 0;
    margin: 0;
}
/* end search-container used in groups/people */

/* search results used in feed/groups/people */
.search-container .info-item a,
.form-post-input .search-results a,
.search-container .search-results span.message,
.form-post-input .search-results span.message {
    font-size: 12px;
    font-weight: bold;
    color: #515151;
    display: block;
    margin: 0;
    padding: 10px 3.4em;
    text-align: center;
    text-decoration: none;
}

.search-container .search-results span.message,
.form-post-input .search-results span.message {
    font-weight: normal;
    font-style: italic;
}

.search-container .search-results,
.form-post .search-results {
    margin: -1px 0 0 12px;
    nowhitespace: afterproperty;
    position: absolute;
    width:92%;
    max-height: 150px;
    border: 1px solid #afafaf;
    border-top: none;
    display: none;
    overflow-x: hidden;
    overflow-y: scroll;
    text-align: left;
    background: #fff;
    border-top:none;
    z-index: 5;
}

.touch .form-post .search-results {
	border: 0 none;
}

.form-post .search-results {
    margin-top: 0;
    width: 30%;
}

.search-container .search-results ul,
.form-post .search-results ul {
    margin: 0;
    padding: 0;
    position: relative;
}
.search-container .search-results li,
.form-post .search-results li {
    width: 100%;
    float: left;
    background: #fff;
    padding: 5px 0;
}

.search-container .search-results li.selected,
.form-post .search-results li.selected {
    background: #eff8fd;
}

.search-container .search-results a,
.form-post .search-results a,
.search-container .search-results span.message,
.form-post .search-results span.message {
	width: 100%;
	float: left;
    padding: 5px;
    font-size: 0.75em;
    font-weight: normal;
    text-align: left;
    color: #515151;
    display: block;
    font-weight: bold;
}
.search-container .search-results .search-foto,
.form-post .search-results .search-foto {
    max-width: 20px;
    max-height: 20px;
    margin-right: 3px;
    float: left;
}
.search-container .search-results .search-text,
.form-post .search-results .search-text {
    overflow: hidden;
    max-width: 235px;
    float: left;
}

.form-post .long-message {
	color: #e02900;
	font-style: italic;
	font-size: 0.8em;
	font-weight: bold;
}

.search-results-header {
	padding: 1em 0 0 1.875em;
	font-size: 1.2em;
}
/* end search results used in feed/groups/people */


/* list tiles used in people and group lists*/
.list-container {
    background-color: #f9f9f9;
}

.list-container .message {
    display: block;
    margin: 2em;
}

.list-container .list {
    margin: 0;
    padding:0 .8em 0 1.875em;
}

.list-container .list-header {
    background-color: #2D82B9;
    color: #FFFFFF;
    float: left;
    font-size: 0.9em;
    font-weight: bold;
    height: 25px;
    margin: 2.5em 0 0.5em;
    padding: 0.2em 0 0 1em;
    width: 100%;
}

.list-container .list-header.first-row {
    margin: 1.5em 0 0.5em;
}

.list-container .list-item {
    background-color: #FFFFFF;
    border: 1px solid #D5D5D5;
    float: left;
    height: 80px;
    margin: 6px;
    overflow: hidden;
    width: 325px;
}

.list-container .list-item .list-foto {
    float: left;
    margin: 5px 10px 5px 5px;
    position: relative;
}

.list-container .list-item img {
    display: block;
    height: 64px;
    width: 64px;
}

.list-container .list-item .list-name {
    margin: 5px;
    height: 100%;
    overflow: hidden;
}


.list-container .list-item .list-name a,
.list-container .list-item .list-foto a {
    float: left;
    height: 100%;
    width: 100%;
}

.list-container .list-item .list-name h3 {
    font-size: .875em;
    margin: 0;
    word-wrap: break-word;
    font-weight:bold;
}

.list-container .list-item .list-name .title{
    font-size: 0.813em;
    display:block;
}

.list-container .list-item .list-name .company {
    font-size: 0.750em;
    display:block;
}

.list-container .list-item .cta-position {
    float: right;
    margin:15px 5px 0;
}

.list-container .list-item .follow-link {
    float: right;
    margin:25px 5px 0;
    height:26px;
    display: block;
    width:26px;
}

.list-container .list-item .follow-link.follow {
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll #afc753; /* Old browsers */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, -moz-linear-gradient(top, #afc753 0%, #96ae3a 100%); /* FF3.6+ */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, -webkit-gradient(linear, left top, left bottom, color-stop(0%,#afc753), color-stop(100%,#96ae3a)); /* Chrome,Safari4+ */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, -webkit-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Chrome10+,Safari5.1+ */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, -o-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Opera 11.10+ */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, -ms-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* IE10+ */
    background: url('media_image_icons_png_follow') 50% 50% no-repeat scroll, linear-gradient(to bottom, #afc753 0%,#96ae3a 100%); /* W3C */
}

.list-container .list-item .follow-link.following {
    background:url("media_image_icons_png_minusSmall") no-repeat scroll 5px 5px #4D5253;
}

.list-container .list-item .list-name a {
    float: left;
    width: 100%;
    height: 100%;
    color: #333;
    line-height: 100%;
    word-wrap: break-word;
}
/* end list tiles used in people and group lists*/


/* form-post-container */
.form-post-container {
    background-color: #F9F9F9;
    border-bottom: 1px solid #E0E0E0;
    padding: 1em 1.55em;
}

.form-post-container .actions-bucket.mobile {
    text-align: center;
}

.form-post-container .actions-bucket.mobile .box {
    border: 1px solid #000000;
    color: white;
    display: inline-block;
    font-weight: bold;
    margin: 0 20px;
    padding: 0.5em 1.2em;
    -webkit-border-radius: 10px;
    -moz-border-radius: 10px;
    border-radius: 10px;
}

.form-post-container .actions-bucket.mobile .box .icon-camera,
.form-post-container .actions-bucket.mobile .box .icon-gallery {
    display: inline-block;
    vertical-align: middle;
}

.form-post-container .actions-bucket.mobile .box .icon-label{
    display: inline-block;
    margin: 0 0 0 10px;
    vertical-align: middle;
    width: 60px;
}

.form-post-container .post-menu {
    border-right: medium none;
    cursor: pointer;
    display: block;
    float: left;
    height: 42px;
    margin: 0;
    width: 55px;
    border-radius: 3px 0 0 3px;
    -webkit-border-radius: 3px 0 0 3px;
    -moz-border-radius: 3px 0 0 3px;    
    background-color: #FFFFFF;
}


.form-post-container .post-menu.display-none {
    display: none;
}


.form-post-container .post-menu .clip {
    background: url("media_image_icons_png_clip") no-repeat scroll 0 0 transparent;
    display: block;
    height: 24px;
    margin: 9px 0 0 22px;
    width: 13px;
}

.form-post-container .post-menu .camera {
    background: url("media_image_icons_png_cameraPost") no-repeat scroll 0 0 transparent;
    display: block;
    height: 24px;
    margin: 10px 0 0 11px;
    width: 33px;
}

.form-post-container .button {
    color: #FFFFFF;
    cursor: pointer;
    float: right;
    font-size: 13px;
    font-weight: bold;
    height: 42px;
    margin: 0 0 0 10px;
    padding: 11px 20px;
    text-decoration: none;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
    vertical-align: middle;
}

.form-post-container .button label{
    color: #FFFFFF;
}


.form-post-container .posting,
.form-post-container .fileUploading,
.create-group-container .savingGroup,
.create-group-container .fileUploading,
.edit-profile-container .savingProfile,
.edit-profile-container .fileUploading {
    background: #999; /* Old browsers */
    background: -moz-linear-gradient(top, #fefefe 0%, #999 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fefefe), color-stop(100%,#999)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #fefefe 0%,#999 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #fefefe 0%,#999 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top, #fefefe 0%,#999 100%); /* IE10+ */
    background: linear-gradient(to bottom, #fefefe 0%,#999 100%); /* W3C */
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#999',GradientType=0 ); /* IE6-9 */
}

.form-post-container .form-post-input {
    background: none repeat scroll 0 0 white;
    border-radius: 0 3px 3px 0;
    -webkit-border-radius: 0 3px 3px 0;
    -moz-border-radius: 0 3px 3px 0;
    overflow: hidden;
    padding: 0 10px;
    border-top: 1px solid #CCCCCC;
    border-right: 1px solid #CCCCCC;
    border-bottom: 1px solid #CCCCCC;
    border-left: 1px solid #ebebeb;    
}

.form-post-container .form-post-input .textarea-input {
    border: medium none;
    color: #8F8F8F;
    font-size: 14px;
    height: 26px;
    line-height: 18px;
    margin: 7px 0;
    min-height: 26px;
    outline: medium none;
    padding: 4px 0;
    resize: none;
    white-space: pre-wrap;
    width: 100%;
}

.form-post-container .mobilePhotoTitle,
.form-post-container .desktopPhotoTitle {
    font-size:0.85em;
    font-weight:bold;
}

/* icon for selected mobile photo only on feeds */ 
.form-post-input .mobilePhotoTitle .fileTypeIcon {
    float: left; 
    height: 25px;
}

.form-post-input .mobilePhotoTitle .mobileTitle {
    position: relative;
    top: 5px; 
    left: 2px;
    text-align: left;
}

.profile-img-upload .mobilePhotoTitle .fileTypeIcon,
.group-img-upload .mobilePhotoTitle .fileTypeIcon {
    display: none;
}

.form-post-container .desktopPhotoTitle {
    width:140px;
    word-wrap:break-word;
}

/* form-post-container */

/* form-post-container overrides for use in comments */

.comment-list .form-post-container {
    border-top: none;
    border-bottom: none;
    padding: 0.125em;
    background-color:#fff;
}

.comment-list .form-post-container .button {
    margin: 0.313em 0 0;
    padding: 0.375em 1.250em;
}

.comment-list .form-post-container .form-post-input {
	border: 1px solid #EFEFEF;
}

.comment-list .form-post-container .form-post-input .textarea-input {
    font-size: 14px;
    height: 15px;
    min-height: 15px;
    line-height: 16px;
    margin-top: 8px;
    padding: 0;
}

/* form-post-container overrides for use in comments */

.feed-container {
    background-color: #fff;
}

.feed-list {
    margin: 0;
    padding: 0;
    background-color:#f9f9f9;
}

.more-items {
    display: inline-block;
}

.feed-list .feed-item {
    border-bottom: solid 1px #e0e0e0;
}

.feed-list .feed-item.last {
    border: none !important;
}

.feed-list .feed-item .item-container {
    padding: 1.25em 1.563em 0;
}

.feed-list .feed-item .item-foto {
    float: left;
    line-height: 0;
    margin: 0 1.25em .75em 0;
    border: 1px solid #d0ccc8;
}

.feed-list .feed-item .item-foto img {
    height: 50px;
    width: 50px;
}

.feed-list .feed-item .item-body {
    overflow: hidden;
    margin: 0.313em 0.625em 0.625em 0.625em;
    padding: 0;
    font-size: 14px;
}

.feed-list .feed-item .item-body p {
    font-size: inherit;
    margin-bottom: 0;
    word-wrap: break-word;
}

.feed-list .feed-item .item-body a {
    word-break: break-all;
}

.feed-list .feed-item .item-name {
    overflow: hidden;
}

.feed-list .feed-item .item-name .item-date {
    display: inline-block;
}

.feed-container .feed-list .feed-item .action-items {
    float: right;
}

.feed-list .feed-item .action-items.comments {
    float: none;
    margin: 0 1.563em 0 6em;
}

.feed-list .feed-item .action-items.comments .action-item {
    padding: 0 0 0.313em 0;
    margin-right: 0.625em;
}

.feed-list .feed-item .action-items.comments .action-item.comment .meta-text {
    color:#6e6e6e;
    font-weight:bold;
    font-style:normal;
    font-size: .85em;
}

.feed-list .feed-item h2 {
    display: inline-block;
    font-size: 16px;
    margin: 0 5px 0 0;
}

.feed-list .feed-item .action-item {
    display: inline-block;
    font-style: italic;
    margin: 0;
    padding: 0.313em;
    position: relative;
    text-align: left;
    text-decoration: none;
    width: auto;
}

.feed-list .feed-item .action-item.like {
	border: solid 1px #efefef;
}

.feed-list .feed-item .action-item.like .meta-text{
	display: inline-block;
}

.feed-list .feed-item .action-item .action-item.delete{
	margin-right: 0.313em;
}


.feed-list .feed-item .action-item .icon {
    display: inline-block;
    vertical-align: middle;
    background: transparent url("media_image_icons_png_chatterfeedSprite") no-repeat 0 0;
    margin: -3px 5px 0 4px;
}

.feed-list .feed-item .action-item.like .icon {
    background-position: 0 -26px;
    width: 14px;
    height: 21px;
}

.feed-list .feed-item .action-item.like .me .icon {
    background-position: -27px -26px;
}

.feed-list .feed-item .action-item.delete .icon {
    background-position: 0 -53px;
    width: 15px;
    height: 21px;
}

.feed-list .feed-item .action-item.delete.me .icon {
    background-position: -27px -53px;
}

.comment-list {
    background-color: #FFFFFF;
    border-left: 1px solid #ececec;
    border-right: 1px solid #ececec;
    border-top: 1px solid #ececec;
    margin: 0 1.563em 0 6em;
    padding: 0;
}

.comment-list .comment-item .item-container {
    padding: 0.875em 0.875em .5em;
    border-bottom: solid 1px #ececec;
}

.comment-list .comment-item .item-foto {
    margin: 0.19em 0.688em 0 0;
}

.comment-list .comment-item .item-foto.comment {
    display: none;
}

.comment-list .comment-item .item-foto img {
    height: 30px;
    width: 30px;
}

.comment-list .comment-item.post .item-foto {
    margin-top: 0.1em;
    border: solid 1px #ddddd8;
}

.comment-list .comment-item.post .item-container {
    border-bottom: none;
}

.comment-list .comment-item .item-body {
    font-size: 14px;
    line-height: 16px;
    margin-top: 0;
}

.comment-list .comment-item .item-name {
    margin: 0;
}

.comment-list .comment-item .item-name h2 {
    font-size: 14px;
    display: inline-block;
    margin: 0 5px 0 0;
}

.comment-list .form-post-container .button {
    display: none;
    float: right;
}

/* post/attachment area  */

.post-actions-container {
    display: none;
}

.post-actions-container .icon-close {
    float: right;
    margin: 0 0 10px 0;
}

.post-actions-container .actions-bucket {
    padding: 10px;
}

.profile-img-upload .post-actions-container .actions-bucket.desktop,
.group-img-upload .post-actions-container .actions-bucket.desktop {
    text-align:left;
}

.post-actions-container .actions-bucket .box {
    display: inline-block;
    margin: 0 3em 1em;
    padding: 4em 5em;
}

.post-actions-container .actions-bucket.mobile .form-upload {
    margin: 20px auto;
    width: 310px;
    position: relative;
}

/* form-upload for desktop is in an iframe */
.form-upload.desktop {
    background-color:transparent !important;
}

.form-upload.desktop .input-placeholder-container {
    position: absolute;
    left: 0;
}

.form-upload.desktop.imageOnly .input-placeholder-container {
    display:none;
}

.form-upload.desktop .input-placeholder {
    height: 29px;
    padding-left: 10px;
    width: 225px;
}

.form-upload.desktop .button-browse {
    position: absolute;
    right: 0;
    top: 1px;
}

.form-upload.desktop .file-wrap {
    opacity: 0;
    cursor:pointer;
}

.form-upload.desktop .button-browse .cta {
    padding: 0.4em 1em;
    color: #666;
    text-shadow:none;
}

.form-upload.desktop.imageOnly .button-browse {
    left:0;
}

.form-upload.desktop.imageOnly .button-browse .cta {
    color:#fff;
}

.fileTypeIcon {
    background: url("media_image_chatterui_icons_png_doctype_32_sprite") no-repeat scroll 0 0 transparent;
    height: 32px;
    width: 32px;
    margin:3px 0;
}

.fileTypeIcon.sprite-doctype__32 {
    background-position: 0 0;
}

.fileTypeIcon.sprite-doctype_ai_32 {
    background-position: 0 -43px;
}

.fileTypeIcon.sprite-doctype_audio_32 {
    background-position: 0 -83px;
}

.fileTypeIcon.sprite-doctype_csv_32 {
    background-position: 0 -127px;
}

.fileTypeIcon.sprite-doctype_eps_32 {
    background-position: 0 -169px;
}

.fileTypeIcon.sprite-doctype_excel_32 {
    background-position: 0 -211px;
}

.fileTypeIcon.sprite-doctype_exe_32 {
    background-position: 0 -259px;
}

.fileTypeIcon.sprite-doctype_flash_32 {
    background-position: 0 -295px;
}

.fileTypeIcon.sprite-doctype_gdoc_32 {
    background-position: 0 -336px;
}

.fileTypeIcon.sprite-doctype_gpres_32 {
    background-position: 0 -378px;
}

.fileTypeIcon.sprite-doctype_gsheet_32 {
    background-position: 0 -420px;
}

.fileTypeIcon.sprite-doctype_html_32 {
    background-position: 0 -462px;
}

.fileTypeIcon.sprite-doctype_image_32 {
    background-position: 0 -509px;
}

.fileTypeIcon.sprite-doctype_link_32 {
    background-position: 0 -546px;
}

.fileTypeIcon.sprite-doctype_mp4_32 {
    background-position: 0 -589px;
}

.fileTypeIcon.sprite-doctype_pack_32 {
    background-position: 0 -631px;
}

.fileTypeIcon.sprite-doctype_pdf_32 {
    background-position: 0 -673px;
}

.fileTypeIcon.sprite-doctype_ppt_32 {
    background-position: 0 -714px;
}

.fileTypeIcon.sprite-doctype_psd_32 {
    background-position: 0 -757px;
}

.fileTypeIcon.sprite-doctype_rtf_32 {
    background-position: 0 -799px;
}

.fileTypeIcon.sprite-doctype_slide_32 {
    background-position: 0 -841px;
}

.fileTypeIcon.sprite-doctype_txt_32 {
    background-position: 0 -883px;
}

.fileTypeIcon.sprite-doctype_unknown_32 {
    background-position: 0 -924px;
}

.fileTypeIcon.sprite-doctype_video_32 {
    background-position: 0 -969px;
}

.fileTypeIcon.sprite-doctype_visio_32 {
    background-position: 0 -1008px;
}

.fileTypeIcon.sprite-doctype_webex_32 {
    background-position: 0 -1051px;
}

.fileTypeIcon.sprite-doctype_word_32 {
    background-position: 0 -1092px;
}

.fileTypeIcon.sprite-doctype_xml_32 {
    background-position: 0 -1134px;
}

.fileTypeIcon.sprite-doctype_zip_32 {
    background-position: 0 -1177px;
}

/* .post-actions-container .actions-bucket.ipad  .box.camera                                {background: url("media_image_icons_png_camera") no-repeat scroll 0 0 transparent;}
.post-actions-container .actions-bucket.ipad  .box.fotos                                    {background: url("media_image_icons_png_fotos") no-repeat scroll 0 0 transparent;}
   ================================================== */

/* post/attachment area  */

/* Call to actions */
.actions .call-to-action {
	display: inline-block;
    font-size: 0.8em;
    font-weight: bold;
    padding: 1em 1em 1em 2.5em;
    text-decoration: none;
    width: auto;
    color: white;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    line-height: 100%;
    text-shadow:1px 1px 2px rgba(0, 0, 0, 0.5);
}

.actions .create-contact{
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll #418fc0; /* Old browsers */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, -moz-linear-gradient(top, #418fc0 0%, #2d83b9 100%); /* FF3.6+ */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, -webkit-gradient(linear, left top, left bottom, color-stop(0%,#418fc0), color-stop(100%,#2d83b9)); /* Chrome,Safari4+ */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, -webkit-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Chrome10+,Safari5.1+ */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, -o-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Opera 11.10+ */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, -ms-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* IE10+ */
    background: url('media_image_icons_png_groupAdd') 5% 50% no-repeat scroll, linear-gradient(to bottom, #418fc0 0%,#2d83b9 100%); /* W3C */
	margin-right:10px;
	float:right;
}


.actions .follow-link {
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll #afc753; /* Old browsers */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, -moz-linear-gradient(top, #afc753 0%, #96ae3a 100%); /* FF3.6+ */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, -webkit-gradient(linear, left top, left bottom, color-stop(0%,#afc753), color-stop(100%,#96ae3a)); /* Chrome,Safari4+ */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, -webkit-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Chrome10+,Safari5.1+ */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, -o-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Opera 11.10+ */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, -ms-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* IE10+ */
    background: url('media_image_icons_png_follow') 15% 50% no-repeat scroll, linear-gradient(to bottom, #afc753 0%,#96ae3a 100%); /* W3C */
	float:right;
}


.actions .unfollow-link {
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll #7a7e81; /* Old browsers */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, -moz-linear-gradient(top, #7a7e81 0%, #74797b 6%, #707476 8%, #666a6c 17%, #5e6365 21%, #585d5e 27%, #525759 29%, #484d4e 38%, #333a3a 50%, #33393a 100%); /* FF3.6+ */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7a7e81), color-stop(6%,#74797b), color-stop(8%,#707476), color-stop(17%,#666a6c), color-stop(21%,#5e6365), color-stop(27%,#585d5e), color-stop(29%,#525759), color-stop(38%,#484d4e), color-stop(50%,#333a3a), color-stop(100%,#33393a)); /* Chrome,Safari4+ */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, -webkit-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* Chrome10+,Safari5.1+ */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, -o-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* Opera 11.10+ */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, -ms-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* IE10+ */
    background: url('media_image_icons_png_unfollow') 15% 50% no-repeat scroll, linear-gradient(to bottom, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* W3C */
	float:right;
}

.actions .follow-link:hover,
.email:hover {
    color: #FFF;
}


/* constants */

/* icon mobile attachment */

.bg-gradient-1 {
    background: #7a7e81; /* Old browsers */
    background: -moz-linear-gradient(top, #7a7e81 0%, #74797b 6%, #707476 8%, #666a6c 17%, #5e6365 21%, #585d5e 27%, #525759 29%, #484d4e 38%, #333a3a 50%, #33393a 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7a7e81), color-stop(6%,#74797b), color-stop(8%,#707476), color-stop(17%,#666a6c), color-stop(21%,#5e6365), color-stop(27%,#585d5e), color-stop(29%,#525759), color-stop(38%,#484d4e), color-stop(50%,#333a3a), color-stop(100%,#33393a)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* IE10+ */
    background: linear-gradient(to bottom, #7a7e81 0%,#74797b 6%,#707476 8%,#666a6c 17%,#5e6365 21%,#585d5e 27%,#525759 29%,#484d4e 38%,#333a3a 50%,#33393a 100%); /* W3C */
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7a7e81', endColorstr='#33393a',GradientType=0 ); /* IE6-9 */
}

/* post */

.bg-gradient-2 {
    background: #ffffff; /* Old browsers */
    background: -moz-linear-gradient(top, #ffffff 0%, #f0f0f0 71%, #e2e2e3 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffffff), color-stop(71%,#f0f0f0), color-stop(100%,#e2e2e3)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #ffffff 0%,#f0f0f0 71%,#e2e2e3 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #ffffff 0%,#f0f0f0 71%,#e2e2e3 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top, #ffffff 0%,#f0f0f0 71%,#e2e2e3 100%); /* IE10+ */
    background: linear-gradient(to bottom, #ffffff 0%,#f0f0f0 71%,#e2e2e3 100%); /* W3C */
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#e2e2e3',GradientType=0 ); /* IE6-9 */
}

/* post button/people  */

.bg-gradient-3 {
    background: #fefefe; /* Old browsers */
    background: -moz-linear-gradient(top, #fefefe 0%, #e2e2e2 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fefefe), color-stop(100%,#e2e2e2)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top, #fefefe 0%,#e2e2e2 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top, #fefefe 0%,#e2e2e2 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top, #fefefe 0%,#e2e2e2 100%); /* IE10+ */
    background: linear-gradient(to bottom, #fefefe 0%,#e2e2e2 100%); /* W3C */
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#e2e2e2',GradientType=0 ); /* IE6-9 */
}

/* share button */
.bg-gradient-4 {
	background: #afc753; /* Old browsers */
	background: -moz-linear-gradient(top, #afc753 0%, #96ae3a 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#afc753), color-stop(100%,#96ae3a)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #afc753 0%,#96ae3a 100%); /* IE10+ */
	background: linear-gradient(to bottom, #afc753 0%,#96ae3a 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#afc753', endColorstr='#96ae3a',GradientType=0 ); /* IE6-9 */
}

/* email button */
.bg-gradient-5 {
	background: #418fc0; /* Old browsers */
	background: -moz-linear-gradient(top, #418fc0 0%, #2d83b9 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#418fc0), color-stop(100%,#2d83b9)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top, #418fc0 0%,#2d83b9 100%); /* IE10+ */
	background: linear-gradient(to bottom, #418fc0 0%,#2d83b9 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#418fc0', endColorstr='#2d83b9',GradientType=0 ); /* IE6-9 */
}

.display-none {
    display: none;
}

.f-left {
    float:left;
}

.f-right {
    float:right;
}

.center-elem {
    margin: 0 auto;
}

.block	{
    display: block;
}

.inline-block {
    display: inline-block;
}

.relative {
    position: relative;
}

.border-1 {
    border: 1px solid #cccccc;
}

.border-2 {
    border: solid 1px #317b9a;
}

.border-3 {
	border:solid 1px #788b2d;
}

.radius-1 {
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
}

.normal {
    font-weight: normal;
}

.margin-top-10 {
    margin-top: 10px;
}

.margin-bottom-10 {
    margin-bottom: 10px;
}

.margin-right-10 {
    margin-right: 10px;
}

.margin-right-1em {
    margin-right: 1em;
}

.margin-top-half-em {
    margin-top: .5em;
}

.cursor-pointer {
    cursor:pointer;
}
/* constants */


/* max-width: 480px */

@media screen and (max-width: 30em) {
	.detail-container .foto {
	    margin: 0 0.625em;
	}
	
	.detail-container .user-name {
    	min-height: 70px;
	}	

	.detail-container .user-name h1 {
    	display: block;
    	font-size: 1.65em;
    	margin: 0;
	}
	
	.detail-container .user-name h2 {
	    display: block;
	}
	
	.detail-container .user-details {
    	margin-left: 1.875em;
	}	

	.actions .create-contact{
		margin-right:0;
		display:block;
		float:none;
	}
	
	.actions .unfollow-link,
	.actions .follow-link {
		float:none;
		margin-bottom:10px;
		display:block;
	}		

	.detail-container .actions .call-to-action {
		padding: 1em;
	}	
	
	.detail-container .actions .call-to-action.follow-link,
	.detail-container .actions .call-to-action.unfollow-link,
	.detail-container .actions .call-to-action.create-contact {
		background-position: 60% 60%;
	}	
	
	.hide-under-480{
		display:none;
	}
	
	.detail-container .actions .cta.join-group,
	.detail-container .actions .cta.leave-group,
	.detail-container .actions .cta.join-request-group,
	.list-item .cta.join-request-group{
		padding: 0.2em 0.3em;
	}	
	
	.detail-container .actions .cta.join-group .icon-plus,
	.detail-container .actions .cta.leave-group .icon-minus,
	.detail-container .actions .cta.join-request-group .icon-plus,
	.list-item .cta.join-request-group .icon-plus{
		margin-right:0;
	}	

	.chatter-info-bar {
    	padding: 0 0 0 1.2em;
	}

	.chatter-info-bar .info-item-container span {
		display: block;
		text-align:center;
	}

	.chatter-info-bar .info-item-container .info-item {
	    padding: 0.675em;
	    font-weight:normal;
	}
	
	.chatter-info-bar .info-item-container .info-item a{
	    font-weight:normal;
	}  

	.chatter-info-bar .info-item-container a span.line-break{
	    font-weight: normal;
	} 	

	/*edit container, used in profile edit and group edit/create*/
	.edit-container .actions {
    	margin-right: 1.250em;
	}	
	
	.edit-container .actions .cta {
    	margin-left: 0.625em;
	}	
	
    .edit-container .form-container .fields-container {
        width: 100%;
    }

    .edit-container .form-container .fields-container .fields-bucket{
        float:none;
        width:100%;
    }

    .edit-container .form-container .fields-container {
        width: 100%;
    }

    .edit-container .form-container .fields-container .fields-bucket{
        float:none;
        width:100%;
    }

    .edit-container .form-container .actions {
        float: none;
        padding: 0;
        text-align: right;
        width: 100%;
    }

	.edit-container .photo-container {
    	float: none;
    	margin-right: 0;
    }
    
	.edit-container .photo-container img {
	    float: left;
	}     
	
	.form-post-container {
	    padding: 1em 1.2em;
	}	

    .form-post-container .button {
        margin: 0 0 0 10px;
        padding: 11px 5px;
    }

    .form-post-container .actions-bucket.mobile .box {
        margin: 0 5px;
        padding: 0.5em 1.5em;
    }

    .form-post-container .actions-bucket.mobile .box .icon-label{
        display:none;
    }

    .form-post-container .actions-bucket.mobile .box.icon-camera,
    .form-post-container .actions-bucket.mobile .box.icon-gallery {
        margin:0;
    }

    .post-actions-container .actions-bucket.desktop .form-upload {
        margin: 30px 0 20px;
    }

    .post-actions-container .actions-bucket.desktop .form-upload .button-browse {
        right: 40px;
    }

    .list-container .list {
        padding: 0;
    }

    .list-container .list-item {
        margin: 0;
        float: none;
        width: 100%;
        box-shadow: none;
        border-left: none;
        border-right: none;
        border-color: -moz-use-text-color -moz-use-text-color #AFAFAF;
        border-style: none none solid;
        border-width: 0 0 1px;
        height:65px;
    }

    .list-container .list-item .list-name {
        float: none;
        margin: 0 0 0 3.750em;
        padding-top: .5em;
    }

    .list-container .list-item .list-foto { margin: 0.5em 3px 3px;}
    .list-container .list-item .follow-link { margin: 15px 5px 0;}
    .list-container .list-item .list-foto img {
        height: 42px;
        width: 42px;
    }
    
	.feed-list .feed-item .item-container {
 	   padding: 1.25em 0.313em 0 1.188em;
	}    

    .feed-list .feed-item .item-foto {
        margin: 0 0.625em 0 0;
    }

    .feed-list .feed-item .item-body {
        float: left;
        margin: 0 0 0.5em 4.4em;
        padding-left: 0;
    }
    
	.comment-list .comment-item .item-body {
    	margin: 0 0 0.313em 3em;
	}    

    .feed-list .feed-item .item-name {
        min-height: 55px;
    }
    
	.feed-list .feed-item .item-name .item-date {
 	   display: block;
	}
	
    .feed-list .feed-item .action-items.comments {
    	margin-left: 5em;
    	margin-right: 0.313em;
    }

    .comment-list {
    	margin-left: 1.188em;
    	margin-right: 0.313em;
    }

    .comment-list .comment-item .item-name {
        min-height: 40px;
    }
    
    .comment-list .comment-item .item-container {
    	padding: .5em 0.313em 0 1.188em;
    }

    .form-post .search-results {
        width: 70%;
        margin-left:0;
    }
}


@media only screen and (-webkit-min-device-pixel-ratio: 1.5),
only screen and (min--moz-device-pixel-ratio: 1.5),
only screen and (min-resolution: 240dpi) {

	.feed-list .feed-item .action-item .icon {
	    background-image:url("media_image_icons_png_chatterfeedSprite_retina");
        -moz-background-size: 45px 52px;
        -o-background-size: 45px 52px;
        -webkit-background-size: 45px 52px;
        background-size: 45px 52px;		    
	}
	
	.feed-list .feed-item .action-item.like .icon {
		background-position: -0px -2px;
	}	
	
	.feed-list .feed-item .action-item.like .me .icon {
		background-position: -28px -2px;
	}	
	
	.feed-list .feed-item .action-item.delete .icon {
	    background-position: 0 -29px;
	}

	.feed-list .feed-item .action-item.delete.me .icon {
    	background-position: -29px -29px;
	}		


}
