root = window

root.defaultPrefix = "z"

root.buildNumber      = '/* @echo APPLICATION_CONFIG_buildNumber */'
root.defaultScheme    = '/* @echo APPLICATION_CONFIG_defaultScheme */' # ex: '/* @echo APPLICATION_CONFIG_scheme */' => 'https://'
root.apiDomain        = '/* @echo APPLICATION_CONFIG_apiDomain */' # ex: '/* @echo APPLICATION_CONFIG_apiDomain */' => 'guru.zefr.com'
root.googleApiKey     = "/* @echo APPLICATION_CONFIG_googleApiKey */"
root.staticFileSuffix = "/* @echo APPLICATION_CONFIG_staticFileSuffix */"

root.staticFilesPath = "/* @echo STATICFILEPATH */"

root.directiveTemplatePath = "#{ root.staticFilesPath }template/directive/" # This allows us to set where the templates for directives are coming from so we can host them not necessarily from the same domain
root.viewTemplatePath      = "#{ root.staticFilesPath }template/view/" # This allows us to set where the templates for the views corresponding to different states are coming from so we can host them not necessarily from the same domain or just change them all in one place
root.imgPath               = "#{ root.staticFilesPath }img/" # this is a hack for now to guarantee that image resources can be loaded from any particular build folder
