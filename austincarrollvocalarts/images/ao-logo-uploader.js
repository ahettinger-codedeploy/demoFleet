(function(){AO.views.LogoUploader=Backbone.View.extend({initialize:function(){this.render(),this.choosedLogoImg=null,this.choosedLogo=null,this.logosId=null,this.checkInterval=null,this.reqNum=30,this.curReqNum=this.reqNum,this.currentLogo=$("#ao-logo").find("img").attr("src")},render:function(){var t=this,e=_.template($("#logo-uploader-template").html(),{});this.$el.html(e),this.$el.parent().hover(function(){t.$el.show()},function(){t.$el.hide()}),this.initForm(),$("#ao_logo_gen_form").ajaxForm({dataType:"html",beforeSubmit:function(){$("#ao_logo_gen_form input[type=submit]").hide(),$("#logo_submit_loading").html("<img src='/assets/ajax-loader.gif'/>")},success:function(e){e=$.parseJSON(e),e.status&&t.checkLogosReady(e.logo_id)},error:function(){$("#ao_logo_gen_form input[type=submit]").show(),$("#logo_submit_loading").empty()}}),$("#logo_list_content").click($.proxy(this.logoClickHandler,this))},checkLogosReady:function(t){var e=this;$.ajax({type:"GET",url:"/logo/check?logo_id="+t+"&hash="+Math.random(),success:function(i){i=$.parseJSON(i),i.status?e.loadLst(t):e.curReqNum>0?(e.curReqNum-=1,setTimeout(function(){e.checkLogosReady(t)},2e3)):e.loadLstFail()}})},loadLst:function(){$.ajax({type:"GET",url:"/logo/lst?op=1&hash="+Math.random(),success:function(t){$("#logo_list_content").html(t),$("#logo_list_wrap").find(".logo_list").css("height",280),$("#ao_logo_gen_form").find("input[type=submit]").show(),$("#logo_submit_loading").empty()}})},loadLstFail:function(){$("#logo_list_content").html("Error generating logos"),$("#epk_builder_logo_gen_form").find("input[type=submit]").show(),$("#logo_submit_loading").empty()},initForm:function(){var t=this;this.formEl=this.$el.find("form"),this.bar=this.$el.find(".bar"),this.percent=this.$el.find(".percent"),this.progressBar=this.$el.find(".progress"),this.formEl.ajaxForm({url:"/epk_logo/update",type:"PUT",beforeSerialize:function(){},beforeSend:function(){t.progressBar.show();var e="0%";t.bar.width(e),t.percent.html(e),t.formEl.hide()},uploadProgress:function(e,i,s,a){var n=a+"%";t.bar.width(n),t.percent.html(n)},success:function(e){e=$.parseJSON(e),e.status&&$("#ao-logo").find("img").attr("src",e.data.logo),$.browser.msie?t.formEl.find("#configure_logo").replaceWith(t.formEl.find("#configure_logo").clone(!0)):t.formEl.find("#configure_logo").val("")},complete:function(){t.formEl.show(),t.progressBar.hide()},error:function(){}}),this.formEl.find("#configure_logo").change(function(){t.formEl.submit()}),$("#ao-logo-dialog").css("zIndex",1500),$("#ao-logo-dialog").dialog({modal:!1,autoOpen:!1,draggable:!0,resizable:!1,height:450,width:800,buttons:[{text:"Accept",click:function(){t.acceptLogoImg(),$(this).dialog("close")},"class":"ui-button"},{text:"Cancel",click:function(){t.cancelLogoImg(),$(this).dialog("close")},"class":"ui-button"}]}),$("#ao-logo-generate-link").click(function(){return $("#ao-logo-dialog").zIndex(1500),$("#ao-logo-dialog").dialog("open"),!1}),$("#logo_background_color").spectrum({color:"#ffffff",preferredFormat:"hex",showInput:!0,change:function(t){$("#logo_background_color").val(t)},hide:function(t){$("#logo_background_color").val(t)}}),$("#logo_font_color").spectrum({color:"#000000",preferredFormat:"hex",showInput:!0,change:function(t){$("#logo_font_color").val(t)},hide:function(t){$("#logo_font_color").val(t)}})},logoClickHandler:function(t){var e=$(t.target),i=e.attr("todo_action"),s=this;if(void 0==i)return!1;if("accept_logo"==i){var a=e.attr("src"),n=$("#logo_font_color").val();$(e).css("border","2px solid "+n),s.choosedLogoImg!=null&&($(s.choosedLogoImg).css("border","2px solid transparent"),s.choosedLogoImg=null),s.choosedLogo=a,s.choosedLogoImg=e,$("#ao-logo").find("img").attr("src",a)}},acceptLogoImg:function(){var t=this;this.choosedLogo!=null&&$.ajax({type:"GET",url:"/logo/accept?logo="+t.choosedLogo.split("/").pop(),success:function(e){var i,s=!1;try{e=$.parseJSON(e),s=!0}catch(a){}s&&e.status?(i=$.parseJSON(e.obj),$("#logo_wrap").find(".upl-name > img").length>0&&$("#logo_wrap").find(".upl-name > img").attr("src",i.logo),t.currentLogo=i.logo,AO.core.events.trigger("message:notify","success","Success: ","You have a new logo.")):AO.core.events.trigger("message:notify","danger","Error: ","Reload page and try again.")}})},cancelLogoImg:function(){$("#ao-logo").find("img").attr("src",this.currentLogo)}})})();