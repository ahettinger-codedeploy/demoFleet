(function(t){t.fn.timepicki=function(e){var i={};return t.extend({},i,e),this.each(function(){function e(){var t=i.val(),e=0,s=0,a="AM",n=new Date;t.length>0&&(t=t.split(" : "),e=t[0],s=t[1],a=t[2],"PM"==a&&(e=parseInt(e,10)+12),n.setHours(e,s));var o=n.getHours(),l=n.getMinutes(),u="AM";o>12&&(o-=12,u="PM"),10>o?r.find(".ti_tx").text("0"+o):r.find(".ti_tx").text(o),10>l?r.find(".mi_tx").text("0"+l):r.find(".mi_tx").text(l),10>u?r.find(".mer_tx").text("0"+u):r.find(".mer_tx").text(u)}var i=t(this),s=i.outerHeight(),a=i.position().left;s+=10,t(i).wrap("<div class='time_pick'>");var n=t(this).parents(".time_pick");n.append("<div class='timepicker_wrap'><div class='arrow_top'></div><div class='time'><div class='prev'></div><div class='ti_tx'></div><div class='next'></div></div><div class='mins'><div class='prev'></div><div class='mi_tx'></div><div class='next'></div></div><div class='meridian'><div class='prev'></div><div class='mer_tx'></div><div class='next'></div></div></div>");var r=t(this).next(".timepicker_wrap"),o=r.find("div");r.css({top:s+"px",left:a+"px"}),t(document).on("click",function(s){if(!t(s.target).is(r))if(t(s.target).is(i))e(),r.fadeIn();else{var a=r.find(".ti_tx").html(),n=r.find(".mi_tx").text(),l=r.find(".mer_tx").text();a.length!=0&&n.length!=0&&l.length!=0&&i.val(a+" : "+n+" : "+l),t(s.target).is(r)||t(s.target).is(o)||r.fadeOut()}});var l=r.find(".next"),u=r.find(".prev");t(u).add(l).on("click",function(){var e=t(this),i=null,s=0;if(e.parent().attr("class")=="time"){i="time",s=12;var a=null;a=r.find("."+i+" .ti_tx").text(),a=parseInt(a),console.log(a),e.attr("class")=="next"?(12==a?r.find("."+i+" .ti_tx").text("01"):(a++,10>a?r.find("."+i+" .ti_tx").text("0"+a):r.find("."+i+" .ti_tx").text(a)),console.log(a)):(a--,10>a?r.find("."+i+" .ti_tx").text("0"+a):r.find("."+i+" .ti_tx").text(a),console.log(a))}else if(e.parent().attr("class")=="mins"){i="mins",s=59;var n=null;n=r.find("."+i+" .mi_tx").text(),n=parseInt(n),e.attr("class")=="next"?59==n?r.find("."+i+" .mi_tx").text("00"):(n++,10>n?r.find("."+i+" .mi_tx").text("0"+n):r.find("."+i+" .mi_tx").text(n)):0==n?r.find("."+i+" .mi_tx").text(59):(n--,10>n?r.find("."+i+" .mi_tx").text("0"+n):r.find("."+i+" .mi_tx").text(n))}else{s=1,i="meridian";var o=null;o=r.find("."+i+" .mer_tx").text(),e.attr("class")=="next"?"AM"==o?r.find("."+i+" .mer_tx").text("PM"):r.find("."+i+" .mer_tx").text("AM"):"AM"==o?r.find("."+i+" .mer_tx").text("PM"):r.find("."+i+" .mer_tx").text("AM")}})})}})(jQuery);