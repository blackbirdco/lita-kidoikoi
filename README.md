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

**Commands:**

**kidoikoi** **split\_bill\_between**  _@debtor1..._ _value_ _@creditor_

**kidoikoi** **clear\_debt\_between** _@user1_ _@user2_

**kidoikoi** **resume\_debt** _@user_
