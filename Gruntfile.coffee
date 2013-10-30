module.exports = (grunt) ->
  grunt.initConfig

   pkg: grunt.file.readJSON('package.json'),

   bower:
        install:
          options:
            targetDir: "pre-build/"
            layout: "byComponent"
            install: true
            verbose: true
            cleanTargetDir: true
            cleanBowerDir: true


  # need to run the JQM setup command to install necessary node modules for JQM
    shell:
      setupjqmnode:
        command:['cd pre-build/jquery-mobile',
          'npm install'
          'echo source files available'                
        ].join('&&')

  # need to run the JQM build command to get the resources compiled to dist
      buildjqm:
        command:['cd pre-build/jquery-mobile',
          'grunt dist'
          'echo built the jqm distribution'                
        ].join('&&')

  # phonegap project creation commands part 1
      createphonegapproject:
        command:['sudo npm install -g phonegap',
          'phonegap create demoapp'
          'echo phonegap project built'                
        ].join('&&')


  # phonegap project creation commands part 2
      createiosbuild:
        command:['cd demoapp',
          'phonegap run ios'
          'echo creating the IOS package'                
        ].join('&&')


  # rename JQM css files to my liking
      renamecss:
        command:['cd assets/css/',
          'ren  jquery.mobile.min.css jquery-mobile-min.css '
          'echo css JQM files renamed'                
        ].join('&&')


  # rename JQM JS files to my liking
      renamejs:
        command:['cd assets/js',
          'ren jquery.mobile.min.js jquery-mobile-min.js '
          'echo js JQM files renamed'                
        ].join('&&')


  # copy over our end distribution resources
    copy:
      jqmcss:
        expand: true
        flatten: true
        cwd: "pre-build/jquery-mobile/dist/"        
        src: "jquery.mobile.min.css"
        dest: "assets/css/"

      jqmjs:
        expand: true
        flatten: true
        cwd: "pre-build/jquery-mobile/dist"        
        src: "jquery.mobile.min.js"
        dest: "assets/js/"

      backbonejs:
        expand: true
        flatten: true
        cwd: "pre-build/backbone"        
        src: "backbone-min.js"
        dest: "assets/js/"

   # move all assets out to app directory for pre-build

      phonegapassetcopy:
        expand: true
        flatten: false 
        cwd: "assets"      
        src: "**"
        dest: "demoapp/www/"


      phonegapindexcopy:
        expand: true
        flatten: false 
        cwd: ""      
        src: "index.html"
        dest: "demoapp/www/"


    # run a minification process on the jquery file

    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> -' + 
        '<%= grunt.template.today("yyyy-mm-dd") %> */'
        report: "min"

      jquery:
        src: ["pre-build/jquery/jquery.js"]
        dest: "assets/js/jquery-min.js"

        
    less:
      development:
        src: "resources/custom/less/jqm-custom.less*"
        dest: "assets/css/jqm-custom.css"
        options:
          compress: false
          yuicompress: false
          optimization: 2          

    coffee:
      allcoffee:
        src: "resources/custom/coffee/*.coffee"
        dest: "assets/js/app.js"
        options:
          join: true         

     bake:
        resources: 
          files: "index.html":"resources/custom/components/base.html"


  # lets start up a headless websever with node and connect
      connect:
        server:
          options:
            protocol:'http'
            port:8000
            base:''


  # lets watch all the stuff going on for live changes.
     watch:
        less:
          files: ["resources/custom/less/**/*.less"] 
          tasks: ["less"]

        coffee:
          files: ["resources/custom/coffee/**/*.coffee"]
          tasks: ["coffee"]

        bake:
          files: ["resources/custom/components/**"]
          tasks: ['bake', 'move-assets', 'move-index-asset', 'build-ios-project']



  grunt.loadNpmTasks "grunt-shell"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-bake"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-bower-task"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-connect"




  grunt.registerTask "newapp", "copy"
  grunt.registerTask "bakeme", "bake"
 

  grunt.registerTask "default", "less coffee bake"


  grunt.registerTask('get-jqm', ['bower:install']);

  grunt.registerTask('setup-jquery', ['uglify:jquery']);

  grunt.registerTask('setup-jqm-node', ['shell:setupjqmnode']);

  grunt.registerTask('build-jqm', ['shell:buildjqm']);

  grunt.registerTask('build-jqm-css', ['copy:jqmcss']);

  grunt.registerTask('build-jqm-js', ['copy:jqmjs']);

  grunt.registerTask('build-backbone-js', ['copy:backbonejs']);

  grunt.registerTask('rename-jqm-css', ['shell:renamecss']);

  grunt.registerTask('rename-jqm-js', ['shell:renamejs']);

  grunt.registerTask('create-phonegap', ['shell:createphonegapproject']);

  grunt.registerTask('move-assets', ['copy:phonegapassetcopy']);

  grunt.registerTask('move-index-asset', ['copy:phonegapindexcopy']);




  grunt.registerTask('build-ios-project', ['shell:createiosbuild']);



# Tak setups and runs the install grunt command for JQM package, setups all the assets, and then fires the watch command start coding.
  grunt.registerTask('setup-jqm', ['get-jqm', 'setup-jquery', 'setup-jqm-node', 'build-jqm',  'build-jqm-css', 'build-jqm-js', 'build-backbone-js','rename-jqm-css', 'rename-jqm-js', 'create-phonegap', 'move-assets', 'build-ios-project' ,'default']);

  grunt.registerTask('default', ['connect', 'watch']);
