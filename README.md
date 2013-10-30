
autojqm
jqm: version 2.0

grunt plugins used:
https://npmjs.org/package/grunt-bake
animo.js - 

I rewrote 90% -better instructions coming - essentially this is an all
in one build jquery mobile app. You just type grunt setup-jqm and it
grabs the latest (beta version of jqm) dependencies,extracts, builds,
copies over files to the assets, directory - to top it off this uses
bake to automagically watch and build your index.html from components!



INSTRUCTIONS:
I love ways to jump in and start building. This usese bake and component files to create a jquery mobile multi-page app framework. I include several goodies in the build directory.
after working with jquery mobile a lot I wanted to make it more fun quick, and get the code and building out of the process.

 - build
    - custom
       - coffee: All my custom coffee files
       - less: All my custom less files specifically one called called jqm-custom.less which can have a custom JQM theme
       - components: these are html sub-parts. JQM multipage apps consist of several pages in one document. Using the great bake library for grunt. The base file contains pointers using the baked notation to point to included components. As a demo there are 3 pages baked in. When working all the files compiles and spit out index.html to your root directory.



Future - I want to add in some more goodies


1. Setup Grunt
2. Unzip or git this repo to an empty dev directory
3. run npm install
4. grunt copy - copies 3rd party vendor tools, and custom less etc to the assets directory
5. grunt watch  - start developing!
