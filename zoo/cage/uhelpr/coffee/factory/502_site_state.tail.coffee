root = window

root.SiteState = class SiteState extends root.BaseFactory
	$_name: 'SiteState'

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

		@getAllPendingResults().then =>
			@$currentLocation = @$locations[ 0 ] or new root.Location 'Venice Beach'

			currentOrganizationIndex = -1
			setInterval(
				=> @$rootScope.$apply => @$currentOrganization = @$organizations[ currentOrganizationIndex = ( currentOrganizationIndex + 1 ) % @$organizations.length ]

				5000
			)

	getResources: ->
		@$_stats.addPending()

		@$q.all( [
			( @$organizations = @OrganizationRequester.getAll() ).$_promise
			( @$locations     = @LocationRequester    .getAll() ).$_promise
		] ).then(

			=> @$_stats.pendingResolved()

			=>
				@$_stats.pendingRejected()
				# fakeOrgCount = 15
				# @$organizations = ( new root.Organization() while --fakeOrgCount )
		)

	getAllPendingResults: =>
		@$q.all [ @GoogleMapsApi.getAllPendingResults(), @$_stats.pendingResults ]

	getCurrentLocation: ->
		@$currentLocation

	getMarkerOptions: ( organization ) ->
		return null unless organization?
		markerOptions =
			title   : organization.name
			position: @GoogleMapsApi.geocodeAddress( organization.address, @$currentLocation.position ).then ( geocoderResults ) -> markerOptions.position = geocoderResults[ 0 ]?.geometry.location

root.addFactory SiteState