# Crafting Guide Prerender

TL;DR—Don't worry about this repository. It's strictly for administrative purposes.

---

This repository supports [Crafting Guide](http://github.com/andrewminer/crafting-guide) by containing all the pre-rendered HTML files generated for each page of the site.

Crafting Guide is a pure-client JavaScript application built using [BackBone.js](http://backbonejs.org), and therefore really only has a single HTML page. All other seeming pages are actually created when BackBone.js evaluates the current URL and engages the appropriate JavaScript code to create that page.

Since this is the case, if Google's bots crawl were to crawl the site without any pre-rendered pages, it would only see the bare scaffolding which sets up BackBone.js and kicks it off.  Therefore, Google would completely fail to index the site as all the pages would appear to be identical, empty, pages.

The HTML stored in this repository is created by using an automated browser ([PhantomJS](http://phantomjs.org/)) and a [local server](https://github.com/andrewminer/crafting-guide/blob/master/scripts/server) to call up each page in the site and allowing the Backbone.js code to run to completion. The resulting HTML is saved to a file for each page and then checked in to this repository.

Once complete, the HTML in this repository can be deployed to S3 where it is made available to the public as part of the Crafting Guide website.
