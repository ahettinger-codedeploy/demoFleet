define(['jquery', 'internal/sitebuilder/common/ModuleClassLoader'],
function($, ModuleClassLoader) {
	var module = {}, extend = {};

	// SubModules

	// Module Styles
	extend.styles = {"base":{"global":{"css":"view.less"},"default":true,"slug":"base"}};
	if (!extend.styles['base']['global']) {
		extend.styles['base']['global'] = {};
	}
	extend.styles['base']['global']['js'] = null;
	extend.defaultStyle = extend.styles['base'];

	// View JS
	


	return ModuleClassLoader.register('html', module, extend);
});