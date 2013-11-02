root = window

class App extends root.BaseModule
	# Remember, this allows us to refer to this module as its given name in markup, while still being able to minify this script.
	$_name: "App"

	$_dependencies: [ 'ui.router', 'ngCookies', 'ngResource', 'ngSanitize' ]

root.addModule       App
root.setTargetModule App
