## R CMD check results

Response to CRAN feedback:

> please spell 'Shiny' as 'shiny' in the title and description since
> package names are case sensitive.

Done, thank you (see DESCRIPTION lines 3, 6).

> It seems like you have too many spaces in your description field.
> Probably because linebreaks count as spaces too.
> Please remove unecassary ones.

OK, I have done this (see DESCRIPTION lines 6, 7).

> Please replace the \dontrun{}-wrapper with if(interactive()){}.
> \dontrun{} should only be used if the example really cannot be executed
> (e.g. because of missing additional software, missing API keys, ...) by
> the user.
> 
> For more details:
> <https://contributor.r-project.org/cran-cookbook/general_issues.html#structuring-of-examples>

The "dontrun" example was in update.R, function update_inline(). I have 
expanded this example so that it can be run, so the "dontrun" is no longer
needed and has been removed (see lines 45-76 of R/update.R).

> Please always make sure to reset to user's options(), working directory
> or par() after you changed it in examples and vignettes and demos.
> e.g.:
> oldpar <- par(mfrow = c(1,2))
> ...
> par(oldpar)
> 
> -> inst/doc/inshiny.R
> For more details:
> <https://contributor.r-project.org/cran-cookbook/code_issues.html#change-of-options-graphical-parameters-and-working-directory>

The incorrect code was in the "inshiny" vignette. I have fixed it as requested
(see lines 137, 141 of vignettes/inshiny.Rmd).

Thank you.

0 errors | 0 warnings | 1 note

* Note: This is a new submission.
* Since this package uses Shiny extensively, I have written the tests to check 
  the HTML output of the widgets produced. 
