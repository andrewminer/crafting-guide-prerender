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

        clean:
            dist: ['./dist']

        compress:
            static:
                options:
                    mode: 'gzip'
                files: [
                    {expand: true, cwd:'./static', src:'**/*.html', dest:'./dist'}
                    {expand: true, cwd:'./static', src:'**/*.txt', dest:'./dist'}
                ]

    # Composite Tasks ##################################################################################################

    grunt.registerTask 'default', 'rebuilds the sitemap and prerenders any missing pages',
        ['prerender']

    grunt.registerTask 'deploy:prod', 'deploy the project to production via CircleCI',
        ['script:deploy:prod']

    grunt.registerTask 'deploy:staging', 'deploy the project to staging via CircleCI',
        ['script:deploy:staging']

    grunt.registerTask 'dist', 'prepares the prerendered files for upload to Amazon S3',
        ['clean', 'compress']

    grunt.registerTask 'prerender', 'prerender any missing files based upon the sitemap',
        ['script:sitemap', 'script:prerender']

    grunt.registerTask 'sitemap', 'produce a sitemap based upon the data files for the site',
        ['script:sitemap']

    grunt.registerTask 'upload:prod', 'upload the project to the production Amazon S3 environment',
        ['dist', 'script:s3_upload:prod']

    grunt.registerTask 'upload:staging', 'upload the project the staging Amazon S3 environment',
        ['dist', 'script:s3_upload:staging']

    # Code Tasks #######################################################################################################

    grunt.registerTask 'use-local-deps', 'replace various node modules to use the local versions', ->
        grunt.file.mkdir './node_modules'

        grunt.file.delete './node_modules/crafting-guide', force:true
        fs.symlinkSync '../../crafting-guide/', './node_modules/crafting-guide'

        grunt.file.delete './node_modules/crafting-guide-common', force:true
        fs.symlinkSync '../../crafting-guide-common/', './node_modules/crafting-guide-common'

    # Script Tasks #####################################################################################################

    grunt.registerTask 'script:deploy:prod', "deploy code by copying to the production branch", ->
        done = this.async()
        grunt.util.spawn cmd:'./scripts/deploy', args:['--production'], opts:{stdio:'inherit'}, (error)-> done(error)

    grunt.registerTask 'script:deploy:staging', "deploy code by copying to the staging branch", ->
        done = this.async()
        grunt.util.spawn cmd:'./scripts/deploy', args:['--staging'], opts:{stdio:'inherit'}, (error)-> done(error)

    grunt.registerTask 'script:sitemap', "produce a sitemap based upon the full website's data", ->
        done = this.async()
        child = grunt.util.spawn {cmd: './scripts/sitemap'}, (error)-> done(error)
        child.stdout.pipe fs.createWriteStream './static/sitemap.txt'

    grunt.registerTask 'script:prerender', "prerender all HTML files listed in the sitemap", ->
        done = this.async()
        grunt.util.spawn(
            {
                cmd: './scripts/prerender'
                args: ['--sitemap ./static/sitemap.txt']
                opts: {stdio:'inherit'}
            },
            (error)-> done(error)
        )

    grunt.registerTask 'script:s3_upload:prod', 'uploads all static content to S3', ->
        done = this.async()
        grunt.util.spawn(
            {
                cmd: './scripts/s3_upload'
                args: ['--prod']
                opts: {stdio:'inherit'}
            },
            (error)-> done(error)
        )

    grunt.registerTask 'script:s3_upload:staging', 'uploads all static content to S3', ->
        done = this.async()
        grunt.util.spawn(
            {
                cmd: './scripts/s3_upload'
                args: ['--staging']
                opts: {stdio:'inherit'}
            },
            (error)-> done(error)
        )
