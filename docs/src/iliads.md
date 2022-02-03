```@setup iliads
archiveroot = joinpath(pwd() |> dirname |> dirname |> dirname, "hmt-archive", "archive")

```

# Facsimiles of HMT project *Iliad*s


While the package's frame is general enough to work with facsimiles of any kind of text-bearing surface (papyri, inscriptions, printed books...), the initial motivation for this package was to be able to publish facsimiles of the Homer Multitext project's editions quickly and easily.

The current version includes two types of facsimile builder. The `CitableIliadFacsimile` packages a block of components uses URNs for identification of citable content.  Although the time required to compare two URNs might typically be in the range of 0.00003 - 0.00005 seconds or less on consumer-level personal computers, these times accumulate when a facsimile builder has to make the many millions of comparisons necessary to organize the rich data of the HMT project page by page.

The `StringifiedIliadFacsimile` converts the data in a `CitableIliadFacsimile` into regularized string values that can be compared with string equality or Julia's highly optimized `startswith` functions.  Batch processing hundreds of pages of manuscripts using `CitableIliadFacsimile` can take hours;  the `StringifiedIliadFacsimile` can do the same work in seconds.

## Constructing a builder

The current version of this package only supports loading data from a clone of the Homer Multitext project's archival repository on github.  

!!! note

    The much faster option of building a facsimile from a CEX publication of the repository is in progress and should be published soon in an updated release of this package.

### From a clone of the HMT archive

If `archiveroot` points to the `archive` directory of the Homer Multitext project's `hmt-archive` repository, we can create a `StringifiedIliadFacsimile` as follows.

1. Load an `HmtArchive`.
2. Use the `hmtcitable` function to create a `CitableIliadFacsimile`. (Typical time on consumer hardware: ca. 30 seconds.)
3. Convert the `CitableIliadFacsimile` to a `StringifiedIliadFacsimile` with the `stringify` function. (Typical run time: ca. 3 seconds.)

```@example iliads
using HmtFacsimileBuilders
using HmtArchive

hmtarchive = Archive(archiveroot)
hmt_cite = hmtcitable(hmtarchive)
hmt_md = stringify(hmt_cite)
```

The stringified version eliminates the need for URN comparisons in the page formatting functions.  It regularizes all *Iliad* URNs by dropping exemplar identifiers and converting them to strings, and *scholia* URNs by dropping version identifiers and converting them to strings.  It uses the `CitableImage` package to replace URNs for images with either markdown or HTML linking to an IIIF service.  The default is markdown:  you can change this by setting the optional `outputformat` parameter to `HmtFacsimileBuilders.HTML`, as illustrated here.


```@example iliads
hmt_html = stringify(hmt_cite, outputformat = HmtFacsimileBuilders.HTML)
```

### From a CEX release 

!!! warning

    (TBA)


## Publishing a facsimile

Once we have a facsimile builder, we can use it with an appropriate page formatter to create an facsimile.

Here we apply the `stringified_iliad_mdpage` function to create a simple markdown edition suitable for use in a web production system like jekyll.

```@example iliads
facsimile(stringified_iliad_mdpage, hmt_md)
```

See the API documentation for more information on optional parameters to the `facsimile` function.

