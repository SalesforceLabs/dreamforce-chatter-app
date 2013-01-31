/**!
 * css_themes_default.css
 *
 *
 */

/* =============================================================================
   Modals, Dialogs and Masks
   ========================================================================== */


#pageMask,
.areaMask {
    background-color: #000;
    opacity: 0.5;
    /* IE lte 8 */
    filter: alpha(opacity = 50)\9;
    zoom: 1\9;
}

.areaMask.alternate,
#pageMask.alternate {
    background-color: #fff;
    opacity: 0.5;
    /* IE lte 8 */
    filter: alpha(opacity = 50)\9;
    zoom: 1\9;
}


/*#overlayMask {
background: #000;
opacity: 0.5;
filter: alpha(opacity = 50)\9;
zoom: 1\9;
}*/


/*
 * Per spec at http://proto/touch/dropdown/warning.png
 */
 #simplemodal-overlay {
    background-color: #000;
    cursor:wait;
}
/*#simplemodal-container {
    padding:0 1em;
}*/
#simplemodal-container .simplemodal-wrap {
    /*font-size: 0.813em;					/* 13px; */
    color: #363c40;
    /*text-shadow: 0px 1px 0px #DDD;*/
    background: #f0f3f4;
    position: relative;                     /* Fixes Bug that displays the button outside the modal window when the viewport is too small */
    border: 3px solid #38bae3 !important;
    -moz-border-radius: 	7px;
    -webkit-border-radius:	7px;
    border-radius:			7px;
    -moz-box-shadow: 		0px 3px 15px rgba(0, 0, 0, 0.3);
    -webkit-box-shadow: 	0px 3px 15px rgba(0, 0, 0, 0.3);
    box-shadow: 			0px 3px 15px rgba(0, 0, 0, 0.3);
}
#simplemodal-container h1 {
    font-size: 1.1em;
    text-align: center;
    /*margin: 0 0 1em;*/
}
#simplemodal-container p {
    color: #444;
    font-size: 0.9em;
    padding: 0.2em 0.4em;
}
#simplemodal-container ul {
    font-size: 0.9em;
}
#simplemodal-container ul ul {
    font-size: 1em; /* Use parent ul's font-size */
}
#simplemodal-container #tosContent div.textContainer {
    background: #FFF;
    height:65%;
    width: 96%;
    position:absolute;
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch;
    -moz-border-radius: 	3px;
    -webkit-border-radius:	3px;
    border-radius:			3px;
    -moz-box-shadow: 		0px 1px 1px rgba(0, 0, 0, 0.1);
    -webkit-box-shadow: 	0px 1px 1px rgba(0, 0, 0, 0.1);
    box-shadow: 			0px 1px 1px rgba(0, 0, 0, 0.1);
}

#simplemodal-container #tosContent .buttonContainer a {
    margin: 0;
}

#simplemodal-container li {
    list-style-type: none;
}

/********** DEBUG *************/
/*.bLeft {
}
.bRight {
    background: pink;
}
.bBody {
    background: white;
}
.stackItem {
    background: beige;
}
*/

/* =============================================================================
   Base
   ========================================================================== */


/*
 * Remove text-shadow in selection highlight: h5bp.com/i
 * ###### These selection declarations have to be separate
 */

::-moz-selection {
    background: #97d7dc;
    color: #fff;
    text-shadow: none;
}
::selection {
    background: #97d7dc;
    color: #fff;
    text-shadow: none;
}


/*
 * Addresses font-family inconsistency between 'textarea' and other form elements.
 */

html,
button,
input,
select,
textarea {
    font-family: sans-serif;
}


/*
 * See Eric Meyer on unitless line-heights:
 * http://meyerweb.com/eric/thoughts/2006/02/08/unitless-line-heights/
 */
body {
    font-size: 1em;
    line-height: 1.4;
}



body,
button,
input,
select,
textarea {
    font-family: sans-serif;
    color: #2a2a2a;
}



.masthead {
    background-repeat: no-repeat;
}



.appNav {
    background:#2A7DB2;
}



.appNavBar{
    -webkit-box-shadow: inset 0 -1px 0 #2C79AB;
    box-shadow:         inset 0 -1px 0 #2C79AB;
}



.toolbar {
    position: relative;
    border-bottom: 1px solid #0D84AF;
    border-top: 1px solid #3E8DBF;
    background: #2E81BD;
    height: 2.86em;
    line-height: 2.86em;
    -webkit-box-shadow: 0 1px 5px #111;
    box-shadow: 0 1px 5px #111;
    z-index: 99999;
}

.sidebar {
    background: #3F484F;
    color: #fff;
    -moz-box-shadow: 	1px 0 1px rgba(150, 150, 150, .4);
    -webkit-box-shadow: 1px 0 1px rgba(150, 150, 150, .4);
    box-shadow: 		1px 0 1px rgba(150, 150, 150, .4);
}



.panels {
    background-color: #f9f9f9;
    height: 100%;
}

.panelHeaderBar,
.panelHeaderSearchBar {
    line-height: 2;
    border-bottom: 1px solid #e7e7e7;
}

.panelHeaderBar {
    background-color: #fff;
    color: #727272;
}

.panelHeaderBar h3 {
    font-weight: bold;
    text-transform: uppercase;
    font-size: 1em;
    line-height: 2.375em;
}

.panelHeaderSearchBar {
    background: #ffffff;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffffff), color-stop(100%,#e5e5e5));
    background: -webkit-linear-gradient(top, #ffffff 0%,#e5e5e5 100%);
    background:    -moz-linear-gradient(top, #ffffff 0%, #e5e5e5 100%);
    background:     -ms-linear-gradient(top, #ffffff 0%,#e5e5e5 100%);
    background:      -o-linear-gradient(top, #ffffff 0%,#e5e5e5 100%);
    background:         linear-gradient(to bottom, #ffffff 0%,#e5e5e5 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#e5e5e5',GradientType=0 );
}

.refresh {
    background-image: url('media_image_icons_png8_searchBarRefresh');
}

label {
    color: #000;
    font-size: 0.75em;
}

.sidebarMainTitle {
    font-size: 0.875em;
    color:#C7C7C7;
    text-transform: uppercase;
}

.sidebarRegList {
    margin: 0;
    padding: 0;
    list-style-type: none;
}
.sidebarRegList li {
    color: #fff;
    font-weight: bold;
    font-size: 0.875em; /* 14px */
    text-shadow: 0 1px 0 #000;
}

.sidebarRegList a {
    border-bottom: 1px solid #2C353C;
    border-top: 1px solid #4E575E;
}

/* Put first so we can more easily override */
.sidebarRegList a:hover {
    color: #212426;
    border: 1px solid #000;
}
.sidebarRegList a.uneditable {
    background: #3F484F;
    color: #808488;
    font-weight: bold;
    text-shadow: none;
}
.sidebarRegList a.editable,
.sidebarRegList a:visited.editable {
    background: #3F484F;
    color: #fff;
}
.sidebarRegList a:hover.editable {
    background-color: #1C252C;
    border: 1px solid #000;
}

.sidebarRegList a:hover.uneditable {
    border-left:none;
    border-bottom: 1px solid #2C353C;
    border-top: 1px solid #4E575E;
}
.sidebarRegList a.current,
.sidebarRegList a:visited.current {
    color: #fff;
    background: #1C252C;
    border: 1px solid #000;
    -moz-box-shadow:    inset 0 0 7px #111;
    -webkit-box-shadow: inset 0 0 7px #111;
    box-shadow:         inset 0 0 7px #111;
}

.sidebarRegList a.current,
.sidebarRegList a.uneditable {
    cursor: default;
}

.hidden {
    display:none;
}

#detailView {
    background: #F9F9F9;
}

#detailView,
.listItem .listDetailTitle,
.listDetailTitle .listInfo {
    color: #3f3f3f;
}


/* =============================================================================
   Links
   ========================================================================== */


a {
    color: #3d9cd1;
    text-decoration: none;
}
a:visited {
    color: #3d9cd1;
}
a:hover {
    color: #009ddc;
}

.header,
.toolbar,
a.appNavLink,
a:visited.appNavLink,
a:active.appNavLink{
    font-weight: bold;
    color: #FFF;
}

a:hover.appNavLink {
    color: #bbb;
}

.telLink,
.smsLink,
.mailtoLink {
    color: #3d9cd1;
    cursor: pointer;
}

.telLink:hover,
.smsLink:hover,
.mailtoLink:hover {
    color: #009ddc;;
}


.toggleNav {
    cursor: default;
}
.canToggleNav .toggleNav {
    cursor: pointer;
}

.toolbarButton {
    background: transparent none;
    border: 0 none;
    color: #FFF;
    display: block;
    float: left;
    font-size: 0.9em;
    font-weight: bold;
    height: 2.25em;
    line-height: 2.25em;
    margin: 0.367em 0 0 0;
    padding: 0 0.5em;
    position: relative;
    -webkit-appearance: none;
}

.toggleNavCurrentSelection {
    float: left;
    margin-right: 10px;
}

.toolbarButton .toggleNavIcon {
    background-color: #256F9E;
    background-position: 10px 8px;
    border: 1px solid #205F87;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    border-radius: 4px;
    display: block;
    float: left;
    height: 2.25em;
    margin: 0 0.5em 0 0;
    position: relative;
    width: 2.57em;
}


.logo {
    position:absolute;
    left:50%;
    margin-left:-97px; 
    top:-2px;
}

#ie7ToggleNavIcon {
    display:none;
}

#toggleTopNav,
.hideNav #toggleTopNav {
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAHCAYAAAA4R3wZAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYxIDY0LjE0MDk0OSwgMjAxMC8xMi8wNy0xMDo1NzowMSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNS4xIE1hY2ludG9zaCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCQTUzQjk1NUNBRUIxMUUxOUNCRUFGN0VCRUE4MDM2OSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCQTUzQjk1NkNBRUIxMUUxOUNCRUFGN0VCRUE4MDM2OSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkJBNTNCOTUzQ0FFQjExRTE5Q0JFQUY3RUJFQTgwMzY5IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkJBNTNCOTU0Q0FFQjExRTE5Q0JFQUY3RUJFQTgwMzY5Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+ArSfewAAAFRJREFUeNpi+PX3XyMQ/4fi1UDMDMQMWPB8JHUzYYKENKNoAokhS7bg0IyhCV0jNs1YNWHTCMLtSIqxasKlEV3zTGxqGMG6sYN2IBYC4nRskgABBgCd/B4zVSAThwAAAABJRU5ErkJggg%3D%3D);
    display: block;
    float: left;
    padding: 0 1.231em;
    height: 1.6em;
    background-repeat: no-repeat;
    background-position: 50% 60%;
    border: 2px groove #97D7DC;
    border-radius: 5px;
    margin-top: 4%;
}

#toggleTopNav {
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAHCAYAAAA4R3wZAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAABIAAAASABGyWs+AAAACXZwQWcAAAAOAAAABwBgmUq+AAAAW0lEQVQY02P89fcfAw6Qz8DAwM/AwNCETZIFj6YJSHxMzb/+/kPH+b/+/vuPhqvR1eHTdODX339bcGnGp4nz199/bL/+/tuIJF6BrhGbJpgcVs3omvaiacKpGQCaMfLginYA8wAAACJ6VFh0U29mdHdhcmUAAHjac0zJT0pV8MxNTE8NSk1MqQQAL5wF1K4MqU0AAAAASUVORK5CYII%3D);
}

.toggleList {
    border-right: 1px solid #0094CE;
}

.toggleList .showOnSideBarHide{
    border-left: 1px solid #0094CE;
}

#toggleButton {
    height: 2.25em;
    width: 1.25em;
    padding-right: 0.625em;
}

.canToggleNav {
    cursor: pointer;
}

#qrReader {
    width:50px;
    background-repeat: no-repeat;
    background-position: 50% 50%;
    background-image: url(media_image_icons_png8_qr);
}


#printButton {
    background-image: url(media_image_icons_png8_printButton);
}

#calendarSync {
    background-image: url(media_image_icons_png8_icalButtonHighRes);
}

/* =============================================================================
   Typography
   ========================================================================== */


/*
 * Addresses font sizes and margins set differently in IE6/7
 * Addresses font sizes within 'section' and 'article' in FF4+, Chrome, S5
 */

h1 {
    font-size: 2em;
    margin: 0.67em 0;
}

h2 {
    font-size: 1.5em;
    margin: 0.83em 0;
}

h3 {
    font-size: 1.17em;
    margin: 1em 0;
}

h4 {
    font-size: 1em;
    margin: 1.33em 0;
}

h5 {
    font-size: 0.83em;
    margin: 1.67em 0;
}

h6 {
    font-size: 0.75em;
    margin: 2.33em 0;
}

/* Override any extra SFDC CSS rules */
h1, h2, h3, h4, h5, h6 {
    display: block;
}



mark {
    background: #ff0;
    color: #000;
}



hr {
    display: block;
    height: 1px;
    border: 0;
    border-top: 1px solid #ccc;
    margin: 1em 0;
    padding: 0;
}



ins {
    background: #ff9;
    color: #000;
    text-decoration: none;
}



pre,
code,
kbd,
samp {
    font-family: monospace, serif;
    _font-family: 'courier new', monospace;
    font-size: 1em;
}

small {
    font-size: 75%;
}

.ghostText,
.lockedField {
    color: #8f8f8f;
    margin-left: 10px;
}

.green {
    color: #009900;
}

.disabledFields label {
    color: #8f8f8f;
    cursor: default;
}

p {
    font-size: 0.813em;	/* 13px */
}

p.big {
    font-size: 1em;
}

.importantText {
    font-weight: bold;
    color: #FD4a4a;
}

/* =============================================================================
   Forms
   ========================================================================== */

form.styled {
    background: #F0F3F4;
}


/*
 * Define consistent border, margin, and padding
 */

fieldset {
    border: 1px solid #c0c0c0;
    margin: 0 2px;
    padding: 0.35em 0.625em 0.75em;
}


button,
input,
select,
textarea {
    font-size: 100%;
}


/* Colors for form validity */
input:valid,
textarea:valid {  }

input:invalid,
textarea:invalid {
    background-color: #f0dddd;
}


input,
select,
textarea {
    color: #444;
    border: 1px solid #cacaca;
    /*-webkit-appearance: none;			/* Disables default iOS styles, like inner shadow */
}

input[type='radio']{
    border:none;
}

/*
.fieldContainer.nice {
    background: white none;
    border: 3px solid white;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, .5);
    border-radius: 3px;
}*/


/* This is the default way text-based input fields should look */
input[type="text"],
input[type="password"],
input[type="email"],
select,
textarea,
textarea.input {
    overflow: hidden;
    width: 100%;
    font-family: inherit;
    font-size: 1em;
    line-height: 1em;
    height: 2.25em;
    resize: none;
    padding: 0.5em;
    -moz-border-radius: 	3px;
    -webkit-border-radius: 	3px;
    border-radius: 			3px;
    -webkit-transition: height .4s ease-in-out; 
}
textarea {
    height: auto;
}


input.nice,
select.nice,
textarea.nice {
    border: none;
    background: white none;
    border: 3px solid white;
    -moz-box-shadow: 	inset 0 1px 2px rgba(0, 0, 0, .5);
    -webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, .5);
    box-shadow: 		inset 0 1px 2px rgba(0, 0, 0, .5);
}

.totalAmount {
    font-weight: bold;
    font-size: 1.1em;
}

.discount {
    font-weight: bold;
    font-size: 1em;
    margin-bottom: 0;
}

.error .errorText,
.error label,
.formError,
.customError {
    color: #FD4a4a;
}
.error input,
.error select {
    border-color: #FD4a4a;
}

.valid select {
    border-color: #8fbd35;
}

/* PageMessages errors */
.infoM3 {
    font-size: 0.813em;
}

.errorM2 h4,
.errorM3 h4 {
    margin:0;
}
.errorM2 .messageCell br,
.errorM3 .messageCell br {
    display: none;
}
.errorM3 li,
.errorM3 li {
    list-style-type: none;
}
.errorM2,
.errorM3 {
    color: #FD4a4a;
    margin-bottom: 0.5em;
}

.errorM2 {
    color: #fd4a4a;
}

/* =============================================================================
   Lists
   ========================================================================== */

ul.summary {
    margin-bottom: 1em;
    list-style-type: none;
}

ul.summary > .line {
    border-bottom: 1px solid #cdcdcd;
    margin-bottom: 1em;
    padding-bottom: 1em;
}

ul.summary dl {
    font-size: 0.813em;
}

ul.summary dl dt,
ul.summary dl dd {
    display: inline;
    margin: 0;
    padding: 0;
}

ul.summary dl dd {
    margin-right: 2em;
}



/* =============================================================================
   Buttons
   ========================================================================== */

.osButton.styled {
    font-weight: bold;
    font-size: .9em;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    border-radius: 4px;
    border: 0;
    border-top: 1px solid rgba(255,255,255,.45);
    background: #F8F8F9;
    /*background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#F8F8F9), to(#DDDFE1));*/
    text-shadow: #fff 0px 1px 1px;
    -moz-box-shadow: 	rgba(0, 0, 0, 0.699219) 0px 1px 3px, rgba(0, 0, 0, 0.296875) 0px 1px 0px;
    -webkit-box-shadow: rgba(0, 0, 0, 0.699219) 0px 1px 3px, rgba(0, 0, 0, 0.296875) 0px 1px 0px;
    box-shadow: 		rgba(0, 0, 0, 0.699219) 0px 1px 3px, rgba(0, 0, 0, 0.296875) 0px 1px 0px;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#F8F8F9), color-stop(100%,#DDDFE1));
    background: -webkit-linear-gradient(top, #F8F8F9 0%, #DDDFE1 100%);
    background:    -moz-linear-gradient(top, #F8F8F9 0%, #DDDFE1 100%);
    background:     -ms-linear-gradient(top, #F8F8F9 0%, #DDDFE1 100%);
    background:      -o-linear-gradient(top, #F8F8F9 0%, #DDDFE1 100%);
    background:         linear-gradient(top, #F8F8F9 0%, #DDDFE1 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#F8F8F9', endColorstr='#DDDFE1',GradientType=0 );
}


.osButton.styled:hover {
    background: #757D8A;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7F8792), color-stop(100%,#DDDFE1));
    background: -webkit-linear-gradient(top, #7F8792 0%, #535B68 100%);
    background:    -moz-linear-gradient(top, #7F8792 0%, #535B68 100%);
    background:     -ms-linear-gradient(top, #7F8792 0%, #535B68 100%);
    background:      -o-linear-gradient(top, #7F8792 0%, #535B68 100%);
    background:         linear-gradient(top, #7F8792 0%, #535B68 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7F8792', endColorstr='#535B68',GradientType=0 );
    border: 0;
    border-top: 1px solid rgba(255,255,255,.45);
    text-shadow: rgba(0, 0, 0, 0.5) 0px -1px 1px;
    color: #fefefe;
}


.osButton.styled .label {
    color: #3A3D42;
}


.osButton.styled:hover .label {
    color: #fff;
}


.uiButton.fancy,
.uiButton.fancy:hover {
    color: #363C40;
    border: 1px solid #9D9D9D;
    -moz-box-shadow: 	inset 0 1px 0 0 #fff;
    -webkit-box-shadow: inset 0 1px 0 0 #fff;
    box-shadow: 		inset 0 1px 0 0 #fff;
    background-color: #F0F3F4;
    /*background-color: #39bbe4;	/* See spec at http://proto/touch/dropdown/warning.png */
}


.uiButton,
.uiButton:hover,
.uiButton:visited,
.iconButton.toggleFilters,
.iconButton.toggleFilters:hover,
.iconButton.toggleFilters:visited {
    border: 1px solid #096286;
    color: #fff;
    background: #418fc0; /* Old browsers */
    background: -moz-linear-gradient(top,  #418fc0 0%, #2d83b9 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#418fc0), color-stop(100%,#2d83b9)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top,  #418fc0 0%,#2d83b9 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top,  #418fc0 0%,#2d83b9 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top,  #418fc0 0%,#2d83b9 100%); /* IE10+ */
    background: linear-gradient(to bottom,  #418fc0 0%,#2d83b9 100%); /* W3C */
}

.uiButton.clearFilters,
.uiButton.clearFilters:hover {
    border-color:#858585;
    background: #bbbbbb; /* Old browsers */
    background: -moz-linear-gradient(top,  #bbbbbb 0%, #a1a1a1 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#bbbbbb), color-stop(100%,#a1a1a1)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top,  #bbbbbb 0%,#a1a1a1 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top,  #bbbbbb 0%,#a1a1a1 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top,  #bbbbbb 0%,#a1a1a1 100%); /* IE10+ */
    background: linear-gradient(to bottom,  #bbbbbb 0%,#a1a1a1 100%); /* W3C */
}

.uiButton.close,
.uiButton.close:hover {
    width:33px;
    height: 33px;
    min-width: 0;
    padding: 0;
    border:none;
    line-height: 1em;
    background:url(media_image_icons_png8_closeX) no-repeat center center;
}

.uiButton.selected,
.uiButton.selected:hover {
    background-color: #1679c9;
    color: #fff;
    border-color: #9d9d9d;
}

.uiButton.applyFilters {
    border-color:#788B2D;
    background: #afc753; /* Old browsers */
    background: -moz-linear-gradient(top,  #afc753 0%, #96ae3a 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#afc753), color-stop(100%,#96ae3a)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top,  #afc753 0%,#96ae3a 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top,  #afc753 0%,#96ae3a 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top,  #afc753 0%,#96ae3a 100%); /* IE10+ */
    background: linear-gradient(to bottom,  #afc753 0%,#96ae3a 100%); /* W3C */
}

.uiButton.submit,
.uiButton.submit:hover {
    background: #ff8c00;
    color: #fff;
    border-color: #ffd633;
    min-width: 4em;
}

.uiButton.loginBtn,
.uiButton.loginBtn:hover {
    background: #F18D03;
    color: #fff;
    border-color: #c2c2c2;
    text-shadow: 0 0 transparent;
}

.uiButton.signupBtn,
.uiButton.signupBtn:hover {
    background: #a2c647;
    color: #fff;
    border-color: #c2c2c2;
    text-shadow: 0 0 transparent;
}

.uiButton.tag,
.uiButton.tag:hover {
    border-color: #1D6B9C;
    -moz-border-radius: 15px;
    -webkit-border-radius: 15px;
    border-radius: 15px;
    background: #2C82B9;
    color: #FFF;
}

.uiButton.disabled,
.uiButton.disabled:hover {
    opacity: 0.30;
    /* IE lte 8 */
    filter: alpha(opacity = 30)\9;
    zoom: 1\9;
}

/* W-1356332: FireFox- Romove button is not solid Red. */
.uiButton::-moz-selection {
    background: transparent;
}

.uiButton::selection {
    background: transparent;
}

.iconButton.toggleFilters .toggleFiltersIcon {
    -webkit-background-size: 18px 18px;
       -moz-background-size: 18px 18px;
         -o-background-size: 18px 18px;
            background-size: 18px 18px;
    background: url('media_image_icons_png_toggleFilters') 50% 50% no-repeat;
}

.panelHeaderBar .refreshButton,
.panelHeaderBar .refreshButton:hover,
.panelHeaderBar .refreshButton:visited {
    -webkit-background-size: 29px 24px;
       -moz-background-size: 29px 24px;
         -o-background-size: 29px 24px;
            background-size: 29px 24px;
    background: url('media_image_icons_png8_refresh') 50% 50% no-repeat;
}


/* =============================================================================
   Text
   ========================================================================== */

.footnote {
    font-size: 0.8em;
    color: #444;
}


.required {
    color: #fd6262;
}

.requiredLegend,
.requiredLegendSignup {
    float: right;
    margin: 0.625em 1.25em 0 0.313em;
}
.requiredLegendSignup {
    margin: 0;
    padding-top: 1.4em;
}
.requiredLegend span:not(.required),
.requiredLegendSignup span:not(.required) {
    font-size: 0.8em;
}


/* =============================================================================
   Chrome Frame Prompt
   ========================================================================== */

.chromeframe {
    margin: 0.2em 0;
    background: #ccc;
    color: black;
    padding: 0.2em 0;
}

/* =============================================================================
   Table
   ========================================================================== */

.uitable {
    margin-bottom: 1em;
}

.uitable thead {
    line-height: 1.5em;
    font-size: 1em;
    font-weight: bold;
    color: #363C40;
    border: 1px solid #9D9D9D;
    -moz-border-radius:     3px;
    -webkit-border-radius:  3px;
    border-radius:          3px;
    -moz-box-shadow:    inset 0 1px 0 0 #fff;
    -webkit-box-shadow: inset 0 1px 0 0 #fff;
    box-shadow:         inset 0 1px 0 0 #fff;
    background-color: #F0F3F4;
}

.uitable th {
    text-align:left;
    padding: 0.5em;
}
.uitable td {
    padding: 0.5em;
    font-size: 0.75em;
}

.uitable .odd,
.uitable .even {
    background-color: #FFFFFF;
    border: 1px solid #9D9D9D;
}

.productsList {
    box-shadow: 3px 2px 3px 0px #b4b4b4
}

/* =============================================================================
   Accordion
   ========================================================================== */

.accordionHeader {
    background: #fff;
    text-transform: uppercase;
    border-bottom: 1px solid #d5d5d5;
    color: #009ddc;
    cursor: pointer;
    position: relative;
}

.accordionHeader .checkmark {
    display: none;
}

.accordionHeader.done .checkmark {
    position: absolute;
    top: 50%;
    right: 1.5em;
    margin-top: -15px;
    display: block;
}

.accordionHeader h3,
.accordionHeader h4 {
    line-height: 3.2em;
    margin: 0 0.5em 0 0;
    padding: 0 0 0 3em;
    display: inline-block;
    background-image: url(media_image_buttons_png_accordionCollapsed);
    background-position: 1.4em 1em;
    background-repeat: no-repeat;
}

.accordionHeader.open h3 {
    background-image: url(media_image_buttons_png_accordionExpanded);
    background-position: 1.4em 1.2em;
}

.accordionItem {
    background-color: #f2f2f2;
    padding: 1em 1em 1em 1.7em;
    border-bottom: 1px solid #b4b4b4;
}

.accordionItem h4 {
    margin: 0;
}

.accordionItem input[type="checkbox"] {
    display: none;
}

.accordionItem .description {
    margin-right: 185px;
}

.accordionItem .price {
    line-height: 2em;
}

.accordionItem .description,
.accordionItem .productDate {
    font-size: 0.813em; /* Should be the same as our default <p> font-size */
}

.reservationInfo h4 {
    margin: 0.5em 0;
}

#undoChange {
    display: none;
}

.hideNav .header {
    display: none;
}

/* Grey Accordion */


.greyAccordion .accordionHeader {
    background: #e1e1e1;
    border-bottom: 1px solid #B4B4B4;
    border-top: none;
    color: #3f3f3f;
}

.greyAccordion .accordionHeader h4 {
    line-height: 3em;
    background-image: url(media_image_buttons_png_accordionCollapsed);
    background-position: 1.4em 1em;
    padding: 0.3em 0 0 3.5em;
}

.greyAccordion .accordionHeader.open h4 {
    background-image: url(media_image_buttons_png_accordionExpanded);
    background-position: 1.4em 1.4em;
}

.greyAccordion .accordionItem {
    padding: 0;
    background: #fff;
}

/* White Accordion */

.whiteAccordion .accordionHeader {
    background: #FFF;
    border-bottom: 1px solid #D5D5D5;
    border-top: none;
    color: #009DDC;
    filter: "progid:DXImageTransform.Microsoft.gradient(enabled=false)";
}

.whiteAccordion .accordionHeader h4 {
    line-height: inherit;
    background-image: url('media_image_icons_png8_accordionArrowRight');
    background-position: 2.75em 1.15em;
    padding: 0.9em 0 0.85em 4em;
    font-size:.8em;
    text-transform: uppercase;
}

.whiteAccordion .accordionHeader.open h4 {
    background-image: url('media_image_icons_png8_accordionArrowDown');
    background-position: 2.75em 1.15em;
}

.whiteAccordion .accordionItem {
    padding: 0;
    background: #fff;
}

.whiteAccordion .accordionItem.noBackground {
    background: none;
}
/* =============================================================================
   Static Pages Heading
   ========================================================================== */
.staticHeading h1,
.staticHeading h2,
.staticHeading h3 {
    color: #3F484F;
}

.staticHeading h2 {
    font-size: 1.7em;
}

.staticHeading h3 {
    font-size: 1.4em;
}
/* =============================================================================
   Help
   ========================================================================== */

ul.helpActions {
    margin: 1em auto;
}

.helpAction {
    position: relative;
    background: #fff;
    border: 1px solid #ebebeb;
    -moz-border-radius:     7px;
    -webkit-border-radius:  7px;
    border-radius:          7px;
}

.helpActionTitle {
    color: #333;
    font-size: 1.3em;
    font-weight: bold;
    line-height: 1.1em;
}

.altBack {
    background: #F9F9F9;
    border-bottom: 1px solid #e7e7e7;
}

ul.steps {
    padding: 0;
    width: 100%;
    float: left;
    background: #fff;
    border: 1px solid #ECECEC;
}

ul.steps li {
    list-style: none;
    padding: 1em;
    font-size: 0.8em;
    color: #5B6365;
    font-weight: bold;
    width: 33.3333%;
    height: 100%;
    min-height: 100%;
}

ul.steps li.notFirst {
    border-left: 1px solid #ECECEC;
}

ul.steps span.step {
    color: #F28B26;
    font-size: 2.5em;
    float: left;
    display: inline-block;
}

ul.steps span.info {
    display: block;
    padding-left: 2em;
}

div.importantDates {
    font-size: 0.9em;
}

div.importantDates h3 {
    background: #2C82B9 url(media_image_icons_png_calendar_heading) no-repeat 5px 11px;
    color: #fff;
    padding: 0.7em;
    padding-left: 2em;
    margin-bottom: 0;
    font-size: 0.95em;
}

div.importantDates ul {
    padding: 0;
    margin-top: 0;
}

div.importantDates li {
    padding: 1em;
    list-style: none;
    font-size: 0.9em;
    border: 1px solid #ECECEC;
    border-top: none;
}

.containerButtons {
    width: 100%;
}

.bigButton {
    background: #fff;
    border: 1px solid #ebebeb;
    width: 35%;
    margin: 5%;
    padding-left: 5em;
}


