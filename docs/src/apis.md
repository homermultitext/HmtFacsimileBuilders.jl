# API documentation


Pairings of facsimile builders and page components:

## `AbstractFacsimile` and `Lego`

The facsimile builder:

```@docs
AbstractFacsimile
surfaces
facsimile
legoforsurface
```

The page components:

```@docs
Lego
filename
pageid
pagelabel
thumbnail
```

## `MSFacsimile` and `ManuscriptLego`

The `MSFacsimile` is a subtype of `AbstractFacsimile`; `ManuscriptLego` is a subtype of `Lego`.

```@docs
MSFacsimile
rectosversos
ManuscriptLego
rectoverso
```

## `IliadFacsimile` and `IliadLego`


The `IliadFacsimile` is a subtype of `MSFacsimile`; `IliadLego` is a subtype of `ManuscriptLego`.

```@docs
IliadFacsimile
IliadLego
iliadtext
othertext
iliadtoscholia
scholiatoiliad
```



## Concrete *Iliad* facsimile builders

These facsimile builders are subtypes of `IliadFacsimile`.

### `CitableIliadFacsimile`

```@docs
CitableIliadFacsimile
hmtcitable
```
### `StringifiedIliadFacsimile`

```@docs
StringifiedIliadFacsimile
stringify
```

Page formatters that work with `StringifiedIliadLego`, a subtype of `IliadLego`:

```@docs
StringifiedIliadLego
stringified_iliad_mdpage
stringified_iliad_mdimage_browser
```