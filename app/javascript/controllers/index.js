// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)

// Chechbox select all
import CheckboxSelectAll from 'stimulus-checkbox-select-all'
application.register('checkbox-select-all', CheckboxSelectAll)
// ReadMore
import ReadMore from 'stimulus-read-more'
application.register('read-more', ReadMore)
// Dropdown
import Dropdown from 'stimulus-dropdown'
application.register('dropdown', Dropdown)
// Scroll to
import ScrollTo from 'stimulus-scroll-to'
application.register('scroll-to', ScrollTo)
// Reveal controller
import Reveal from 'stimulus-reveal-controller'
application.register('reveal', Reveal)
// Searchable selects
import "controllers/select_enhancer"
