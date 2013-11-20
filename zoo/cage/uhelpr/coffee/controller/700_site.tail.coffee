root = window

class SiteStateResolvable extends root.BaseResolvable
	$_name: 'SiteStateResolvable'

	$_dependencies: [ root.SiteState ]

	resolve: ->
		@SiteState.initialize()

		@SiteState.getAllPendingResults()

root.Site = class Site extends root.BaseResolvableController
	$_name: 'Site'

	$_dependencies: [ root.SiteState ]

	$_resolvables: [ SiteStateResolvable ]

	constructor: ->
		super

		root.$body.removeClass 'not'