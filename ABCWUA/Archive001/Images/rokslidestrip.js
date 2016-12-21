/**
 *  @author Olmo Maldonado, <http://olmo-maldonado.com
 */
var RokSlide = new Class({
	options: {
		active: '',
		fx: {
			wait: false,
			duration: 350
		},
		scrollFX: {
			wait: false,
			transition: Fx.Transitions.Sine.easeInOut	
		},
		
		dimensions: {
			width: 722,
			height: 200
		}
	},
	
	initialize: function(contents, options) {
		this.setOptions(options);
		this.content = $(contents).setStyle('visibility', 'hidden');
		this.sections = this.content.getElements('.tab-pane');
		if(!this.sections.length) return;
	
		this.filmstrip = new Element('div').injectAfter(this.content);
		this.buildToolbar();
		this.buildFrame();
		if(window.ie) this.fixIE();
		
		this.scroller = $('scroller');
		this.startposition = $(this.sections[0].id.replace('-tab', '-pane')).getPosition().x;
		//this.scroller.fx = this.scroller.effects(this.options.fx);
		this.scroller.scrollFX = new Fx.Scroll(this.scroller, this.options.scrollFX);
		if(this.options.active) this.scrollSection(this.options.active.test(/-tab|-pane/) ? this.options.active : this.options.active + '-tab');
		else this.scrollSection(this.sectionptr[0]);
		$(contents).setStyle('visibility', 'visible');
	},
	
	buildToolbar: function() {	
		var lis = [];
		var that = this;
		this.sectionptr = [];
		var h1, title;
		this.sections.each(function(el) {
			el.setStyles({
				width: this.options.dimensions.width - 142,
				height: this.options.dimensions.height
			});
			this.sectionptr.push(el.id.replace('-pane', '-tab'));
			h1 = el.getElement('.tab-title');
			title = h1.innerHTML;
			h1.empty().remove();
			lis.push(new Element('li', {
				id: el.id.replace('-pane', '-tab'),
				events: {
					'click': function() {
						this.addClass('active');	
						
						that.scrollSection(this);
					},
					'mouseover': function() {
						this.addClass('hover');
						this.addClass('active');
					},
					'mouseout': function() {
						this.removeClass('hover');
						this.removeClass('active');
					}
				}
			}).setHTML(title));
		}, this);
		
		this.filmstrip.adopt(new Element('ul', {
					id: 'rokslide-toolbar',
					styles: {
						width: this.options.dimensions.width	
					}
				}).adopt(lis), new Element('hr'));
	},
	
	buildFrame: function() {
		var that = this, events = {
			'click': function() {
				that.scrollArrow(this)
			},
			'mouseover': function() {
				this.addClass('hover');
			},
			'mouseout': function() {
				this.removeClass('hover');
			}
		};
		this.filmstrip.adopt(
			new Element('div', {
				id: 'frame', 
				styles: this.options.dimensions
			}).adopt(
				new Element('div', {
					'class': 'button',
					'id': 'left',
					'events': events
				}),
				new Element('div', { 
					id: 'scroller',
					styles: {
						width: 	this.options.dimensions.width - 102,
						height: this.options.dimensions.height
					}
				}).adopt(this.content.setStyle('width', this.sections.length * 1600)),
				new Element('div', {
					'class': 'button',
					'id': 'right',
					'events': events
				})
			)
		);	
	},
	
	fixIE: function() {
		// if(window.ie6) {
		// 	this.sections.each(function(el) {
		// 		el.setStyle('margin', '0px 10px');
		// 	});
		// }
		
		this.filmstrip.getElement('hr').setStyle('display', 'none');
		
		// [$('frame'), this.scroller].merge(this.sections).merge($$('#frame div.button')).each(function(el) {
		// 	if(el) el.setStyle('height', '75.5em');
		// });
	},
	
	scrollSection: function(element) {
		element = $($(element || this.sections[0]).id.replace('-pane', '-tab'));
		var oldactive = element.getParent().getElement('.current');
		if(oldactive) oldactive.removeClass('current');
		element.addClass('current');
	
		var offset = $(element.id.replace('-tab', '-pane')).getPosition().x - this.startposition;
		this.scroller.scrollFX.scrollTo(offset, false);
		/*var that = this;
		this.scroller.fx.start({
			opacity: 0	
		}).chain(function() {
			that.scroller.fx.start({
				opacity: 1
			});
		});*/
	},
	
	scrollArrow: function(element) {
		var direction = Math.pow(-1, ['left','right'].indexOf(element.id) + 1);
		var current = this.sectionptr.indexOf(this.filmstrip.getElement('.current').id);
		var to = current + direction;
		this.scrollSection(this.sectionptr[to < 0 ? this.sectionptr.length - 1 : to % this.sectionptr.length]);
	}
});
RokSlide.implement(new Options);