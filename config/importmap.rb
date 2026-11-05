# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'https://ga.jspm.io/npm:@hotwired/stimulus@3.2.1/dist/stimulus.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'flowbite', to: 'https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.6.4/flowbite.turbo.min.js'
pin 'hotkeys-js', to: 'https://ga.jspm.io/npm:hotkeys-js@3.10.1/dist/hotkeys.esm.js'
pin 'stimulus-dropdown', to: 'https://ga.jspm.io/npm:stimulus-dropdown@2.1.0/dist/stimulus-dropdown.mjs'
pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js'
pin 'stimulus-scroll-to', to: 'https://ga.jspm.io/npm:stimulus-scroll-to@4.1.0/dist/stimulus-scroll-to.mjs'
pin 'stimulus-checkbox-select-all', to: 'https://ga.jspm.io/npm:stimulus-checkbox-select-all@5.2.0/dist/stimulus-checkbox-select-all.mjs'
pin 'stimulus-read-more', to: 'https://ga.jspm.io/npm:stimulus-read-more@4.1.0/dist/stimulus-read-more.mjs'
pin 'stimulus-reveal-controller', to: 'https://ga.jspm.io/npm:stimulus-reveal-controller@4.1.0/dist/stimulus-reveal-controller.mjs'
pin 'trix', to: 'https://ga.jspm.io/npm:trix@2.0.4/dist/trix.esm.min.js'
pin '@rails/actiontext', to: 'https://ga.jspm.io/npm:@rails/actiontext@8.0.0/app/assets/javascripts/actiontext.js'
