# HmtFacsimileBuilders.jl

## Overview 

`HmtFacsimileBuilders` is a highly generalized framework for generating static-page websites publishing digital facsimiles of edited texts.

It defines an abstract type hierarchy with root type `AbstractFacsimile`.  You can apply three functions to any subtype of `AbstractFacsimile`:

1. `surfaces`: compute a list of all surfaces known to the facsimile builder.
2. `legoforsurface`: for a given surface, assemble all the data components ("lego blocks") you need to build a facsimile page.  
3. `facsimile`: given a facsimile builder and a page formatting function, cycle through each surface, and apply the page formatting function to the lego blocks for a page to compose a string, then write the string to a static file

It also defines the `Lego` abstraction.  All subtypes of `Lego` have a `file` function that returns a file name to use for the page.  Beyond that, subtypes may work with specific functions for information appropriate to the type of facsimile you are building.  When you are working with a manuscript facsimile, for example, you could use a `rectoverso` function to determine if the page is a recto or verso (useful if you're desining two-page layouts).



## Quick example


```@setup overview
archiveroot = joinpath(pwd() |> dirname |> dirname |> dirname, "hmt-archive", "archive")
using HmtArchive
hmtarchive = Archive(archiveroot)
using HmtFacsimileBuilders
hmtcite = hmtcitable(hmtarchive)
hmt = stringify(hmtcite)
```

In the following example, `hmt` is an instance of a `StringifiedIliadFacsimile`.  This is a subtype of `AbstractFacsimile` that 
can be used with the `legoforsurface` to package manuscript editions from the Homer Multitext project's archive into lego blocks specifically supporting facsimile editions of manuscripts with text and *scholia*.  

One function that can format these lego blocks is `stringified_iliad_mdpage`.  It writes a simple markdown page for each page of the manuscripts, so its output would be suitable for use with a web site generator like jekyll. The following invocation of `facsimile` writes a complete set of facsimile files for all pages in the Homer Multitext archive.

```@example overview
facsimile(stringified_iliad_mdpage, hmt)
```

The flexibility of the `HmtFacsimileBuilders` package is that you could alternatively supply a different function:  perhaps to write HTML with more elaborate page layout and styling, perhpas to publish pages with facing bifolio spreads, or to combine texts from the manuscript pages in different ways.  There is no limit on what you might choose to do:  your function simply needs to accept the subtype of `Lego` generated here for each page (in this case, called `StringifiedIliadLego`), and produce a string that will be written to a file.