function showErrorMessage(msg) {
    alert(msg);
}

$(function () {
    $('#js-login').click(function () {
        $.get('/user/login', {
            'username': $('#login-username').val(),
            'password': $('#login-password').val()
        }, function(res) {
            if (typeof(res) == 'string') {
                res = JSON.parse(res);
            }
            var success;
            if (res.code && res.code == 200) {
                success = true;
            }
            if (success) {
                window.location.href = "/dashboard";
            } else {
                showErrorMessage(res.message);
            }
        });
    });

    $('#js-signup').click(function () {
        $.post('/user/create', {
            'username': $('#signup-username').val(),
            'email': $('#signup-email').val(),
            'password': $('#signup-password').val()
        }, function (res) {
            //TODO: change when endpoint is defined
            var success = true;

            if (success) {
                window.location.href = "/dashboard";
            } else {
                showErrorMessage(res);
            }
        });
    });

    $('#js-ToLogin').click(function() {
        $('#signup-container').hide();
        $('#login-container').show();
    });

    $('#js-ToSignup').click(function() {
        $('#login-container').hide();
        $('#signup-container').show();
    });  
});