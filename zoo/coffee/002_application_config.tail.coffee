root = window

root.defaultPrefix = "z"

root.buildNumber      = 'undefined'
root.defaultScheme    = 'http://' # ex: 'undefined' => 'https://'
root.apiDomain        = 'localhost:5000' # ex: 'localhost:5000' => 'guru.zefr.com'
root.googleApiKey     = "AIzaSyCutrVvQ_D7xVZpPOp7sWjCrhC-AFpFco4"
root.staticFileSuffix = ""

root.staticFilesPath = "http://localhost/static/"

root.directiveTemplatePath = "#{ root.staticFilesPath }template/directive/" # This allows us to set where the templates for directives are coming from so we can host them not necessarily from the same domain
root.viewTemplatePath      = "#{ root.staticFilesPath }template/view/" # This allows us to set where the templates for the views corresponding to different states are coming from so we can host them not necessarily from the same domain or just change them all in one place
root.imgPath               = "#{ root.staticFilesPath }img/" # this is a hack for now to guarantee that image resources can be loaded from any particular build folder
