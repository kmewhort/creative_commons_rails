# Creative Commons Rails

The Creative Commons Rails gem allows you to quickly and easily render internationalized Creative Commons license notices in your views.

## Installation

Add this line to your application's Gemfile:

    gem 'creative_commons_rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install creative_commons_rails

## Usage

Basic usage (in your view):

    <%= cc_license_tags(:by) %>

With options (see below for details):

    <%= cc_license_tags(:by, version: 2.5, jurisdiction: :ca, size: :compact %>

To display the license notice in a different language, simple ensure your I18n.locale setting is appropriately configured.

## Options

* **License type parameter:** symbol {:by,:by_sa,:by_nd,:by_nc,:by_nc_sa, or :by_nc_nd}. See [creativecommons.org](http://creativecommons.org/licenses/) for information on licensing options.
* **version:** FixNum or String [default: 3.0].
* **jurisdiction:** symbol [default: :unported]. See *lib/creative_commons_rails/license_list.yaml* for all available jurisdictions.
* **size:** symbol {:normal or :compact} [default: :normal]. Controls the image size.

## License

(c) 2013, Kent Mewhort, licensed under BSD. See LICENSE.txt for details.

