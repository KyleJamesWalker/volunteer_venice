root = window

class UhelprStateResolvable extends root.BaseResolvable
	$_name: 'UhelprStateResolvable'

	$_dependencies: [ root.UhelprState ]

	resolve: ->
		@UhelprState.initialize()

		@UhelprState.getAllPendingResults()

root.Uhelpr = class Uhelpr extends root.BaseResolvableController
	$_name: 'Uhelpr'

	$_dependencies: [ root.UhelprState ]

	$_resolvables: [ UhelprStateResolvable ]

	constructor: ->
		super

		root.$body.removeClass 'not'