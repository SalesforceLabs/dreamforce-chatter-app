/**!
 * css_reset.css
 *
 * Credit:
 *	HTML5 Boilerplate - https://github.com/h5bp/html5-boilerplate
 *	Mobile Boilerplate - https://github.com/h5bp/mobile-boilerplate
 * 	Normalize.css - https://github.com/necolas/normalize.css
 *
 * 	More details: h5bp.com/css
 *
 */

/*
 * Reset all elements to use border-box.
 * http://paulirish.com/2012/box-sizing-border-box-ftw/
 */

* {
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}


/* =============================================================================
   HTML5 display definitions
   ========================================================================== */

/*
 * Corrects block display not defined in IE6/7/8/9 & FF3
 */

article,
aside,
details,
figcaption,
figure,
footer,
header,
hgroup,
nav,
section,
summary {
    display: block;
}


/*
 * Corrects inline-block display not defined in IE6/7/8/9 & FF3
 */

audio,
canvas,
video {
    display: inline-block;
    *display: inline;
    *zoom: 1;
}


/*
 * Prevents modern browsers from displaying 'audio' without controls
 */

audio:not([controls]) {
    display: none;
}


/*
 * Addresses styling for 'hidden' attribute not present in IE7/8/9, FF3, S4
 * Known issue: no IE6 support
 */

[hidden] {
    display: none;
}



/* =============================================================================
   Base
   ========================================================================== */

/*
 * 1. Corrects text resizing oddly in IE6/7 when body font-size is set using em units
 *    http://clagnut.com/blog/348/#c790
 * 2. Prevents iOS text size adjust after orientation change, without disabling user zoom
 *    www.456bereastreet.com/archive/201012/controlling_text_size_in_safari_for_ios_without_disabling_user_zoom/
 */

html {
    font-size: 100%; /* 1 */
    -webkit-text-size-adjust: 100%; /* 2 */
    -ms-text-size-adjust: 100%; /* 2 */
}


/*
 * 1. Addresses margins handled incorrectly in IE6/7
 * 2. Prevents OS X Lion intertial scrolling applied to entire page
 * 	  http://reviews.cnet.com/8301-13727_7-57329926-263/disable-inertial-scrolling-to-fix-os-x-lion-page-jiggles/
 *    http://www.smilingsouls.net/blog/20110804114957.html
 *    http://micho.biz/mac-osx-lion-horizontal-scroll-event/
 */

body {
    margin: 0; /* 1 */
    overflow: hidden; /* 2 */
}


/* =============================================================================
   Links
   ========================================================================== */

/*
 * Addresses outline displayed oddly in Chrome
 */

a:focus {
    outline: thin dotted;
}


/*
 * Improves readability when focused and also mouse hovered in all browsers
 * people.opera.com/patrickl/experiments/keyboard/test
 */

a:hover,
a:active {
    outline: 0;
}


/* =============================================================================
   Typography
   ========================================================================== */


/*
 * Addresses styling not present in IE7/8/9, S5, Chrome
 */

abbr[title] {
    border-bottom: 1px dotted;
}


/*
 * Addresses style set to 'bolder' in FF3+, S4/5, Chrome
*/

b,
strong {
    font-weight: bold;
}

blockquote {
    margin: 1em 40px;
}


/*
 * Addresses styling not present in S5, Chrome
 */

dfn {
    font-style: italic;
}


/*
 * Addresses styling not present in IE6/7/8/9
 * Leaving in here so they will get picked up regardless of the theme. Theme
 * can override later.
 */

mark {
    background: #ff0;
    color: #000;
}


/*
 * Addresses margins set differently in IE6/7
 */

p,
pre {
    margin: 1em 0;
}


/*
 * Corrects font family set oddly in IE6, S4/5, Chrome
 * en.wikipedia.org/wiki/User:Davidgothberg/Test59
 */

pre,
code,
kbd,
samp {
    font-family: monospace, serif;
    _font-family: 'courier new', monospace;
    font-size: 1em;
}


/*
 * Improves readability of pre-formatted text in all browsers
 */

pre {
    white-space: pre;
    white-space: pre-wrap;
    word-wrap: break-word;
}


/*
 * 1. Addresses CSS quotes not supported in IE6/7
 * 2. Addresses quote property not supported in S4
 */

/* 1 */

q {
    quotes: none;
}

/* 2 */

q:before,
q:after {
    content: '';
    content: none;
}


small {
    font-size: 75%;
}


/*
 * Prevents sub and sup affecting line-height in all browsers
 * gist.github.com/413930
 */

sub,
sup {
    font-size: 75%;
    line-height: 0;
    position: relative;
    vertical-align: baseline;
}

sup {
    top: -0.5em;
}

sub {
    bottom: -0.25em;
}



/* =============================================================================
   Lists
   ========================================================================== */

/*
 * Addresses margins set differently in IE6/7
 */

dl,
menu,
ol,
ul {
    margin: 1em 0;
}

dd {
    margin: 0 0 0 40px;
}


/*
 * Addresses paddings set differently in IE6/7
 */

menu,
ol,
ul {
    padding: 0 0 0 40px;
}


/*
 * Corrects list images handled incorrectly in IE7
 */

nav ul,
nav ol {
    list-style: none;
    list-style-image: none;
}


/* =============================================================================
   Embedded content
   ========================================================================== */

/*
 * 1. Removes border when inside 'a' element in IE6/7/8/9, FF3
 * 2. Improves image quality when scaled in IE7
 *    code.flickr.com/blog/2008/11/12/on-ui-quality-the-little-things-client-side-image-resizing/
 * 3. Remove the gap between images and borders on image containers: h5bp.com/i/440
 * 4. Responsive images
 */

img {
    border: 0; /* 1 */
    -ms-interpolation-mode: bicubic; /* 2 */
    vertical-align: middle; /* 3 */
    max-width: 100%; /* 4 */
}


/*
 * Corrects overflow displayed oddly in IE9
 */

svg:not(:root) {
    overflow: hidden;
}



/* =============================================================================
   Figures
   ========================================================================== */

/*
 * Addresses margin not present in IE6/7/8/9, S5, O11
 */

figure {
    margin: 0;
}



/* =============================================================================
   Forms
   ========================================================================== */

/*
 * Corrects margin displayed oddly in IE6/7
 */

form {
    margin: 0;
}


/* Indicate that 'label' will shift focus to the associated form element */
label {
    cursor: pointer;
}


/*
 * 1. Corrects color not being inherited in IE6/7/8/9
 * 2. Corrects text not wrapping in FF3
 * 3. Corrects alignment displayed oddly in IE6/7
 */

legend {
    border: 0; /* 1 */
    padding: 0;
    white-space: normal; /* 2 */
    *margin-left: -7px; /* 3 */
}


/*
 * 1. Corrects font size not being inherited in all browsers
 * 2. Addresses margins set differently in IE6/7, FF3+, S5, Chrome
 * 3. Improves appearance and consistency in all browsers
 */

button,
input,
select,
textarea {
    font-size: 100%; /* 1 */
    margin: 0; /* 2 */
    vertical-align: baseline; /* 3 */
    *vertical-align: middle; /* 3 */
}


/*
 * 1. Define line-height as normal to match FF3/4 (set using !important in the UA stylesheet)
 * 2. Correct inner spacing displayed oddly in IE6/7
 */

button,
input {
    line-height: normal;
    *overflow: visible;
}


/*
 * 1. Improves usability and consistency of cursor style between image-type 'input' and others
 * 2. Corrects inability to style clickable 'input' types in iOS
 * 3. Removes inner spacing in IE7 without affecting normal text inputs
 *    Known issue: inner spacing remains in IE6
 */

button,
input[type="button"],
input[type="reset"],
input[type="submit"] {
    cursor: pointer; /* 1 */
    -webkit-appearance: button; /* 2 */
    *overflow: visible;  /* 3 */
}


/*
 * Re-set default cursor for disabled elements
 */

button[disabled],
input[disabled] {
    cursor: default;
}


/*
 * 1. Addresses box sizing set to content-box in IE8/9
 * 2. Removes excess padding in IE8/9
 * 3. Removes excess padding in IE7
      Known issue: excess padding remains in IE6
 */

input[type="checkbox"],
input[type="radio"] {
    box-sizing: border-box; /* 1 */
    padding: 0; /* 2 */
    *height: 13px; /* 3 */
    *width: 13px; /* 3 */
}


/*
 * 1. Addresses appearance set to searchfield in S5, Chrome
 * 2. Addresses box-sizing set to border-box in S5, Chrome (include -moz to future-proof)
 */

/****
input[type="search"] {
    -webkit-appearance: textfield; /* 1 */
/****    -moz-box-sizing: content-box;
    -webkit-box-sizing: content-box; /* 2 */
/****    box-sizing: content-box;
}***/


/*
 * Removes inner padding and search cancel button in S5, Chrome on OS X
 * If you use the above, you probably want to use this too
 */
/***
input[type="search"]::-webkit-search-decoration,
input[type="search"]::-webkit-search-cancel-button {
    -webkit-appearance: none;
}***/


/*
 * Removes inner padding and border in FF3+
 * www.sitepen.com/blog/2008/05/14/the-devils-in-the-details-fixing-dojos-toolbar-buttons/
 */

button::-moz-focus-inner {
    border: 0;
    padding: 0;
}


textarea {
    overflow: auto;
    vertical-align: top;
    resize: vertical;
}


/*
 * Reintroduce inner spacing in 'table' to avoid overlap and whitespace issues in IE6/7
 */

table button,
table input {
    *overflow: auto;
}



/* =============================================================================
   Tables
   ========================================================================== */

table {
    border-collapse: collapse;
    border-spacing: 0;
}
td {
    vertical-align: top;
}



