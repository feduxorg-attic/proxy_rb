#  UNRELEASED

Empty

# RELEASED

## [v0.10.5](https://github.com/fedux-org/proxy_rb/compare/v0.10.5...v0.10.5)

* Fix for overwriting proxies

## [v0.10.4](https://github.com/fedux-org/proxy_rb/compare/v0.10.3...v0.10.4)

* Don't overwrite proxies set by multiple tags

## [v0.10.3](https://github.com/fedux-org/proxy_rb/compare/v0.10.2...v0.10.3)

* Setting user information now works with default step in Before Hook

## [v0.10.2](https://github.com/fedux-org/proxy_rb/compare/v0.10.1...v0.10.2)

* Make it possible to visit pages and then check all of them

## [v0.10.1](https://github.com/fedux-org/proxy_rb/compare/v0.10.0...v0.10.1)

* Add support for password fetching for a particular step

## [v0.10.0](https://github.com/fedux-org/proxy_rb/compare/v0.9.3...v0.10.0)

* Fixed dependency problem with `thor`
* Removed `rspec` dependency because otherwise we would also need to add a
  `cucumbr` dependency. Now it's up to the user to add this to his/her
  `Gemfile`.

## [v0.9.3](https://github.com/fedux-org/proxy_rb/compare/v0.9.2...v0.9.3)

* Added best practises for usage of cucumber steps
* Refactored steps to make it possible to check for body in proxy
* Added step to set user directly - required for best practises

## [v0.9.2](https://github.com/fedux-org/proxy_rb/compare/v0.9.1...v0.9.2)

* Fixed proxy authentication for cucumber steps

## [v0.9.1](https://github.com/fedux-org/proxy_rb/compare/v0.9.0...v0.9.1)

* Added initializer for cucumber which I forgot to add earlier

## [v0.9.0](https://github.com/fedux-org/proxy_rb/compare/v0.8.3...v0.9.0)

* Added some step definitions for cucumber

## [v0.8.3](https://github.com/fedux-org/proxy_rb/compare/v0.8.2...v0.8.3)

* Make warning appear once

## [v0.8.2](https://github.com/fedux-org/proxy_rb/compare/v0.8.1...v0.8.2)

* Added warning if one disables `strict`-mode which was 

## [v0.8.1](https://github.com/fedux-org/proxy_rb/compare/v0.8.0...v0.8.1)

* Handle drivers - like `capybara-selenium` which currently not support
  `#response_headers` on `page.driver.response_headers`.

## [v0.8.0](https://github.com/fedux-org/proxy_rb/compare/v0.7.1...v0.8.0)

* Introduce `strict` option to make it possible to be more relaxed in matchers
  when the response is not readable, this can lead to status_code == 0

## [v0.7.1](https://github.com/fedux-org/proxy_rb/compare/v0.7.0...v0.7.1)

* Handle nil as input for `#simple_table`

## [v0.7.0](https://github.com/fedux-org/proxy_rb/compare/v0.6.0...v0.7.0)

* Make simple_table-formatter available as method

## [v0.6.0](https://github.com/fedux-org/proxy_rb/compare/v0.5.0...v0.6.0)

* Added announcer for response headers

## [v0.5.0](https://github.com/fedux-org/proxy_rb/compare/v0.4.0...v0.5.0)

* Added initializer to bootstrap `proxy_prb`
* Improved documentation
* Improved test suite
* Made test suite succeed on travis.org
* Added announcer known from `aruba`. Now one output information about
  configured user, proxy and resource
* Addd new matchers to output better error messages


## [v0.4.0](https://github.com/fedux-org/proxy_rb/compare/v0.1.0...v0.4.0)

* Added support for `poltergeist`, `selenium` and `webkit`
