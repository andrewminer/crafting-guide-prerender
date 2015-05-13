###
# Crafting Guide - Gruntfile.coffee
#
# Copyright (c) 2014 by Redwood Labs
# All rights reserved.
###

fs = require 'fs'

########################################################################################################################

module.exports = (grunt)->

    grunt.loadTasks tasks for tasks in grunt.file.expand './node_modules/grunt-*/tasks'

    grunt.config.init

        shell:
            sitemap:
                command: './scripts/sitemap > ./static/sitemap.txt'
            prerender:
                command: './scripts/prerender --sitemap ./static/sitemap.txt'

    grunt.registerTask 'default', []

    grunt.registerTask 'prerender', ['shell:prerender']

    grunt.registerTask 'sitemap', ['shell:sitemap']

    grunt.registerTask 'use-local-deps', ->
        grunt.file.mkdir './node_modules'

        grunt.file.delete './node_modules/crafting-guide', force:true
        fs.symlinkSync '../../crafting-guide/', './node_modules/crafting-guide'

        grunt.file.delete './node_modules/crafting-guide-common', force:true
        fs.symlinkSync '../../crafting-guide-common/', './node_modules/crafting-guide-common'
