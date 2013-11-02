root = window

root.UhelprState = class UhelprState extends root.BaseFactory
	$_name: 'UhelprState'

	$_dependencies: [
		'$q'
		'$injector'
		'$rootScope'
		root.OrganizationRequester
		root.LocationRequester
		root.GoogleMapsApi
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

		@getResources()

	getResources: ->
		@$_stats.addPending()

		@$q.all( [
			( @$organizations = @OrganizationRequester.getAll() ).$promise
			( @$locations     = @LocationRequester.getAll() ).$promise
		] ).then(
			=> @$_stats.pendingResolved()
			=> @$_stats.pendingRejected()
		)

	getAllPendingResults: =>
		@$q.all [ @$_stats.pendingResults, @GoogleMapsApi.mapsApiLoadedPromise ]

	getCurrentLocation: ->
		@$locations[ 0 ]

root.addFactory UhelprState