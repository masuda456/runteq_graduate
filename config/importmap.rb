# Pin npm packages by running ./bin/importmap

pin "application"
pin "sw", to: "sw.js"
pin "register_sw", to: "register_sw.js"
# pin "manifest"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
# pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"

pin_all_from 'app/javascript/controllers', under: 'controllers'
