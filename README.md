# glyph-listutils

Provides the *pw::listutils* command ensemble to perform setwise operations on
lists. See the [Set (mathematics) wiki][SetWiki] for details.

### Table of Contents
* [Namespace pw::listutils](#namespace-pwlistutils)
* [pw::listutils Library Docs](#pwlistutils-library-docs)
* [pw::listutils Library Usage Examples](#pwlistutils-library-usage-examples)
    * [Example 1](#example-1)
* [Disclaimer](#disclaimer)


## Using The Library

To use this library you must include `listutils.tcl` in your application script.

```Tcl
source "/some/path/to/your/copy/of/listutils.tcl"
```

All of the procs in this collection reside in the **pw::listutils** ensemble.

To call a proc in this collection, you must prefix the proc name with a **pw::listutils** ensemble name.

For example:
```Tcl
source "/some/path/to/your/copy/of/listutils.tcl"
pw::listutils lunion {1 2 3} {a b c}
pw::listutils lmutate {a b c}
```

To avoid the long ensemble name prefix, you can also import the public **pw::listutils** procs into your script.

For example, to import all procs.
```Tcl
source "/some/path/to/your/copy/of/listutils.tcl"
# import all public procs
namespace import ::pw::listutils::*
lunion {1 2 3} {a b c}
lmutate {a b c}
```

Or, to only import specific procs.
```Tcl
source "/some/path/to/your/copy/of/listutils.tcl"
# import all public procs
namespace import ::pw::listutils::lunion
namespace import ::pw::listutils::lmutate
lunion {1 2 3} {a b c}
lmutate {a b c}
```


## pw::listutils Library Docs

Commands in this ensemble are accessed as:

```Tcl
pw::listutils <cmd> ?<options>?
```
Where,
<dl>
  <dt><code>cmd</code></dt>
  <dd>Is one of the setwise operation names.</dd>
  <dt><code>options</code></dt>
  <dd>Optional, cmd dependent options.</dd>
</dl>
<br/>

### lproduct

```Tcl
pw::listutils lproduct <subcmd> ?<options>?
```
Computes the product for a collection of lists.

For example, the product of `{1 2 3}` and `{a b}` is
`{{1 a} {1 b} {2 a} {2 b} {3 a} {3 b}}`

<dl>
  <dt><code>subCmd</code></dt>
  <dd>One of get or foreach.</dd>
</dl>
<br/>

```Tcl
pw::listutils lproduct get <list> ?<list> ...?
```
Returns the product as a list of sub-product lists.
<dl>
  <dt><code>list ?lists ...?</code></dt>
  <dd>One or more lists used used to compute the product.</dd>
</dl>
<br/>

```Tcl
pw::listutils lproduct foreach <varname> <list> ?<list> ...? <body>
```
Each sub-product is passed to the script defined by body using the specified
varname.

<dl>
  <dt><code>varname</code></dt>
  <dd>Name of the sub-product script variable.</dd>
  <dt><code>list ?lists ...?</code></dt>
  <dd>One or more lists used used to compute the product.</dd>
  <dt><code>body</code></dt>
  <dd>The script to execute for each sub-product.</dd>
</dl>
<br/>

### lmutate

```Tcl
pw::listutils lmutate <subcmd> ?<options>?
```
Computes the permutations of a list.

For example, the permutations of `{a b c}` are `{{a b c} {a c b} {b a c} {b c a}
{c b a} {c a b}}`.

<dl>
  <dt><code>subCmd</code></dt>
  <dd>One of get or foreach.</dd>
</dl>
<br/>

```Tcl
pw::listutils lmutate get <list>
```
Returns the permutations as a list of lists.
<dl>
  <dt><code>list</code></dt>
  <dd>The list to mutate.</dd>
</dl>
<br/>

```Tcl
pw::listutils lmutate foreach <varname> <list> <body>
```
Each permutation is passed to the script defined by body using the specified
varname.

<dl>
  <dt><code>varname</code></dt>
  <dd>Name of the permutation script variable.</dd>
  <dt><code>list</code></dt>
  <dd>The list to mutate.</dd>
  <dt><code>body</code></dt>
  <dd>The script to execute for each permutation.</dd>
</dl>
<br/>

### lunion

```Tcl
pw::listutils lunion ?<list> ...?
```
Returns the union of a collection of lists.

For example, the union of `{1 2 3}` and `{a b}` is `{1 2 3 a b}`.
<dl>
  <dt><code>list ...</code></dt>
  <dd>The lists used used to compute the union. If no lists are provided, an
  empty list is returned.</dd>
</dl>
<br/>

### lintersect

```Tcl
pw::listutils lintersect <list> <list> ?<list> ...?
```
Returns the intersection of a collection of lists.

For example, the intersection of `{1 2 3 a}` and `{a 2 z}` is `{a 2}`.
<dl>
  <dt><code>list</code></dt>
  <dd>Two or more lists used used to compute the intersection.</dd>
</dl>
<br/>

### lsubtract

```Tcl
pw::listutils lsubtract <list> <list> ?<list> ...?
```
Returns the left-to-rigth subtraction of a collection of lists.

For example, the subtraction of `{1 2 3 a}` and `{a 2 z}` is `{1 3}`.
<dl>
  <dt><code>list</code></dt>
  <dd>Two or more lists used used to compute the subtraction.</dd>
</dl>
<br/>

### lsymmetricdiff

```Tcl
pw::listutils lsymmetricdiff <list> <list> ?<list> ...?
```
Returns the symmetric difference of a collection of lists. A symmetric
difference of A and B is equivalent to ((A subtract B) union (B subtract A)).

For example, the symmetric difference of `{1 2 3 a}` and `{a 2 z}` is `{1 3 z}`.
<dl>
  <dt><code>list</code></dt>
  <dd>Two or more lists used used to compute the symmetricdifference.</dd>
</dl>
<br/>

### lissubset

```Tcl
pw::listutils lissubset <superlist> <sublist> ?<sublist> ...?
```
Returns true if all sublist lists are a subset of superlist.

For example, `{1 a}` is a sublist of `{1 2 3 a}`.
<dl>
  <dt><code>superlist</code></dt>
  <dd>The list to compare all sublists against.</dd>
  <dt><code>sublist</code></dt>
  <dd>One or more subset lists.</dd>
</dl>
<br/>


### pw::listutils Library Usage Examples

#### Example 1

```Tcl
    xxxx
```


## Disclaimer
Scripts are freely provided. They are not supported products of
Pointwise, Inc. Some scripts have been written and contributed by third
parties outside of Pointwise's control.

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, POINTWISE DISCLAIMS
ALL WARRANTIES, EITHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, WITH REGARD TO THESE SCRIPTS. TO THE MAXIMUM EXTENT PERMITTED
BY APPLICABLE LAW, IN NO EVENT SHALL POINTWISE BE LIABLE TO ANY PARTY
FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS
INFORMATION, OR ANY OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR
INABILITY TO USE THESE SCRIPTS EVEN IF POINTWISE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES AND REGARDLESS OF THE FAULT OR NEGLIGENCE OF
POINTWISE.

[SetWiki]: http://en.wikipedia.org/wiki/Set_%28mathematics%29
