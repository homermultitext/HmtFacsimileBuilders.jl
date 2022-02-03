# Page components and page formatters



You can easily write your own page formatter and use it with the `facsimile` function.  It should have a signature accepting one required parameter, a subtype of `Lego`, and one optional parameter, a boolean flag indicating whether or not to include navigation components on the resulting facsimile page.

!!! note See a full example

    See the API documentation for details of the `StringifiedIliadLego` structure.


## `Lego` blocks: page components

All subtypes of `Lego` implement:

- `filename`
- `thumbnail`