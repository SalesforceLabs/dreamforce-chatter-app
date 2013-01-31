/**!
 *
 * css_panelPageContent
 *
 * For landing pages, etc.
 *
 */



.simpleHeader,
.bannerMessage {
    text-align: center;
}


/*** Landing Page stuff ***/

.landingPage,
.panelPage,
.footer {
    max-width: 60em;
}


.landingPage .columnContent,
.panelPage .columnContent {
    /* Background color in backgroundsShared */
    padding: 0 0.625em; /* 10px */
}


.landingPage .columnContent,
.panelPage .columnContent,
.bannerMessage {
    margin: 0 0.625em; /* 10px */
}


.landingPage .loginFormWrap,
.panelPage .formWrap {
    margin: 0 auto;
    padding: 0 0 4em;
    position: relative;
}


.landingPage .loginForm {
    display: none;
}


.landingPage .loginForm input,
.landingPage .loginForm select,
.landingPage .loginForm textarea,
.panelPage .form input,
.panelPage .form select,
.panelPage .form textarea {
    width: 100%;
}


