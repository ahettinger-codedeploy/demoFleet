/**
 * $Id: editor_plugin_src.js 520 2008-01-07 16:30:32Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright � 2004-2008, Moxiecode Systems AB, All rights reserved.
 */

(function() {
	tinymce.create('tinymce.plugins.ClipartPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceClipart', function() {
				ed.windowManager.open({
					file : url + '/clipart.php'+(ed.settings.search_peopleid != null ? '?i='+ed.settings.search_peopleid : ''),
					width : 350 + parseInt(ed.getLang('clipart.delta_width', 0)),
					height : 400 + parseInt(ed.getLang('clipart.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register buttons
			ed.addButton('clipart', {title : 'clipart.clipart_desc', cmd : 'mceClipart', image : url + '/img/star.png'});
		},

		getInfo : function() {
			return {
				longname : 'Calendar Sticker',
				author : '',
				authorurl : '',
				infourl : '',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('clipart', tinymce.plugins.ClipartPlugin);
})();