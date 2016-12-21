(function(){AO.views.EditorLeftPanel=Backbone.View.extend({tagName:"div",id:"editor_left_panel_container",events:{"click #ao_publish":"publishTemplate","click #ao_preview_mode > a":"switchPEmode","click #ao_edit_mode > a":"switchPEmode"},initialize:function(){AO.modules.editorMenuItemsCollection=new AO.collections.EditorMenuItems($.parseJSON($("#menu_items_data").html()))},initTopMenu:function(){this.topMenu=new AO.views.TopMenuEditor.Main({el:this.$el.find("#top_menu_editor_container")})},initStyles:function(){this.styles=new AO.views.StylesEditor.Main({el:this.$el.find("#style_editor_container")})},initSeo:function(){this.styles=new AO.views.SeoEditor.Main({el:this.$el.find("#seo_editor_container")})},render:function(){var t=_.template($("#editor_left_panel_template").html());return this.$el.html(t),this.initTopMenu(),this.initStyles(),this.initSeo(),this.setLiveUrl(),this.setLiveUrl(),this.initPublish(),this.initColorTheme(),this},initColorTheme:function(){this.colorTheme=new AO.views.ColorThemesEditor({el:this.$el.find("#color_themes_editor_container")})},initPublish:function(){this.publish=this.$el.find("#ao_publish"),this.publishedTpl=$.parseJSON($("#published_template_id_data").html()),this.publishedTpl.template_id?this.setUnpublish():this.setPublish()},setPublish:function(){this.publish.find("a.btn").removeClass("btn-primary").addClass("btn-success").html("Publish")},setUnpublish:function(){this.publish.find("a.btn").removeClass("btn-success").addClass("btn-primary").html("Unpublish")},publishTemplate:function(){var t=this;this.$el.find("#ao_publish a").addClass("hidden"),this.$el.find("#ao_publish img").removeClass("hidden"),$.ajax({type:"GET",url:"/onepage/publish_template?template_id="+AO.tplId+"&hash="+Math.random(),success:function(e){e=$.parseJSON(e),t.$el.find("#ao_publish a").removeClass("hidden"),t.$el.find("#ao_publish img").addClass("hidden"),e.status&&(e.publish?t.setUnpublish():t.setPublish())}})},switchPEmode:function(t){var e=$(t.currentTarget),i=e.parent();i.attr("id")=="ao_preview_mode"&&(e.addClass("active"),i.siblings().find(">a").removeClass("active"),AO.core.events.trigger("page_manager:set:mode","preview")),i.attr("id")=="ao_edit_mode"&&(e.addClass("active"),i.siblings().find(">a").removeClass("active"),AO.core.events.trigger("page_manager:set:mode","edit"))},setLiveUrl:function(){this.$el.find("#ao_live_preview a").attr("href",$(document.body).attr("data-url"))}})})();