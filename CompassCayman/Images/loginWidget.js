var loginModal = null;
document.observe('dom:loaded', function () {
    if (loginModal != null) modal.close();
    loginModal = new Control.Modal($('loginLink'), {
        overlayOpacity: 0.75,
        className: 'modal',
        closeOnClick: 'login_close',
        fade: true
    });

    if (loginError == 'True') {
        if (loginModal != null) {
            loginModal.open();
        }
    }
});