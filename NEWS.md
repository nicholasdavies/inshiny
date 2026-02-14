# inshiny (development version)

# inshiny 0.1.2

* Changed to use htmltools::tagQuery for tag editing, and modified check_tags() 
  so it only runs during continuous integration. These are changes in internal 
  details that doesn't affect users of the package, done to make the package
  more robust to future changes to Shiny and to move the onus of keeping this 
  package accurate onto myself rather than Shiny developers. Thanks to 
  @schloerke who raised this in PR #1 and issue #2.

# inshiny 0.1.1

* Bug fix: updated to work with the newly released shiny 1.12.0.

# inshiny 0.1.0

* Initial CRAN submission.
