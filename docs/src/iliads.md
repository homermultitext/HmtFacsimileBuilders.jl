# Facsimiles of HMT project *Iliad*s



Citable vs. stringified facsimile builders.

Rely on domain knowledge to design structures with string values that can be 


## Constructing a builder

### From a clone of the HMT archive

```
hmtcite = hmtcitable(hmtarchive)
hmtstrings = stringify(hmtcite)
```

### From a CEX release 

(TBA)


## Publishing a facsimile

The `stringified_iliad_page` function creates a markdown edition.

```
facsimile(stringified_iliad_page, hmtstrings)
```