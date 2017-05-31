.. title: Python Hints
.. slug: python-hints
.. date: 2017-03-21 16:21:33 UTC
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text
.. author: Illarion Khlestov

.. contents:: Contents


`Python Tutor <http://www.pythontutor.com/>`__ is an awesome online tool to visualize how Python works in detail.

Using namespace classes
=======================

This classes allow you directly assign params to class

.. code-block:: python

    from types import SimpleNamespace
    class S(SimpleNamespace):
        pass

    s = S(some='some', value='42')
    print(s.some)
    # out: 'some'
    print(s.value)
    # out: '42'

can be replaced such way:

.. code-block:: python

    class adict(dict):
        def __init__(self, *av, **kav):
            dict.__init__(self, *av, **kav)
            self.__dict__ = self

Checking args prior to runtime
==============================

It is useful to check args received by function prior to runtime.
This can be implemented with decorator:

.. code-block:: python
    
    # define decorator
    def check_args(*types):
        def real_decorator(func):
            def wrapper(*args, **kwargs):
                for val, typ in zip(args, types):
                    if not isinstance(val, typ):
                        msg = "Value {} is not of expected type {}".format(val, typ)
                        raise ValueError(msg)
                return func(*args, **kwargs)
            return wrapper
        return real_decorator

    # example usage of decorator
    @check_args(str, int)
    def print_something(name, quantity):
        print("name: {}, quantity: {}".format(name, quantity))


Palindromes
===========

.. code-block:: python
    
    # simple example
    def is_palindrome(s):
        return s == s[::-1]

    # for unicode data
    import unicodedata
    def is_palindrome(s):
        if any(unicodedata.combining(c) for c in s):
            s = unicodedata.normalize('NFC', s)
        return s == s[::-1] 

Change handling function based on length of provided arguments
==============================================================

.. code-block:: python

    import math
    ​
    formula_gerona = "%.5f*(%.5f-a)*(%.5f-b)*(%.5f-c)"
    figur = [
        lambda d: math.pi*((d/2.0)**2),                                  #Circle
        lambda a,b: a*b,                                                 #Square/Rectangle
        lambda a,b,c: math.sqrt(eval(formula_gerona%(((a+b+c)/2,)*4) )), #Triangle
    ]
    ​
    def simple_areas(*args):
        return figur[len(args)-1](*args)

PyTest
======

.. code-block:: bash

    # Allow pdb/ipdb at the pytest
    pytest -s tests/

    # run pytest with coverage
    coverage run -m pytest tests

    # Run pytest coverage for many installed django apps at once
    py.test --cov-report html --cov={app1, app2, ...} */tests.py

Example .coveragerc file:

.. code-block::

    [run]
    source = package_name
    omit = site-packages, .env

    [html]
    directory = htmlcov

String formatting
=================

.. code-block:: python
    
    # dictionary string formatting
    params = {"uid":"sa", "pwd":"secret"}
    print("%(pwd)s" % params)
    print("{pwd}".format(**params))
    # out: 'secret'

    # strip float precision length
    print('%.2f' % 0.1245125)
    print('{:.2f}'.format(0.1245125))
    # out: 0.12

    # free space before word
    print('%10s' % 'some')
    print('{:>10}'.format('some'))
    # out: '        some'
    print('%-10s' % 'some')
    print('{:<10}'.format('some'))
    # out: 'some        '


Generators, yield from syntax
=============================

Example of ``yield`` as generator:

.. code-block:: python

    def generator(x):
        # here generator will be interupted and wait for next call
        yield x
        yield x*2

    # example:
    gen = generator(10)
    next(gen)
    # out: 10
    next(gen)
    # out: 20

Example of ``yield`` as coroutine:

.. code-block:: python

    def writer():
        while True:
            # rcv a data
            w = yield
            print("was received:", w)

    w = writer()
    # initialize the generator
    w.send(None)
    w.send(10)
    # out: "was received: 10"
    w.send("some text")
    # out: "was received: some text"

Example usage of ``yield from`` syntax:

.. code-block:: python

    # define our generator
    def generator():
        for i in range(4):
            yield i

    # manually fetch data
    def fetcher(g):
        for fetch in g:
            yield fetch

    # yield from fetcher
    def fetcher_yield(g):
        yield from g

    # examples:
    fetch_results = fetcher(generator())
    for i in fetch_results:
        print(i)

    fetch_results = fetcher_yield(generator())
    for i in fetch_results:
        print(i)


Change existing object with generator
=====================================

It is possible to create object at generator and after only change it's value.
This will reduce memory consumption, but can lead to some errors:

.. code-block:: python
    
    def generator():
        d = {}
        yield d
        counter = 0
        while True:
            d["value"] = counter
            counter += 1
            yield

    gen = generator()
    res = next(gen)
    print(res)
    # out: {}
    
    # modify same dict
    next(gen)
    print(res)
    # out: {'value': 0}


List/Tuples(iterators)
======================

Comprehensions
--------------

.. code-block:: python
    
    # nested list comprehension
    mylist = [['10', '20', '30'], ['1', '2', '3']]
    # flattened list
    new_list = [float(entry) for sublist in mylist for entry in sublist]
    [10.0, 20.0, 30.0, 1.0, 2.0, 3.0]
    # nested list of floats
    new_list = [[float(entry) for entry in sublist] for sublist in mylist]
    [[10.0, 20.0, 30.0], [1.0, 2.0, 3.0]]
    # also can be used to generate cartesian product
    colors = ['black', 'white']
    sizes = ['S', 'M', 'L']
    tshirts = [(color, size) for color in colors
                             for size in sizes]
    [('black', 'S'),
     ('black', 'M'),
     ('black', 'L'),
     ('white', 'S'),
     ('white', 'M'),
     ('white', 'L')]
     # the same as:
     for color in colors:
        for size in sizes:
            print(color, size)

    # dict comprehension
    my_dict = {key:value for item in list if conditional}


Using * to grab excess items
----------------------------

.. code-block:: python

    a, b, *rest = range(5)
    a, b, rest
    # out: (0, 1, [2, 3, 4])

    a, b, *rest = range(2)
    # out: (0, 1, [])

    # can be assigned at any position
    a, *body, c, d = range(5)
    a, body, c, d
    # out: (0, [1, 2], 3, 4)

Nested tuple unpacking
----------------------

.. code-block:: python
    
    # if we have list of tuples like this
    metro_areas = [ ('Tokyo','JP',36.933,(35.689722,139.691667)), '...' ]
    # we can unpack it like this:
    for name, cc, pop, (latitude, longitude) in metro_areas:
        if longitude <= 0:
            print("Do something")

Namedtuples
-------------------

.. code-block:: python

    from collections import namedtuple
    City = namedtuple('City', ['name', 'country', 'population', 'coordinates'])
    # or provide just space delimited string
    City = namedtuple('City', 'name country population coordinates')

    tokyo = City('Tokyo', 'JP', 36.933, (35.689722, 139.691667))

    City._fields
    # out: ('name', 'country', 'population', 'coordinates')

    # convert namedtuple to dict
    tokyo._asdict()

Slicing
--------

Slices can be assigned to variable and used after assigning:

.. code-block:: pycon
    
    >>> test = 'test string'
    >>> test[0:4]
    'test'
    >>> first_slice = slice(0, 4)
    >>> test[first_slice]
    'test'
    >>> second_slice = slice(4, None)
    >>> test[second_slice]
    ' string'

Assigning to slices
-------------------

.. code-block:: pycon

    >>> l = list(range(10))
    >>> l
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] 
    >>> l[2:5] = [20, 30]
    >>> l
    [0, 1, 20, 30, 5, 6, 7, 8, 9]
    >>> del l[5:7]
    >>> l
    [0, 1, 20, 30, 5, 8, 9]

bisect module
-------------

Return the corresponding letter grade

.. code-block:: pycon

    >>> def grade(score, breakpoints=[60, 70, 80, 90], grades='FDCBA'):
    ...     # returns index of where score should be inserted
    ...     i = bisect.bisect(breakpoints, score)
    ...     return grades[i]
    ...
    >>> [grade(score) for score in [33, 99, 77, 70, 89, 90, 100]]
    ['F', 'A', 'C', 'C', 'B', 'A', 'A']

Miscellaneous
=============

.. listing:: python-hints.py python

.. listing:: python-hints.sh bash
