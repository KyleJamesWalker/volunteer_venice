root = window

root.UhelprState = class UhelprState extends root.BaseFactory
	$_name: 'UhelprState'

	$_dependencies: [
		'$q'
		'$injector'
		'$rootScope'
		root.OrganizationRequester
		root.LocationRequester
	]

	constructor: ->
		super

		@$rootScope[ @$_name ] = @

		@$_stats = new root.Stats @$injector

		@$organizations = new Array()
		@$locations     = new Array()

	initialize: =>
		return if @initialized
		@initialized = yes

		@$organizations = @OrganizationRequester.getAll()
		@$locations     = @LocationRequester.getAll()

	getAllPendingResults: =>
		@$_stats.pendingResults

	getCurrentLocation: ->
		@$locations[ 0 ]

root.addFactory UhelprState