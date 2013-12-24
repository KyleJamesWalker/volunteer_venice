root = window

class ImageController extends root.BaseDirectiveController
	$_name: 'ImageController'

	constructor: ->
		super

		@$scope.$watch 'src', @switch

		@debouncedFinishSwitching = _.debounce @finishSwitching, 600

	switch: ( newSrc ) =>
		newSrc = "url(#{ newSrc })"

		@nextSrc = newSrc

		@switching = yes

		@debouncedFinishSwitching newSrc

	finishSwitching: ( newSrc ) =>
		@src = newSrc

		@switching = no

class Image extends root.BaseTemplatedDirective
	$_name: 'Image'

	controller: ImageController

	scope:
		src       : '@'
		imageClass: '='

	notIsolated: yes

root.addDirective Image