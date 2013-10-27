root = window

root.UhelprConfig = class UhelprConfig extends root.ConfigBlock

	$_dependencies: [ '$urlRouterProvider' ]

	setupStates: ->
		super

		@$urlRouterProvider.otherwise '/home'

		@addState 'home',
			url        : "^/home"
			templateUrl: "home.html"
			controller : root.Uhelpr

	setupInterceptors: ->
		@addHighestPrecedenceInterceptor root.CommunicationInterceptor::$_makeName()

root.addConfigBlock UhelprConfig
