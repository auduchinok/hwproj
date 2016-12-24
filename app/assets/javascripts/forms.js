jQuery(document).on('ready page:load page:restore', function() {
    $('.glyphicon-wrench').popover({
        container: 'body',
        placement: 'right',
        html: true,
        trigger: 'manual',
        content: function() {
            return $('#popover_content_wrapper').html();
        }
    }).on("mouseenter", function() {
        var _this = this;
        $(this).popover("show");
        $(".popover").on("mouseleave", function() {
            $(_this).popover('hide');
        });
    }).on("mouseleave", function() {
        var _this = this;
        setTimeout(function() {
            if (!$(".popover:hover").length) {
                $(_this).popover("hide");
            }
        }, 100);
    });
    $("body").on('1ouseleave', '.popover', function() {
        $('.glyphicon-wrench').popover("hide");
    });

    $('#new_note, #new_message').keydown(function(event) {
        if (submit_shortcut == "Ctrl+Enter" && event.which == 13 && event.ctrlKey ||
            submit_shortcut == "Shift+Enter" && event.which == 13 && event.shiftKey ||
            submit_shortcut == "Enter" && event.which == 13 && !event.ctrlKey && !event.shiftKey) {
            event.preventDefault();
            $(this).submit();
        }
    });

    $('#new_note #note_text').on('input', function() {
        $('#submit_button').attr('disabled', $(this).val().trim() == '');
    });

    function replaceHints(str1, str2, str3) {
        $(".help-block").each(function() {
            var _this = $(this);
            _this.text(_this.text().replace(submit_shortcut, str1).replace(str2, str3))
        });
        submit_shortcut = str1;
    }

    $("body").on('change', "[name=submission_form_type]", function() {
        if ($('[id*=ctrl_enter]').is(':checked')) {
            replaceHints("Ctrl+Enter", "Shift+Enter –", "Enter –");
        }

        if ($('[id*=shift_enter]').is(':checked')) {
            replaceHints("Shift+Enter", "Shift+Enter –", "Enter –");
        }

        if ($("[id=submission_form_type_enter]").is(':checked')) {
            replaceHints("Enter", "Enter –", "Shift+Enter –");
        }

//--------This is the magic that`s needed for correct work of popover----------
        $(".popover-content [name=submission_form_type]").each(function() {
            this.removeAttribute("checked");
        });

        this.setAttribute("checked", "checked");

        $("#popover_content_wrapper").html($(".popover-content").html());
        $(".popover-content").html($("#popover_content_wrapper").html());
//-----------------------------------------------------------------------------

        $.ajax({
            type: 'PUT',
            headers: 'application/json',
            url: '/users',
            data: {
                'user': {
                    'submission_form_type': submit_shortcut
                }
            }
        })

    });
});
