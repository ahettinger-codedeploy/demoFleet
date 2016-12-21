$(document).ready(function(){

    $("div.accordion_full h3").click(function(){
        var $tabs = $(this).next().find("li.tab");

        var accordionTabSwitch = function(){
            var $this_ = $(this);
            if ($this_.size() > 0 && $this_.attr){
                var className = $this_.attr("class");
                if (className) {
                    var nTab = $this_.attr("class").replace(/[^0-9]/g, "");

                    $this_.parent().parent().find(".tab-" + nTab + "-content")
                        .show(0)
                        .siblings("div")
                        .hide(0);

                    $this_.addClass("active")
                        .siblings("li")
                            .removeClass("active");
                }
            }
        };

        accordionTabSwitch.apply($tabs[0]);
        $tabs.click(accordionTabSwitch);

    });

});
