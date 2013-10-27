module.exports = ( grunt ) ->

	prepCoffee =
		expand : yes
		flatten: yes
		src    : [ '**/coffee/**/*.coffee', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/coffee/'

	prepJs =
		expand : yes
		flatten: yes
		src    : [ '**/js/**/*.js', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/js/'

	prepCss =
		expand : yes
		flatten: yes
		src    : [ '**/css/**/*.css', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/css/'

	prepFont =
		expand : yes
		flatten: yes
		src    : [ '**/font/**/*', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/font/'

	prepImg =
		expand : yes
		flatten: yes
		src    : [ '**/img/**/*', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/img/'

	prepDirectiveTemplates =
		expand : yes
		flatten: yes
		src    : [ '**/template/directive/*.html', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/template/directive/'

	prepViewTemplates =
		expand : yes
		flatten: yes
		src    : [ '**/template/view/*.html', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/template/view/'

	prepScss =
		expand : yes
		flatten: no
		src    : [ '**/scss/**/*.scss', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss'

	buildCoffeeHead = 
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/coffee/*.head.coffee'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/'
		ext    : '.head.js'

	buildCoffeeTail = 
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/coffee/*.tail.coffee'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/'
		ext    : '.tail.js'

	buildJs =
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/js/*.js'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/'

	buildCss =
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/css/*.css'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/'

	buildFont =
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/font/*'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/font/'

	buildImg =
		expand : yes
		flatten: yes
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/img/*'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/img/'

	buildTemplates =
		expand : yes
		flatten: no
		cwd    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/template/'
		src    : '**/*.html'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/template/'

	buildScss =
		expand : yes
		flatten: yes
		src    : [ '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/**/*.scss', '!**/_*.scss', '!**/*.head.scss', '!**/*.body.scss' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/'
		ext    : '.css'

	buildScssHead =
		expand : yes
		flatten: yes
		src    : [ '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/**/*.head.scss', '!**/_*.scss' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/'
		ext    : '.head.css'

	buildScssBody =
		expand : yes
		flatten: yes
		src    : [ '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/**/*.body.scss', '!**/_*.scss' ]
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/'
		ext    : '.body.css'

	builtTemplatesJs = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/901_templates.tail.js'

	builtJsHead = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/*.head.js'
	builtJsTail = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/*.tail.js'

	uglyJsHead = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/head.js'
	uglyJsTail = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/tail.js'

	prettyJsHead = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/pretty_head.js'
	prettyJsTail = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/pretty_tail.js'

	builtCssHead = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/*.head.css'
	builtCssBody = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/*.body.css'

	miniCssHead = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/head.css'
	miniCssBody = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/body.css'

	allJs  = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js/all.js'
	allCss = '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css/all.css'

	pkg = grunt.file.readJSON 'package.json'

	preprocessContext =
		ENVIRONMENT        : pkg.environment
		ENGINE             : pkg.engine
		LIVERELOADPORT     : pkg.livereloadPort
		NGAPP              : pkg.ngApp
		BUILDDIR           : pkg.buildDir
		BUILDNUMBER        : pkg.buildNumber
		STATICFILEPATH     : "#{ pkg.applicationConfig[ pkg.environment ].defaultScheme }#{ pkg.applicationConfig[ pkg.environment ].staticFileDomain }/"
	preprocessContext[ "APPLICATION_CONFIG_buildNumber"         ] = pkg.buildNumber
	preprocessContext[ "APPLICATION_CONFIG_#{ configProperty }" ] = configValue for configProperty, configValue of pkg.applicationConfig[ pkg.environment ]

	htmlBuildDevelopment = 
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/*.html'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/'
		options:
			scripts:
				head: [ builtJsHead ]
				tail: [ builtJsTail ]
			styles:
				head: [ builtCssHead ]
				body: [ builtCssBody ]

	htmlBuildNonDevelopment = 
		src    : '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/*.html'
		dest   : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/'
		options:
			scripts:
				head: [ uglyJsHead ]
				tail: [ uglyJsTail ]
			styles:
				head: [ miniCssHead ]
				body: [ miniCssBody ]

	gruntConfig =
		pkg: pkg

		clean: 
			all   : [ '<%= pkg.buildDir %>/' ]
			coffee: [ '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/coffee', '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/js', '<%= pkg.buildDir %>/<%= pkg.builtDir %>/js'  ]
			scss  : [ '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss'  , '<%= pkg.buildDir %>/<%= pkg.builtDir %>/css' ]

		copy: 
			prepCoffee    : files: [ prepCoffee ]
			prepScss      : files: [ prepScss ]
			prepJs        : files: [ prepJs ]
			prepCss       : files: [ prepCss ]
			prepFont      : files: [ prepFont ]
			prepImg       : files: [ prepImg ]
			prepTemplates : files: [ prepDirectiveTemplates, prepViewTemplates ]
			buildJs       : files: [ buildJs ]
			buildCss      : files: [ buildCss ]
			buildFont     : files: [ buildFont ]
			buildImg      : files: [ buildImg ]
			buildTemplates: files: [ buildTemplates ]

		coffee:
			# options:
			# 	sourceMap: yes
			head: buildCoffeeHead
			tail: buildCoffeeTail

		ngtemplates:
			ngApp:
				cwd    : '<%= pkg.buildDir %>/<%= pkg.builtDir %>/template'
				src    : '**/*.html'
				dest   : builtTemplatesJs

				options:
					module : pkg.ngApp
					url    : ( url ) -> "#{ preprocessContext.STATICFILEPATH }template/#{ url }#{ preprocessContext.APPLICATION_CONFIG_staticFileSuffix }"
					htmlmin:
						collapseBooleanAttributes: no
						collapseWhitespace       : yes
						removeAttributeQuotes    : yes
						removeComments           : yes
						removeEmptyAttributes    : yes
						removeRedundantAttributes: yes

		concat:
			options:
				separator: ';'
			prettyHead: 
				src : builtJsHead
				dest: prettyJsHead
			prettyTail: 
				src : builtJsTail
				dest: prettyJsTail
			allJs:
				src : [ builtJsHead, builtJsTail ]
				dest: allJs
			allCss:
				src : [ miniCssHead, miniCssBody ]
				dest: allCss

		uglify:
			options:
				report: pkg.report
			headJs:
				src : builtJsHead
				dest: uglyJsHead
			tailJs:
				src : builtJsTail
				dest: uglyJsTail

		sass:
			options:
				compass : yes
				loadPath: [ 
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/**/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/base/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/guru/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/guru_channel_tools/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/guru_video_tools/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/video/scss'
					'<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/scss/cage/ui/scss'
				]
				style   : 'condensed'
				require : 'animation'
			dist: files: [ buildScssHead, buildScssBody, buildScss ]

		cssmin:
			options:
				report: pkg.report
			headCss:
				src : builtCssHead
				dest: miniCssHead
			bodyCss:
				src : builtCssBody
				dest: miniCssBody

		preprocess:
			options: 
				context: preprocessContext
			index:
				src : 'index.html'
				dest: '<%= pkg.buildDir %>/<%= pkg.almostBuiltDir %>/index.html'

			applicationConfig:
				src : 'coffee/002_application_config.tail.preprocess.coffee'
				dest: 'coffee/002_application_config.tail.coffee'

		htmlbuild:
			development: htmlBuildDevelopment
			production : htmlBuildNonDevelopment

		watch:
			options:
				livereload: yes # pkg.livereloadPort # livereloading on a specific port doesn't seem to work...
				verbose   : yes
				nospawn   : no
			gruntfile:
				files: [ 'Gruntfile.coffee', 'package.json' ]
				tasks: [ '<%= pkg.environment %>' ]
			scss:
				files: [ '**/scss/**/*.scss', '**/css/**/*.css', '!<%= pkg.buildDir %>/**/*' ]
				tasks: [ 'clean:scss', 'copy', 'sass', 'cssmin', 'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>' ]
			coffee:
				files: [ '**/coffee/**/*.coffee', '**/template/**/*.html', '!<%= pkg.buildDir %>/**/*' ]
				tasks: [ 'clean:coffee', 'preprocess:applicationConfig', 'copy', 'coffee', 'ngtemplates', 'uglify', 'concat', 'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>' ]
			statics:
				files: [ '**/js/**/*.js', '**/css/**/*.css', '**/font/**/*', '**/img/**/*', '!cage_template/**/*', '!node_modules/**/*', '!<%= pkg.buildDir %>/**/*' ]
				tasks: [ 'copy', 'ngtemplates', 'concat', 'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>' ]
			index:
				files: [ 'index.html' ]
				tasks: [ 'preprocess', 'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>' ]

		bump:
			options:
				files             : [ 'package.json' ]
				updateConfigs     : []
				commit            : yes
				commitMessage     : '<%= pkg.name %> Front End Release uiv%VERSION%'
				commitFiles       : [ '-a' ] # '-a' for all files
				createTag         : yes
				tagName           : 'uiv%VERSION%'
				tagMessage        : '<%= pkg.name %> Front End Version %VERSION%'
				push              : yes
				pushTo            : 'origin'
				gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d' # options to use with '$ git describe'

	grunt.initConfig gruntConfig

	grunt.log.writeln "Build environment: #{ pkg.environment }, Build type: #{ pkg.applicationConfig[ pkg.environment ].type }"

	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-sass'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-html-build'
	grunt.loadNpmTasks 'grunt-bump'
	grunt.loadNpmTasks 'grunt-preprocess'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-angular-templates'

	tasksByType = 
		development: [ 
			'clean:all'
			'preprocess:applicationConfig'
			'copy'
			'coffee'
			'ngtemplates'
			'uglify'
			'sass'
			'cssmin'
			'concat'
			'preprocess:index'
			'htmlbuild:development'
		]
		production: [ 
			'clean:all'
			'preprocess:applicationConfig'
			'copy'
			'coffee'
			'ngtemplates'
			'uglify'
			'sass'
			'cssmin'
			'concat'
			'preprocess:index'
			'htmlbuild:production'
		]

	grunt.registerTask environment, tasksByType[ applicationConfig.type ] for environment, applicationConfig of pkg.applicationConfig

	grunt.registerTask 'default', tasksByType[ pkg.applicationConfig[ pkg.environment ].type ]
