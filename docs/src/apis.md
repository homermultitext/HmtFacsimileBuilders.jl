# API documentation


Pairings of facsimile builders and page components:

## `AbstractFacsimile` and `Lego`

### The facsimile builder: `AbstractFacsimile`


```@docs
AbstractFacsimile
surfaces
facsimile
legoforsurface
```


### The page components: `Lego`


```@docs
Lego
filename
pageid
pagelabel
thumbnail
```

## `MSFacsimile` and `ManuscriptLego`

The `MSFacsimile` is a subtype of `AbstractFacsimile`; `ManuscriptLego` is a subtype of `Lego`.


### The facsimile builder: `MSFacsimile`



```@docs
MSFacsimile
rectosversos
```


### The page components: `ManuscriptLego`

```@docs
ManuscriptLego
rectoverso
```

## `IliadFacsimile` and `IliadLego`


The `IliadFacsimile` is a subtype of `MSFacsimile`; `IliadLego` is a subtype of `ManuscriptLego`.

### The facsimile builder: `IliadFacsimile`

```@docs
IliadFacsimile
```

### The page components: `IliadLego`
```@docs
IliadLego
iliadtext
othertext
iliadtoscholia
scholiatoiliad
```






## `CitableIliadFacsimile`

`CitableIliadFacsimile` is a  subtype of `IliadFacsimile`.  It does not 
have a corresponding fully implemented type of page components: the `CitableIliadFacsimile` serves instead as a source for making `StringifiedIliadFacsimile`s.


```@docs
CitableIliadFacsimile
hmtcitable
```

## `StringifiedIliadFacsimile` and `StringifiedIliadLego`

`StringifiedIliadFacsimile`  is a subtype of `IliadFacsimile`; `StringifiedIliadLego` is a subtype of `IliadLego`.

### The facsimile builder: `StringifiedIliadFacsimile` 

```@docs
StringifiedIliadFacsimile
stringify
```

### The page components: `StringifiedIliadLego`

```@docs
StringifiedIliadLego
```

## Page formatters

Page formatters that work with `StringifiedIliadLego`:

```@docs
StringifiedIliadLego
stringified_iliad_mdpage
stringified_iliad_mdimage_browser
```