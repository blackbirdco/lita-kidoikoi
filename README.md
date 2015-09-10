# lita-kidoikoi

[![Build Status](https://travis-ci.org/blackbirdco/lita-kidoikoi.png?branch=master)](https://travis-ci.org/blackbirdco/lita-kidoikoi)
[![Coverage Status](https://coveralls.io/repos/blackbirdco/lita-kidoikoi/badge.png)](https://coveralls.io/r/blackbirdco/lita-kidoikoi)

A plugin for splitting bills between coworkers.

"Kidoikoi" is for "qui doit quoi", which means in french "who owes what".

## Installation

Add lita-kidoikoi to your Lita instance's Gemfile:

``` ruby
gem "lita-kidoikoi"
```

## Usage

###Commands:

####split\_bill:

`split bill @DEBTOR1... VALUE @CREDITOR`

Split a bill of the specified value between one ore more debtors and one creditor.

####clear\_debt\_between:

`clear debt between @USER1 @USER2`

Clear mutual debt of two users.

####resume\_debt\_of:

`resume debt of @USER`

Resume debt of one user.
