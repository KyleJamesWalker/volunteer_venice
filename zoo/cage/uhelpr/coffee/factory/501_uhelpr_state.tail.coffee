root = window

root.UhelprState = class UhelprState extends root.BaseFactory
	$_name: 'UhelprState'

	$_dependencies: [
		'$q'
		'$injector'
		'$rootScope'
	]

	constructor: ->
		super

		@$rootScope[ @$_name ] = @

		@$_stats = new root.Stats @$injector

		@$locations = {}
		@$currentLocation = null

	initialize: =>
		return if @initialized
		@initialized = yes

	getAllPendingResults: =>
		@$_stats.pendingResults

root.addFactory UhelprState