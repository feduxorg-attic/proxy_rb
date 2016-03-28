#  UNRELEASED

Empty

# RELEASED

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
